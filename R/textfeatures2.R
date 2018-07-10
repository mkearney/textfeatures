
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
textfeatures2.data.frame <- function(x) {
  ## validate input
  stopifnot("text" %in% names(x))
  ## make sure "text" is character
  if (is.factor(x$text)) {
    x$text <- as.character(x$text)
  }
  ## validate text class
  stopifnot(is.character(x$text))
  ## if ID
  if ("id" %in% names(x)) {
    idname <- "id"
    ids <- x$id
  } else if (any(grepl("[._]id$", names(x)))) {
    idname <- grep("[._]id$", names(x), value = TRUE)[1]
    ids <- x[[grep("[._]id$", names(x))[1]]]
  } else {
    ids <- NULL
  }
  ## extract features for all observations
  x <- suppressMessages(dplyr::transmute(x,
    text = text_cleaner(.data$text),
    n_chars = n_charS(.data$text),
    n_commas = n_commas(.data$text),
    n_digits = n_digits(.data$text),
    n_exclaims = n_exclaims(.data$text),
    n_extraspaces = n_extraspaces(.data$text),
    n_lowers = n_lowers(.data$text),
    n_lowersp = (.data$n_lowers + 1L) / (.data$n_chars + 1L),
    n_periods = n_periods(.data$text),
    n_words = n_words(.data$text),
    n_caps = n_caps(.data$text),
    n_nonasciis = n_nonasciis(.data$text),
    n_puncts = n_puncts(.data$text),
    n_capsp = (.data$n_caps + 1L) / (.data$n_chars + 1L),
    n_charsperword = (.data$n_chars + 1L) / (.data$n_words + 1L)
  ))
  if (!is.null(ids)) {
    x[[idname]] <- ids
  } else {
    x$id <- seq_len(nrow(x))
  }
  ## move ID to front
  x <- x[, c(ncol(x), 1:(ncol(x) - 1))]
  tibble::as_tibble(x[names(x) != "text"], validate = FALSE)
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

