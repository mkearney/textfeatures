#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL



char_to_b64 <- function(x) {
  vapply(x, function(x) {
    x <- as.numeric(charToRaw(x))
    l <- ceiling(length(x) / 3)
    a <- length(x) %% 3
    y <- integer(l)
    m <- 256^(2:0)
    d <- 64^(3:0)
    for (i in seq(l)) {
      t <- x[seq(i * 3 - 2, i * 3)] * m
      t[is.na(t)] <- 0
      y[seq(i * 4 - 3, i * 4)] <- sum(t) %/% d %% 64
    }
    y <- char_table[y + 1]
    if (a > 0) {
      y[seq(l * 4 - 2 + a, l * 4)] <- "="
    }
    paste(y, collapse = "")
  }, FUN.VALUE = character(1), USE.NAMES = FALSE)
}


b64_to_char <- function(s) {
  s <- strsplit(s, "")
  vapply(s, function(x) {
    l <- length(x) / 4
    a <- sum(x == "=")
    x <- x[x != "="]
    x <- match(x, char_table) - 1
    y <- integer(l)
    m <- 64^(3:0)
    d <- 256^(2:0)
    for (i in seq_len(l)) {
      z <- x[seq(i * 4 - 3, i * 4)] * m
      z[is.na(z)] <- 0
      y[seq(i * 3 - 2, i * 3)] <- sum(z) %/% d %% 256
    }
    if (a > 0) {
      y <- y[seq(length(y) - a)]
    }
    rawToChar(as.raw(y))
  }, FUN.VALUE = character(1), USE.NAMES = FALSE)
}
