
# 👷‍♂️ textfeatures 👷‍♀️ <img src="man/figures/logo.png" width="200px" align="right" />

[![Build
status](https://travis-ci.org/mkearney/textfeatures.svg?branch=master)](https://travis-ci.org/mkearney/textfeatures)
[![CRAN
status](https://www.r-pkg.org/badges/version/textfeatures)](https://cran.r-project.org/package=textfeatures)

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

> A simple package for extracting useful features from character
> objects.

## Install

Install from CRAN.

``` r
## download from CRAN
install.packages("textfeatures")
```

Or install the development version from Github.

``` r
## install from github
devtools::install_github("mkearney/textfeatures")
```

## Usage

### Input: `character`

``` r
## vector of some text
x <- c(
  "this is A!\t sEntence https://github.com about #rstats @github",
  "doh", "THe following list:\n- one\n- two\n- three\nOkay!?!"
)

## get text features
textfeatures(x)
#> # A tibble: 3 x 46
#>   n_urls n_hashtags n_mentions sent_afinn sent_bing sent_syuzhet n_chars
#>    <dbl>      <dbl>      <dbl>      <dbl>     <dbl>        <dbl>   <dbl>
#> 1  0.301      0.301      0.301         -2         0            0   1.34 
#> 2  0          0          0              0         0            0   0.602
#> 3  0          0          0              0         0            0   1.59 
#> # ... with 39 more variables: n_commas <dbl>, n_digits <dbl>,
#> #   n_exclaims <dbl>, n_extraspaces <dbl>, n_lowers <dbl>,
#> #   n_lowersp <dbl>, n_periods <dbl>, n_words <dbl>, n_caps <dbl>,
#> #   n_nonasciis <dbl>, n_puncts <dbl>, n_capsp <dbl>,
#> #   n_charsperword <dbl>, polite_hedges <dbl>,
#> #   polite_positive_emotion <dbl>, polite_negative_emotion <dbl>,
#> #   polite_impersonal_pronoun <dbl>, polite_swearing <dbl>,
#> #   polite_negation <dbl>, polite_filler_pause <dbl>,
#> #   polite_informal_title <dbl>, polite_formal_title <dbl>,
#> #   polite_subjunctive <dbl>, polite_indicative <dbl>,
#> #   polite_for_me <dbl>, polite_for_you <dbl>, polite_reasoning <dbl>,
#> #   polite_reassurance <dbl>, polite_ask_agency <dbl>,
#> #   polite_give_agency <dbl>, polite_hello <dbl>,
#> #   polite_group_identity <dbl>, polite_questions <dbl>,
#> #   polite_gratitude <dbl>, polite_apology <dbl>, polite_actually <dbl>,
#> #   polite_please <dbl>, polite_first_person <dbl>,
#> #   polite_second_person <dbl>
```

### Input: `data.frame`

``` r
## data frame with up to one hundred tweets
rt <- rtweet::search_tweets("rstats", n = 100, verbose = FALSE)

## get text features
textfeatures(rt)
#> # A tibble: 100 x 46
#>    n_urls n_hashtags n_mentions sent_afinn sent_bing sent_syuzhet n_chars
#>     <dbl>      <dbl>      <dbl>      <dbl>     <dbl>        <dbl>   <dbl>
#>  1  0.301      0.301      0              0        -2        -0.8     1.67
#>  2  0.477      0.477      0.301          1         1         0.75    1.81
#>  3  0.477      0.954      0.602          0         0         0       1.48
#>  4  0.301      0.301      0              2         1         0.5     2.24
#>  5  0          0.301      0.477          6         3         1.75    1.93
#>  6  0.477      0.301      0.301          0         1         1.7     1.95
#>  7  0.301      0.301      0              2         1         0.5     2.24
#>  8  0.477      0.301      0.477          9         3         0.9     2.18
#>  9  0.477      0.301      0.477          9         3         0.9     2.18
#> 10  0          0.301      0.477          6         3         1.75    1.93
#> # ... with 90 more rows, and 39 more variables: n_commas <dbl>,
#> #   n_digits <dbl>, n_exclaims <dbl>, n_extraspaces <dbl>, n_lowers <dbl>,
#> #   n_lowersp <dbl>, n_periods <dbl>, n_words <dbl>, n_caps <dbl>,
#> #   n_nonasciis <dbl>, n_puncts <dbl>, n_capsp <dbl>,
#> #   n_charsperword <dbl>, polite_hedges <dbl>,
#> #   polite_positive_emotion <dbl>, polite_negative_emotion <dbl>,
#> #   polite_impersonal_pronoun <dbl>, polite_swearing <dbl>,
#> #   polite_negation <dbl>, polite_filler_pause <dbl>,
#> #   polite_informal_title <dbl>, polite_formal_title <dbl>,
#> #   polite_subjunctive <dbl>, polite_indicative <dbl>,
#> #   polite_for_me <dbl>, polite_for_you <dbl>, polite_reasoning <dbl>,
#> #   polite_reassurance <dbl>, polite_ask_agency <dbl>,
#> #   polite_give_agency <dbl>, polite_hello <dbl>,
#> #   polite_group_identity <dbl>, polite_questions <dbl>,
#> #   polite_gratitude <dbl>, polite_apology <dbl>, polite_actually <dbl>,
#> #   polite_please <dbl>, polite_first_person <dbl>,
#> #   polite_second_person <dbl>
```

### Input: `grouped_df`

``` r
## data frame with up to two hundred tweets for each of 4 users
gdf <- rtweet::get_timelines(
  c("cnn", "nytimes", "foxnews", "latimes"), n = 1000)

## group by screen_name and return text features
f <- textfeatures(dplyr::group_by(gdf, screen_name))

## load ggplot
suppressPackageStartupMessages(library(tidyverse))

## standardize scales
scale_standard <- function(x) {
  xmin <- min(x, na.rm = TRUE)
  (x - xmin) / (max(x, na.rm = TRUE) - xmin)
}

## convert to long (tidy) form and plot
p <- f %>%
  summarise_if(is.numeric, mean) %>%
  gather(var, val, -screen_name) %>%
  mutate_if(is.numeric, scale_standard) %>%
  ggplot(aes(x = var, y = val, fill = screen_name)) + 
  geom_col(width = .65) + 
  theme_bw(base_family = "Roboto Condensed") + 
  facet_wrap( ~ screen_name, nrow = 1) + 
  coord_flip() + 
  theme(legend.position = "none",
    axis.text = element_text(colour = "black"),
    axis.text.x = element_text(size = rel(.7)),
    plot.title = element_text(face = "bold")) + 
  labs(y = NULL, x = NULL,
    title = "{textfeatures}: Extract Features from Text",
    subtitle = "Features extracted from text of the most recent 1,000 tweets posted by each news media account")

## save plot
ggsave("tools/readme/readme.png", p, width = 7, height = 7, units = "in")
```

![](tools/readme/readme.png)
