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
  x <- nchar(gsub("\\D", "", x))
  x[na] <- NA_integer_
  x
}

n_hashtags <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("#\\S+", x)
  x <- vply_int(m, ~ sum(. > 0))
  x[na] <- NA_integer_
  x
}

n_mentions <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("@\\S+", x)
  x <- vply_int(m, ~ sum(. > 0))
  x[na] <- NA_integer_
  x
}

n_commas <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr(",+", x)
  x <- vply_int(m, ~ sum(. > 0))
  x[na] <- NA_integer_
  x
}

n_periods <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("\\.+", x)
  x <- vply_int(m, ~ sum(. > 0))
  x[na] <- NA_integer_
  x
}

n_exclaims <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("\\!+", x)
  x <- vply_int(m, ~ sum(. > 0))
  x[na] <- NA_integer_
  x
}

n_extraspaces <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("\\s{2,}|\\t|\\n", x)
  x <- vply_int(m, ~ sum(. > 0))
  x[na] <- NA_integer_
  x
}

n_caps <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("[[:upper:]]", x)
  x <- vply_int(m, ~ sum(. > 0))
  x[na] <- NA_integer_
  x
}

n_lowers <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("[[:lower:]]", x)
  x <- vply_int(m, ~ sum(. > 0))
  x[na] <- NA_integer_
  x
}

n_urls <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("https?:", x)
  x <- vply_int(m, ~ sum(. > 0))
  x[na] <- NA_integer_
  x
}

n_nonasciis <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  x <- iconv(x, from = "UTF-8", to = "ASCII", sub = "[NONASCII]")
  m <- gregexpr("\\[NONASCII\\]", x)
  x <- vply_int(m, ~ sum(. > 0))
  x[na] <- NA_integer_
  x
}

n_puncts <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  x <- gsub("!|\\.|\\,", "", x)
  m <- gregexpr("[[:punct:]]", x)
  x <- vply_int(m, ~ sum(. > 0))
  x[na] <- NA_integer_
  x
}
