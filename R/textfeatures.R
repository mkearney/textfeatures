utils::globalVariables(c("text2", "n_chars", "text"))

#' textfeatures
#'
#' Extracts features from text vector.
#'
#' @param x Input data. Should be character vector or data frame/grouped data
#'   frame with variable of interest named "text"
#' @return A tibble data frame with extracted features as columns
#' @export
textfeatures <- function(x) UseMethod("textfeatures")

#' @export
textfeatures.character <- function(x) {
  x <- tibble::data_frame(text = x, validate = FALSE)
  textfeatures(x)
}

#' @export
#' @importFrom dplyr transmute
textfeatures.data.frame <- function(x) {
  stopifnot("text" %in% names(x))
  x$text2 <- gsub("https?:[[:graph:]]+|@\\S+|#\\S+", "", x$text)
  ## exclamation mark
  x$text2 <- gsub("\u00A1|\u01C3|\u202C|\u203D|\u2762", "\u0021", x$text2)
  ## apostrophe
  x$text2 <- gsub(
    "\u2018|\u2019|\u05F3|\u02B9|\u02Bc|\u02C8|\u0301|\u05F3|\u2032|\uA78C",
    "\u0027", x$text2)
  ## comma
  x$text2 <- gsub("\u2795", "\u002B", x$text2)
  ## hyphen
  x$text2 <- gsub("\u2010|\u2011|\u2012|\u2013|\u2043|\u2212|\u10191", "\u002D", x$text2)
  ## period
  x$text2 <- gsub("\u06D4|\u2E3C|\u3002", "\u002E", x$text2)
  ## eplipses
  x$text2 <- gsub("\u2026", "\u002E\u002E\u002E", x$text2)
  suppressMessages(dplyr::transmute(x,
    n_chars = n_charS(text2),
    n_commas = n_commas(text2),
    n_digits = n_digits(text2),
    n_exclaims = n_exclaims(text2),
    n_extraspaces = n_extraspaces(text2),
    n_hashtags = n_hashtags(text),
    n_lowers = n_lowers(text2),
    n_lowersp = (n_lowers + 1L) / (n_chars + 1L),
    n_mentions = n_mentions(text),
    n_periods = n_periods(text2),
    n_urls = n_urls(text),
    n_words = n_words(text2),
    n_caps = n_caps(text2),
    n_nonasciis = n_nonasciis(text2),
    n_puncts = n_puncts(text2),
    n_capsp = (n_caps + 1L) / (n_chars + 1L),
    n_charsperword = (n_chars + 1L) / (n_words + 1L)
  ))
}

#' @export
#' @importFrom dplyr transmute summarise_all
textfeatures.grouped_df <- function(x) {
  stopifnot("text" %in% names(x))
  x$text2 <- gsub("https?:[[:graph:]]+|@\\S+|#\\S+", "", x$text)
  ## exclamation mark
  x$text2 <- gsub("\u00A1|\u01C3|\u202C|\u203D|\u2762", "\u0021", x$text2)
  ## apostrophe
  x$text2 <- gsub(
    "\u2018|\u2019|\u05F3|\u02B9|\u02Bc|\u02C8|\u0301|\u05F3|\u2032|\uA78C",
    "\u0027", x$text2)
  ## comma
  x$text2 <- gsub("\u2795", "\u002B", x$text2)
  ## hyphen
  x$text2 <- gsub("\u2010|\u2011|\u2012|\u2013|\u2043|\u2212|\u10191", "\u002D", x$text2)
  ## period
  x$text2 <- gsub("\u06D4|\u2E3C|\u3002", "\u002E", x$text2)
  ## eplipses
  x$text2 <- gsub("\u2026", "\u002E\u002E\u002E", x$text2)
  x <- suppressMessages(dplyr::transmute(x,
    n_chars = n_charS(text2),
    n_commas = n_commas(text2),
    n_digits = n_digits(text2),
    n_exclaims = n_exclaims(text2),
    n_extraspaces = n_extraspaces(text2),
    n_hashtags = n_hashtags(text),
    n_lowers = n_lowers(text2),
    n_lowersp = (n_lowers + 1L) / (n_chars + 1L),
    n_mentions = n_mentions(text),
    n_periods = n_periods(text2),
    n_urls = n_urls(text),
    n_words = n_words(text2),
    n_caps = n_caps(text2),
    n_nonasciis = n_nonasciis(text2),
    n_puncts = n_puncts(text2),
    n_capsp = (n_caps + 1L) / (n_chars + 1L),
    n_charsperword = (n_chars + 1L) / (n_words + 1L)
  ))
  dplyr::summarise_all(x, mean, na.rm = TRUE)
}


