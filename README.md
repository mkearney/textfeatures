
# 👷 textfeatures 👷<img src="man/figures/logo.png" width="160px" align="right" />

[![Build
status](https://travis-ci.org/mkearney/textfeatures.svg?branch=master)](https://travis-ci.org/mkearney/textfeatures)
[![CRAN
status](https://www.r-pkg.org/badges/version/textfeatures)](https://cran.r-project.org/package=textfeatures)

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

> Easily extract useful features from character objects.

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

### `textfeatures()`

Input a character vector.

``` r
## vector of some text
x <- c(
  "this is A!\t sEntence https://github.com about #rstats @github",
  "and another sentence here", "THe following list:\n- one\n- two\n- three\nOkay!?!"
)

## get text features
textfeatures(x)
#> # A tibble: 3 x 31
#>   id    n_urls n_hashtags n_mentions n_chars n_commas n_digits n_exclaims n_extraspaces n_lowers
#>   <chr>  <int>      <int>      <int>   <int>    <int>    <int>      <int>         <int>    <int>
#> 1 1          1          1          1      21        0        0          1             3       18
#> 2 2          0          0          0      22        0        0          0             0       22
#> 3 3          0          0          0      38        0        0          2             4       28
#> # ... with 21 more variables: n_lowersp <dbl>, n_periods <int>, n_words <int>, n_caps <int>,
#> #   n_nonasciis <int>, n_puncts <int>, n_capsp <dbl>, n_charsperword <dbl>, sent_afinn <int>,
#> #   sent_bing <int>, n_polite <dbl>, n_first_person <int>, n_first_personp <int>,
#> #   n_second_person <int>, n_second_personp <int>, n_third_person <int>, n_tobe <int>,
#> #   n_prepositions <int>, w1 <dbl>, w2 <dbl>, w3 <dbl>
```

Or input a data frame with a column named `text`.

``` r
## data frame with up to one hundred tweets
rt <- rtweet::search_tweets("rstats", n = 100, verbose = FALSE)

## get text features
textfeatures(rt)
#> # A tibble: 100 x 48
#>    user_id n_urls n_hashtags n_mentions n_chars n_commas n_digits n_exclaims n_extraspaces n_lowers
#>    <chr>    <int>      <int>      <int>   <int>    <int>    <int>      <int>         <int>    <int>
#>  1 113952…      1          1          0      66        0        0          0             1       62
#>  2 866671…      2          2          1     135        2        0          0             3      124
#>  3 382514…      1          1          0       0        0        0          0             0        0
#>  4 730130…      2          4          7      93        0        2          0            10       72
#>  5 313671…      3          8          0      43        0        0          0             6       34
#>  6 313671…      2         15          1      24        0        0          0             9       23
#>  7 313671…      2         11          1      91        0        4          0             7       74
#>  8 313671…      3         10          0      44        0        6          0            10       30
#>  9 235549…      1          2          1      97        1        4          0             3       88
#> 10 418128…      2          2          1     135        2        0          0             3      124
#> # ... with 90 more rows, and 38 more variables: n_lowersp <dbl>, n_periods <int>, n_words <int>,
#> #   n_caps <int>, n_nonasciis <int>, n_puncts <int>, n_capsp <dbl>, n_charsperword <dbl>,
#> #   sent_afinn <int>, sent_bing <int>, n_polite <dbl>, n_first_person <int>, n_first_personp <int>,
#> #   n_second_person <int>, n_second_personp <int>, n_third_person <int>, n_tobe <int>,
#> #   n_prepositions <int>, w1 <dbl>, w2 <dbl>, w3 <dbl>, w4 <dbl>, w5 <dbl>, w6 <dbl>, w7 <dbl>,
#> #   w8 <dbl>, w9 <dbl>, w10 <dbl>, w11 <dbl>, w12 <dbl>, w13 <dbl>, w14 <dbl>, w15 <dbl>,
#> #   w16 <dbl>, w17 <dbl>, w18 <dbl>, w19 <dbl>, w20 <dbl>
```

Compare across multiple authors.

``` r
## data frame tweets from multiple news media accounts
news <- rtweet::get_timelines(
  c("cnn", "nytimes", "foxnews", "latimes", "washingtonpost"), n = 2000)

## get text features (including ests for 20 word dims) for all observations
news_features <- textfeatures(news, word2vec_dims = 20, threads = 4)
```

<p style="align:center">

<img src='tools/readme/readme.png' max-width="600px" />

</p>

## Fast version

If you’re looking for something faster try setting `sentiment = FALSE`
and `word2vec = 0`.

``` r
## 100 tweets
rt <- rtweet::search_tweets("lang:en", n = 100, verbose = FALSE)

## get non-substantive text features
textfeatures(rt, sentiment = FALSE, word2vec_dims = 0)
#> # A tibble: 100 x 26
#>    user_id n_urls n_hashtags n_mentions n_chars n_commas n_digits n_exclaims n_extraspaces n_lowers
#>    <chr>    <int>      <int>      <int>   <int>    <int>    <int>      <int>         <int>    <int>
#>  1 273041…      1          0          1      54        0        0          0             1       50
#>  2 900380…      1          0          0      13        0        0          0             0       12
#>  3 241870…      1          0          0     195        1        5          0             3      175
#>  4 396366…      2          0          2     193        0        0          0             3      159
#>  5 160849…      2          1          0      34        0        0          0             5       16
#>  6 933222…      0          0          0      58        0        0          0             0       54
#>  7 100279…      0          0          5      13        1        0          0             2       11
#>  8 545597…      2          1          8      90        0        1          1             8       80
#>  9 823713…      0          0          1      32        0        0          0             0       30
#> 10 481504…      0          0          0      59        2        0          0             0       51
#> # ... with 90 more rows, and 16 more variables: n_lowersp <dbl>, n_periods <int>, n_words <int>,
#> #   n_caps <int>, n_nonasciis <int>, n_puncts <int>, n_capsp <dbl>, n_charsperword <dbl>,
#> #   n_polite <dbl>, n_first_person <int>, n_first_personp <int>, n_second_person <int>,
#> #   n_second_personp <int>, n_third_person <int>, n_tobe <int>, n_prepositions <int>
```
