n_words <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  x <- gsub("\\d", "", x)
  x <- strsplit(x, "\\s+")
  x <- lengths(x)
  x[na] <- NA_integer_
  x
}


n_uq_words <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  x <- gsub("\\d", "", x)
  x <- strsplit(x, "\\s+")
  x <- lapply(x, unique)
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

n_uq_charS <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  x <- gsub("\\s", "", x)
  x <- strsplit(x, "")
  x <- lapply(x, unique)
  x <- lengths(x)
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
  m <- gregexpr("#[[:alnum:]_]+", x)
  x <- purrr::map_int(m, ~ sum(.x > 0, na.rm = TRUE))
  x[na] <- NA_integer_
  x
}

n_uq_hashtags <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("#[[:alnum:]_]+", x)
  x <- regmatches(x, m)
  x <- lapply(x, unique)
  x <- lengths(x)
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

n_uq_mentions <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("@\\S+", x)
  x <- regmatches(x, m)
  x <- lapply(x, unique)
  x <- lengths(x)
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

n_uq_urls <- function(x) {
  na <- is.na(x)
  if (all(na)) return(0)
  m <- gregexpr("https?", x)
  x <- regmatches(x, m)
  x <- lapply(x, unique)
  x <- lengths(x)
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

#' List of all feature counting functions
#'
#' @details
#' In this function we refer to "first person", "first person plural" and
#' so on. This list describes what words are contained in each group.
#' \describe{
#' \item{first person}{I, me, myself, my, mine, this.}
#' \item{first person plural}{we, us, our, ours, these.}
#' \item{second person}{you, yours, your, yourself.}
#' \item{second person plural}{he, she, it, its, his, hers.}
#' \item{third person}{they, them, theirs, their, they're, their's, those, that.}
#' \item{to be}{am, is, are, was, were, being, been, be, were, be.}
#' \item{prepositions}{about, below,
#' excepting, off, toward, above, beneath, on, under, across, from, onto,
#' underneath, after, between, in, out, until, against, beyond, outside, up,
#' along, but, inside, over, upon, among, by, past, around, concerning,
#' regarding, with, at, despite, into, since, within, down, like, through,
#' without, before, during, near, throughout, behind, except, of, to, for.}
#' }
#'
#' @export
#' @format Named list of all ferature counting functions
#' \describe{
#' \item{\code{n_words}}{Number of words.}
#' \item{\code{n_uq_words}}{Number of unique words.}
#' \item{\code{n_charS}}{Number of characters. Not counting urls, hashtags, mentions or white spaces.}
#' \item{\code{n_uq_charS}}{Number of unique characters. Not counting urls, hashtags, mentions or white spaces.}
#' \item{\code{n_digits}}{Number of digits.}
#' \item{\code{n_hashtags}}{Number of hashtags, word preceded by a '#'.}
#' \item{\code{n_uq_hashtags}}{Number of unique hashtags, word preceded by a '#'.}
#' \item{\code{n_mentions}}{Number of mentions, word preceded by a '@@'.}
#' \item{\code{n_uq_mentions}}{Number of unique mentions, word preceded by a '@@'.}
#' \item{\code{n_commas}}{Number of commas.}
#' \item{\code{n_periods}}{Number of periods.}
#' \item{\code{n_exclaims}}{Number of exclamation points.}
#' \item{\code{n_extraspaces}}{Number of times more then 1 consecutive space have been used.}
#' \item{\code{n_caps}}{Number of upper case characters.}
#' \item{\code{n_lowers}}{Number of lower case characters.}
#' \item{\code{n_urls}}{Number of urls.}
#' \item{\code{n_uq_urls}}{Number of unique urls.}
#' \item{\code{n_nonasciis}}{Number of non ascii characters.}
#' \item{\code{n_puncts}}{Number of punctuations characters, not including exclamation points, periods and commas.}
#' \item{\code{politeness}}{Summed sentiment value calculated using politeness_dict.}
#' \item{\code{first_person}}{Number of "first person" words.}
#' \item{\code{first_personp}}{Number of "first person plural" words.}
#' \item{\code{second_person}}{Number of "second person" words.}
#' \item{\code{second_personp}}{Number of "second person plural" words.}
#' \item{\code{third_person}}{Number of "third person" words.}
#' \item{\code{to_be}}{Number of "to be" words.}
#' \item{\code{prepositions}}{Number of preposition words.}
#' }
"count_functions"
count_functions <- list(
  n_words = n_words,
  n_uq_words = n_uq_words,
  n_charS = n_charS,
  n_uq_charS = n_uq_charS,
  n_digits = n_digits,
  n_hashtags = n_hashtags,
  n_uq_hashtags = n_uq_hashtags,
  n_mentions = n_mentions,
  n_uq_mentions = n_uq_mentions,
  n_commas = n_commas,
  n_periods = n_periods,
  n_exclaims = n_exclaims,
  n_extraspaces = n_extraspaces,
  n_caps = n_caps,
  n_lowers = n_lowers,
  n_urls = n_urls,
  n_uq_urls = n_uq_urls,
  n_nonasciis = n_nonasciis,
  n_puncts = n_puncts,
  politeness = politeness,
  first_person = first_person,
  first_personp = first_personp,
  second_person = second_person,
  second_personp = second_personp,
  third_person = third_person,
  to_be = to_be,
  prepositions = prepositions
)
