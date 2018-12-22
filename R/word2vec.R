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
