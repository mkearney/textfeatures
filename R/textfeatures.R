
#' textfeatures
#'
#' Extracts features from text vector.
#'
#' @param x Input data. Should be character vector, data frame, or grouped data
#'   frame (grouped_df) with character variable of interest named "text". If
#'   grouped_df is provided, then features will be averaged across all
#'   observations for each group.
#' @param sentiment Logical, indicating whether to return sentiment analysis
#'   features–this includes \code{sent_afinn} and \code{sent_bing}. Defaults to
#'   FALSE. Setting this to true will speed things up a bit.
#' @param word2vec_dims Integer indicating the desired number of word2vec dimension
#'   estimates. By default (\code{word2vec_dims = NULL, threads = 1}), this function
#'   will pick a reasonable number of dimensions (ranging from 3 to 200) based on
#'   size of input. To disable word2vec estimates, set this to 0 or FALSE.
#' @param threads Integer, specifying the number of threads to use when generating
#'   word2vec estimates. Defaults to 1. Ignored if \code{word2vec_dims = 0}.
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
textfeatures <- function(x, sentiment = TRUE, word2vec_dims = NULL, threads = threads) {
  UseMethod("textfeatures")
}

#' @export
textfeatures.character <- function(x, sentiment = TRUE, word2vec_dims = NULL, threads = 1) {
  textfeatures(data.frame(text = x, row.names = NULL, stringsAsFactors = FALSE),
    sentiment = sentiment, word2vec_dims = word2vec_dims, threads = threads)
}

#' @export
textfeatures.factor <- function(x, sentiment = TRUE, word2vec_dims = NULL, threads = 1) {
  textfeatures(as.character(x), sentiment = sentiment,
    word2vec_dims = word2vec_dims, threads = threads)
}

#' @export
#' @importFrom tibble as_tibble
#' @importFrom tokenizers tokenize_words
textfeatures.data.frame <- function(x, sentiment = TRUE, word2vec_dims = NULL, threads = 1) {
  ## initialize output data
  o <- list()

  ## validate input
  stopifnot("text" %in% names(x))
  ## make sure "text" is character
  text <- as.character(x$text)
  ## validate text class
  stopifnot(is.character(text), is.numeric(threads), is.logical(sentiment))

  ## try to determine ID/ID-like variable, or create a new one
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
    idname <- "id"
    o$id <- as.character(seq_len(nrow(x)))
  }

  ## number of URLs/hashtags/mentions
  o$n_urls = n_urls(text)
  o$n_hashtags = n_hashtags(text)
  o$n_mentions = n_mentions(text)

  ## scrub urls, hashtags, mentions
  text = text_cleaner(text)

  ## count various character types
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

  ## estimate sentiment
  if (sentiment) {
    o$sent_afinn = syuzhet::get_sentiment(text, method = "afinn")
    o$sent_bing = syuzhet::get_sentiment(text, method = "bing")
  }

  ## tokenize into words
  text <- prep_wordtokens(text)

  ## if null, pick reasonable number of dims
  if (is.null(word2vec_dims)) {
    if (nrow(x) > 10000) {
      n_vectors <- 200
    } else if (nrow(x) > 1000) {
      n_vectors <- 100
    } else if (nrow(x) > 300) {
      n_vectors <- 50
    } else if (nrow(x) > 60) {
      n_vectors <- 20
    } else if (nrow(x) > 10) {
      n_vectors <- 6
    } else {
      n_vectors <- 3
    }
  }

  ## if specified, set as n_vectors
  if (is.numeric(word2vec_dims)) {
    n_vectors <- word2vec_dims
  }

  ## if false, set to 0
  if (identical(word2vec_dims, FALSE)) {
    n_vectors <- 0
  }

  ## if applicable, get w2v estimates
  if (identical(word2vec_dims, 0)) {
    w <- NULL
  } else {
    w <- tryCatch(word2vec_obs(text, n_vectors, threads),
      error = function(e) return(NULL))
  }

  ## count number of polite, POV, to-be, and preposition words.
  o$n_polite <- politeness(text)
  o$n_first_person <- first_person(text)
  o$n_first_personp <- first_personp(text)
  o$n_second_person <- second_person(text)
  o$n_second_personp <- second_personp(text)
  o$n_third_person <- third_person(text)
  o$n_tobe <- to_be(text)
  o$n_prepositions <- prepositions(text)

  ## convert to tibble
  o <- tibble::as_tibble(o, validate = FALSE)

  ## name ID variable
  names(o)[names(o) == "id"] <- idname

  ## merge with w2v estimates
  dplyr::bind_cols(o, w)
}




#' @export
#' @importFrom purrr map_lgl map
textfeatures.list <- function(x, sentiment = TRUE, word2vec_dims = NULL, threads = 1) {
  ## if named list with "text" element
  if (!is.null(names(x)) && "text" %in% names(x)) {
    x <- x$text
    return(textfeatures(x, sentiment = sentiment,
      word2vec_dims = word2vec_dims, threads = threads))
    ## if all elements are character vectors, return list of DFs
  } else if (all(lengths(x) == 1L) && all(map_lgl(x, is.character))) {
    ## (list in, list out)
    return(map(x, textfeatures, sentiment = sentiment,
      word2vec_dims = word2vec_dims, threads = threads))
  }
  ## if all elements are recursive objects containing "text" variable
  if (all(map_lgl(x, is.recursive)) &&
      all(map_lgl(x, ~ "text" %in% names(.x)))) {
    x <- map(x, ~ .x$text)
    return(map(x, textfeatures, sentiment = sentiment,
      word2vec_dims = word2vec_dims, threads = threads))
  }
  stop(paste0("Input is a list without a character vector named \"text\". ",
    "Are you sure the input shouldn't be a character vector or a data frame",
    "with a \"text\" variable?"), call. = FALSE)
}


