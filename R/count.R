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
  m <- gregexpr("https?", x)
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

#' @importFrom purrr map_dbl
politeness <- function(x) {
  purrr::map_dbl(x, ~ sum(politeness_dict$p[politeness_dict$term %in% .x],
    na.rm = TRUE))
}

#' @importFrom purrr map_int
first_person <- function(x) {
  fp <- c("i", "me", "myself", "my", "mine", "this")
  purrr::map_int(x, ~ sum(fp %in% .x, na.rm = TRUE))
}

#' @importFrom purrr map_int
first_personp <- function(x) {
  fp <- c("we", "us", "our", "ours", "these")
  purrr::map_int(x, ~ sum(fp %in% .x, na.rm = TRUE))
}

#' @importFrom purrr map_int
second_person <- function(x) {
  fp <- c("you", "yours", "your", "yourself")
  purrr::map_int(x, ~ sum(fp %in% .x, na.rm = TRUE))
}

#' @importFrom purrr map_int
second_personp <- function(x) {
  fp <- c("he", "she", "it", "its", "his", "hers")
  purrr::map_int(x, ~ sum(fp %in% .x, na.rm = TRUE))
}

#' @importFrom purrr map_int
third_person <- function(x) {
  fp <- c("they", "them", "theirs", "their", "they're",
    "their's", "those", "that")
  purrr::map_int(x, ~ sum(fp %in% .x, na.rm = TRUE))
}

#' @importFrom purrr map_int
to_be <- function(x) {
  fp <- c("am", "is", "are", "was", "were", "being",
    "been", "be", "were", "be")
  purrr::map_int(x, ~ sum(fp %in% .x, na.rm = TRUE))
}

#' @importFrom purrr map_int
prepositions <- function(x) {
  fp <- c("about", "below", "excepting", "off", "toward", "above", "beneath",
    "on", "under", "across", "from", "onto", "underneath", "after", "between",
    "in", "out", "until", "against", "beyond", "outside", "up", "along", "but",
    "inside", "over", "upon", "among", "by", "past", "around", "concerning",
    "regarding", "with", "at", "despite", "into", "since", "within", "down",
    "like", "through", "without", "before", "during", "near", "throughout",
    "behind", "except", "of", "to", "for")
  purrr::map_int(x, ~ sum(fp %in% .x, na.rm = TRUE))

}

