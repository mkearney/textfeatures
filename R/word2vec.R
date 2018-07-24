
#' word2vec
#'
#' Convert text into wordvec dimensions
#'
#' @param x Input text
#' @param n_vectors Number of vectors (dimensions) defaults to 100
#' @param threads Number of threads to use, defaults to 3.
#' @useDynLib textfeatures, .registration = TRUE
#' @export
word2vec <- function(x, n_vectors = 50, threads = 3) {
  tmp_train <- tempfile()
  on.exit(unlink(tmp_train), add = TRUE)
  writeLines(x[nchar(x) > 0], tmp_train)
  tmp_out <- tempfile()
  on.exit(unlink(tmp_out), add = TRUE)
  if (length(x) < 5) {
    min_count <- as.character(length(x))
  } else {
    min_count <- "5"
  }
  # Whether to output binary, default is 1 means binary.
  utils::capture.output(sh <- suppressMessages(.C("CWrapper_word2vec",
    train_file = tmp_train,
    output_file = tmp_out,
    binary = "1",
    dims = as.character(n_vectors),
    threads = as.character(threads),
    window = "12",
    classes = "0",
    cbow = "0",
    min_count = min_count,
    iter = "5",
    neg_samples = "5")))
  x <- read_word2vecoutput(tmp_out)
  x <- tibble::as_tibble(t(x[-1, ]), validate = FALSE)
  names(x) <- gsub("['`<>\\)\\(\\}\\{\\/\\\\]", "", names(x))
  x
}

prep_word2vec <- function(x) {
  x <- text_cleaner(x)
  x <- iconv(x, to = "ASCII", sub = " ")
  x <- trim_ws(x)
  tokenizers::tokenize_words(x, strip_numeric = TRUE)
}

#' word2vec estimates of observed text
#'
#' Converts text vector into n word2vec (dimension) estimates
#'
#' @inheritParams word2vec
#' @return A tibble of observations with n_vectors columns.
#' @export
word2vec_obs <- function(x, n_vectors = 100, threads = 1) {
  x <- prep_word2vec(x)
  w2v <- word2vec(vapply(x, paste, collapse = " ",
    FUN.VALUE = character(1), USE.NAMES = FALSE),
    n_vectors = n_vectors, threads = threads)
  word2vec_obs_ <- function(x) {
    m <- match(x, names(w2v))
    m <- m[!is.na(m)]
    if (length(m) == 0) return(rep(0, nrow(w2v)))
    x <- tibble::as_tibble(lapply(m, function(.x) w2v[[.x]]), validate = FALSE)
    rowSums(x)
  }
  o <- lapply(x, word2vec_obs_)
  o <- tibble::as_tibble(as.data.frame(matrix(unlist(o), length(x), nrow(w2v),
    byrow = TRUE),
    row.names = NULL, stringsAsFactors = FALSE), validate = FALSE)
  names(o) <- paste0("w", seq_len(ncol(o)))
  o
}

trim_ws <- function(x) {
  x <- gsub("[ ]{2,}", " ", x)
  gsub("^[ ]+|[ ]+$", "", x)
}


read_word2vecoutput <- function(filename) {
  a <- file(filename, 'rb')
  on.exit(close(a), add = TRUE)
  rows <- ""
  most_recent = ""
  while (most_recent != " ") {
    most_recent <- readChar(a, 1)
    rows <- paste0(rows, most_recent)
  }
  rows <- as.integer(rows)

  col_number <- ""
  while (most_recent != "\n") {
    most_recent <- readChar(a, 1)
    col_number <- paste0(col_number, most_recent)
  }
  col_number <- as.integer(col_number)

  ## Read a row
  rownames <- rep("", rows)

  returned_columns <- col_number

  read_row <- function(i) {
    rowname <- ""
    most_recent <- ""
    while (TRUE) {
      most_recent <- readChar(a, 1)
      if (most_recent == " ") break
      if (most_recent != "\n") {
        # Some versions end with newlines, some don't.
        rowname <- paste0(rowname, most_recent)
      }
    }
    rownames[i] <<- rowname
    row <- readBin(a, numeric(), size = 4, n = col_number, endian = "little")
    row
  }

  matrix <- t(vapply(1:rows, read_row, as.array(rep(0, returned_columns))))
  rownames(matrix) <- rownames
  matrix
}
