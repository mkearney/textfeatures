estimate_word_dims <- function(text, word_dims, n_obs) {
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
      tfse::print_start("Word dimensions estimated")
    }
  }
  w
}
