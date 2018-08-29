
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
#> # A tibble: 3 x 28
#>   id    n_urls n_hashtags n_mentions n_chars n_commas n_digits n_exclaims n_extraspaces n_lowers
#>   <chr>  <dbl>      <dbl>      <dbl>   <dbl>    <dbl>    <dbl>      <dbl>         <dbl>    <dbl>
#> 1 1      1.15       1.15       1.15   -0.792        0        0      0.173         0.445   -1.09 
#> 2 2     -0.577     -0.577     -0.577  -0.332        0        0     -1.08         -1.15     0.224
#> 3 3     -0.577     -0.577     -0.577   1.12         0        0      0.902         0.701    0.869
#> # … with 18 more variables: n_lowersp <dbl>, n_periods <dbl>, n_words <dbl>, n_caps <dbl>,
#> #   n_nonasciis <dbl>, n_puncts <dbl>, n_capsp <dbl>, n_charsperword <dbl>, sent_afinn <dbl>,
#> #   sent_bing <dbl>, n_polite <dbl>, n_first_person <dbl>, n_first_personp <dbl>,
#> #   n_second_person <dbl>, n_second_personp <dbl>, n_third_person <dbl>, n_tobe <dbl>,
#> #   n_prepositions <dbl>
```

Or input a data frame with a column named `text`.

``` r
## data frame with rstats tweets
rt <- rtweet::search_tweets("rstats", n = 2000, verbose = FALSE)

