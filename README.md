
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
#> 1 1      1.15       1.15       1.15   -0.792        0        0      0.173         0.445   -1.09 
#> 2 2     -0.577     -0.577     -0.577  -0.332        0        0     -1.08         -1.15     0.224
#> 3 3     -0.577     -0.577     -0.577   1.12         0        0      0.902         0.701    0.869
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
textfeatures(rt, threads = 2)
#> # A tibble: 1,946 x 128
#>    user_id n_urls n_hashtags n_mentions n_chars n_commas n_digits n_exclaims n_extraspaces n_lowers
#>    <chr>    <dbl>      <dbl>      <dbl>   <dbl>    <dbl>    <dbl>      <dbl>         <dbl>    <dbl>
#>  1 237966…  0.694     -0.253      0.634  0.0374   -0.493   -0.553     -0.496       -0.0119   0.0228
#>  2 165457… -2.51      -0.992     -0.732  1.65      2.81     3.24      -0.496        0.240    1.50  
#>  3 217911… -0.489     -0.560      1.43   0.293    -0.493   -0.553     -0.496       -0.0119   0.401 
#>  4 144592… -0.489     -0.560     -0.732 -1.80     -0.493    2.59      -0.496       -1.28    -2.22  
#>  5 144592… -0.489     -0.560     -0.732  0.153    -0.493   -0.553     -0.496       -1.28     0.134 
#>  6 144592… -0.489     -0.560     -0.732 -0.852    -0.493   -0.553     -0.496       -1.28    -0.633 
#>  7 144592… -0.489     -0.560     -0.732 -0.281    -0.493   -0.553     -0.496       -1.28    -0.234 
#>  8 144592… -0.489     -0.560     -0.732 -1.45     -0.493   -0.553      1.32        -1.28    -1.43  
#>  9 742544… -0.489      1.52      -0.732 -1.22     -0.493   -0.553     -0.496        1.20    -1.43  
#> 10 742544… -0.489      1.46      -0.732 -1.07     -0.493   -0.553     -0.496        1.41    -1.35  
#> # ... with 1,936 more rows, and 118 more variables: n_lowersp <dbl>, n_periods <dbl>,
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
#> # A tibble: 1,946 x 26
#>    user_id n_urls n_hashtags n_mentions n_chars n_commas n_digits n_exclaims n_extraspaces n_lowers
#>    <chr>    <dbl>      <dbl>      <dbl>   <dbl>    <dbl>    <dbl>      <dbl>         <dbl>    <dbl>
#>  1 237966…  0.694     -0.253      0.634  0.0374   -0.493   -0.553     -0.496       -0.0119   0.0228
#>  2 165457… -2.51      -0.992     -0.732  1.65      2.81     3.24      -0.496        0.240    1.50  
#>  3 217911… -0.489     -0.560      1.43   0.293    -0.493   -0.553     -0.496       -0.0119   0.401 
#>  4 144592… -0.489     -0.560     -0.732 -1.80     -0.493    2.59      -0.496       -1.28    -2.22  
#>  5 144592… -0.489     -0.560     -0.732  0.153    -0.493   -0.553     -0.496       -1.28     0.134 
#>  6 144592… -0.489     -0.560     -0.732 -0.852    -0.493   -0.553     -0.496       -1.28    -0.633 
#>  7 144592… -0.489     -0.560     -0.732 -0.281    -0.493   -0.553     -0.496       -1.28    -0.234 
#>  8 144592… -0.489     -0.560     -0.732 -1.45     -0.493   -0.553      1.32        -1.28    -1.43  
#>  9 742544… -0.489      1.52      -0.732 -1.22     -0.493   -0.553     -0.496        1.20    -1.43  
#> 10 742544… -0.489      1.46      -0.732 -1.07     -0.493   -0.553     -0.496        1.41    -1.35  
#> # ... with 1,936 more rows, and 16 more variables: n_lowersp <dbl>, n_periods <dbl>, n_words <dbl>,
#> #   n_caps <dbl>, n_nonasciis <dbl>, n_puncts <dbl>, n_capsp <dbl>, n_charsperword <dbl>,
#> #   n_polite <dbl>, n_first_person <dbl>, n_first_personp <dbl>, n_second_person <dbl>,
#> #   n_second_personp <dbl>, n_third_person <dbl>, n_tobe <dbl>, n_prepositions <dbl>
```

## Example: NASA meta data

Extract text features from NASA meta data:

``` r
## read NASA meta data
nasa <- jsonlite::fromJSON("https://data.nasa.gov/data.json")

## identify non-public or restricted data sets
nonpub <- grepl("Not publicly available|must register", nasa$data$rights, ignore.case = TRUE) | 
  nasa$dataset$accessLevel %in% c("restricted public", "non-public")

