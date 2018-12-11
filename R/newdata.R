


#' @export
textfeatures.textfeatures_model <- function(x,
                                            sentiment = TRUE,
                                            word_dims = NULL,
                                            normalize = TRUE,
                                            newdata = NULL) {
  if (is.null(newdata)) {
    stop(
      "Failed to supply value to `newdata` (a character vector or data frame ",
      "with a 'text' character vector column)",
      call. = FALSE
    )
  }
  ## rename objects
  tf_model <- x$dict
  x <- newdata

  ## fix newdata format
  if (is.factor(x)) {
    x <- as.character(x)
  }
  if (is.character(x)) {
    x <- data.frame(
      text = x,
      row.names = NULL,
      stringsAsFactors = FALSE)
  }
  ## validate newdata
  if (!is.data.frame(x)) {
    stop("`newdata` must be a character vector or data frame with a character ",
      "vector column named 'text'.",
      call. = FALSE)
  }

  ## validate input
  stopifnot("text" %in% names(x))

  ## initialize output data
  o <- list()

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

  ## if applicable, get w2v estimates
  w <- tryCatch(
    word_dims_newtext(tf_model, text),
    error = function(e) return(NULL)
  )

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
  m <- vapply(o[-1], mean, na.rm = TRUE, FUN.VALUE = numeric(1))
  s <- vapply(o[-1], stats::sd, na.rm = TRUE, FUN.VALUE = numeric(1))
  e <- list(avg = m, std_dev = s)
  e$dict <- attr(w, "dict")

  ## normalize
  if (normalize) {
    o <- scale_normal(scale_count(o))
  }

  ## store export list as attribute
  attr(o, "tf_export") <- e

  ## return
  o
}




#' @export
textfeatures.list <- function(x,
  sentiment = TRUE,
  word_dims = NULL,
  normalize = TRUE) {

  ## if named list with "text" element
  if (!is.null(names(x)) && "text" %in% names(x)) {
    x <- x$text
    return(textfeatures(x,
      sentiment = sentiment,
      word_dims = word_dims))

    ## if all elements are character vectors, return list of DFs
  } else if (all(lengths(x) == 1L) &&
      all(purrr::map_lgl(x, is.character))) {
    ## (list in, list out)
    return(purrr::map(x, textfeatures, sentiment = sentiment,
      word_dims = word_dims, normalize = normalize))
  }
  ## if all elements are recursive objects containing "text" variable
  if (all(purrr::map_lgl(x, is.recursive)) &&
      all(purrr::map_lgl(x, ~ "text" %in% names(.x)))) {
    x <- purrr::map(x, ~ .x$text)
    return(purrr::map(x, textfeatures, sentiment = sentiment,
      word_dims = word_dims, normalize = normalize))
  }

  stop(paste0("Input is a list without a character vector named \"text\". ",
    "Are you sure the input shouldn't be a character vector or a data frame",
    "with a \"text\" variable?"), call. = FALSE)

}


tf_export <- function(x) attr(x, "tf_export")
