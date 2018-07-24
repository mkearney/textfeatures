
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
#> # A tibble: 3 x 32
#>      id n_urls n_hashtags n_mentions text  sent_afinn sent_bing n_chars n_commas n_digits n_exclaims
#>   <int>  <int>      <int>      <int> <chr>      <int>     <int>   <int>    <int>    <int>      <int>
#> 1     1      1          1          1 "thi…         -2         0      53        0        0          1
#> 2     2      0          0          0 and …         -2         0      22        0        0          0
#> 3     3      0          0          0 "THe…          0         0      38        0        0          2
#> # ... with 21 more variables: n_extraspaces <int>, n_lowers <int>, n_lowersp <dbl>,
#> #   n_periods <int>, n_words <int>, n_caps <int>, n_nonasciis <int>, n_puncts <int>, n_capsp <dbl>,
#> #   n_charsperword <dbl>, n_polite <dbl>, n_first_person <int>, n_first_personp <int>,
#> #   n_second_person <int>, n_second_personp <int>, n_third_person <int>, n_tobe <int>,
#> #   n_prepositions <int>, w1 <dbl>, w2 <dbl>, w3 <dbl>
```

Or input a data frame with a column named `text`.

``` r
## data frame with up to one hundred tweets
rt <- rtweet::search_tweets("rstats", n = 100, verbose = FALSE)

## get text features
textfeatures(rt)
#> # A tibble: 100 x 79
#>    user_id n_urls n_hashtags n_mentions text  sent_afinn sent_bing n_chars n_commas n_digits
#>    <chr>    <int>      <int>      <int> <chr>      <int>     <int>   <int>    <int>    <int>
#>  1 372235…      1          4          1 "   …          0         0      67        0        0
#>  2 802535…      2         17          0 "The…          0         0     260        0        6
#>  3 319985…      2          4          7 "[bl…          0         0     252        0        6
#>  4 975828…      0          1          0 Not …          2         2     109        1        1
#>  5 101740…      2          2          2 "Any…          7         1     222        1        1
#>  6 490203…      1          1          0 "New…          0         1     143        1        0
#>  7 975885…      1          2          0 "Our…          0         0     192        0        1
#>  8 295209…      2          3          1 "🗺 g…          3         1     145        0        4
#>  9 178717…      2          4          0 "Int…          0         0     142        0        4
#> 10 178717…      2          4          0 "!R …          0         0     171        0        2
#> # ... with 90 more rows, and 69 more variables: n_exclaims <int>, n_extraspaces <int>,
#> #   n_lowers <int>, n_lowersp <dbl>, n_periods <int>, n_words <int>, n_caps <int>,
#> #   n_nonasciis <int>, n_puncts <int>, n_capsp <dbl>, n_charsperword <dbl>, n_polite <dbl>,
#> #   n_first_person <int>, n_first_personp <int>, n_second_person <int>, n_second_personp <int>,
#> #   n_third_person <int>, n_tobe <int>, n_prepositions <int>, w1 <dbl>, w2 <dbl>, w3 <dbl>,
#> #   w4 <dbl>, w5 <dbl>, w6 <dbl>, w7 <dbl>, w8 <dbl>, w9 <dbl>, w10 <dbl>, w11 <dbl>, w12 <dbl>,
#> #   w13 <dbl>, w14 <dbl>, w15 <dbl>, w16 <dbl>, w17 <dbl>, w18 <dbl>, w19 <dbl>, w20 <dbl>,
#> #   w21 <dbl>, w22 <dbl>, w23 <dbl>, w24 <dbl>, w25 <dbl>, w26 <dbl>, w27 <dbl>, w28 <dbl>,
#> #   w29 <dbl>, w30 <dbl>, w31 <dbl>, w32 <dbl>, w33 <dbl>, w34 <dbl>, w35 <dbl>, w36 <dbl>,
#> #   w37 <dbl>, w38 <dbl>, w39 <dbl>, w40 <dbl>, w41 <dbl>, w42 <dbl>, w43 <dbl>, w44 <dbl>,
#> #   w45 <dbl>, w46 <dbl>, w47 <dbl>, w48 <dbl>, w49 <dbl>, w50 <dbl>
```

Compare across multiple authors.

``` r
## data frame tweets from multiple news media accounts
news <- rtweet::get_timelines(
  c("cnn", "nytimes", "foxnews", "latimes", "washingtonpost"), n = 2000)

## get text features for all observations
news_features <- textfeatures(news)
```

<p style="align:center">

<img src='tools/readme/readme.png' max-width="600px" />

</p>

## Fast version

If you’re looking for something faster try setting `sentiment` and
`word2vec` to `FALSE`.

``` r
## 100 tweets
rt <- rtweet::search_tweets("lang:en", n = 100, verbose = FALSE)

## get non-substantive text features
textfeatures(rt, sentiment = FALSE, word2vec = FALSE)
#> # A tibble: 100 x 27
#>    user_id n_urls n_hashtags n_mentions text  n_chars n_commas n_digits n_exclaims n_extraspaces
#>    <chr>    <int>      <int>      <int> <chr>   <int>    <int>    <int>      <int>         <int>
#>  1 323064…      0          0          1 " Yo…     212        0        0          0             0
#>  2 120094…      0          2          1 "  t…      87        0        5          0             0
#>  3 102768…      1          0          0 "Pls…      88        0        0          0             0
#>  4 738692…      1          0          0 "coc…      41        0        2          0             0
#>  5 231932…      0          0          2 "  H…      51        0        2          1             0
#>  6 219424…      0          0          1 " pl…      26        0        0          0             0
#>  7 152705…      1          0          0 "Tra…      63        0        2          0             0
#>  8 190808…      1          0          0 "You…      73        0        2          0             0
#>  9 503612…      1          0          0 "If …      69        1        3          0             0
#> 10 905582…      0          0          2 " eh…      30        0        0          0             0
#> # ... with 90 more rows, and 17 more variables: n_lowers <int>, n_lowersp <dbl>, n_periods <int>,
#> #   n_words <int>, n_caps <int>, n_nonasciis <int>, n_puncts <int>, n_capsp <dbl>,
#> #   n_charsperword <dbl>, n_polite <dbl>, n_first_person <int>, n_first_personp <int>,
#> #   n_second_person <int>, n_second_personp <int>, n_third_person <int>, n_tobe <int>,
#> #   n_prepositions <int>
```