## create data frame with ID, description (name it "text"), and nonpub
nd <- data.frame(text = nasa$dataset$description, nonpub = nonpub, 
  stringsAsFactors = FALSE)

## drop duplicates (truncate text to ensure more distinct obs)
nd <- nd[!duplicated(tolower(substr(nd$text, 1, 100))), ]

## filter via sampling to create equal number of pub/nonpub
nd <- nd[c(sample(which(!nd$nonpub), sum(nd$nonpub)), which(nd$nonpub)), ]

## get text features
nasa_tf <- textfeatures(nd, threads = 10)

## drop columns with little to no variance
nasa_tf <- min_var(nasa_tf)

## view summary
skimrskim(nasa_tf)
```

| variable           | min     | 25%     | mid     | 75%     | max   | hist     |
| :----------------- | :------ | :------ | :------ | :------ | :---- | :------- |
| n\_caps            | \-2.58  | \-0.58  | 0.28    | 0.65    | 1.73  | ▁▂▂▃▃▇▃▂ |
| n\_capsp           | \-0.97  | \-0.79  | \-0.56  | 1.03    | 2.01  | ▇▂▁▁▁▁▂▂ |
| n\_chars           | \-2.84  | \-0.76  | \-0.3   | 1       | 1.56  | ▁▁▂▇▅▂▅▇ |
| n\_charsperword    | \-6.37  | \-0.29  | 0.23    | 0.55    | 2.44  | ▁▁▁▁▁▇▇▁ |
| n\_commas          | \-1.49  | \-0.75  | \-0.02  | 0.84    | 2.34  | ▇▃▃▇▇▆▁▁ |
| n\_digits          | \-0.95  | \-0.95  | \-0.11  | 0.73    | 3.2   | ▇▂▃▂▂▁▁▁ |
| n\_extraspaces     | \-0.55  | \-0.55  | \-0.55  | 0.43    | 3.94  | ▇▁▁▁▁▁▁▁ |
| n\_first\_person   | \-0.76  | \-0.76  | \-0.76  | 1.08    | 2.16  | ▇▁▁▁▁▅▁▁ |
| n\_hashtags        | \-0.055 | \-0.055 | \-0.055 | \-0.055 | 18.28 | ▇▁▁▁▁▁▁▁ |
| n\_lowers          | \-1.56  | \-0.77  | 0.069   | 0.95    | 1.35  | ▇▁▅▃▃▂▆▇ |
| n\_mentions        | \-0.075 | \-0.075 | \-0.075 | \-0.075 | 15.45 | ▇▁▁▁▁▁▁▁ |
| n\_nonasciis       | \-0.074 | \-0.074 | \-0.074 | \-0.074 | 15.91 | ▇▁▁▁▁▁▁▁ |
| n\_periods         | \-1.06  | \-1.06  | \-0.011 | 0.92    | 2.78  | ▇▂▃▂▃▂▁▁ |
| n\_polite          | \-4.9   | \-0.16  | 0.28    | 0.28    | 3.12  | ▁▁▁▁▂▇▁▁ |
| n\_puncts          | \-1.14  | \-1.14  | \-0.021 | 0.87    | 2.02  | ▇▁▅▂▂▃▂▂ |
| n\_second\_person  | \-0.092 | \-0.092 | \-0.092 | \-0.092 | 13.62 | ▇▁▁▁▁▁▁▁ |
| n\_second\_personp | \-0.38  | \-0.38  | \-0.38  | \-0.38  | 4.01  | ▇▁▁▁▁▁▁▁ |
| n\_third\_person   | \-0.56  | \-0.56  | \-0.56  | 1.23    | 3.61  | ▇▁▁▂▁▁▁▁ |
| n\_tobe            | \-0.83  | \-0.83  | \-0.83  | 1.06    | 2.17  | ▇▁▁▂▁▃▁▁ |
| n\_words           | \-1.94  | \-0.78  | \-0.3   | 1.06    | 1.61  | ▂▃▇▅▂▂▆▆ |
| sent\_afinn        | \-8.86  | \-0.43  | \-0.43  | 0.24    | 3.94  | ▁▁▁▁▁▇▂▁ |
| w1                 | \-4.86  | \-0.47  | 0.49    | 0.66    | 1.05  | ▁▁▁▁▁▂▂▇ |
| w10                | \-1.03  | \-0.66  | \-0.56  | 0.53    | 5.11  | ▇▂▂▂▁▁▁▁ |
| w11                | \-3.01  | \-0.32  | \-0.029 | 0.15    | 8.39  | ▁▅▇▁▁▁▁▁ |
| w13                | \-1.02  | \-0.58  | \-0.43  | 0.24    | 5.05  | ▇▃▁▁▁▁▁▁ |
| w14                | \-5.01  | \-0.28  | 0.49    | 0.6     | 1.15  | ▁▁▁▁▁▂▂▇ |
| w15                | \-1.02  | \-0.7   | \-0.59  | 0.55    | 4.87  | ▇▂▂▁▁▁▁▁ |
| w16                | \-0.85  | \-0.74  | \-0.52  | 0.7     | 4.79  | ▇▂▂▁▁▁▁▁ |
| w17                | \-0.92  | \-0.71  | \-0.59  | 0.68    | 3.51  | ▇▁▁▁▁▁▁▁ |
| w18                | \-4.15  | \-0.4   | 0.49    | 0.67    | 1.08  | ▁▁▁▁▂▁▂▇ |
| w2                 | \-5.83  | \-0.41  | 0.46    | 0.69    | 0.76  | ▁▁▁▁▁▁▂▇ |
| w20                | \-1.01  | \-0.71  | \-0.58  | 0.7     | 3.72  | ▇▂▂▂▁▁▁▁ |
| w25                | \-0.9   | \-0.59  | \-0.45  | 0.12    | 6.08  | ▇▂▁▁▁▁▁▁ |
| w26                | \-2.46  | \-0.36  | \-0.19  | 0.39    | 4.82  | ▁▂▇▂▁▁▁▁ |
| w27                | \-4.61  | \-0.65  | 0.57    | 0.72    | 0.95  | ▁▁▁▁▂▂▂▇ |
| w3                 | \-3.48  | \-0.29  | \-0.15  | 0.37    | 4.34  | ▁▁▂▇▂▁▁▁ |
| w30                | \-5.4   | \-0.47  | 0.34    | 0.7     | 2.04  | ▁▁▁▁▂▃▇▁ |
| w31                | \-3.54  | \-0.45  | 0.044   | 0.23    | 6.23  | ▁▁▇▆▁▁▁▁ |
| w32                | \-5.17  | \-0.34  | 0.35    | 0.58    | 1.37  | ▁▁▁▁▂▂▇▅ |
| w33                | \-5.25  | \-0.5   | 0.56    | 0.63    | 1.19  | ▁▁▁▁▁▂▂▇ |
| w35                | \-1.82  | \-0.65  | \-0.47  | 0.23    | 3.58  | ▁▇▃▂▁▁▁▁ |
| w36                | \-0.84  | \-0.75  | \-0.54  | 0.6     | 3.79  | ▇▁▁▂▁▁▁▁ |
| w37                | \-0.96  | \-0.69  | \-0.53  | 0.58    | 3.82  | ▇▁▁▂▁▁▁▁ |
| w38                | \-0.9   | \-0.59  | \-0.47  | 0.25    | 5.95  | ▇▂▁▁▁▁▁▁ |
| w39                | \-0.71  | \-0.64  | \-0.54  | 0.26    | 5.82  | ▇▂▁▁▁▁▁▁ |
| w40                | \-5.62  | \-0.43  | 0.44    | 0.66    | 0.98  | ▁▁▁▁▁▁▁▇ |
| w41                | \-4.64  | \-0.44  | 0.41    | 0.7     | 0.89  | ▁▁▁▁▁▂▂▇ |
| w43                | \-4.1   | \-0.7   | 0.58    | 0.67    | 1.16  | ▁▁▁▁▂▂▂▇ |
| w44                | \-0.86  | \-0.66  | \-0.5   | 0.53    | 4.68  | ▇▂▂▁▁▁▁▁ |
| w45                | \-4.03  | \-0.34  | \-0.21  | 0.15    | 5.16  | ▁▁▂▇▁▁▁▁ |
| w47                | \-6.56  | \-0.26  | 0.14    | 0.37    | 4.05  | ▁▁▁▁▆▇▁▁ |
| w49                | \-2.36  | \-0.52  | \-0.39  | 0.053   | 5.15  | ▁▆▇▁▁▁▁▁ |
| w5                 | \-1.79  | \-0.56  | \-0.45  | 0.32    | 3.9   | ▁▇▃▂▁▁▁▁ |
| w50                | \-3.52  | \-0.48  | 0.56    | 0.66    | 0.96  | ▁▁▁▁▁▁▁▇ |
| w7                 | \-2.6   | \-0.39  | \-0.16  | 0.2     | 5.73  | ▁▂▇▁▁▁▁▁ |
| w9                 | \-4.85  | \-0.45  | 0.0038  | 0.17    | 3.83  | ▁▁▁▂▇▁▁▁ |
