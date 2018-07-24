
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
## data frame with rstats tweets
rt <- rtweet::search_tweets("rstats", n = 2000, verbose = FALSE)

## get text features
textfeatures(rt)
#> # A tibble: 1,993 x 128
#>    user_id n_urls n_hashtags n_mentions n_chars n_commas n_digits n_exclaims n_extraspaces n_lowers
#>    <chr>    <int>      <int>      <int>   <int>    <int>    <int>      <int>         <int>    <int>
#>  1 343928…      1          2          0     209        2        3          0             7      169
#>  2 152907…      1          1          0     113        1        0          0             1       99
#>  3 978355…      3         10          0      44        0        6          0            10       30
#>  4 151380…      2          2          2     161        2        0          0             4      148
#>  5 739773…      1          2          0     117        0        0          0             2      115
#>  6 739773…      3          3          1     121        0        0          0             5      105
#>  7 859466…      2         17          1      57        0        0          0            12       49
#>  8 938010…      1          2          1      75        0        0          0             1       73
#>  9 938010…      1          2          1      75        0        0          0             1       73
#> 10 167914…      3          6          0     134        3        1          0             7      112
#> # ... with 1,983 more rows, and 118 more variables: n_lowersp <dbl>, n_periods <int>,
#> #   n_words <int>, n_caps <int>, n_nonasciis <int>, n_puncts <int>, n_capsp <dbl>,
#> #   n_charsperword <dbl>, sent_afinn <int>, sent_bing <int>, n_polite <dbl>, n_first_person <int>,
#> #   n_first_personp <int>, n_second_person <int>, n_second_personp <int>, n_third_person <int>,
#> #   n_tobe <int>, n_prepositions <int>, w1 <dbl>, w2 <dbl>, w3 <dbl>, w4 <dbl>, w5 <dbl>, w6 <dbl>,
#> #   w7 <dbl>, w8 <dbl>, w9 <dbl>, w10 <dbl>, w11 <dbl>, w12 <dbl>, w13 <dbl>, w14 <dbl>, w15 <dbl>,
#> #   w16 <dbl>, w17 <dbl>, w18 <dbl>, w19 <dbl>, w20 <dbl>, w21 <dbl>, w22 <dbl>, w23 <dbl>,
#> #   w24 <dbl>, w25 <dbl>, w26 <dbl>, w27 <dbl>, w28 <dbl>, w29 <dbl>, w30 <dbl>, w31 <dbl>,
#> #   w32 <dbl>, w33 <dbl>, w34 <dbl>, w35 <dbl>, w36 <dbl>, w37 <dbl>, w38 <dbl>, w39 <dbl>,
#> #   w40 <dbl>, w41 <dbl>, w42 <dbl>, w43 <dbl>, w44 <dbl>, w45 <dbl>, w46 <dbl>, w47 <dbl>,
#> #   w48 <dbl>, w49 <dbl>, w50 <dbl>, w51 <dbl>, w52 <dbl>, w53 <dbl>, w54 <dbl>, w55 <dbl>,
#> #   w56 <dbl>, w57 <dbl>, w58 <dbl>, w59 <dbl>, w60 <dbl>, w61 <dbl>, w62 <dbl>, w63 <dbl>,
#> #   w64 <dbl>, w65 <dbl>, w66 <dbl>, w67 <dbl>, w68 <dbl>, w69 <dbl>, w70 <dbl>, w71 <dbl>,
#> #   w72 <dbl>, w73 <dbl>, w74 <dbl>, w75 <dbl>, w76 <dbl>, w77 <dbl>, w78 <dbl>, w79 <dbl>,
#> #   w80 <dbl>, w81 <dbl>, w82 <dbl>, …
```

Compare across multiple authors.

``` r
## data frame tweets from multiple news media accounts
news <- rtweet::get_timelines(
  c("cnn", "nytimes", "foxnews", "latimes", "washingtonpost"), n = 2000)

## get text features (including ests for 20 word dims) for all observations
news_features <- textfeatures(news, word2vec_dims = 20, threads = 3)
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
#>  1 394082…      1          0          0      31        0        2          0             0       28
#>  2 286737…      0          1          0     226        2        2          0             8      205
#>  3 334067…      1          0          0      20        0        0          0             0       16
#>  4 100102…      1          0          0      50        0        0          0             0        3
#>  5 238934…      0          0          0      99        1        0          0             0       87
#>  6 469428…      0          0          0     224        2        0          0             0      218
#>  7 414470…      2          0          1      80        0        8          4             2       58
#>  8 966225…      0          0          0      73        0        0          0             0       67
#>  9 398891…      0          0          3     206        2        0          0             1      201
#> 10 831303…      1          0          0      19        0        0          0             0       17
#> # ... with 90 more rows, and 16 more variables: n_lowersp <dbl>, n_periods <int>, n_words <int>,
#> #   n_caps <int>, n_nonasciis <int>, n_puncts <int>, n_capsp <dbl>, n_charsperword <dbl>,
#> #   n_polite <dbl>, n_first_person <int>, n_first_personp <int>, n_second_person <int>,
#> #   n_second_personp <int>, n_third_person <int>, n_tobe <int>, n_prepositions <int>
```
