context("test-main.R")

test_that("main textfeatures function", {
  ## character vector
  txt <- c(
    "this is A!\t sEntence https://github.com about #rstats @github",
    "doh", "THe following list:\n- one\n- two\n- three\nOkay!?!",
    "asdf87. 68as7df6a as8\n  7df6asfd     87asdfasd &12 3091-.,'[] $ @asdf!!!"
  )
  ## factor
  text_fct <- factor(txt)
  ## data frame with text variable
  df <- data.frame(text = txt, stringsAsFactors = FALSE)
  ## list of dfs with text variables
  lst <- list(df, df, df)

  ## get text features of character vector
  o_chr <- textfeatures(txt)
  expect_true(is.data.frame(o_chr))

  ## get text features of factor
  o_fct <- textfeatures(text_fct)
  expect_true(is.data.frame(o_fct))

  ## get text features of character vector
  o_df <- textfeatures(df, sentiment = FALSE, word_dims = 0)
  expect_true(is.data.frame(o_df))

  ## get text features of list of DFs with "text" vars
  o_lst <- textfeatures(lst)
  expect_true(all(vapply(o_lst, is.data.frame, FUN.VALUE = logical(1))))

  ## shouldn't work if no variable named text
  expect_error(textfeatures(mtcars))

  ## shouldn't work on numeric vector
  expect_error(textfeatures(rnorm(100)))

  ## factor
  text_fct <- factor(txt)
  ## data frame with text variable
  df <- data.frame(text = txt, stringsAsFactors = FALSE)
  ## list of dfs with text variables
  lst <- list(df, df, df)

  expect_true(is.data.frame(scale_count(o_df)))
  expect_true(is.data.frame(scale_log(o_df)))
  expect_true(is.data.frame(scale_normal(o_df)))
  expect_true(is.data.frame(scale_standard(o_df)))
  expect_true(is.data.frame(scale_sqrt(o_df)))
})
