context("test-color")

library(tidygraph)

test_that("graph can be colored", {
  expect_success(
    play_islands(5, 10, 0.8, 3) %>%
      mutate(color = as.factor(color_dsatur()))
  )
})
