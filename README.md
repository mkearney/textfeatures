
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
#>  1 8697941…      1          2          1          0         1          0.8
#>  2 1011817…      1          1          0          0         1          0.8
#>  3 1011817…      1          1          0          0         0          0.8
#>  4 1011817…      1          1          0          0         1          0.8
#>  5 1011817…      1          1          0          0         0          0.8
#>  6 1011817…      1          1          0          0         1          0.8
#>  7 1011817…      1          1          0          0         0          0.8
#>  8 1011817…      1          1          0          0         1          0.8
#>  9 1011817…      1          1          0          0         0          0.8
#> 10 1011817…      1          1          0          0         1          0.8
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

## convert to long (tidy) form and plot
p <- f %>%
  scale_count() %>%
  scale_standard() %>%
  summarise_if(is.numeric, mean) %>%
  gather(var, val, -screen_name) %>%
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
#>  1 8697941962…      24        0        3          0             2       18
#>  2 1011817655…      41        0        0          0             1       40
#>  3 1011817655…      45        0        0          0             1       38
#>  4 1011817655…      25        0        3          0             1       18
#>  5 1011817655…      44        0        0          0             1       38
#>  6 1011817655…      24        0        3          0             1       18
#>  7 1011817655…      45        0        0          0             1       38
#>  8 1011817655…      25        0        3          0             1       18
#>  9 1011817655…      93        1        0          0             1       79
#> 10 1011817655…      59        1        3          0             1       46
#> # ... with 90 more rows, and 8 more variables: n_lowersp <dbl>,
#> #   n_periods <int>, n_words <int>, n_caps <int>, n_nonasciis <int>,
#> #   n_puncts <int>, n_capsp <dbl>, n_charsperword <dbl>
```
