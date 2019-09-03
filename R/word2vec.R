#' @param lda_model A pretrained \code{\link[text2vec]{LDA}} model from
#'     \pkg{text2vec}.
#' @export
#' @inheritParams word_dims
#' @rdname word_dims
word_dims_newtext <- function(lda_model, text, n_iter = 20) {
  tokens <- text2vec::word_tokenizer(tolower(text))
  it <- text2vec::itoken(tokens, ids = seq_along(text))
  v <- text2vec::create_vocabulary(it)
  v <- text2vec::prune_vocabulary(v, term_count_min = 5, doc_proportion_max = 0.2)
  dtm <- text2vec::create_dtm(it, text2vec::vocab_vectorizer(v))
  d <- lda_model$fit_transform(dtm, n_iter = n_iter)
  d <- as.data.frame(d, stringsAsFactors = FALSE)
  names(d) <- paste0("w", seq_len(ncol(d)))
  row.names(d) <- NULL
  d
}

#' Calculates word2vec dimension estimates
#'
#' @param text Input data. Should be character vector.
#' @param n Integer, determines the number of latent topics.
#' @param n_iter Integer, number of sampling iterations.
#'
#' @return A tibble data frame
#' @export
#'
#' @examples
#' trump_tweets <- c(
#' "#FraudNewsCNN #FNN https://t.co/WYUnHjjUjg",
#' "TODAY WE MAKE AMERICA GREAT AGAIN!",
#' paste("Why would Kim Jong-un insult me by calling me \"old,\" when I would",
#'       "NEVER call him \"short and fat?\" Oh well, I try so hard to be his",
#'       "friend - and maybe someday that will happen!"),
#' paste("Such a beautiful and important evening! The forgotten man and woman",
#'       "will never be forgotten again. We will all come together as never before"),
#' paste("North Korean Leader Kim Jong Un just stated that the \"Nuclear",
#'       "Button is on his desk at all times.\" Will someone from his depleted and",
#'       "food starved regime please inform him that I too have a Nuclear Button,",
#'       "but it is a much bigger &amp; more powerful one than his, and my Button",
#'       "works!")
#' )
#' word_dims(trump_tweets)
#'
#' @rdname word_dims
word_dims <- function(text, n = 10, n_iter = 20) {
  tokens <- text2vec::word_tokenizer(tolower(text))
  it <- text2vec::itoken(tokens, ids = seq_along(text))
  v <- text2vec::create_vocabulary(it)
  v <- text2vec::prune_vocabulary(v, term_count_min = 2, vocab_term_max = n * 50)
  dtm <- text2vec::create_dtm(it, text2vec::vocab_vectorizer(v))
  lda_model <- text2vec::LDA$new(n_topics = n)
  d <- lda_model$fit_transform(dtm, n_iter = n_iter)
  d <- as.data.frame(d, stringsAsFactors = FALSE)
  names(d) <- paste0("w", seq_len(ncol(d)))
  row.names(d) <- NULL
  attr(d, "dict") <- lda_model
  d
}
