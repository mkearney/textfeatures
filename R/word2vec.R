
#' @useDynLib textfeatures, .registration = TRUE
word2vec <- function(x, n_vectors, threads) {
  tmp_train <- tempfile()
  on.exit(unlink(tmp_train), add = TRUE)
  writeLines(x[nchar(x) > 0], tmp_train)
  tmp_out <- tempfile()
  on.exit(unlink(tmp_out), add = TRUE)
  if (length(x) < 5 & length(x) > 1) {
    min_count <- as.character(length(x) - 1)
  } else {
    min_count <- "5"
  }
  # Whether to output binary, default is 1 means binary.
  utils::capture.output(sh <- suppressMessages(.C("cwrapper_word2vec",
    train_file = tmp_train,
    output_file = tmp_out,
    binary = "0",
    dims = as.character(n_vectors),
    threads = as.character(threads),
    window = "12",
    classes = "0",
    cbow = "0",
    min_count = min_count,
    iter = "5",
    neg_samples = "5")))
  x <- read.table(tmp_out, skip = 1)
  nms <- x[, 1, drop = TRUE]
  x <- tibble::as_tibble(t(x[, -1]), validate = FALSE)
  names(x) <- nms
  x
}

word2vec_obs <- function(x, n_vectors = 50, threads = 1, export = FALSE,
                         w2v = NULL) {
  if (is.null(w2v)) {
    w2v <- word2vec(vapply(x, paste, collapse = " ",
      FUN.VALUE = character(1), USE.NAMES = FALSE),
      n_vectors = n_vectors, threads = threads)
  }
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
  if (export) {
    attr(o, "w2v_dict") <- w2v
  }
  o
}

trim_ws <- function(x) {
  x <- gsub("[ ]{2,}", " ", x)
  gsub("^[ ]+|[ ]+$", "", x)
}
