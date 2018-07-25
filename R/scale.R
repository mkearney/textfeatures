
#' Apply various transformations to numeric (and non-id) data
#'
#' scale_count: Transforms integer and integerlike columns using log
#'
#' @param x Input data frame containing numeric columns.
#' @return A data frame with the same dimensions but with the
#'   numeric/relevant variables transformed.
#' @details
#' Scale transformations are applied only to numeric (or in the
#'   case of \code{scale_count} only integer or integerish) columns
#'   that are not named \code{"id"} or \code{"(\\.|_)?id"}.
#' @rdname scale_count
#' @export
scale_count <- function(x) {
  yes_ints <- (purrr::map_lgl(x, rlang::is_integerish) |
      (grepl("^n_", names(x)) & purrr::map_lgl(x, is.numeric))) &
    !grepl("[._]?id$", names(x)) & names(x) != "y"
  x[yes_ints] <- purrr::map(x[yes_ints], ~ log10(scale_zero(.x) + 1))
  x
}


scale_zero <- function(x) x + (0 - min(x))


#' scale_
#'
#' scale_log: Transforms numeric columns using log
#'
#' @inheritParams scale_count
#' @rdname scale_count
#' @export
scale_log <- function(x) {
  yes <- purrr::map_lgl(x, is.numeric) & !grepl("[._]?id$", names(x)) &
    names(x) != "y"
  x[yes] <- purrr::map(x[yes], ~ log(scale_zero(.x) + 1))
  x
}

#' scale_
#'
#' scale_normal: Transforms numeric columns using mean centering and dividing by standard deviation
#'
#' @inheritParams scale_count
#' @rdname scale_count
#' @export
scale_normal <- function(x) {
  yes <- purrr::map_lgl(x, is.numeric) & !grepl("[._]?id$", names(x)) &
    names(x) != "y"
  x[yes] <- scale0(x[yes])
  x
}

scale0 <- function(x) {
  x <- as.matrix(x)
  center <- colMeans(x, na.rm = TRUE)
  x <- sweep(x, 2L, center, check.margin = FALSE)
  f <- function(v) {
    v <- v[!is.na(v)]
    sqrt(sum(v^2)/max(1, length(v) - 1L))
  }
  scale <- apply(x, 2L, f)
  x[, scale != 0] <- sweep(x[, scale != 0, drop = FALSE], 2L, scale[scale != 0], "/", check.margin = FALSE)
  x
}


#' scale_
#'
#' scale_standard: Transforms numeric columns onto 0-1 scales with 0 and 1 set empirically
#'
#' @inheritParams scale_count
#' @rdname scale_count
#' @export
scale_standard <- function(x) {
  yes <- purrr::map_lgl(x, is.numeric) & !grepl("[._]?id$", names(x)) &
    names(x) != "y"
  x[yes] <- purrr::map(x[yes], standard_scale)
  x
}


#' scale_
#'
#' scale_sqrt: Transforms numeric columns using sqrt
#'
#' @inheritParams scale_count
#' @rdname scale_count
#' @export
scale_sqrt <- function(x) {
  yes <- purrr::map_lgl(x, ~ is.numeric(.x) & min(.x, na.rm = TRUE) >= 0) &
    !grepl("[._]?id$", names(x)) & names(x) != "y"
  x[yes] <- purrr::map(x[yes], sqrt)
  x
}


standard_scale <- function(x) {
  xmin <- min(x, na.rm = TRUE)
  (x - xmin) / (max(x, na.rm = TRUE) - xmin)
}
