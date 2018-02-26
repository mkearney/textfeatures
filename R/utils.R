

vply_int <- function(.x, .f) {
  vapply(.x, rlang::as_closure(.f), FUN.VALUE = integer(1), USE.NAMES = FALSE)
}
vply_dbl <- function(.x, .f) {
  vapply(.x, rlang::as_closure(.f), FUN.VALUE = double(1), USE.NAMES = FALSE)
}
vply_lgl <- function(.x, .f) {
  vapply(.x, rlang::as_closure(.f), FUN.VALUE = logical(1), USE.NAMES = FALSE)
}
vply_chr <- function(.x, .f) {
  vapply(.x, rlang::as_closure(.f), FUN.VALUE = character(1), USE.NAMES = FALSE)
}
vply_fct <- function(.x, .f) {
  vapply(.x, rlang::as_closure(.f), FUN.VALUE = factor(1), USE.NAMES = FALSE)
}
vply_pos <- function(.x, .f) {
  x <- vapply(.x, rlang::as_closure(.f), FUN.VALUE = double(1), USE.NAMES = FALSE)
  as.POSIXct(x, origin = "1970-01-01")
}

