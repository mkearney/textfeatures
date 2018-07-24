#' @useDynLib textfeatures, .registration = TRUE
#' @importFrom Rcpp sourceCpp
NULL

#' word2vec
#'
#' Convert text into wordvec dimensions
#'
#' @param x Input text
#' @param n_vectors Number of vectors (dimensions) defaults to 100
#' @param threads Number of threads to use, defaults to 1.
#' @export
word2vec <- function(x, n_vectors = 50, threads = 1) {
  tmp_train <- tempfile()
  writeLines(x[nchar(x) > 0], tmp_train)
  tmp_out <- tempfile()
  # Whether to output binary, default is 1 means binary.
  capture.output(sh <- suppressMessages(.C("CWrapper_word2vec",
    train_file = tmp_train,
    output_file = tmp_out,
    binary = "1",
    dims = as.character(n_vectors),
    threads = as.character(threads),
    window = "12",
    classes = "0",
    cbow = "0",
    min_count = "5",
    iter = "5",
    neg_samples = "5")))
  x <- read_word2vecoutput(tmp_out)
  unlink(tmp_out)
  unlink(tmp_train)
  x <- tibble::as_tibble(t(x[-1, ]))
  names(x) <- gsub("['`<>\\)\\(\\}\\{\\/\\\\]", "", names(x))
  x
}

prep_word2vec <- function(x) {
  x <- text_cleaner(x)
  x <- iconv(x, to = "ASCII", sub = " ")
  x <- trim_ws(x)
  tokenizers::tokenize_words(x, strip_numeric = TRUE)
}

#' word2vec observations
#'
#' @inheritParams word2vec
#' @return Matrix
#' @export
word2vec_obs <- function(x, n_vectors = 100, threads = 1) {
  x <- prep_word2vec(x)
  w2v <- word2vec(vapply(x, paste, collapse = " ",
    FUN.VALUE = character(1), USE.NAMES = FALSE), n_vectors = n_vectors, threads = threads)
  word2vec_obs_ <- function(x) {
    m <- match(x, names(w2v))
    m <- m[!is.na(m)]
    if (length(m) == 0) return(rep(0, nrow(w2v)))
    x <- tfse::as_tbl(purrr::map(m, ~ w2v[[.x]]))
    rowSums(x)
  }
  o <- purrr::map(x, word2vec_obs_)
  tibble::as_tibble(as.data.frame(matrix(unlist(o), length(x), nrow(w2v), byrow = TRUE),
    row.names = NULL, stringsAsFactors = FALSE))
}

trim_ws <- function(x) {
  x <- gsub("[ ]{2,}", " ", x)
  gsub("^[ ]+|[ ]+$", "", x)
}


read_word2vecoutput <- function(filename,nrows = Inf, cols = "All", rowname_list = NULL, rowname_regexp = NULL) {
  if (!is.null(rowname_list) && !is.null(rowname_regexp)) {
    stop("Specify a whitelist of names or a regular expression to be applied to all input, not both.")
  }
  a <- file(filename,'rb')
  rows <- ""
  mostRecent = ""
  while (mostRecent != " ") {
    mostRecent <- readChar(a,1)
    rows <- paste0(rows,mostRecent)
  }
  rows <- as.integer(rows)

  col_number <- ""
  while (mostRecent != "\n") {
    mostRecent <- readChar(a,1)
    col_number <- paste0(col_number,mostRecent)
  }
  col_number <- as.integer(col_number)

  if (nrows < rows) {
    rows <- nrows
  } else {
  }


  ## Read a row
  rownames <- rep("", rows)


  returned_columns <- col_number
  if (is.numeric(cols)) {
    returned_columns <- length(cols)
  }

  read_row <- function(i) {
    rowname <- ""
    mostRecent <- ""
    while (TRUE) {
      mostRecent <- readChar(a, 1)
      if (mostRecent == " ") {break}
      if (mostRecent != "\n") {
        # Some versions end with newlines, some don't.
        rowname <- paste0(rowname, mostRecent)
      }
    }
    rownames[i] <<- rowname
    row <- readBin(a, numeric(),size = 4, n = col_number, endian = "little")
    if (is.numeric(cols)) {
      return(row[cols])
    }
    return(row)
  }

  # When the size is fixed, it's faster to do as a vapply than as a for loop.
  if (is.null(rowname_list) && is.null(rowname_regexp)) {
    matrix <- t(
      vapply(1:rows,read_row,as.array(rep(0, returned_columns)))
    )
  } else {
    elements <- list()
    mynames <- c()
    for (i in 1:rows) {
      row <- read_row(i)
      if (!is.null(rowname_list)) {
        if (rownames[i] %in% rowname_list) {
          elements[[rownames[i]]] <- row
        }
      }
      if (!is.null(rowname_regexp)) {
        if (grepl(pattern = rowname_regexp, x = rownames[i])) {
          elements[[rownames[i]]] <- row
        }
      }
    }
    matrix <- t(simplify2array(elements))
    rownames <- names(elements)

  }
  close(a)
  rownames(matrix) <- rownames
  matrix
}
