tweet_features <- function(text) {
  ## initialize output data with message
  o <- list()
  tfse::print_start("Tweet-text features")

  ## number of URLs/hashtags/mentions
  o$n_urls <- n_urls(text)
  o$n_uq_urls <- n_uq_urls(text)
  o$n_hashtags <- n_hashtags(text)
  o$n_uq_hashtags <- n_uq_hashtags(text)
  o$n_mentions <- n_mentions(text)
  o$n_uq_mentions <- n_uq_mentions(text)

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
  o
}
