
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
#>  1 1005…      2         11          1          2         2      91        0        4          0             7
#>  2 1005…      2         15          1          2         1      24        0        0          0             9
#>  3 1417…      3         10          0          2         1      44        0        6          0            10
#>  4 1417…      2         13          1          5         2      62        0        1          0            11
#>  5 1417…      2         15          1          2         1      24        0        0          0             9
#>  6 1417…      2         11          1          2         2      91        0        4          0             7
#>  7 2481…      2         11          1          2         2      91        0        4          0             7
#>  8 3690…      2         11          1          2         2      91        0        4          0             7
#>  9 9276…      2         15          1          2         1      24        0        0          0             9
#> 10 8429…      0          4          0          0        -1     100        0        2          0             4
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
  mutate(var = factor(var, levels = unique(var)), 
    id = paste0("@", id)) %>%
  ggplot(aes(x = var, y = val, fill = id)) + 
  geom_col(width = .15, fill = "#000000bb") +
  geom_point(size = 2.75, shape = 21) + 
  theme_bw(base_family = "Roboto Condensed") + 
  facet_wrap( ~ id, nrow = 1) + 
  coord_flip() + 
  theme(legend.position = "none",
    axis.text = element_text(colour = "black"),
    axis.text.x = element_text(size = rel(.7)),
    plot.title = element_text(face = "bold", size = rel(1.6)),
    panel.grid.major = element_line(colour = "#333333", size = rel(.05)),
    panel.grid.minor = element_line(colour = "#333333", size = rel(.025))) + 
  labs(y = NULL, x = NULL,
    title = "{textfeatures}: Extract Features from Text",
    subtitle = "Features extracted from text of the most recent 1,000 tweets posted by each news media account")

## save plot
ggsave("tools/readme/readme.png", p, width = 8, height = 5, units = "in")
```

<p style="align:center">

<img src='tools/readme/readme.png' max-width="600px" />

</p>

## `textfeatures2()`

For those not patient enough for the more substantive analytical
methods…

``` r
## 100 tweets
rt <- rtweet::search_tweets("lang:en", n = 100, verbose = FALSE)

## get non-substantive text features
textfeatures2(rt)
#> # A tibble: 100 x 15
#>    id    n_chars n_commas n_digits n_exclaims n_extraspaces n_lowers n_lowersp n_periods n_words n_caps
#>    <chr>   <int>    <int>    <int>      <int>         <int>    <int>     <dbl>     <int>   <int>  <int>
#>  1 1264…      57        1        0          0             2       54     0.948         0      17      2
#>  2 2294…     122        0        0          0             0      116     0.951         1      30      3
#>  3 8378…      48        0        0          0             0       44     0.918         1      11      1
#>  4 2654…      20        0        0          0             0       15     0.762         0       6      1
#>  5 7194…     209        0        6          0             7      171     0.819         7      42     13
#>  6 4269…     102        0        0          0             2       97     0.951         1      16      3
#>  7 1457…     111        0        0          0             0       94     0.848         6      26     11
#>  8 2942…      46        0        0          0             1       39     0.851         0      12      3
#>  9 2938…      17        0        0          0             0       15     0.889         0       7      2
#> 10 1929…      93        0        2          0             3       82     0.883         0      23      2
#> # ... with 90 more rows, and 4 more variables: n_nonasciis <int>, n_puncts <int>, n_capsp <dbl>,
#> #   n_charsperword <dbl>
```
