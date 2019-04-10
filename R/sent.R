
sentiment_est <- function(x, dict) {
  if (is.character(x)) {
    ## this removes URLs
    x <- gsub("https?://\\S+", "", x)
    x <- tokenizers::tokenize_words(
      x, lowercase = TRUE, strip_punct = TRUE, strip_numeric = FALSE
    )
  }
  vapply(
    x,
    function(.x) sum(dict$value[match(.x, dict$word)], na.rm = TRUE),
    FUN.VALUE = numeric(1),
    USE.NAMES = FALSE
  )
}

sentiment_afinn <- function(x) {
  sentiment_est(x, afinn_dict)
}

sentiment_bing <- function(x) {
  sentiment_est(x, bing_dict)
}

sentiment_syuzhet <- function(x) {
  sentiment_est(x, syuzhet_dict)
}

sentiment_vader <- function(x) {
  sentiment_est(x, vader_dict)
}


