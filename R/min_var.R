
#' Select columns with minimum amount of variance
#'
#' Filters numeric columns by requiring a minimum amount of variance
#'
#' @param x Input data, which should be either a data frame or matrix.
#' @param min Minimum amount of variance to require per column.
#' @return Returns data frame (or matrix, depending on input class) with all non-numeric
#'   columns and only those numeric columns that meet the minimum amount of variance.
#' @details This function omits missing values.
#' @export
min_var <- function(x, min = 1) UseMethod("min_var")

#' @export
min_var.default <- function(x, min = 1) {
  if (!is.matrix(x)) {
    stop(sprintf("Expected data frame or matrix input but got %s", class(x)[1]),
      call. = FALSE)
  }
  stopifnot(is.numeric(x))
  x[, apply(x, 2, stats::var) >= min]
}

#' @export
min_var.data.frame <- function(x, min = 1) {
  is_num <- vapply(x, is.numeric, FUN.VALUE = logical(1))
  non_num <- names(x)[!is_num]
  yminvar <- names(x[is_num])[
    vapply(x[is_num],
      function(.x) stats::var(.x, na.rm = TRUE) >= min,
      FUN.VALUE = logical(1))
  ]
  x[c(non_num, yminvar)]
}
