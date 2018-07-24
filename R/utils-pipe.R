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



text_cleaner <- function(x) {
  stopifnot(is.character(x))

  ## remove URLs, mentions, and hashtags
  x <- gsub("https?:[[:graph:]]+|@\\S+|#\\S+", "", x)

  ## convert non-ascii into ascii exclamation marks
  x <- gsub("\u00A1", "\u0021", x, fixed = TRUE)
  x <- gsub("\u01C3", "\u0021", x, fixed = TRUE)
  x <- gsub("\u202C", "\u0021", x, fixed = TRUE)
  x <- gsub("\u203D", "\u0021", x, fixed = TRUE)
  x <- gsub("\u2762", "\u0021", x, fixed = TRUE)

  ## convert non-ascii into ascii apostrophes
  x <- gsub("\u2018", "\u0027", x, fixed = TRUE)
  x <- gsub("\uA78C", "\u0027", x, fixed = TRUE)
  x <- gsub("\u05F3", "\u0027", x, fixed = TRUE)
  x <- gsub("\u0301", "\u0027", x, fixed = TRUE)
  x <- gsub("\u02C8", "\u0027", x, fixed = TRUE)
  x <- gsub("\u2018", "\u0027", x, fixed = TRUE)
  x <- gsub("\u02Bc", "\u0027", x, fixed = TRUE)
  x <- gsub("\u02B9", "\u0027", x, fixed = TRUE)
  x <- gsub("\u05F3", "\u0027", x, fixed = TRUE)
  x <- gsub("\u2019", "\u0027", x, fixed = TRUE)

  ## convert non-ascii into ascii commas
  x <- gsub("\u2795", "\u002B", x, fixed = TRUE)

  ## convert non-ascii into ascii hypthens
  x <- gsub("\u2010", "\u002D", x, fixed = TRUE)
  x <- gsub("\u2011", "\u002D", x, fixed = TRUE)
  x <- gsub("\u2012", "\u002D", x, fixed = TRUE)
  x <- gsub("\u2013", "\u002D", x, fixed = TRUE)
  x <- gsub("\u2043", "\u002D", x, fixed = TRUE)
  x <- gsub("\u2212", "\u002D", x, fixed = TRUE)
  x <- gsub("\u10191", "\u002D", x, fixed = TRUE)

  ## convert non-ascii into ascii periods
  x <- gsub("\u06D4", "\u002E", x, fixed = TRUE)
  x <- gsub("\u2E3C", "\u002E", x, fixed = TRUE)
  x <- gsub("\u3002", "\u002E", x, fixed = TRUE)

  ## convert non-ascii into ascii elipses
  gsub("\u2026", "\u002E\u002E\u002E", x, fixed = TRUE)
}



char_to_b64 <- function(x) {
  char_table <- c(LETTERS, letters, 0:9, "+", "/")
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
  char_table <- c(LETTERS, letters, 0:9, "+", "/")
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
