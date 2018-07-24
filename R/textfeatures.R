
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
  textfeatures(data.frame(text = x, row.names = NULL, stringsAsFactors = FALSE))
}

#' @export
textfeatures.factor <- function(x) {
  textfeatures(as.character(x))
}

#' @export
#' @importFrom tibble as_tibble
textfeatures.data.frame <- function(x) {
  ## initialize output data
  o <- list()

  ## validate input
  stopifnot("text" %in% names(x))
  ## make sure "text" is character
  text <- as.character(x$text)
  ## validate text class
  stopifnot(is.character(text))
  ## if ID
  if ("id" %in% names(x)) {
    idname <- "id"
    o$id <- .subset2(x, "id")
  } else if (any(grepl("[._]?id$", names(x)))) {
    idname <- grep("[._]?id$", names(x), value = TRUE)[1]
    o$id <- .subset2(x, grep("[._]?id$", names(x))[1])
  } else if ((is.character(x[[1]]) || is.factor(x[[1]])) && names(x)[1] != "text") {
    idname <- names(x)[1]
    o$id <- as.character(x[[1]])
  } else {
    o$id <- seq_len(nrow(x))
  }

  ## extract features for all observations
  o$n_urls = n_urls(text)
  o$n_hashtags = n_hashtags(text)
  o$n_mentions = n_mentions(text)
  o$text = text_cleaner(text)
  o$sent_afinn = syuzhet::get_sentiment(text, method = "afinn")
  o$sent_bing = syuzhet::get_sentiment(text, method = "bing")
  o$n_chars = n_charS(text)
  o$n_commas = n_commas(text)
  o$n_digits = n_digits(text)
  o$n_exclaims = n_exclaims(text)
  o$n_extraspaces = n_extraspaces(text)
  o$n_lowers = n_lowers(text)
  o$n_lowersp = (o$n_lowers + 1L) / (o$n_chars + 1L)
  o$n_periods = n_periods(text)
  o$n_words = n_words(text)
  o$n_caps = n_caps(text)
  o$n_nonasciis = n_nonasciis(text)
  o$n_puncts = n_puncts(text)
  o$n_capsp = (o$n_caps + 1L) / (o$n_chars + 1L)
  o$n_charsperword = (o$n_chars + 1L) / (o$n_words + 1L)
  if (nrow(x) > 1000) {
    n_vectors <- 200
  } else if (nrow(x) > 300) {
    n_vectors <- 100
  } else if (nrow(x) > 60) {
    n_vectors <- 50
  } else if (nrow(x) > 10) {
    n_vectors <- 10
  } else {
    n_vectors <- 3
  }
  w <- tryCatch(word2vec_obs(text, n_vectors), error = function(e) return(NULL))
  text <- wtokens(text)
  o$polite <- politeness(text)
  o$n_first_person <- first_person(text)
  o$n_first_personp <- first_personp(text)
  o$n_second_person <- second_person(text)
  o$n_second_personp <- second_personp(text)
  o$n_third_person <- third_person(text)
  o$n_tobe <- to_be(text)
  o$n_prepositions <- prepositions(text)

  o <- tibble::as_tibble(o, validate = FALSE)

  dplyr::bind_cols(o, w)
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


