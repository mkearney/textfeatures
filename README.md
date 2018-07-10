
# 👷

♂️ textfeatures 👷 ♀️
<img src="man/figures/logo.png" width="200px" align="right" />

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
#> # A tibble: 3 x 47
#>      id n_urls n_hashtags n_mentions sent_afinn sent_bing sent_syuzhet
#>   <int>  <int>      <int>      <int>      <int>     <int>        <dbl>
#> 1     1      1          1          1         -2         0            0
#> 2     2      0          0          0          0         0            0
#> 3     3      0          0          0          0         0            0
#> # ... with 40 more variables: n_chars <int>, n_commas <int>,
#> #   n_digits <int>, n_exclaims <int>, n_extraspaces <int>, n_lowers <int>,
#> #   n_lowersp <dbl>, n_periods <int>, n_words <int>, n_caps <int>,
#> #   n_nonasciis <int>, n_puncts <int>, n_capsp <dbl>,
#> #   n_charsperword <dbl>, n_pol_hedges <int>, n_pol_positiveemotion <int>,
#> #   n_pol_negativeemotion <int>, n_pol_impersonalpronoun <dbl>,
#> #   n_pol_swearing <dbl>, n_pol_negation <dbl>, n_pol_fillerpause <dbl>,
#> #   n_pol_informaltitle <dbl>, n_pol_formaltitle <dbl>,
#> #   n_pol_subjunctive <dbl>, n_pol_indicative <dbl>, n_pol_forme <dbl>,
#> #   n_pol_foryou <dbl>, n_pol_reasoning <dbl>, n_pol_reassurance <dbl>,
#> #   n_pol_askagency <dbl>, n_pol_giveagency <dbl>, n_pol_hello <int>,
#> #   n_pol_groupidentity <int>, n_pol_questions <dbl>,
#> #   n_pol_gratitude <int>, n_pol_apology <int>, n_pol_actually <dbl>,
#> #   n_pol_please <dbl>, n_pol_firstperson <int>, n_pol_secondperson <int>
```

### Input: `data.frame`

``` r
## data frame with up to one hundred tweets
rt <- rtweet::search_tweets("rstats", n = 100, verbose = FALSE)

## get text features
textfeatures(rt)
#> # A tibble: 100 x 47
#>    user_id  n_urls n_hashtags n_mentions sent_afinn sent_bing sent_syuzhet
#>    <chr>     <int>      <int>      <int>      <int>     <int>        <dbl>
#>  1 4536934…      2          3          1          8         2         1.05
#>  2 3101015…      0          1          0          2        -2         0.7 
#>  3 1030049…      1          1          1          0         0         0.8 
#>  4 1114574…      1          4          2          0         0         0   
#>  5 9130697…      2          1          0         -1        -2        -0.75
#>  6 1235849…      0          1          3          9         4         3.25
#>  7 3345539…      1          3          0          0         1         0.8 
#>  8 3345539…      2          5          0          2         2         1.1 
#>  9 3345539…      1          2          1          0         1         0.8 
#> 10 3345539…      1          2          1          7         1         2   
#> # ... with 90 more rows, and 40 more variables: n_chars <int>,
#> #   n_commas <int>, n_digits <int>, n_exclaims <int>, n_extraspaces <int>,
#> #   n_lowers <int>, n_lowersp <dbl>, n_periods <int>, n_words <int>,
#> #   n_caps <int>, n_nonasciis <int>, n_puncts <int>, n_capsp <dbl>,
#> #   n_charsperword <dbl>, n_pol_hedges <int>, n_pol_positiveemotion <int>,
#> #   n_pol_negativeemotion <int>, n_pol_impersonalpronoun <dbl>,
#> #   n_pol_swearing <dbl>, n_pol_negation <dbl>, n_pol_fillerpause <dbl>,
#> #   n_pol_informaltitle <dbl>, n_pol_formaltitle <dbl>,
#> #   n_pol_subjunctive <dbl>, n_pol_indicative <dbl>, n_pol_forme <dbl>,
#> #   n_pol_foryou <dbl>, n_pol_reasoning <dbl>, n_pol_reassurance <dbl>,
#> #   n_pol_askagency <dbl>, n_pol_giveagency <dbl>, n_pol_hello <int>,
#> #   n_pol_groupidentity <int>, n_pol_questions <dbl>,
#> #   n_pol_gratitude <int>, n_pol_apology <int>, n_pol_actually <dbl>,
#> #   n_pol_please <dbl>, n_pol_firstperson <int>, n_pol_secondperson <int>
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

## `textfeatures2()`

For those not patient enough for sentiment/politeness analysis

``` r
## get non-substantive text features
textfeatures2(rt)
#> # A tibble: 100 x 15
#>    user_id     n_chars n_commas n_digits n_exclaims n_extraspaces n_lowers
#>    <chr>         <int>    <int>    <int>      <int>         <int>    <int>
#>  1 453693457       118        0        0          2             4      114
#>  2 3101015701      145        1        0          0             0      139
#>  3 103004948        25        0        0          0             3       22
#>  4 111457430        29        0        0          0             7       25
#>  5 9130697596…     140        1        0          1             2      127
#>  6 123584958       175        1        0          3             3      162
#>  7 334553913        62        0        0          0             2       59
#>  8 334553913       128        0        1          0             3      115
#>  9 334553913        24        0        3          0             2       18
#> 10 334553913        69        1        0          1             2       62
#> # ... with 90 more rows, and 8 more variables: n_lowersp <dbl>,
#> #   n_periods <int>, n_words <int>, n_caps <int>, n_nonasciis <int>,
#> #   n_puncts <int>, n_capsp <dbl>, n_charsperword <dbl>
```
