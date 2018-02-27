
textfeatures
------------

A simple package for extracting useful features from character objects.

Install
-------

``` r
## download devtools if necessary
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

## install from github
devtools::install_github("mkearney/textfeatures")
```

Usage
-----

### Input: `character`

``` r
## vector of some text
x <- c(
  "this is A!\t sEntence https://github.com about #rstats @github",
  "doh", "THe following list:\n- one\n- two\n- three\nOkay!?!"
)

## get text features
textfeatures(x)
```

    ## # A tibble: 3 x 17
    ##   n_chars n_commas n_digits n_exclaims n_extraspaces n_hashtags n_lowers
    ##     <int>    <int>    <int>      <int>         <int>      <int>    <int>
    ## 1      21        0        0          1             3          1       18
    ## 2       3        0        0          0             0          0        3
    ## 3      38        0        0          2             4          0       28
    ## # ... with 10 more variables: n_lowersp <dbl>, n_mentions <int>,
    ## #   n_periods <int>, n_urls <int>, n_words <int>, n_caps <int>,
    ## #   n_noasciis <int>, n_puncts <int>, n_capsp <dbl>, n_charsperword <dbl>

### Input: `data.frame`

``` r
## data frame with up to one hundred tweets
rt <- rtweet::search_tweets("rstats", n = 100, verbose = FALSE)

## get text features
textfeatures(rt)
```

    ## # A tibble: 100 x 17
    ##    n_chars n_commas n_digits n_exclaims n_extraspaces n_hashtags n_lowers
    ##      <int>    <int>    <int>      <int>         <int>      <int>    <int>
    ##  1      71        1        4          0             1          1       54
    ##  2     110        1        0          0             1          0       94
    ##  3     110        0        0          0             1          0       81
    ##  4      62        0        0          1             3          2       44
    ##  5      37        0        4          0             2          2       25
    ##  6     127        1        1          0             3          2      117
    ##  7      35        0        4          0             1          2       25
    ##  8      81        0        0          0             4          1       66
    ##  9      36        0        0          0             2          3       33
    ## 10      62        0        0          1             1          2       50
    ## # ... with 90 more rows, and 10 more variables: n_lowersp <dbl>,
    ## #   n_mentions <int>, n_periods <int>, n_urls <int>, n_words <int>,
    ## #   n_caps <int>, n_noasciis <int>, n_puncts <int>, n_capsp <dbl>,
    ## #   n_charsperword <dbl>

### Input: `grouped_df`

``` r
## data frame with up to one hundred tweets for each of 5 users
gdf <- rtweet::get_timelines(
  c("wapo", "cnn", "nytimes", "foxnews", "latimes"), n = 100)

## group by user id and return text features
textfeatures(dplyr::group_by(rt, user_id))
```

    ## # A tibble: 65 x 18
    ##    user_id   n_chars n_commas n_digits n_exclaims n_extraspaces n_hashtags
    ##    <chr>       <dbl>    <dbl>    <dbl>      <dbl>         <dbl>      <dbl>
    ##  1 100640404   103       2.00     0          1.00          2.00          0
    ##  2 113498828   110       1.00     0          0             1.00          0
    ##  3 114142293   111       0        0          0             1.00          0
    ##  4 11953392     29.0     0        1.00       0             2.00          0
    ##  5 12296332    111       0        0          0             1.00          0
    ##  6 13489282    110       1.00     0          0             1.00          0
    ##  7 136522450    75.0     0        0          0             4.00          0
    ##  8 139578999   110       0        0          0             1.00          0
    ##  9 140384362   110       1.00     0          0             1.00          0
    ## 10 144592995    42.5     0        2.00       0             1.00          0
    ## # ... with 55 more rows, and 11 more variables: n_lowers <dbl>,
    ## #   n_lowersp <dbl>, n_mentions <dbl>, n_periods <dbl>, n_urls <dbl>,
    ## #   n_words <dbl>, n_caps <dbl>, n_noasciis <dbl>, n_puncts <dbl>,
    ## #   n_capsp <dbl>, n_charsperword <dbl>
