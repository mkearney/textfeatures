
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
    !grepl("[._]?id$", names(x))
  x[yes_ints] <- purrr::map(x[yes_ints], ~ log(.x + 1))
  x
}

#' scale_
#'
#' scale_count10: Transforms integer and integerlike columns using log10
#'
#' @inheritParams scale_count
#' @rdname scale_count
#' @export
scale_count10 <- function(x) {
  yes_ints <- (purrr::map_lgl(x, rlang::is_integerish) |
      (grepl("^n_", names(x)) & purrr::map_lgl(x, is.numeric))) &
    !grepl("[._]?id$", names(x))
  x[yes_ints] <- purrr::map(x[yes_ints], ~ log10(.x + 1))
  x
}


#' scale_
#'
#' scale_inverse: Transforms numeric columns using 1 / x
#'
#' @inheritParams scale_count
#' @rdname scale_count
#' @export
scale_inverse <- function(x) {
  yes <- purrr::map_lgl(x, is.numeric) & !grepl("[._]?id$", names(x))
  x[yes] <- purrr::map(x[yes], ~ 1 / (scale_zero(.x) + 1))
  x
}


scale_zero <- function(x) {
  sign(min(x, na.rm = TRUE)) * x - min(x, na.rm = TRUE)
}


#' scale_
#'
#' scale_log: Transforms numeric columns using log
#'
#' @inheritParams scale_count
#' @rdname scale_count
#' @export
scale_log <- function(x) {
  yes <- purrr::map_lgl(x, is.numeric) & !grepl("[._]?id$", names(x))
  x[yes] <- purrr::map(x[yes], ~ log(scale_zero(.x) + 1))
  x
}

#' scale_
#'
#' scale_log10: Transforms numeric columns using log10
#'
#' @inheritParams scale_count
#' @rdname scale_count
#' @export
scale_log10 <- function(x) {
  yes <- purrr::map_lgl(x, is.numeric) & !grepl("[._]?id$", names(x))
  x[yes] <- purrr::map(x[yes], ~ log10(scale_zero(.x) + 1))
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
  yes <- purrr::map_lgl(x, is.numeric) & !grepl("[._]?id$", names(x))
  x[yes] <- scale(x[yes])
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
  yes <- purrr::map_lgl(x, is.numeric) & !grepl("[._]?id$", names(x))
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
  yes <- purrr::map_lgl(x, is.numeric) & !grepl("[._]?id$", names(x))
  x[yes] <- purrr::map(x[yes], sqrt)
  x
}


standard_scale <- function(x) {
  xmin <- min(x, na.rm = TRUE)
  (x - xmin) / (max(x, na.rm = TRUE) - xmin)
}
