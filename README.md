
# 👷

♂️ textfeatures 👷 ♀️
<img src="man/figures/logo.png" width="160px" align="right" />

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
#> # A tibble: 3 x 29
#>      id n_urls n_hashtags n_mentions text  sent_afinn sent_bing n_chars n_commas n_digits n_exclaims
#>   <int>  <int>      <int>      <int> <chr>      <int>     <int>   <int>    <int>    <int>      <int>
#> 1     1      1          1          1 "thi…         -2         0      53        0        0          1
#> 2     2      0          0          0 doh            0         0       3        0        0          0
#> 3     3      0          0          0 "THe…          0         0      38        0        0          2
#> # ... with 18 more variables: n_extraspaces <int>, n_lowers <int>, n_lowersp <dbl>,
#> #   n_periods <int>, n_words <int>, n_caps <int>, n_nonasciis <int>, n_puncts <int>, n_capsp <dbl>,
#> #   n_charsperword <dbl>, polite <dbl>, n_first_person <int>, n_first_personp <int>,
#> #   n_second_person <int>, n_second_personp <int>, n_third_person <int>, n_tobe <int>,
#> #   n_prepositions <int>
```

### Input: `data.frame`

``` r
## data frame with up to one hundred tweets
rt <- rtweet::search_tweets("rstats", n = 100, verbose = FALSE)

## get text features
textfeatures(rt)
#> # A tibble: 100 x 79
#>    id    n_urls n_hashtags n_mentions text  sent_afinn sent_bing n_chars n_commas n_digits
#>    <chr>  <int>      <int>      <int> <chr>      <int>     <int>   <int>    <int>    <int>
#>  1 8240…      2         20          0 "UML…          0         0     275        0        3
#>  2 2133…      1          2          0 "Ant…          0         0     102        0        0
#>  3 1445…      1          2          0 "Ant…          0         0     102        0        0
#>  4 9442…      1          2          0 "1/4…          0        -1     249        2        4
#>  5 7664…      2         20          0 "UML…          0         0     275        0        3
#>  6 7664…      2         17          0 "Tra…          3         1     260        0        1
#>  7 7664…      2         15          1 "Sec…          0         0     250        0        4
#>  8 7664…      2         19          0 "Pro…          1         1     277        0        4
#>  9 7664…      2         18          0 "Mac…          0        -1     250        0        5
#> 10 7664…      2         19          0 "Art…          0         1     270        0        4
#> # ... with 90 more rows, and 69 more variables: n_exclaims <int>, n_extraspaces <int>,
#> #   n_lowers <int>, n_lowersp <dbl>, n_periods <int>, n_words <int>, n_caps <int>,
#> #   n_nonasciis <int>, n_puncts <int>, n_capsp <dbl>, n_charsperword <dbl>, polite <dbl>,
#> #   n_first_person <int>, n_first_personp <int>, n_second_person <int>, n_second_personp <int>,
#> #   n_third_person <int>, n_tobe <int>, n_prepositions <int>, w2v1 <dbl>, w2v2 <dbl>, w2v3 <dbl>,
#> #   w2v4 <dbl>, w2v5 <dbl>, w2v6 <dbl>, w2v7 <dbl>, w2v8 <dbl>, w2v9 <dbl>, w2v10 <dbl>,
#> #   w2v11 <dbl>, w2v12 <dbl>, w2v13 <dbl>, w2v14 <dbl>, w2v15 <dbl>, w2v16 <dbl>, w2v17 <dbl>,
#> #   w2v18 <dbl>, w2v19 <dbl>, w2v20 <dbl>, w2v21 <dbl>, w2v22 <dbl>, w2v23 <dbl>, w2v24 <dbl>,
#> #   w2v25 <dbl>, w2v26 <dbl>, w2v27 <dbl>, w2v28 <dbl>, w2v29 <dbl>, w2v30 <dbl>, w2v31 <dbl>,
#> #   w2v32 <dbl>, w2v33 <dbl>, w2v34 <dbl>, w2v35 <dbl>, w2v36 <dbl>, w2v37 <dbl>, w2v38 <dbl>,
#> #   w2v39 <dbl>, w2v40 <dbl>, w2v41 <dbl>, w2v42 <dbl>, w2v43 <dbl>, w2v44 <dbl>, w2v45 <dbl>,
#> #   w2v46 <dbl>, w2v47 <dbl>, w2v48 <dbl>, w2v49 <dbl>, w2v50 <dbl>
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
#>    id    n_chars n_commas n_digits n_exclaims n_extraspaces n_lowers n_lowersp n_periods n_words
#>    <chr>   <int>    <int>    <int>      <int>         <int>    <int>     <dbl>     <int>   <int>
#>  1 2246…     200        0        2          0             1      166     0.831         5      46
#>  2 1016…      21        0        0          0             4       17     0.818         0       8
#>  3 3021…      61        0        0          0             2       55     0.903         1      13
#>  4 2469…      22        0        0          0             0       15     0.696         0       4
#>  5 1970…     113        0        0          0             0      107     0.947         0      28
#>  6 4734…      94        1        0          0             1       89     0.947         0      26
#>  7 1894…     120        0        0          0             0      111     0.926         1      30
#>  8 1635…      26        0        0          0             0       22     0.852         1       6
#>  9 1012…      57        0        0          0             4       52     0.914         1      13
#> 10 6031…      26        0        0          0             1       22     0.852         1       8
#> # ... with 90 more rows, and 5 more variables: n_caps <int>, n_nonasciis <int>, n_puncts <int>,
#> #   n_capsp <dbl>, n_charsperword <dbl>
```
