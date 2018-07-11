
#' textfeatures2
#'
#' Quick and dirty feature extraction from text vector (like textfeatures but
#'   without the sentiment and politeness analysis)
#'
#' @param x Input data. Should be character vector, data frame, or grouped data
#'   frame (grouped_df) with character variable of interest named "text". If
#'   grouped_df is provided, then features will be averaged across all
#'   observations for each group.
#' @return A tibble data frame with extracted features as columns.
#' @export
textfeatures2 <- function(x) UseMethod("textfeatures2")

#' @export
textfeatures2.NULL <- function(x) {
  data.frame()
}

#' @export
textfeatures2.default <- function(x) {
  textfeatures2(data.frame(text = x, row.names = NULL, stringsAsFactors = FALSE))
}

#' @export
textfeatures2.character <- function(x) {
  textfeatures2(data.frame(text = x, row.names = NULL, stringsAsFactors = FALSE))
}

#' @export
textfeatures2.factor <- function(x) {
  textfeatures2(as.character(x))
}

#' @export
#' @importFrom dplyr transmute
#' @importFrom rlang .data
#' @export
#' @importFrom tibble as_tibble
textfeatures2.data.frame <- function(x) {
  ## validate input
  stopifnot("text" %in% names(x))
  ## make sure "text" is character
  text <- as.character(x$text)
  ## validate text class
  stopifnot(is.character(text))
  ## if ID
  if ("id" %in% names(x)) {
    idname <- "id"
    id <- x$id
  } else if (any(grepl("[._]id$", names(x)))) {
    idname <- grep("[._]id$", names(x), value = TRUE)[1]
    id <- x[[grep("[._]id$", names(x))[1]]]
  } else if ((is.character(x[[1]]) || is.factor(x[[1]])) && names(x)[1] != "text") {
    idname <- names(x)[1]
    id <- as.character(x[[1]])
  } else {
    id <- seq_len(nrow(x))
  }

  ## extract features for all observations
  text = text_cleaner(text)
  n_chars = n_charS(text)
  n_commas = n_commas(text)
  n_digits = n_digits(text)
  n_exclaims = n_exclaims(text)
  n_extraspaces = n_extraspaces(text)
  n_lowers = n_lowers(text)
  n_lowersp = (n_lowers + 1L) / (n_chars + 1L)
  n_periods = n_periods(text)
  n_words = n_words(text)
  n_caps = n_caps(text)
  n_nonasciis = n_nonasciis(text)
  n_puncts = n_puncts(text)
  n_capsp = (n_caps + 1L) / (n_chars + 1L)
  n_charsperword = (n_chars + 1L) / (n_words + 1L)

  x <- list(id = id,
    n_chars = n_chars,
    n_commas = n_commas,
    n_digits = n_digits,
    n_exclaims = n_exclaims,
    n_extraspaces = n_extraspaces,
    n_lowers = n_lowers,
    n_lowersp = n_lowersp,
    n_periods = n_periods,
    n_words = n_words,
    n_caps = n_caps,
    n_nonasciis = n_nonasciis,
    n_puncts = n_puncts,
    n_capsp = n_capsp,
    n_charsperword = n_charsperword)
  tibble::as_tibble(x, validate = FALSE)
}

#' @export
#' @importFrom purrr map_lgl map
textfeatures2.list <- function(x) {
  ## if named list with "text" element
  if (!is.null(names(x)) && "text" %in% names(x)) {
    x <- x$text
    return(textfeatures2(x))
    ## if all elements are character vectors, return list of DFs
  } else if (all(lengths(x) == 1L) && all(map_lgl(x, is.character))) {
    ## (list in, list out)
    return(map(x, textfeatures2))
  }
  ## if all elements are recursive objects containing "text" variable
  if (all(map_lgl(x, is.recursive)) &&
      all(map_lgl(x, ~ "text" %in% names(.x)))) {
    x <- map(x, ~ .x$text)
    return(map(x, textfeatures2))
  }
  stop(paste0("Input is a list without a character vector named \"text\". ",
    "Are you sure the input shouldn't be a character vector or a data frame",
    "with a \"text\" variable?"), call. = FALSE)
}

