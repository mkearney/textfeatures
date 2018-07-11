
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
#> # A tibble: 3 x 28
#>      id n_urls n_hashtags n_mentions sent_afinn sent_bing n_chars n_commas n_digits n_exclaims n_extraspaces
#>   <int>  <int>      <int>      <int>      <int>     <int>   <int>    <int>    <int>      <int>         <int>
#> 1     1      1          1          1         -2         0      21        0        0          1             3
#> 2     2      0          0          0          0         0       3        0        0          0             0
#> 3     3      0          0          0          0         0      38        0        0          2             4
#> # ... with 17 more variables: n_lowers <int>, n_lowersp <dbl>, n_periods <int>, n_words <int>, n_caps <int>,
#> #   n_nonasciis <int>, n_puncts <int>, n_capsp <dbl>, n_charsperword <dbl>, polite <dbl>,
#> #   n_first_person <int>, n_first_personp <int>, n_second_person <int>, n_second_personp <int>,
#> #   n_third_person <int>, n_tobe <int>, n_prepositions <int>
```

### Input: `data.frame`

``` r
## data frame with up to one hundred tweets
rt <- rtweet::search_tweets("rstats", n = 100, verbose = FALSE)

## get text features
textfeatures(rt)
#> # A tibble: 100 x 28
#>    id    n_urls n_hashtags n_mentions sent_afinn sent_bing n_chars n_commas n_digits n_exclaims n_extraspaces
#>    <chr>  <int>      <int>      <int>      <int>     <int>   <int>    <int>    <int>      <int>         <int>
#>  1 1356…      2          6          0          0         0      58        0        0          0             4
#>  2 1487…      1          3          1          4         3     135        0        0          0             5
#>  3 2746…      0          1          0          0         0     195        0        0          0             0
#>  4 3996…      1          2          9          2         0      17        0        0          1             8
#>  5 2953…      2          1          0          0         1      61        1        0          0             3
#>  6 7545…      1          2          0          0         0     127        1        0          0             3
#>  7 7545…      2          4          0          0         0     100        0        1          1             7
#>  8 2133…      1          4          2          4         2      78        0        0          2             4
#>  9 1605…      1          4          2          4         2      78        0        0          2             4
#> 10 1955…      2          1          1          1         2     168        1        0          0             3
#> # ... with 90 more rows, and 17 more variables: n_lowers <int>, n_lowersp <dbl>, n_periods <int>,
#> #   n_words <int>, n_caps <int>, n_nonasciis <int>, n_puncts <int>, n_capsp <dbl>, n_charsperword <dbl>,
#> #   polite <dbl>, n_first_person <int>, n_first_personp <int>, n_second_person <int>, n_second_personp <int>,
#> #   n_third_person <int>, n_tobe <int>, n_prepositions <int>
```

### Input: `grouped_df`

``` r
## data frame with up to two hundred tweets for each of 4 users
gdf <- rtweet::get_timelines(
  c("cnn", "nytimes", "foxnews", "latimes"), n = 1000)

## get text features for all observations
f <- textfeatures(gdf)

## override id with screen names
f$id <- gdf$screen_name

## load the tidyverse
suppressPackageStartupMessages(library(tidyverse))

## convert to long (tidy) form and plot
p <- f %>%
  scale_count() %>%
  scale_standard() %>%
  group_by(id) %>%
  summarise_if(is.numeric, mean) %>%
  gather(var, val, -id) %>%
  arrange(-val) %>%
  mutate(var = factor(var, levels = unique(var))) %>%
  ggplot(aes(x = var, y = val, fill = id)) + 
  geom_col(width = .15, fill = "#000000bb") +
  geom_point(size = 2.75, shape = 21) + 
  theme_bw(base_family = "Roboto Condensed") + 
  facet_wrap( ~ id, nrow = 1) + 
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

For those not patient enough for the more substantive analytical
methods…

``` r
## 100 tweets
rt <- rtweet::search_tweets("lang:en", n = 100, verbose = FALSE)

## get non-substantive text features
textfeatures2(rt)
#> # A tibble: 100 x 15
#>    id          n_chars n_commas n_digits n_exclaims n_extraspaces n_lowers n_lowersp n_periods n_words n_caps
#>    <chr>         <int>    <int>    <int>      <int>         <int>    <int>     <dbl>     <int>   <int>  <int>
#>  1 1464697975       22        0        2          0             0       20     0.913         0       5      0
#>  2 8869951695…     154        0        0          0             1      145     0.942         0      33      0
#>  3 541624081        62        0        0          0             0       49     0.794         5      15      4
#>  4 7632860884…      23        0        0          0             1       16     0.708         0       6      1
#>  5 9879529890…      27        0        0          0             0       26     0.964         0       8      1
#>  6 3295642727        6        0        0          0             0        4     0.714         0       2      1
#>  7 9999261102…      13        0        0          0             0       10     0.786         0       3      0
#>  8 7569889547…     110        0        0          1             0       99     0.901         1      25      6
#>  9 20358329         68        1        0          0             0       61     0.899         3      13      3
#> 10 236330808        68        0        0          0             0       54     0.797         1      11     12
#> # ... with 90 more rows, and 4 more variables: n_nonasciis <int>, n_puncts <int>, n_capsp <dbl>,
#> #   n_charsperword <dbl>
```
