#' Appenders
#'
#' @description
#'
#' In \href{https://logging.apache.org/log4j/}{log4j} etymology,
#' \strong{Appenders} are destinations where messages are written. Depending on
#' the nature of the destination, the format of the messages may be controlled
#' using a \strong{\link[=layouts]{Layout}}.
#'
#' The most basic appenders log messages to the console or to a file; these are
#' described below.
#'
#' For implementing your own appenders, see Details.
#'
#' @details
#'
#' Appenders are implemented as functions with the interface
#' \code{function(level, ...)}. These functions are expected to write their
#' arguments to a destination and return \code{invisible(NULL)}.
#'
#' @param layout A layout function taking a \code{level} parameter and
#'   additional arguments corresponding to the message. See
#'   \code{\link{layouts}}.
#'
#' @examples
#' # The behaviour of an appender can be seen by using them directly; the
#' # following snippet will write the message to the console.
#' appender <- console_appender()
#' appender("INFO", "Input has length ", 0, ".")
#'
#' @seealso \code{\link{tcp_appender}}, \code{\link{http_appender}},
#'   \code{\link{syslog_appender}}
#'
#'
#' @name appenders
#' @rdname appenders
#' @aliases console_appender
#' @export
console_appender <- function(layout = default_log_layout()) {
  file_appender(file = "", layout = layout)
}

#' @param file The file to write messages to.
#' @param append When \code{TRUE}, the file is not truncated when opening for
#'   the first time.
#'
#' @rdname appenders
#' @aliases file_appender
#' @export
file_appender <- function(file, append = TRUE, layout = default_log_layout()) {
  stopifnot(is.function(layout))
  layout <- compiler::cmpfun(layout)
  force(file)
  if (!append) {
    # This should truncate the file, if it exists.
    file.create(file)
  }
  function(level, ...) {
    msg <- layout(level, ...)
    cat(msg, file = file, sep = "", append = TRUE)
  }
}

#' Log Messages via TCP
#'
#' Append messages to arbitrary TCP destinations.
#'
#' @param host Hostname for the socket connection.
#' @param port Port number for the socket connection.
#' @param layout A layout function taking a \code{level} parameter and
#'   additional arguments corresponding to the message.
#' @param timeout Timeout for the connection.
#'
#' @seealso \code{\link{appenders}} for more information on Appenders, and
#'   \code{\link[base]{socketConnection}} for the underlying connection object
#'   used by \code{tcp_appender}.
#'
#' @export
tcp_appender <- function(host, port, layout = default_log_layout(),
                         timeout = getOption("timeout")) {
  stopifnot(is.function(layout))
  layout <- compiler::cmpfun(layout)
  # Use a finalizer pattern to make sure we close the connection.
  env <- new.env(size = 1)
  env$con <- socketConnection(
    host = host, port = port, open = "wb", blocking = TRUE, timeout = timeout
  )
  reg.finalizer(env, function(e) close(e$con), onexit = TRUE)
  function(level, ...) {
    msg <- layout(level, ...)
    writeBin(msg, con = env$con)
  }
}

#' Log Messages via HTTP
#'
#' @description
#'
#' Send messages in the body of HTTP requests. Responses with status code 400
#' or above will trigger errors.
#'
#' Requires the \code{httr} package.
#'
#' @param url The URL to submit messages to.
#' @param method The HTTP method to use, usually \code{"POST"} or \code{"GET"}.
#' @param layout A layout function taking a \code{level} parameter and
#'   additional arguments corresponding to the message.
#' @param ... Further arguments passed on to \code{\link[httr]{POST}}.
#'
#' @examples
#' \dontrun{
#' # POST messages to localhost.
#' appender <- http_appender("localhost")
#' appender("INFO", "Message.")
#'
#' # POST JSON-encoded messages.
#' appender <- http_appender(
#'   "localhost", method = "POST", layout = default_log_layout(),
#'   httr::content_type_json()
#' )
#' appender("INFO", "Message.")
#' }
#'
#' @seealso \code{\link{appenders}} for more information on Appenders.
#'
#' @export
http_appender <- function(url, method = "POST", layout = default_log_layout(),
                          ...) {
  if (!requireNamespace("httr", quietly = TRUE)) {
    stop("The 'httr' package is required to use this HTTP appender.")
  }
  stopifnot(is.function(layout))
  layout <- compiler::cmpfun(layout)

  tryCatch({
    verb <- get(method, envir = asNamespace("httr"))
  }, error = function(e) {
    stop("'", method, "' is not a supported HTTP method.", call. = FALSE)
  })
  args <- c(list(url = url), list(...))
  function(level, ...) {
    args$body <- layout(level, ...)
    resp <- do.call(verb, args)

    # Treat HTTP errors as actual errors.
    if (httr::status_code(resp) >= 400) {
      stop("Server responded with error ", httr::status_code(resp), ".")
    }
  }
}

#' Log Messages to the Local Syslog
#'
#' Send messages to the local syslog. Requires the \code{rsyslog} package.
#'
#' @param identifier A string identifying the application.
#' @param layout A layout function taking a \code{level} parameter and
#'   additional arguments corresponding to the message.
#' @param ... Further arguments passed on to \code{\link[rsyslog]{open_syslog}}.
#'
#' @seealso \code{\link{appenders}} for more information on Appenders.
#'
#' @export
syslog_appender <- function(identifier, layout = bare_log_layout(), ...) {
  if (!requireNamespace("rsyslog", quietly = TRUE)) {
    stop("The 'rsyslog' package is required to use this syslog appender.")
  }
  stopifnot(is.function(layout))
  layout <- compiler::cmpfun(layout)

  rsyslog::open_syslog(identifier = identifier, ...)

  # Override any existing masking. Priority thresholds are handled by the
  # package instead of by syslog.
  rsyslog::set_syslog_mask("DEBUG")

  function(level, ...) {
    msg <- layout(level, ...)
    # Translate between log4j and syslog priority levels. Using a switch
    # statement turns out to be faster than a lookup.
    syslog_level <- switch(
      level, "TRACE" = "DEBUG", "DEBUG" = "DEBUG", "INFO" = "INFO",
      "WARN" = "WARNING", "ERROR" = "ERR", "FATAL" = "CRITICAL"
    )
    rsyslog::syslog(msg, level = syslog_level)
  }
}
