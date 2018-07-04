
#' textfeatures
#'
#' Extracts features from text vector.
#'
#' @param x Input data. Should be character vector, data frame, or grouped data
#'   frame (grouped_df) with character variable of interest named "text". If
#'   grouped_df is provided, then features will be averaged across all
#'   observations for each group.
#' @return A tibble data frame with extracted features as columns.
#' @examples
#'
#' ## the text of five of Trump's most retweeted tweets
#' trump_tweets <- c(
#'   "#FraudNewsCNN #FNN https://t.co/WYUnHjjUjg",
#'   "TODAY WE MAKE AMERICA GREAT AGAIN!",
#'   paste("Why would Kim Jong-un insult me by calling me \"old,\" when I would",
#'     "NEVER call him \"short and fat?\" Oh well, I try so hard to be his",
#'     "friend - and maybe someday that will happen!"),
#'   paste("Such a beautiful and important evening! The forgotten man and woman",
#'     "will never be forgotten again. We will all come together as never before"),
#'   paste("North Korean Leader Kim Jong Un just stated that the \"Nuclear",
#'     "Button is on his desk at all times.\" Will someone from his depleted and",
#'     "food starved regime please inform him that I too have a Nuclear Button,",
#'     "but it is a much bigger &amp; more powerful one than his, and my Button",
#'     "works!")
#' )
#'
#' ## get the text features of a character vector
#' textfeatures(trump_tweets)
#'
#' ## data frame with a character vector named "text"
#' df <- data.frame(
#'   id = c(1, 2, 3),
#'   text = c("this is A!\t sEntence https://github.com about #rstats @github",
#'     "doh", "The following list:\n- one\n- two\n- three\nOkay!?!"),
#'   stringsAsFactors = FALSE
#' )
#'
#' ## get text features of a data frame with "text" variable
#' textfeatures(df)
#'
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
#' @importFrom rlang .data
textfeatures.data.frame <- function(x) {
  ## validate input
  stopifnot("text" %in% names(x))
  ## make sure "text" is character
  if (is.factor(x$text)) {
    x$text <- as.character(x$text)
  }
  ## validate text class
  stopifnot(is.character(x$text))
  ## extract features for all observations
  x <- suppressMessages(dplyr::transmute(x,
    n_urls = n_urls(.data$text),
    n_hashtags = n_hashtags(.data$text),
    n_mentions = n_mentions(.data$text),
    text = text_cleaner(.data$text),
    sent_afinn = syuzhet::get_sentiment(.data$text, method = "afinn"),
    sent_bing = syuzhet::get_sentiment(.data$text, method = "bing"),
    sent_syuzhet = syuzhet::get_sentiment(.data$text, method = "syuzhet"),
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
  x <- dplyr::bind_cols(x, polite_politeness(x$text))
  x <- dplyr::select(x, -.data$text)
  x <- x %>% dplyr::mutate_if(is.integer, as.numeric)
  y <- grepl("^n_", names(x))
  x[y] <- purrr::map(x[y], ~ log10(.x + 1L))
  x
}



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

#' @export
#' @importFrom purrr map_lgl map
textfeatures.list <- function(x) {
  ## if named list with "text" element
  if (!is.null(names(x)) && "text" %in% names(x)) {
    x <- x$text
    return(textfeatures(x))
    ## if all elements are character vectors, return list of DFs
  } else if (all(lengths(x) == 1L) && all(map_lgl(x, is.character))) {
    ## (list in, list out)
    return(map(x, textfeatures))
  }
  ## if all elements are recursive objects containing "text" variable
  if (all(map_lgl(x, is.recursive)) &&
      all(map_lgl(x, ~ "text" %in% names(.x)))) {
    x <- map(x, ~ .x$text)
    return(map(x, textfeatures))
  }
  stop(paste0("Input is a list without a character vector named \"text\". ",
    "Are you sure the input shouldn't be a character vector or a data frame",
    "with a \"text\" variable?"), call. = FALSE)
}

