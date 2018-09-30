
# 👷 textfeatures 👷<img src="man/figures/logo.png" width="160px" align="right" />

[![Build
status](https://travis-ci.org/mkearney/textfeatures.svg?branch=master)](https://travis-ci.org/mkearney/textfeatures)
[![CRAN
status](https://www.r-pkg.org/badges/version/textfeatures)](https://cran.r-project.org/package=textfeatures)
[![Coverage
Status](https://codecov.io/gh/mkearney/textfeatures/branch/master/graph/badge.svg)](https://codecov.io/gh/mkearney/textfeatures?branch=master)

![Downloads](https://cranlogs.r-pkg.org/badges/textfeatures)
![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/textfeatures)
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
#> # … with 20 more variables: n_lowersp <dbl>, n_periods <dbl>, n_words <dbl>, n_caps <dbl>,
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
tf <- textfeatures(rt, threads = 20)

## preview data
tf
#> # A tibble: 2,000 x 128
#>    user_id n_urls n_hashtags n_mentions n_chars n_commas n_digits n_exclaims n_extraspaces n_lowers
#>    <chr>    <dbl>      <dbl>      <dbl>   <dbl>    <dbl>    <dbl>      <dbl>         <dbl>    <dbl>
#>  1 109288…  0.836     -0.877      0.604   1.27     0.852   -0.461     -0.471         0.213    1.27 
#>  2 109288…  0.836     -0.877     -0.733   1.32    -0.647   -0.461     -0.471        -0.600    1.41 
#>  3 476587…  0.836      2.37      -0.733  -1.20    -0.647   -0.461     -0.471         1.85    -1.22 
#>  4 811058…  0.836      2.12      -0.733  -0.212    0.852   -0.461     -0.471         1.47    -0.366
#>  5 101181… -0.302     -0.337     -0.733   0.510   -0.647   -0.461      1.69         -0.600    0.547
#>  6 101181…  0.836      2.12      -0.733  -0.212    0.852   -0.461     -0.471         1.47    -0.366
#>  7 101181… -0.302     -0.337     -0.733   0.369    0.852   -0.461     -0.471         0.213    0.383
#>  8 101181…  0.836      2.37      -0.733  -1.20    -0.647   -0.461     -0.471         1.85    -1.22 
#>  9 101181…  0.836      1.61      -0.733  -0.436   -0.647   -0.461      1.69          1.15    -0.447
#> 10 101181…  0.836      0.343      0.604   0.671   -0.647   -0.461      1.69          0.213    0.771
#> # … with 1,990 more rows, and 118 more variables: n_lowersp <dbl>, n_periods <dbl>, n_words <dbl>,
#> #   n_caps <dbl>, n_nonasciis <dbl>, n_puncts <dbl>, n_capsp <dbl>, n_charsperword <dbl>,
#> #   sent_afinn <dbl>, sent_bing <dbl>, n_polite <dbl>, n_first_person <dbl>, n_first_personp <dbl>,
#> #   n_second_person <dbl>, n_second_personp <dbl>, n_third_person <dbl>, n_tobe <dbl>,
#> #   n_prepositions <dbl>, w1 <dbl>, w2 <dbl>, w3 <dbl>, w4 <dbl>, w5 <dbl>, w6 <dbl>, w7 <dbl>,
#> #   w8 <dbl>, w9 <dbl>, w10 <dbl>, w11 <dbl>, w12 <dbl>, w13 <dbl>, w14 <dbl>, w15 <dbl>, w16 <dbl>,
#> #   w17 <dbl>, w18 <dbl>, w19 <dbl>, w20 <dbl>, w21 <dbl>, w22 <dbl>, w23 <dbl>, w24 <dbl>,
#> #   w25 <dbl>, w26 <dbl>, w27 <dbl>, w28 <dbl>, w29 <dbl>, w30 <dbl>, w31 <dbl>, w32 <dbl>,
#> #   w33 <dbl>, w34 <dbl>, w35 <dbl>, w36 <dbl>, w37 <dbl>, w38 <dbl>, w39 <dbl>, w40 <dbl>,
#> #   w41 <dbl>, w42 <dbl>, w43 <dbl>, w44 <dbl>, w45 <dbl>, w46 <dbl>, w47 <dbl>, w48 <dbl>,
#> #   w49 <dbl>, w50 <dbl>, w51 <dbl>, w52 <dbl>, w53 <dbl>, w54 <dbl>, w55 <dbl>, w56 <dbl>,
#> #   w57 <dbl>, w58 <dbl>, w59 <dbl>, w60 <dbl>, w61 <dbl>, w62 <dbl>, w63 <dbl>, w64 <dbl>,
#> #   w65 <dbl>, w66 <dbl>, w67 <dbl>, w68 <dbl>, w69 <dbl>, w70 <dbl>, w71 <dbl>, w72 <dbl>,
#> #   w73 <dbl>, w74 <dbl>, w75 <dbl>, w76 <dbl>, w77 <dbl>, w78 <dbl>, w79 <dbl>, w80 <dbl>,
#> #   w81 <dbl>, w82 <dbl>, …
```

Compare across multiple authors.

``` r
## data frame tweets from multiple news media accounts
news <- rtweet::get_timelines(
  c("cnn", "nytimes", "foxnews", "latimes", "washingtonpost"), 
  n = 2000)

## get text features (including ests for 20 word dims) for all observations
news_features <- textfeatures(news, word_dims = 20, threads = 3)
```

<p style="align:center">

<img src='tools/readme/readme.png' max-width="600px" />

</p>

## Fast version

If you’re looking for something faster try setting `sentiment = FALSE`
and `word2vec = 0`.

``` r
## get non-substantive text features
textfeatures(rt, sentiment = FALSE, word_dims = 0)
#> # A tibble: 2,000 x 26
#>    user_id n_urls n_hashtags n_mentions n_chars n_commas n_digits n_exclaims n_extraspaces n_lowers
#>    <chr>    <dbl>      <dbl>      <dbl>   <dbl>    <dbl>    <dbl>      <dbl>         <dbl>    <dbl>
#>  1 109288…  0.836     -0.877      0.604   1.27     0.852   -0.461     -0.471         0.213    1.27 
#>  2 109288…  0.836     -0.877     -0.733   1.32    -0.647   -0.461     -0.471        -0.600    1.41 
#>  3 476587…  0.836      2.37      -0.733  -1.20    -0.647   -0.461     -0.471         1.85    -1.22 
#>  4 811058…  0.836      2.12      -0.733  -0.212    0.852   -0.461     -0.471         1.47    -0.366
#>  5 101181… -0.302     -0.337     -0.733   0.510   -0.647   -0.461      1.69         -0.600    0.547
#>  6 101181…  0.836      2.12      -0.733  -0.212    0.852   -0.461     -0.471         1.47    -0.366
#>  7 101181… -0.302     -0.337     -0.733   0.369    0.852   -0.461     -0.471         0.213    0.383
#>  8 101181…  0.836      2.37      -0.733  -1.20    -0.647   -0.461     -0.471         1.85    -1.22 
#>  9 101181…  0.836      1.61      -0.733  -0.436   -0.647   -0.461      1.69          1.15    -0.447
#> 10 101181…  0.836      0.343      0.604   0.671   -0.647   -0.461      1.69          0.213    0.771
#> # … with 1,990 more rows, and 16 more variables: n_lowersp <dbl>, n_periods <dbl>, n_words <dbl>,
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
nonpub <- grepl("Not publicly available|must register", 
  nasa$data$rights, ignore.case = TRUE) | 
  nasa$dataset$accessLevel %in% c("restricted public", "non-public")

## create data frame with ID, description (name it "text"), and nonpub
nd <- data.frame(text = nasa$dataset$description, nonpub = nonpub, 
  stringsAsFactors = FALSE)

## drop duplicates (truncate text to ensure more distinct obs)
nd <- nd[!duplicated(tolower(substr(nd$text, 1, 100))), ]

## filter via sampling to create equal number of pub/nonpub
nd <- nd[c(sample(which(!nd$nonpub), sum(nd$nonpub)), which(nd$nonpub)), ]

## get text features
nasa_tf <- textfeatures(nd, word_dims = 20, threads = 10)

## drop columns with little to no variance
nasa_tf <- min_var(nasa_tf)

## view summary
skimrskim(nasa_tf)
```

| variable           | min     | 25%     | mid     | 75%     | max   | hist     |
| :----------------- | :------ | :------ | :------ | :------ | :---- | :------- |
| n\_caps            | \-2.6   | \-0.53  | 0.25    | 0.66    | 2.01  | ▁▁▃▃▆▇▃▁ |
| n\_capsp           | \-0.96  | \-0.78  | \-0.54  | 1.03    | 2     | ▇▂▁▁▁▁▂▂ |
| n\_exclaims        | \-0.055 | \-0.055 | \-0.055 | \-0.055 | 18.28 | ▇▁▁▁▁▁▁▁ |
| n\_first\_personp  | \-0.49  | \-0.49  | \-0.49  | \-0.49  | 4.01  | ▇▁▁▂▁▁▁▁ |
| n\_hashtags        | \-0.13  | \-0.13  | \-0.13  | \-0.13  | 7.41  | ▇▁▁▁▁▁▁▁ |
| n\_lowers          | \-1.55  | \-0.77  | 0.11    | 0.93    | 1.5   | ▆▁▃▃▂▂▇▂ |
| n\_mentions        | \-0.075 | \-0.075 | \-0.075 | \-0.075 | 15.45 | ▇▁▁▁▁▁▁▁ |
| n\_nonasciis       | \-0.15  | \-0.15  | \-0.15  | \-0.15  | 7.14  | ▇▁▁▁▁▁▁▁ |
| n\_periods         | \-1.08  | \-1.08  | \-0.064 | 0.84    | 2.18  | ▇▂▂▂▃▂▂▁ |
| n\_polite          | \-6.18  | \-0.076 | 0.32    | 0.32    | 2.67  | ▁▁▁▁▁▇▂▁ |
| n\_puncts          | \-1.11  | \-1.11  | \-0.26  | 0.93    | 3.22  | ▇▃▂▃▃▁▁▁ |
| n\_second\_person  | \-0.095 | \-0.095 | \-0.095 | \-0.095 | 10.52 | ▇▁▁▁▁▁▁▁ |
| n\_second\_personp | \-0.41  | \-0.41  | \-0.41  | \-0.41  | 3.78  | ▇▁▁▁▁▁▁▁ |
| n\_third\_person   | \-0.57  | \-0.57  | \-0.57  | 1.2     | 3.53  | ▇▁▁▂▁▁▁▁ |
| n\_tobe            | \-0.87  | \-0.87  | \-0.87  | 1.02    | 2.13  | ▇▁▁▂▁▃▁▁ |
| n\_urls            | \-0.24  | \-0.24  | \-0.24  | \-0.24  | 4.66  | ▇▁▁▁▁▁▁▁ |
| sent\_bing         | \-7.95  | \-0.39  | \-0.39  | 0.59    | 4.24  | ▁▁▁▁▇▂▁▁ |
| w10                | \-0.83  | \-0.61  | \-0.35  | 0.2     | 7.67  | ▇▂▁▁▁▁▁▁ |
| w11                | \-9.42  | \-0.51  | 0.46    | 0.59    | 0.94  | ▁▁▁▁▁▁▃▇ |
| w12                | \-5.06  | \-0.59  | 0.62    | 0.73    | 1.01  | ▁▁▁▁▂▂▂▇ |
| w14                | \-2.36  | \-0.54  | \-0.34  | 0.33    | 7.67  | ▁▇▂▁▁▁▁▁ |
| w16                | \-0.94  | \-0.58  | \-0.37  | 0.21    | 10.75 | ▇▂▁▁▁▁▁▁ |
| w17                | \-3.74  | \-0.36  | \-0.21  | \-0.029 | 4.16  | ▁▁▁▇▁▁▁▁ |
| w18                | \-6.87  | \-0.14  | 0.32    | 0.57    | 1.09  | ▁▁▁▁▁▁▂▇ |
| w2                 | \-6.3   | \-0.41  | 0.54    | 0.65    | 0.69  | ▁▁▁▁▁▁▂▇ |
| w3                 | \-5.27  | \-0.018 | 0.35    | 0.46    | 6.35  | ▁▁▁▇▂▁▁▁ |
| w4                 | \-0.68  | \-0.59  | \-0.4   | 0.36    | 9.94  | ▇▂▁▁▁▁▁▁ |
| w5                 | \-0.76  | \-0.71  | \-0.53  | 0.5     | 5.95  | ▇▂▁▁▁▁▁▁ |
| w7                 | \-1.46  | \-0.44  | \-0.38  | 0.13    | 7.35  | ▇▅▂▁▁▁▁▁ |
| w8                 | \-6.5   | \-0.24  | 0.18    | 0.39    | 6.51  | ▁▁▁▃▇▁▁▁ |
| w9                 | \-5.95  | \-0.43  | \-0.33  | 0.19    | 7.81  | ▁▁▁▇▁▁▁▁ |

``` r

## add nonpub variable
nasa_tf$nonpub <- nd$nonpub

## run model predicting whether data is restricted
m1 <- glm(nonpub ~ ., data = nasa_tf[-1], family = binomial)
#> Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

## view model summary
summary(m1)
#> 
#> Call:
#> glm(formula = nonpub ~ ., family = binomial, data = nasa_tf[-1])
#> 
#> Deviance Residuals: 
#>    Min      1Q  Median      3Q     Max  
#> -2.714  -0.013   0.000   0.182   3.903  
#> 
#> Coefficients:
#>                  Estimate Std. Error z value Pr(>|z|)   
#> (Intercept)        -4.907    114.768   -0.04   0.9659   
#> n_urls             -0.796      0.819   -0.97   0.3309   
#> n_hashtags         -1.209    249.892    0.00   0.9961   
#> n_mentions          3.005    762.726    0.00   0.9969   
#> n_exclaims          0.281    595.616    0.00   0.9996   
#> n_lowers           -5.370      2.983   -1.80   0.0718 . 
#> n_periods           1.221      0.893    1.37   0.1715   
#> n_caps              0.597      1.135    0.53   0.5989   
#> n_nonasciis        -2.335    672.204    0.00   0.9972   
#> n_puncts           -0.527      0.718   -0.73   0.4627   
#> n_capsp            -1.053      2.284   -0.46   0.6447   
#> sent_bing          -1.284      1.291   -0.99   0.3199   
#> n_polite            0.419      0.725    0.58   0.5632   
#> n_first_personp    -1.569      1.979   -0.79   0.4280   
#> n_second_person     0.995    511.305    0.00   0.9984   
#> n_second_personp    1.704      1.208    1.41   0.1584   
#> n_third_person      0.349      1.043    0.33   0.7380   
#> n_tobe              2.035      1.118    1.82   0.0689 . 
#> w2                 22.981      7.105    3.23   0.0012 **
#> w3                  2.702      3.163    0.85   0.3930   
#> w4                  1.850      4.012    0.46   0.6447   
#> w5                 -1.918      3.430   -0.56   0.5761   
#> w7                  4.847      2.766    1.75   0.0797 . 
#> w8                  2.692      1.878    1.43   0.1518   
#> w9                 10.315      3.590    2.87   0.0041 **
#> w10                -2.066      2.519   -0.82   0.4122   
#> w11                 0.577      3.613    0.16   0.8730   
#> w12                -5.220      6.660   -0.78   0.4332   
#> w14                -3.243      1.871   -1.73   0.0831 . 
#> w16                 7.078      3.471    2.04   0.0414 * 
#> w17                -2.796      1.659   -1.69   0.0919 . 
#> w18                -1.980      3.474   -0.57   0.5687   
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> (Dispersion parameter for binomial family taken to be 1)
#> 
#>     Null deviance: 465.795  on 335  degrees of freedom
#> Residual deviance:  96.352  on 304  degrees of freedom
#> AIC: 160.4
#> 
#> Number of Fisher Scoring iterations: 18

## how accurate was the model?
table(predict(m1, type = "response") > .5, nasa_tf$nonpub)
#>        
#>         FALSE TRUE
#>   FALSE   159    9
#>   TRUE      9  159
```
