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
  x <- purrr::map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

n_hashtags <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("#\\S+", x)
  x <- purrr::map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

n_mentions <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("@\\S+", x)
  x <- purrr::map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

n_commas <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr(",", x)
  x <- purrr::map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

n_periods <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("\\.", x)
  x <- purrr::map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

n_exclaims <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("\\!", x)
  x <- purrr::map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

n_extraspaces <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("\\s{2}|\\t|\\n", x)
  x <- purrr::map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

n_caps <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("[[:upper:]]", x)
  x <- purrr::map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

n_lowers <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("[[:lower:]]", x)
  x <- purrr::map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

n_urls <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("https?", x)
  x <- purrr::map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

n_nonasciis <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  x <- iconv(x, from = "UTF-8", to = "ASCII", sub = "[NONASCII]")
  m <- gregexpr("\\[NONASCII\\]", x)
  x <- purrr::map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

n_puncts <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  x <- gsub("!|\\.|\\,", "", x)
  m <- gregexpr("[[:punct:]]", x)
  x <- purrr::map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

politeness <- function(x) {
  purrr::map_dbl(x, ~ sum(politeness_dict$p[politeness_dict$term %in% .x],
    na.rm = TRUE))
}

first_person <- function(x) {
  fp <- c("i", "me", "myself", "my", "mine", "this")
  purrr::map_int(x, ~ sum(fp %in% .x, na.rm = TRUE))
}

first_personp <- function(x) {
  fp <- c("we", "us", "our", "ours", "these")
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
  fp <- c("they", "them", "theirs", "their", "they're",
    "their's", "those", "that")
  purrr::map_int(x, ~ sum(fp %in% .x, na.rm = TRUE))
}

to_be <- function(x) {
  fp <- c("am", "is", "are", "was", "were", "being",
    "been", "be", "were", "be")
  purrr::map_int(x, ~ sum(fp %in% .x, na.rm = TRUE))
}

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

