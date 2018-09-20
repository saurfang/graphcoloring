color_with <- function(f, ...) {
  expect_nodes()

  graph <- tidygraph::.G()
  adj_list <- igraph::as_adj_list(graph)
  f(adj_list, ...)
}

#' Color Graph
#'
#' @examples
#' library(tidygraph)
#' library(igraph)
#'
#' play_islands(5, 10, 0.8, 3) %>%
#'   mutate(color = color_dsatur())
#'
#' @rdname graph-coloring
#' @export
color_dsatur <- function() {
  color_with(graph_coloring_dsatur)
}

#' @rdname graph-coloring
#' @export
color_msc <- function() {
  color_with(graph_coloring_msc)
}

#' @rdname graph-coloring
#' @export
color_lmxrlf <- function() {
  color_with(graph_coloring_lmxrlf)
}

#' @rdname graph-coloring
#' @export
color_hybrid_tabucol <- function() {
  color_with(graph_coloring_hybrid_tabucol)
}

#' @rdname graph-coloring
#' @export
color_hybrid_dsatur <- function() {
  color_with(graph_coloring_hybrid_dsatur)
}
