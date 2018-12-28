
#' textfeatures
#'
#' Extracts features from text vector.
#'
#' @param text Input data. Should be character vector or data frame with character
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
textfeatures <- function(text,
                         sentiment = TRUE,
                         word_dims = NULL,
                         normalize = TRUE,
                         newdata = NULL) {
  UseMethod("textfeatures")
}

#' @export
textfeatures.character <- function(text,
                                   sentiment = TRUE,
                                   word_dims = NULL,
                                   normalize = TRUE,
                                   newdata = NULL) {

  ## validate inputs
  stopifnot(
    is.character(text),
    is.logical(sentiment),
    is.atomic(word_dims),
    is.logical(normalize)
  )

  ## initialize output data
  o <- list()

  ## number of URLs/hashtags/mentions
  o$n_urls <- n_urls(text)
  o$n_uq_urls <- n_uq_urls(text)
  o$n_hashtags <- n_hashtags(text)
  o$n_uq_hashtags <- n_uq_hashtags(text)
  o$n_mentions <- n_mentions(text)
  o$n_uq_mentions <- n_uq_mentions(text)
  tfse::print_complete("Tweet text entities (URLs, mentions, etc)")

  ## scrub urls, hashtags, mentions
  text <- text_cleaner(text)

  ## count various character types
  o$n_chars <- n_charS(text)
  o$n_uq_chars <- n_uq_charS(text)
  o$n_commas <- n_commas(text)
  o$n_digits <- n_digits(text)
  o$n_exclaims <- n_exclaims(text)
  o$n_extraspaces <- n_extraspaces(text)
  o$n_lowers <- n_lowers(text)
  o$n_lowersp <- (o$n_lowers + 1L) / (o$n_chars + 1L)
  o$n_periods <- n_periods(text)
  o$n_words <- n_words(text)
  o$n_uq_words <- n_uq_words(text)
  o$n_caps <- n_caps(text)
  o$n_nonasciis <- n_nonasciis(text)
  o$n_puncts <- n_puncts(text)
  o$n_capsp <- (o$n_caps + 1L) / (o$n_chars + 1L)
  o$n_charsperword <- (o$n_chars + 1L) / (o$n_words + 1L)
  tfse::print_complete("Punctuation, characters, words, numbers, etc.")

  ## length
  n_obs <- length(text)

  ## tokenize into words
  text <- prep_wordtokens(text)

  ## estimate sentiment
  if (sentiment) {
    o$sent_afinn <- sentiment_afinn(text)
    tfse::print_complete("Sentiment via 'afinn'")
    o$sent_bing <- sentiment_bing(text)
    tfse::print_complete("Sentiment via 'bing'")
    o$sent_syuzhet <- sentiment_syuzhet(text)
    tfse::print_complete("Sentiment via 'syuzhet'")
    o$sent_vader <- sentiment_vader(text)
    tfse::print_complete("Sentiment via 'vader'")
    o$sent_nrc_positive <- sentiment_nrc_positive(text)
    tfse::print_complete("Positive via 'nrc'")
    o$sent_nrc_negative <- sentiment_nrc_negative(text)
    tfse::print_complete("Negative via 'nrc'")
    o$sent_nrc_anger <- sentiment_nrc_anger(text)
    tfse::print_complete("Anger via 'nrc'")
    o$sent_nrc_anticipation <- sentiment_nrc_anticipation(text)
    tfse::print_complete("Anicipation via 'nrc'")
    o$sent_nrc_disgust <- sentiment_nrc_disgust(text)
    tfse::print_complete("Disgust via 'nrc'")
    o$sent_nrc_fear <- sentiment_nrc_fear(text)
    tfse::print_complete("Fear via 'nrc'")
    o$sent_nrc_sadness <- sentiment_nrc_sadness(text)
    tfse::print_complete("Sadness via 'nrc'")
    o$sent_nrc_surprise <- sentiment_nrc_surprise(text)
    tfse::print_complete("Surprise via 'nrc'")
    o$sent_nrc_trust <- sentiment_nrc_trust(text)
    tfse::print_complete("Trust via 'nrc'")
  }

  ## if null, pick reasonable number of dims
  if (is.null(word_dims)) {
    if (n_obs > 10000) {
      n_vectors <- 200
    } else if (n_obs > 1000) {
      n_vectors <- 100
    } else if (n_obs > 300) {
      n_vectors <- 50
    } else if (n_obs > 60) {
      n_vectors <- 20
    } else {
      n_vectors <- ceiling(n_obs / 2)
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
    sh <- TRUE
    sh <- tryCatch(
      capture.output(w <- word_dims(text, n_vectors)),
      error = function(e) return(FALSE))
    if (identical(sh, FALSE)) {
      w <- NULL
    } else {
      tfse::print_complete("Word dimensions estimated")
    }
  }

  ## count number of polite, POV, to-be, and preposition words.
  o$n_polite <- politeness(text)
  tfse::print_complete("Politeness")

  o$n_first_person <- first_person(text)
  o$n_first_personp <- first_personp(text)
  o$n_second_person <- second_person(text)
  o$n_second_personp <- second_personp(text)
  o$n_third_person <- third_person(text)
  o$n_tobe <- to_be(text)
  o$n_prepositions <- prepositions(text)
  tfse::print_complete("Parts of speech")

  ## convert to tibble
  o <- tibble::as_tibble(o)

  ## merge with word vectors
  o <- dplyr::bind_cols(o, w)

  ## make exportable
  m <- vapply(o, mean, na.rm = TRUE, FUN.VALUE = numeric(1))
  s <- vapply(o, stats::sd, na.rm = TRUE, FUN.VALUE = numeric(1))
  e <- list(avg = m, std_dev = s)
  e$dict <- attr(w, "dict")

  ## normalize
  if (normalize) {
    tfse::print_complete("Normalizing data")
    o <- scale_normal(scale_count(o))
  }

  ## store export list as attribute
  attr(o, "tf_export") <- structure(e,
    class = c("textfeatures_model", "list")
  )

  ## return
  o
}

#' @export
textfeatures.factor <- function(text,
                                sentiment = TRUE,
                                word_dims = NULL,
                                normalize = TRUE,
                                newdata = newdata) {
  textfeatures(
    as.character(text),
    sentiment = sentiment,
    word_dims = word_dims,
    normalize = normalize,
    newdata = newdata
  )
}

#' @export
textfeatures.data.frame <- function(text,
                                    sentiment = TRUE,
                                    word_dims = NULL,
                                    normalize = TRUE,
                                    newdata = newdata) {

  ## validate input
  stopifnot("text" %in% names(text))
  textfeatures(
    text$text,
    sentiment = sentiment,
    word_dims = word_dims,
    normalize = normalize,
    newdata = newdata
  )
}
