
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
#> # A tibble: 3 x 30
#>   id    n_urls n_hashtags n_mentions n_chars n_commas n_digits n_exclaims n_extraspaces n_lowers
#>   <chr>  <dbl>      <dbl>      <dbl>   <dbl>    <dbl>    <dbl>      <dbl>         <dbl>    <dbl>
#> 1 1      1.15       1.15       1.15   -0.792      NaN      NaN      0.173         0.445   -1.09 
#> 2 2     -0.577     -0.577     -0.577  -0.332      NaN      NaN     -1.08         -1.15     0.224
#> 3 3     -0.577     -0.577     -0.577   1.12       NaN      NaN      0.902         0.701    0.869
#> # ... with 20 more variables: n_lowersp <dbl>, n_periods <dbl>, n_words <dbl>, n_caps <dbl>,
#> #   n_nonasciis <dbl>, n_puncts <dbl>, n_capsp <dbl>, n_charsperword <dbl>, sent_afinn <dbl>,
#> #   sent_bing <dbl>, n_polite <dbl>, n_first_person <dbl>, n_first_personp <dbl>,
#> #   n_second_person <dbl>, n_second_personp <dbl>, n_third_person <dbl>, n_tobe <dbl>,
#> #   n_prepositions <dbl>, w1 <dbl>, w2 <dbl>
```

Or input a data frame with a column named `text`.

``` r
## data frame with rstats tweets
rt <- rtweet::search_tweets("rstats", n = 2000, verbose = FALSE)

## get text features
textfeatures(rt)
#> # A tibble: 1,996 x 128
#>    user_id n_urls n_hashtags n_mentions n_chars n_commas n_digits n_exclaims n_extraspaces n_lowers
#>    <chr>    <dbl>      <dbl>      <dbl>   <dbl>    <dbl>    <dbl>      <dbl>         <dbl>    <dbl>
#>  1 335499… -0.495     -1.00       2.46    0.758    1.14    -0.565      1.74         0.223     0.839
#>  2 270458… -0.495      1.85      -0.636  -1.80    -0.492   -0.565     -0.441        1.69     -1.61 
#>  3 270458… -0.495      1.59      -0.636  -0.548   -0.492   -0.565     -0.441        1.20     -0.403
#>  4 270458…  0.721      1.43       2.03   -0.897   -0.492   -0.565     -0.441        1.31     -0.814
#>  5 270458…  0.721      1.37      -0.636  -0.644   -0.492   -0.565     -0.441        1.08     -0.612
#>  6 270458…  0.721      1.37       0.696  -0.373   -0.492   -0.565     -0.441        1.08     -0.469
#>  7 270458…  0.721      1.43      -0.636  -0.292   -0.492    0.571     -0.441        1.08     -0.436
#>  8 781871… -0.495     -0.563     -0.636   1.11    -0.492    1.24      -0.441       -0.0347    1.10 
#>  9 812424…  0.721      1.37      -0.636  -0.644   -0.492   -0.565     -0.441        1.08     -0.612
#> 10 812424…  0.721      1.43      -0.636  -0.192   -0.492   -0.565     -0.441        1.08     -0.193
#> # ... with 1,986 more rows, and 118 more variables: n_lowersp <dbl>, n_periods <dbl>,
#> #   n_words <dbl>, n_caps <dbl>, n_nonasciis <dbl>, n_puncts <dbl>, n_capsp <dbl>,
#> #   n_charsperword <dbl>, sent_afinn <dbl>, sent_bing <dbl>, n_polite <dbl>, n_first_person <dbl>,
#> #   n_first_personp <dbl>, n_second_person <dbl>, n_second_personp <dbl>, n_third_person <dbl>,
#> #   n_tobe <dbl>, n_prepositions <dbl>, w1 <dbl>, w2 <dbl>, w3 <dbl>, w4 <dbl>, w5 <dbl>, w6 <dbl>,
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
## get non-substantive text features
textfeatures(rt, sentiment = FALSE, word2vec_dims = 0)
#> # A tibble: 1,996 x 26
#>    user_id n_urls n_hashtags n_mentions n_chars n_commas n_digits n_exclaims n_extraspaces n_lowers
#>    <chr>    <dbl>      <dbl>      <dbl>   <dbl>    <dbl>    <dbl>      <dbl>         <dbl>    <dbl>
#>  1 335499… -0.495     -1.00       2.46    0.758    1.14    -0.565      1.74         0.223     0.839
#>  2 270458… -0.495      1.85      -0.636  -1.80    -0.492   -0.565     -0.441        1.69     -1.61 
#>  3 270458… -0.495      1.59      -0.636  -0.548   -0.492   -0.565     -0.441        1.20     -0.403
#>  4 270458…  0.721      1.43       2.03   -0.897   -0.492   -0.565     -0.441        1.31     -0.814
#>  5 270458…  0.721      1.37      -0.636  -0.644   -0.492   -0.565     -0.441        1.08     -0.612
#>  6 270458…  0.721      1.37       0.696  -0.373   -0.492   -0.565     -0.441        1.08     -0.469
#>  7 270458…  0.721      1.43      -0.636  -0.292   -0.492    0.571     -0.441        1.08     -0.436
#>  8 781871… -0.495     -0.563     -0.636   1.11    -0.492    1.24      -0.441       -0.0347    1.10 
#>  9 812424…  0.721      1.37      -0.636  -0.644   -0.492   -0.565     -0.441        1.08     -0.612
#> 10 812424…  0.721      1.43      -0.636  -0.192   -0.492   -0.565     -0.441        1.08     -0.193
#> # ... with 1,986 more rows, and 16 more variables: n_lowersp <dbl>, n_periods <dbl>, n_words <dbl>,
#> #   n_caps <dbl>, n_nonasciis <dbl>, n_puncts <dbl>, n_capsp <dbl>, n_charsperword <dbl>,
#> #   n_polite <dbl>, n_first_person <dbl>, n_first_personp <dbl>, n_second_person <dbl>,
#> #   n_second_personp <dbl>, n_third_person <dbl>, n_tobe <dbl>, n_prepositions <dbl>
```