## get text features
textfeatures(rt, threads = 2)
#> # A tibble: 1,982 x 28
#>    user_id n_urls n_hashtags n_mentions n_chars n_commas n_digits n_exclaims n_extraspaces n_lowers
#>    <chr>    <dbl>      <dbl>      <dbl>   <dbl>    <dbl>    <dbl>      <dbl>         <dbl>    <dbl>
#>  1 280813… -0.501    -0.0635     -0.711  1.21      2.31    -0.438     -0.572       -0.336     1.28 
#>  2 166165…  0.731    -0.854       0.495  0.597    -0.570   -0.438      2.52        -0.336     0.602
#>  3 166165… -0.501    -0.392      -0.711  0.391    -0.570   -0.438     -0.572       -1.42      0.544
#>  4 128409… -0.501    -0.392      -0.711  1.09      1.71     2.81      -0.572       -1.42      1.10 
#>  5 295740… -0.501    -0.854       1.20   0.0752   -0.570   -0.438      1.38        -0.336     0.189
#>  6 227646… -0.501     0.191      -0.711  1.02      0.871   -0.438      1.38        -0.336     1.09 
#>  7 227646…  0.731    -0.392       0.495  0.315     0.871   -0.438     -0.572        0.0124    0.170
#>  8 270454… -2.61      0.399      -0.711  0.993     0.871   -0.438     -0.572       -0.336     1.10 
#>  9 270454…  0.731     1.83       -0.711 -0.585    -0.570   -0.438     -0.572        1.50     -0.579
#> 10 270454…  0.731     1.93       -0.711 -2.09     -0.570   -0.438     -0.572        1.62     -1.99 
#> # … with 1,972 more rows, and 18 more variables: n_lowersp <dbl>, n_periods <dbl>, n_words <dbl>,
#> #   n_caps <dbl>, n_nonasciis <dbl>, n_puncts <dbl>, n_capsp <dbl>, n_charsperword <dbl>,
#> #   sent_afinn <dbl>, sent_bing <dbl>, n_polite <dbl>, n_first_person <dbl>, n_first_personp <dbl>,
#> #   n_second_person <dbl>, n_second_personp <dbl>, n_third_person <dbl>, n_tobe <dbl>,
#> #   n_prepositions <dbl>
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
#> # A tibble: 1,982 x 26
#>    user_id n_urls n_hashtags n_mentions n_chars n_commas n_digits n_exclaims n_extraspaces n_lowers
#>    <chr>    <dbl>      <dbl>      <dbl>   <dbl>    <dbl>    <dbl>      <dbl>         <dbl>    <dbl>
#>  1 280813… -0.501    -0.0635     -0.711  1.21      2.31    -0.438     -0.572       -0.336     1.28 
#>  2 166165…  0.731    -0.854       0.495  0.597    -0.570   -0.438      2.52        -0.336     0.602
#>  3 166165… -0.501    -0.392      -0.711  0.391    -0.570   -0.438     -0.572       -1.42      0.544
#>  4 128409… -0.501    -0.392      -0.711  1.09      1.71     2.81      -0.572       -1.42      1.10 
#>  5 295740… -0.501    -0.854       1.20   0.0752   -0.570   -0.438      1.38        -0.336     0.189
#>  6 227646… -0.501     0.191      -0.711  1.02      0.871   -0.438      1.38        -0.336     1.09 
#>  7 227646…  0.731    -0.392       0.495  0.315     0.871   -0.438     -0.572        0.0124    0.170
#>  8 270454… -2.61      0.399      -0.711  0.993     0.871   -0.438     -0.572       -0.336     1.10 
#>  9 270454…  0.731     1.83       -0.711 -0.585    -0.570   -0.438     -0.572        1.50     -0.579
#> 10 270454…  0.731     1.93       -0.711 -2.09     -0.570   -0.438     -0.572        1.62     -1.99 
#> # … with 1,972 more rows, and 16 more variables: n_lowersp <dbl>, n_periods <dbl>, n_words <dbl>,
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
| n\_caps            | \-2.65  | \-0.57  | 0.21    | 0.67    | 2.32  | ▂▁▃▅▇▆▃▁ |
| n\_capsp           | \-0.98  | \-0.8   | \-0.5   | 1.03    | 2.01  | ▇▃▁▁▁▁▂▂ |
| n\_chars           | \-2.78  | \-0.77  | \-0.31  | 0.95    | 1.89  | ▁▁▃▇▂▂▇▂ |
| n\_charsperword    | \-6.44  | \-0.28  | 0.25    | 0.58    | 1.96  | ▁▁▁▁▁▃▇▁ |
| n\_commas          | \-1.47  | \-0.77  | 0.17    | 0.76    | 2.17  | ▇▃▂▆▇▅▃▁ |
| n\_digits          | \-0.99  | \-0.99  | 0.084   | 0.8     | 2.35  | ▇▁▃▂▂▂▂▁ |
| n\_extraspaces     | \-0.54  | \-0.54  | \-0.54  | 0.13    | 4.07  | ▇▁▁▁▁▁▁▁ |
| n\_hashtags        | \-0.055 | \-0.055 | \-0.055 | \-0.055 | 18.28 | ▇▁▁▁▁▁▁▁ |
| n\_lowers          | \-1.55  | \-0.78  | 0.058   | 0.94    | 1.57  | ▆▂▂▅▂▃▇▂ |
| n\_lowersp         | \-1.83  | \-0.96  | 0.58    | 0.77    | 0.94  | ▃▁▁▁▁▁▂▇ |
| n\_mentions        | \-0.075 | \-0.075 | \-0.075 | \-0.075 | 15.45 | ▇▁▁▁▁▁▁▁ |
| n\_periods         | \-1.05  | \-1.05  | \-0.032 | 0.87    | 2.36  | ▇▂▂▂▃▂▁▁ |
| n\_polite          | \-6.55  | \-0.087 | 0.31    | 0.31    | 2.56  | ▁▁▁▁▁▃▇▁ |
| n\_prepositions    | \-1.04  | \-1.04  | \-0.014 | 1.01    | 1.65  | ▇▁▁▂▁▂▃▁ |
| n\_second\_person  | \-0.055 | \-0.055 | \-0.055 | \-0.055 | 18.28 | ▇▁▁▁▁▁▁▁ |
| n\_second\_personp | \-0.4   | \-0.4   | \-0.4   | \-0.4   | 3.91  | ▇▁▁▁▁▁▁▁ |
| n\_words           | \-1.92  | \-0.8   | \-0.3   | 1.01    | 1.89  | ▂▂▇▂▂▃▆▁ |
| sent\_afinn        | \-6.29  | \-0.5   | \-0.5   | 0.25    | 3.16  | ▁▁▁▁▇▂▂▁ |
| sent\_bing         | \-6.83  | \-0.4   | \-0.4   | 0.16    | 3.13  | ▁▁▁▁▁▇▂▁ |

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
#>     Min       1Q   Median       3Q      Max  
#> -2.0053  -0.3401  -0.0002   0.0389   2.8060  
#> 
#> Coefficients:
#>                  Estimate Std. Error z value Pr(>|z|)    
#> (Intercept)         4.431     12.564    0.35  0.72433    
#> n_hashtags         -0.688    130.906   -0.01  0.99580    
#> n_mentions          1.023    154.575    0.01  0.99472    
#> n_chars            13.217     19.049    0.69  0.48778    
#> n_commas           -0.663      0.429   -1.55  0.12209    
#> n_digits           -0.237      0.382   -0.62  0.53449    
#> n_extraspaces       1.069      0.292    3.65  0.00026 ***
#> n_lowers          -25.537     18.445   -1.38  0.16621    
#> n_lowersp           1.091      5.531    0.20  0.84358    
#> n_periods           2.950      0.897    3.29  0.00100 ** 
#> n_words             1.406     22.624    0.06  0.95044    
#> n_caps             -0.609      0.939   -0.65  0.51659    
#> n_capsp             0.204      2.796    0.07  0.94182    
#> n_charsperword      0.255      3.082    0.08  0.93418    
#> sent_afinn          0.206      0.341    0.61  0.54473    
#> sent_bing          -0.297      0.228   -1.30  0.19335    
#> n_polite            0.410      0.282    1.45  0.14577    
#> n_second_person     0.445    154.783    0.00  0.99771    
#> n_second_personp   -0.447      0.270   -1.66  0.09717 .  
#> n_prepositions     -0.270      0.918   -0.29  0.76878    
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> (Dispersion parameter for binomial family taken to be 1)
#> 
#>     Null deviance: 465.79  on 335  degrees of freedom
#> Residual deviance: 142.59  on 316  degrees of freedom
#> AIC: 182.6
#> 
#> Number of Fisher Scoring iterations: 15

## how accurate was the model?
table(predict(m1, type = "response") > .5, nasa_tf$nonpub)
#>        
#>         FALSE TRUE
#>   FALSE   161   18
#>   TRUE      7  150
```
