#define STRICT_R_HEADERS
#include <Rinternals.h>

#define BUF_ABORT
#include "buf.h"

#define LOGFMT_SIG_DIGITS 4

/* Hex code "lookup table". */
static const char *hex = "0123456789abcdef";

char* buf_push_all(char *dest, const char *src, size_t n)
{
  /* It's possible we could be more clever and use memcpy here somehow, but it
     would probably not be worth it. */
  for (size_t i = 0; i < n; i++) {
    buf_push(dest, src[i]);
  }
  return dest;
}

int logfmt_needs_escape(char ch)
{
  return ch == '"' || ch == '=' || ch == '\\' || ch <= 0x20;
}

char* buf_push_escaped(char *dest, const char *src, size_t n)
{
  char ch;
  buf_push(dest, '"');
  for (size_t i = 0; i < n; i++) {
    ch = src[i];
    if (ch > 0x1f && ch != '"' && ch != '\\') {
      buf_push(dest, ch);
      continue;
    }
    buf_push(dest, '\\');
    switch(ch) {
    case '\\':
      /* fallthrough */
    case '"':
      buf_push(dest, ch);
      break;
    case '\n':
      buf_push(dest, 'n');
      break;
    case '\t':
      buf_push(dest, 't');
      break;
    case '\r':
      buf_push(dest, 'r');
      break;
    default:
      /* Encode embedded control characters in the same manner as JSON, by
         converting e.g. '\b' to \u0008. This uses the classic bitshift/and
         approach to convert a character to hex. */
      dest = buf_push_all(dest, "u00", 3);
      buf_push(dest, hex[(ch >> 4) & 0x0F]);
      buf_push(dest, hex[ch & 0x0F]);
      break;
    }
  }
  buf_push(dest, '"');
  return dest;
}

SEXP R_encode_logfmt(SEXP list)
{
  R_xlen_t len = Rf_length(list);
  SEXP keys = Rf_getAttrib(list, R_NamesSymbol);
  if (len == 0 || keys == R_NilValue) {
    return R_BlankScalarString;
  }
  char *buffer = NULL;
  buf_grow(buffer, 256);

  SEXP elt;
  const char *str;
  R_xlen_t i, j, elt_len = 0;
  int empty_key = 1;
  for (i = 0; i < len; i++) {
    elt = STRING_ELT(keys, i);
    str = CHAR(elt);
    elt_len = Rf_length(elt);
    /* Skip fields with zero-length names rather than produce invalid output. */
    if (elt_len == 0 || elt == NA_STRING) {
      continue;
    }
    if (!empty_key) {
      buf_push(buffer, ' ');
    }
    empty_key = 1;
    for (j = 0; j < elt_len; j++) {
      /* Drop characters that would need an escape. This matches the behaviour
         of popular Go implementations, and makes sense from a user perspective
         -- i.e. few programs respond to errors in their log writing code
         effectively, so it is better to be slightly lossy. */
      if (logfmt_needs_escape(str[j])) {
        continue;
      }
      buf_push(buffer, str[j]);
      empty_key = 0;
    }
    /* Again, skip fields with zero-length names (after dropping escape
       characters) rather than produce invalid output. */
    if (empty_key) {
      continue;
    }
    buf_push(buffer, '=');
    elt = VECTOR_ELT(list, i);
    if (Rf_length(elt) == 0) {
      buffer = buf_push_all(buffer, "null", 4);
      continue;
    }
    switch(TYPEOF(elt)) {
    case LGLSXP: {
      int v = LOGICAL_ELT(elt, 0);
      if (v == NA_LOGICAL) {
        buffer = buf_push_all(buffer, "null", 4);
      } else if (v) {
        buffer = buf_push_all(buffer, "true", 4);
      } else {
        buffer = buf_push_all(buffer, "false", 5);
      }
      break;
    }
    case INTSXP: {
      int v = INTEGER_ELT(elt, 0);
      if (v == NA_INTEGER) {
        buffer = buf_push_all(buffer, "null", 4);
        break;
      }
      char vbuff[32];
      size_t written = snprintf(vbuff, 32, "%d", v);
      buffer = buf_push_all(buffer, vbuff, written);
      break;
    }
    case REALSXP: {
      double v = REAL_ELT(elt, 0);
      if (!R_finite(v)) {
        /* TODO: Write out Inf, -Inf, and NaN? */
        buffer = buf_push_all(buffer, "null", 4);
        break;
      }
      char vbuff[32];
      size_t written = snprintf(vbuff, 32, "%.*g", LOGFMT_SIG_DIGITS, v);
      buffer = buf_push_all(buffer, vbuff, written);
      break;
    }
    case CPLXSXP:
      elt = Rf_coerceVector(elt, STRSXP);
      /* fallthrough */
    case STRSXP: {
      elt = STRING_ELT(elt, 0);
      if (elt == NA_STRING) {
        buffer = buf_push_all(buffer, "null", 4);
        break;
      }
      str = CHAR(elt);
      elt_len = Rf_length(elt);
      /* We need to scan through once to determine if the string needs to be
         escaped before we can actually write it out. */
      for (j = 0; j < elt_len; j++) {
        if (logfmt_needs_escape(str[j])) {
          buffer = buf_push_escaped(buffer, str, elt_len);
          goto wrote_string;
        }
      }
      /* The string can be safely written without escaping. */
      for (j = 0; j < elt_len; j++) {
        buf_push(buffer, str[j]);
      }
    wrote_string:
      break;
    }
    default:
      buffer = buf_push_all(buffer, "<omitted>", 9);
      break;
    }
  }
  buf_push(buffer, '\n');
  SEXP out = Rf_ScalarString(Rf_mkCharLen(buffer, buf_size(buffer)));
  buf_free(buffer);
  return out;
}
