#include <stdio.h>
#include <time.h>

#define STRICT_R_HEADERS
#include <Rinternals.h>
#include <R_ext/Rdynload.h> // Included by default in R (>= 3.4).

SEXP R_fmt_current_time(SEXP fmt)
{
  const char *fmt_str = CHAR(Rf_asChar(fmt));

  time_t timer;
  char buffer[26];
  struct tm* tm_info;

  time(&timer);
  tm_info = localtime(&timer);

  int written = strftime(buffer, 26, fmt_str, tm_info);
  if (!written) {
    Rf_error("Failed to format current time.");
    return R_NilValue;
  }

  return Rf_ScalarString(Rf_mkCharLen(buffer, written));
}

static const R_CallMethodDef log4r_entries[] = {
  {"R_fmt_current_time", (DL_FUNC) &R_fmt_current_time, 1},
  {NULL, NULL, 0}
};

void R_init_log4r(DllInfo *info) {
  R_registerRoutines(info, NULL, log4r_entries, NULL, NULL);
  R_useDynamicSymbols(info, FALSE);
}
