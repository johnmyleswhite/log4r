#include <stdio.h>
#include <time.h>

#define STRICT_R_HEADERS
#include <Rinternals.h>
#include <R_ext/Rdynload.h> // Included by default in R (>= 3.4).

SEXP R_fmt_current_time(SEXP fmt, SEXP utc, SEXP use_fractional,
                        SEXP suffix_fmt)
{
  const char *fmt_str = CHAR(Rf_asChar(fmt));
  int use_utc = Rf_asLogical(utc);
  int append_us = Rf_asLogical(use_fractional);
  const char *suffix_fmt_str = NULL;
  if (suffix_fmt != R_NilValue) {
    suffix_fmt_str = CHAR(Rf_asChar(suffix_fmt));
  }

#if (__STDC_VERSION__ >= 201112L)
  struct timespec ts;
  timespec_get(&ts, TIME_UTC);
  char buffer[64];
  struct tm* tm_info;

  tm_info = use_utc ? gmtime(&ts.tv_sec) : localtime(&ts.tv_sec);

  int written = strftime(buffer, 64, fmt_str, tm_info);
  if (!written) {
    Rf_error("Failed to format current time.");
    return R_NilValue;
  }

  if (!append_us) {
    return Rf_ScalarString(Rf_mkCharLen(buffer, written));
  }

  int added = snprintf(buffer + written, 64 - written, ".%06ld",
                       ts.tv_nsec / 1000);
  if (!added) {
    Rf_error("Failed to format current time.");
    return R_NilValue;
  }
  written += added;

  if (!suffix_fmt_str) {
    return Rf_ScalarString(Rf_mkCharLen(buffer, written));
  }

  added = strftime(buffer + written, 64 - written, suffix_fmt_str, tm_info);
  if (!added) {
    Rf_error("Failed to format current time.");
    return R_NilValue;
  }
  written += added;
#else
  time_t timer;
  char buffer[26];
  struct tm* tm_info;

  time(&timer);
  tm_info = use_utc ? gmtime(&timer) : localtime(&timer);

  int written = strftime(buffer, 26, fmt_str, tm_info);
  if (!written) {
    Rf_error("Failed to format current time.");
    return R_NilValue;
  }

  if (!suffix_fmt_str) {
    return Rf_ScalarString(Rf_mkCharLen(buffer, written));
  }

  int added = strftime(buffer + written, 64 - written, suffix_fmt_str, tm_info);
  if (!added) {
    Rf_error("Failed to format current time.");
    return R_NilValue;
  }
  written += added;
#endif

  return Rf_ScalarString(Rf_mkCharLen(buffer, written));
}

SEXP R_encode_logfmt(SEXP list); /* See logfmt.c. */

static const R_CallMethodDef log4r_entries[] = {
  {"R_fmt_current_time", (DL_FUNC) &R_fmt_current_time, 4},
  {"R_encode_logfmt", (DL_FUNC) &R_encode_logfmt, 1},
  {NULL, NULL, 0}
};

void R_init_log4r(DllInfo *info) {
  R_registerRoutines(info, NULL, log4r_entries, NULL, NULL);
  R_useDynamicSymbols(info, FALSE);
}
