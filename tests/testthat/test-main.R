context("test-main.R")

test_that("main textfeatures function", {
  ## character vector
  text <- c(
    "this is A!\t sEntence https://github.com about #rstats @github",
    "doh", "THe following list:\n- one\n- two\n- three\nOkay!?!",
    "asdf87. 68as7df6a as8\n  7df6asfd     87asdfasd &12 3091-.,'[] $ @asdf!!!"
  )
  ## data frame with text variable
  df <- data.frame(text = text, stringsAsFactors = FALSE)

  ## get text features of character vector
  o_chr <- textfeatures(text)
  expect_true(is.data.frame(o_chr))

  ## get text features of character vector
  o_df <- textfeatures(df)
  expect_true(is.data.frame(o_df))

  ## shouldn't work if no variable named text
  expect_error(textfeatures(mtcars))

  ## shouldn't work on numeric vector
  expect_error(textfeatures(rnorm(100)))
})
