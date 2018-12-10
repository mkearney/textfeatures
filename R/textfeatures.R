
#' textfeatures
#'
#' Extracts features from text vector.
#'
#' @param x Input data. Should be character vector or data frame with character
#'   variable of interest named "text". If a data frame then the first "id|*_id"
#'   variable, if found, is assumed to be an ID variable.
#' @param sentiment Logical, indicating whether to return sentiment analysis
#'   features, the variables \code{sent_afinn} and \code{sent_bing}. Defaults to
#'   FALSE. Setting this to true will speed things up a bit.
#' @param word_dims Integer indicating the desired number of word2vec dimension
#'   estimates. When NULL, the default, this function will pick a reasonable
#'   number of dimensions (ranging from 2 to 200) based on size of input. To
#'   disable word2vec estimates, set this to 0 or FALSE.
#' @param normalize Logical indicating whether to normalize (mean center,
#'   sd = 1) features. Defaults to TRUE.
#' @param export Logical indicating whether to store sufficient information for
#'   exporting the feature extraction process (stores the means, standard deviations,
#'   and the word2vec reference object, which can then be used to process new data).
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
#'     "and another sentence here",
#'     "The following list:\n- one\n- two\n- three\nOkay!?!"),
#'   stringsAsFactors = FALSE
#' )
#'
#' ## get text features of a data frame with "text" variable
#' textfeatures(df)
#'
#' @export
textfeatures <- function(x, sentiment = TRUE, word_dims = NULL,
                         normalize = TRUE, export = FALSE) {
  UseMethod("textfeatures")
}

#' @export
textfeatures.character <- function(x, sentiment = TRUE, word_dims = NULL,
                                   normalize = TRUE, export = FALSE) {
  textfeatures(data.frame(text = x, row.names = NULL, stringsAsFactors = FALSE),
    sentiment = sentiment, word_dims = word_dims,
    normalize = normalize, export = export)
}

#' @export
textfeatures.factor <- function(x, sentiment = TRUE, word_dims = NULL,
                                normalize = TRUE, export = FALSE) {
  textfeatures(as.character(x), sentiment = sentiment,
    word_dims = word_dims, normalize = normalize, export = export)
}

#' @export
textfeatures.data.frame <- function(x, sentiment = TRUE, word_dims = NULL,
                                    normalize = TRUE, export = FALSE) {
  ## initialize output data
  o <- list()

  ## validate input
  stopifnot("text" %in% names(x))

  ## make sure "text" is character
  text <- as.character(x$text)

  ## validate text class
  stopifnot(
    is.character(text),
    is.logical(sentiment)
  )

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
  o$n_urls <- n_urls(text)
  o$n_hashtags <- n_hashtags(text)
  o$n_mentions <- n_mentions(text)

  ## scrub urls, hashtags, mentions
  text <- text_cleaner(text)

  ## count various character types
  o$n_chars <- n_charS(text)
  o$n_commas <- n_commas(text)
  o$n_digits <- n_digits(text)
  o$n_exclaims <- n_exclaims(text)
  o$n_extraspaces <- n_extraspaces(text)
  o$n_lowers <- n_lowers(text)
  o$n_lowersp <- (o$n_lowers + 1L) / (o$n_chars + 1L)
  o$n_periods <- n_periods(text)
  o$n_words <- n_words(text)
  o$n_caps <- n_caps(text)
  o$n_nonasciis <- n_nonasciis(text)
  o$n_puncts <- n_puncts(text)
  o$n_capsp <- (o$n_caps + 1L) / (o$n_chars + 1L)
  o$n_charsperword <- (o$n_chars + 1L) / (o$n_words + 1L)

  ## estimate sentiment
  if (sentiment) {
    o$sent_afinn <- syuzhet::get_sentiment(text, method = "afinn")
    o$sent_bing <- syuzhet::get_sentiment(text, method = "bing")
  }

  ## tokenize into words
  text <- prep_wordtokens(text)

  ## if null, pick reasonable number of dims
  if (is.null(word_dims)) {
    if (nrow(x) > 10000) {
      n_vectors <- 200
    } else if (nrow(x) > 1000) {
      n_vectors <- 100
    } else if (nrow(x) > 300) {
      n_vectors <- 50
    } else if (nrow(x) > 60) {
      n_vectors <- 20
    } else {
      n_vectors <- ceiling(nrow(x) / 2)
    }
  }

  ## if specified, set as n_vectors
  if (is.numeric(word_dims)) {
    n_vectors <- word_dims
  }

  ## if false, set to 0
  if (identical(word_dims, FALSE)) {
    n_vectors <- 0
  }

  ## if applicable, get w2v estimates
  if (identical(n_vectors, 0)) {
    w <- NULL
  } else {
    w <- tryCatch(word_dims(text, n_vectors, export = export),
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
  o <- tibble::as_tibble(o)

  ## name ID variable
  names(o)[names(o) == "id"] <- idname

  ## merge with w2v estimates
  o <- dplyr::bind_cols(o, w)

  ## make exportable
  if (export) {
    m <- vapply(o[-1], mean, na.rm = TRUE, FUN.VALUE = numeric(1))
    s <- vapply(o[-1], stats::sd, na.rm = TRUE, FUN.VALUE = numeric(1))
    e <- list(means = m, sds = s)
    e$w2v_dict <- attr(w, "w2v_dict")
  }

  ## normalize
  if (normalize) {
    o <- scale_normal(scale_count(o))
  }

  ## store export list as attribute
  if (export) {
    attr(o, "tf_export") <- e
  }

  ## return
  o
}




#' @export
textfeatures.list <- function(x, sentiment = TRUE, word_dims = NULL,
                              normalize = TRUE, export = FALSE) {

  ## if named list with "text" element
  if (!is.null(names(x)) && "text" %in% names(x)) {
    x <- x$text
    return(textfeatures(x, sentiment = sentiment,
      word_dims = word_dims))

    ## if all elements are character vectors, return list of DFs
  } else if (all(lengths(x) == 1L) &&
      all(purrr::map_lgl(x, is.character))) {
    ## (list in, list out)
    return(purrr::map(x, textfeatures, sentiment = sentiment,
      word_dims = word_dims, normalize = normalize, export = export))
  }
  ## if all elements are recursive objects containing "text" variable
  if (all(purrr::map_lgl(x, is.recursive)) &&
      all(purrr::map_lgl(x, ~ "text" %in% names(.x)))) {
    x <- purrr::map(x, ~ .x$text)
    return(purrr::map(x, textfeatures, sentiment = sentiment,
      word_dims = word_dims, normalize = normalize, export = export))
  }

  stop(paste0("Input is a list without a character vector named \"text\". ",
    "Are you sure the input shouldn't be a character vector or a data frame",
    "with a \"text\" variable?"), call. = FALSE)
}
