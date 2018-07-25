
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
nasa_tf <- textfeatures(nd, word2vec_dims = 20, threads = 10)

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
| w10                | \-1.57  | \-0.73  | \-0.36  | 0.41    | 3.81  | ▂▇▃▂▁▁▁▁ |
| w11                | \-5.19  | \-0.51  | 0.52    | 0.69    | 0.83  | ▁▁▁▁▁▁▂▇ |
| w12                | \-4.12  | \-0.18  | 0.064   | 0.27    | 3.53  | ▁▁▁▂▇▁▁▁ |
| w13                | \-3.01  | \-0.24  | \-0.046 | 0.1     | 5.01  | ▁▁▇▆▁▁▁▁ |
| w14                | \-5.59  | \-0.16  | 0.38    | 0.55    | 1.69  | ▁▁▁▁▁▂▇▁ |
| w16                | \-1.83  | \-0.67  | \-0.52  | 0.46    | 4.86  | ▁▇▂▁▁▁▁▁ |
| w18                | \-1.68  | \-0.67  | \-0.43  | 0.39    | 4.56  | ▁▇▂▁▁▁▁▁ |
| w19                | \-0.86  | \-0.66  | \-0.58  | 0.6     | 5.68  | ▇▂▂▁▁▁▁▁ |
| w2                 | \-3.69  | \-0.65  | 0.59    | 0.71    | 1.08  | ▁▁▁▁▂▂▂▇ |
| w20                | \-5.38  | \-0.6   | 0.48    | 0.71    | 0.89  | ▁▁▁▁▁▂▂▇ |
| w3                 | \-3.93  | \-0.49  | \-0.29  | 0.11    | 5.2   | ▁▁▂▇▁▁▁▁ |
| w4                 | \-2.48  | \-0.47  | \-0.32  | 0.13    | 5.96  | ▁▆▇▂▁▁▁▁ |
| w5                 | \-0.8   | \-0.75  | \-0.59  | 0.69    | 3.99  | ▇▁▁▂▁▁▁▁ |
| w7                 | \-3.58  | \-0.19  | \-0.085 | 0.069   | 4.58  | ▁▁▁▇▁▁▁▁ |
| w8                 | \-5.31  | \-0.2   | 0.43    | 0.57    | 2.47  | ▁▁▁▁▂▇▆▁ |
| w9                 | \-2.57  | \-0.71  | \-0.31  | 0.23    | 3.25  | ▁▁▇▆▂▁▁▁ |

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
#>  -1.86    0.00    0.00    0.00    3.53  
#> 
#> Coefficients:
#>                  Estimate Std. Error z value Pr(>|z|)   
#> (Intercept)        -9.580    101.757   -0.09   0.9250   
#> n_hashtags          1.744    967.272    0.00   0.9986   
#> n_mentions         10.243    800.743    0.01   0.9898   
#> n_chars            32.423     59.853    0.54   0.5880   
#> n_commas           -1.100      2.297   -0.48   0.6321   
#> n_digits           -1.935      1.687   -1.15   0.2516   
#> n_extraspaces       2.564      2.474    1.04   0.3001   
#> n_lowers          -24.204     17.902   -1.35   0.1764   
#> n_periods           1.142      1.910    0.60   0.5499   
#> n_words           -23.737     52.035   -0.46   0.6483   
#> n_caps              2.349      2.931    0.80   0.4229   
#> n_nonasciis         0.780    866.195    0.00   0.9993   
#> n_puncts            0.333      2.172    0.15   0.8783   
#> n_capsp            -8.830      6.558   -1.35   0.1781   
#> n_charsperword     -7.399      8.859   -0.84   0.4036   
#> sent_afinn          8.020      4.175    1.92   0.0547 . 
#> n_polite            2.223      1.765    1.26   0.2080   
#> n_first_person     -5.125      2.956   -1.73   0.0830 . 
#> n_second_person     1.804    265.315    0.01   0.9946   
#> n_second_personp    1.115      2.485    0.45   0.6538   
#> n_third_person     -1.884      3.059   -0.62   0.5381   
#> n_tobe              4.270      2.620    1.63   0.1032   
#> w2                 30.812     15.077    2.04   0.0410 * 
#> w3                 -4.442      3.472   -1.28   0.2008   
#> w4                -17.333      8.917   -1.94   0.0519 . 
#> w5                -49.835     23.512   -2.12   0.0340 * 
#> w7                 -5.170      3.374   -1.53   0.1254   
#> w8                -12.118      4.947   -2.45   0.0143 * 
#> w9                 -0.795      4.188   -0.19   0.8495   
#> w10                18.325      7.542    2.43   0.0151 * 
#> w11               -38.032     22.479   -1.69   0.0907 . 
#> w12                 8.736      4.576    1.91   0.0562 . 
#> w13               -21.203      7.406   -2.86   0.0042 **
#> w14                -4.018      4.450   -0.90   0.3666   
#> w16                -5.797      5.931   -0.98   0.3284   
#> w18                -3.471      3.013   -1.15   0.2494   
#> w19                12.505     10.213    1.22   0.2208   
#> w20                -6.890      9.292   -0.74   0.4584   
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> (Dispersion parameter for binomial family taken to be 1)
#> 
#>     Null deviance: 465.795  on 335  degrees of freedom
#> Residual deviance:  37.196  on 298  degrees of freedom
#> AIC: 113.2
#> 
#> Number of Fisher Scoring iterations: 19

## how accurate was the model?
table(predict(m1, type = "response") > .5, nasa_tf$nonpub)
#>        
#>         FALSE TRUE
#>   FALSE   164    2
#>   TRUE      4  166
```
