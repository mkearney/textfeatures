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

wtokens <- function(x) {
  x <- tolower(x)
  x <- strsplit(x, "\\s+")
  x <- purrr::map(x, ~ gsub("^[[:punct:]]+|[[:punct:]]|$", "", .x))
  x <- purrr::map(x, ~ gsub("[[:punct:]].*", "", .x))
  purrr::map(x, ~ return(.x[.x != ""]))
}

politeness <- function(x) {
  purrr::map_dbl(x, ~ sum(politeness_dict$p[politeness_dict$term %in% .x],
    na.rm = TRUE))
}

first_person <- function(x) {
  fp <- c("i", "me", "myself", "my", "mine")
  purrr::map_int(x, ~ sum(fp %in% .x, na.rm = TRUE))
}

first_personp <- function(x) {
  fp <- c("we", "us", "our", "ours")
  purrr::map_int(x, ~ sum(fp %in% .x, na.rm = TRUE))
}

second_person <- function(x) {
  fp <- c("you", "yours", "your", "yourself")
  purrr::map_int(x, ~ sum(fp %in% .x, na.rm = TRUE))
}

second_personp <- function(x) {
  fp <- c("he", "she", "it", "its", "his", "hers")
  purrr::map_int(x, ~ sum(fp %in% .x, na.rm = TRUE))
}

third_person <- function(x) {
  fp <- c("they", "them", "theirs", "their")
  purrr::map_int(x, ~ sum(fp %in% .x, na.rm = TRUE))
}

to_be <- function(x) {
  fp <- c("am", "is", "are", "was", "were", "being",
    "been", "be", "were", "be")
  purrr::map_int(x, ~ sum(fp %in% .x, na.rm = TRUE))
}

prepositions <- function(x) {
  fp <- c("about", "below", "excepting", "off", "toward", "above", "beneath", "for",
    "on", "under", "across", "from", "onto", "underneath", "after", "between",
    "in", "out", "until", "against", "beyond", "outside", "up", "along", "but",
    "inside", "over", "upon", "among", "by", "past", "around", "concerning",
    "regarding", "with", "at", "despite", "into", "since", "within", "down",
    "like", "through", "without", "before", "during", "near", "throughout",
    "behind", "except", "of", "to")
  purrr::map_int(x, ~ sum(fp %in% .x, na.rm = TRUE))

}

