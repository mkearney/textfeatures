utils::globalVariables(c("text2", "n_chars", "text"))

#' textfeatures
#'
#' Extracts features from text vector.
#'
#' @param x Input data. Should be character vector, data frame, or grouped data
#'   frame (grouped_df) with character variable of interest named "text". If
#'   grouped_df is provided, then features will be averaged across all
#'   observations for each group.
#' @return A tibble data frame with extracted features as columns.
#' @export
textfeatures <- function(x) UseMethod("textfeatures")

#' @export
textfeatures.character <- function(x) {
  x <- tibble::data_frame(text = x, validate = FALSE)
  textfeatures(x)
}

#' @export
textfeatures.factor <- function(x) {
  x <- as.character(x)
  textfeatures(x)
}

#' @export
#' @importFrom dplyr transmute
textfeatures.data.frame <- function(x) {
  ## validate input
  stopifnot("text" %in% names(x))
  ## make sure "text" is character
  if (is.factor(x$text)) {
    x$text <- as.character(x$text)
  }
  ## validate text class
  stopifnot(is.character(x$text))
  ## remove URLs, mentions, etc, and convert some non-ascii into ascii equiv
  x <- text_cleaner(x)
  ## extract features for all observations
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
  ## remove URLs, mentions, etc, and convert some non-ascii into ascii equiv
  x <- text_cleaner(x)
  ## extract features for all observations
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
  ## summarise (via mean) by group and return features data
  dplyr::summarise_all(x, mean, na.rm = TRUE)
}


text_cleaner <- function(x) {
  ## remove URLs, mentions, and hashtags
  x$text2 <- gsub("https?:[[:graph:]]+|@\\S+|#\\S+", "", x$text)
  ## convert non-ascii into ascii exclamation marks
  x$text2 <- gsub("\u00A1|\u01C3|\u202C|\u203D|\u2762", "\u0021", x$text2)
  ## convert non-ascii into ascii apostrophes
  x$text2 <- gsub(
    "\u2018|\u2019|\u05F3|\u02B9|\u02Bc|\u02C8|\u0301|\u05F3|\u2032|\uA78C",
    "\u0027", x$text2)
  ## convert non-ascii into ascii commas
  x$text2 <- gsub("\u2795", "\u002B", x$text2)
  ## convert non-ascii into ascii hypthens
  x$text2 <- gsub("\u2010|\u2011|\u2012|\u2013|\u2043|\u2212|\u10191", "\u002D", x$text2)
  ## convert non-ascii into ascii periods
  x$text2 <- gsub("\u06D4|\u2E3C|\u3002", "\u002E", x$text2)
  ## convert non-ascii into ascii elipses
  x$text2 <- gsub("\u2026", "\u002E\u002E\u002E", x$text2)
  ## return data frame with new text2 var
  x
}


#' @export
textfeatures.list <- function(x) {
  ## if named list with "text" element
  if (!is.null(names(x)) && "text" %in% names(x)) {
    x <- x$text
    return(textfeatures(x))
    ## if all elements are character vectors, return list of DFs
  } else if (all(lengths(x) == 1L) && all(vply_lgl(x, is.character))) {
    ## (list in, list out)
    return(lapply(x, textfeatures))
  }
  ## if all elements are recursive objects containing "text" variable
  if (all(vply_lgl(x, is.recursive)) &&
      all(vply_lgl(x, ~ "text" %in% names(.)))) {
    x <- lapply(x, "[[", "text")
    return(lapply(x, textfeatures))
  }
  stop(paste0("Input is a list without a character vector named \"text\". ",
    "Are you sure the input shouldn't be a character vector or a data frame",
    "with a \"text\" variable?"), call. = FALSE)
}

