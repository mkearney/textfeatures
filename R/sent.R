

sentiment_est <- function(x, dict) {
  if (is.character(x)) {
    x <- gsub("https?://\\S+|@\\S+", "", x)
    x <- tokenizers::tokenize_words(
      x, lowercase = TRUE, strip_punct = TRUE, strip_numeric = FALSE
    )
  }
  vapply(
    x,
    function(.x) sum(dict$value[match(dict$word, .x)], na.rm = TRUE),
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


sentiment_est_binary <- function(x, dict) {
  if (is.character(x)) {
    x <- gsub("https?://\\S+|@\\S+", "", x)
    x <- tokenizers::tokenize_words(
      x, lowercase = TRUE, strip_punct = TRUE, strip_numeric = FALSE
    )
  }
  vapply(
    x,
    function(.x) sum(.x %in% dict$word),
    FUN.VALUE = numeric(1),
    USE.NAMES = FALSE
  )
}

sentiment_nrc_positive <- function(x) {
  sentiment_est_binary(x, nrc_dict[nrc_dict$sentiment == "positive", ])
}
sentiment_nrc_negative <- function(x) {
  sentiment_est_binary(x, nrc_dict[nrc_dict$sentiment == "negative", ])
}
sentiment_nrc_anger <- function(x) {
  sentiment_est_binary(x, nrc_dict[nrc_dict$sentiment == "anger", ])
}
sentiment_nrc_anticipation <- function(x) {
  sentiment_est_binary(x, nrc_dict[nrc_dict$sentiment == "anticipation", ])
}
sentiment_nrc_disgust <- function(x) {
  sentiment_est_binary(x, nrc_dict[nrc_dict$sentiment == "disgust", ])
}
sentiment_nrc_fear <- function(x) {
  sentiment_est_binary(x, nrc_dict[nrc_dict$sentiment == "fear", ])
}
sentiment_nrc_sadness <- function(x) {
  sentiment_est_binary(x, nrc_dict[nrc_dict$sentiment == "sadness", ])
}
sentiment_nrc_surprise <- function(x) {
  sentiment_est_binary(x, nrc_dict[nrc_dict$sentiment == "surprise", ])
}
sentiment_nrc_trust <- function(x) {
  sentiment_est_binary(x, nrc_dict[nrc_dict$sentiment == "trust", ])
}

