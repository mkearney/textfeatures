
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
#>  1 9197…      1         34         48          3         1       7        0        0          0            42
#>  2 9046…      1         32         46          3         1       8        0        0          0            40
#>  3 3698…      1          2          0          1         1     121        0        0          1             3
#>  4 3961…      2          1          1          0         0      59        2        0          0             3
#>  5 9599…      0          1          0          2         0      56        0        6          1             0
#>  6 2266…      1         32         46          3         1       8        0        0          0            40
#>  7 8924…      0          2          0          0         0      25        0        1          0             1
#>  8 6559…      2          2          2          9         3     167        0        0          0             4
#>  9 1661…      1          2          0          2         1      24        0        1          1             1
#> 10 7455…      1          2          0          5         0     191        0        0          1             5
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
#>    id          n_chars n_commas n_digits n_exclaims n_extraspaces n_lowers n_lowersp n_periods n_words n_caps
#>    <chr>         <int>    <int>    <int>      <int>         <int>    <int>     <dbl>     <int>   <int>  <int>
#>  1 9763409440…      82        0        1          2             1       48     0.590         8      15     23
#>  2 8981748454…     101        1        0          0             0       91     0.902         0      19      4
#>  3 9426292          16        0        0          0             0       15     0.941         0       4      1
#>  4 360459022        63        0        1          0             0       29     0.469         1      15     31
#>  5 1003568751…     176        0        3          2             5       97     0.554         1      42     36
#>  6 1004369618…      50        1        0          1             0       44     0.882         0      14      4
#>  7 5981342          66        0        0          0             2       48     0.731         1      13     12
#>  8 8519847839…       8        0        0          0             0        6     0.778         0       3      2
#>  9 1202684592        7        0        0          0             0        5     0.75          0       4      2
#> 10 1013910276…      32        2        0          0             2        5     0.182         1       5     23
#> # ... with 90 more rows, and 4 more variables: n_nonasciis <int>, n_puncts <int>, n_capsp <dbl>,
#> #   n_charsperword <dbl>
```
