


#' @export
textfeatures.textfeatures_model <- function(text,
                                            sentiment = TRUE,
                                            word_dims = NULL,
                                            normalize = TRUE,
                                            newdata = NULL,
                                            verbose = TRUE) {
  if (is.null(newdata)) {
    stop(
      "Failed to supply value to `newdata` (a character vector or data frame ",
      "with a 'text' character vector column)",
      call. = FALSE
    )
  }
  ## rename objects
  tf_model <- text$dict
  text <- newdata

  ## fix newdata format
  if (is.factor(text)) {
    text <- as.character(text)
  }
  if (is.data.frame(text)) {
    text <- text$text
  }
  ## validate newdata
  if (!is.character(text)) {
    stop("`newdata` must be a character vector or data frame with a character ",
      "vector column named 'text'.",
      call. = FALSE)
  }

  ## validate inputs
  stopifnot(
    is.character(text),
    is.logical(sentiment),
    is.atomic(word_dims),
    is.logical(normalize)
  )

  ## initialize output data
  o <- tweet_features(text)

  ## length
  n_obs <- length(text)

  ## tokenize into words
  text <- prep_wordtokens(text)

  ## estimate sentiment
  if (sentiment) {
    if (verbose)
      tfse::print_start("Sentiment analysis...")
    o$sent_afinn <- sentiment_afinn(text)
    o$sent_bing <- sentiment_bing(text)
    o$sent_syuzhet <- sentiment_syuzhet(text)
    o$sent_vader <- sentiment_vader(text)
    o$n_polite <- politeness(text)
  }

  ## parts of speech
  if (verbose)
    tfse::print_start("Parts of speech...")
  o$n_first_person <- first_person(text)
  o$n_first_personp <- first_personp(text)
  o$n_second_person <- second_person(text)
  o$n_second_personp <- second_personp(text)
  o$n_third_person <- third_person(text)
  o$n_tobe <- to_be(text)
  o$n_prepositions <- prepositions(text)

  ## if applicable, get w2v estimates
  sh <- TRUE
  sh <- tryCatch(
    utils::capture.output(w <- word_dims_newtext(tf_model, text)),
    error = function(e) return(FALSE))
  if (identical(sh, FALSE)) {
    w <- NULL
  }

  ## convert 'o' into to tibble and merge with w
  o <- tibble::as_tibble(o)
  o <- dplyr::bind_cols(o, w)

  ## make exportable
  m <- vapply(o, mean, na.rm = TRUE, FUN.VALUE = numeric(1))
  s <- vapply(o, stats::sd, na.rm = TRUE, FUN.VALUE = numeric(1))
  e <- list(avg = m, std_dev = s)
  e$dict <- attr(w, "dict")

  ## normalize
  if (normalize) {
    if (verbose)
      tfse::print_start("Normalizing data")
    o <- scale_normal(scale_count(o))
  }

  ## store export list as attribute
  attr(o, "tf_export") <- structure(e,
    class = c("textfeatures_model", "list")
  )

  ## done!
  if (verbose)
    tfse::print_complete("Job's done!")

  ## return
  o
}


tf_export <- function(x) attr(x, "tf_export")
