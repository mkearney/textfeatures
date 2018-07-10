n_words <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  x <- gsub("\\d", "", x)
  x <- strsplit(x, "\\s+")
  x <- lengths(x)
  x[na] <- NA_integer_
  x
}

n_charS <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  x <- gsub("\\s", "", x)
  x <- nchar(x)
  x[na] <- NA_integer_
  x
}

n_digits <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("\\d", x)
  x <- map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

#' @importFrom purrr map_int
n_hashtags <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("#\\S+", x)
  x <- map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

#' @importFrom purrr map_int
n_mentions <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("@\\S+", x)
  x <- map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

#' @importFrom purrr map_int
n_commas <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr(",", x)
  x <- map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

#' @importFrom purrr map_int
n_periods <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("\\.", x)
  x <- map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

#' @importFrom purrr map_int
n_exclaims <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("\\!", x)
  x <- map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

#' @importFrom purrr map_int
n_extraspaces <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("\\s{2}|\\t|\\n", x)
  x <- map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

#' @importFrom purrr map_int
n_caps <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("[[:upper:]]", x)
  x <- map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

#' @importFrom purrr map_int
n_lowers <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("[[:lower:]]", x)
  x <- map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

#' @importFrom purrr map_int
n_urls <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("https?:", x)
  x <- map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

#' @importFrom purrr map_int
n_nonasciis <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  x <- iconv(x, from = "UTF-8", to = "ASCII", sub = "[NONASCII]")
  m <- gregexpr("\\[NONASCII\\]", x)
  x <- map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

#' @importFrom purrr map_int
n_puncts <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  x <- gsub("!|\\.|\\,", "", x)
  m <- gregexpr("[[:punct:]]", x)
  x <- map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

#' @importFrom utils capture.output
polite_politeness <- function(x) {
  tmp <- tempfile()
  invisible(capture.output(p <- politeness::politeness(x, parser = "none", drop_blank = FALSE,
    metric = "count"), file = tmp))
  unlink(tmp)
  p <- p[!names(p) %in% c("Goodbye", "By.The.Way", "Let.Me.Know")]
  names(p) <- paste0("n_pol_", gsub("\\.", "", tolower(names(p))))
  p
}

