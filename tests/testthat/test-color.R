context("test-color")

library(tidygraph)

expect_graph_colored <- function(graph) {
  graph %>%
    activate(edges) %>%
    mutate(
      from_color = .N()$color[from],
      to_color = .N()$color[to]
    ) %>%
    filter(from_color == to_color) %>%
    as_tibble() %>%
    nrow() %>%
    expect_equal(0L)
}

test_that("graph can be colored with DSATUR", {
  expect_graph_colored(
    play_islands(5, 10, 0.8, 3) %>%
      mutate(color = as.factor(color_dsatur()))
  )
})

test_that("graph can be colored with MSC", {
  expect_graph_colored(
    play_islands(5, 10, 0.8, 3) %>%
      mutate(color = as.factor(color_msc()))
  )
})

test_that("graph can be colored with lmXRLF", {
  expect_graph_colored(
    play_islands(5, 10, 0.8, 3) %>%
      mutate(color = as.factor(color_lmxrlf()))
  )
})

test_that("bipartite graph can be colored with TabuCol using two colors only", {
  expect_graph_colored(
    play_bipartite(10, 10, 0.4) %>%
      mutate(color = as.factor(color_tabucol(2)))
  )
})
#
# test_that("graph can be colored with Hybrid DSATUR/TabuCol", {
#   expect_graph_colored(
#     play_islands(2, 5, 0.8, 3) %>%
#       mutate(color = as.factor(color_hybrid_dsatur_tabucol()))
#   )
# })
#
# test_that("graph can be colored with Hybrid lmXRLF/TabuCol", {
#   expect_graph_colored(
#     play_islands(2, 5, 0.8, 3) %>%
#       mutate(color = as.factor(color_hybrid_lmxrlf_tabucol()))
#   )
# })
