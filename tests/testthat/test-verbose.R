context("test-verbose.R")

test_that("printing output", {
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
  
  expect_output(textfeatures(txt))
  expect_silent(textfeatures(txt, verbose = FALSE))
  
  expect_output(textfeatures(df))
  expect_silent(textfeatures(df, verbose = FALSE))
})
