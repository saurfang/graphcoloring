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
  set.seed(324)
  expect_graph_colored(
    play_bipartite(8, 8, 0.4) %>%
      mutate(color = as.factor(color_tabucol(2)))
  )
})

test_that("TabuCol may fail to color a bipartite graph using two colors when iterations are insufficient", {
  set.seed(1023)
  expect_error(
    play_bipartite(8, 8, 0.4) %>%
      mutate(color = as.factor(color_tabucol(2, rep = 10, nbmax = 10)))
  )
})

test_that("TabuCol errors out when coloring is impossible", {
  expect_error(
    play_bipartite(5, 5, 0.4) %>%
      mutate(color = as.factor(color_tabucol(1))),
    "Graph cannot be colored with 1 colors!"
  )
})

test_that("graph can be colored with Hybrid DSATUR/TabuCol", {
  expect_graph_colored(
    play_islands(2, 5, 0.8, 3) %>%
      mutate(color = as.factor(color_hybrid_dsatur_tabucol()))
  )
})

# test_that("graph can be colored with Hybrid lmXRLF/TabuCol", {
#   expect_graph_colored(
#     play_islands(2, 5, 0.8, 3) %>%
#       mutate(color = as.factor(color_hybrid_lmxrlf_tabucol()))
#   )
# })

test_that("color_with expects tidygraph nodes", {
  expect_error(
    play_islands(5, 10, 0.8, 3) %>%
      activate(edges) %>%
      mutate(color = as.factor(color_dsatur())),
    "This call requires nodes to be active"
  )
})
