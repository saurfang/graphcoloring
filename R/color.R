#' Color nodes using Graph Coloring Algorithm
#'
#' These functions are [`tidygraph`] wrapper around the various [graph coloring algorithms][graph_coloring()].
#' They automatically use the graph that is being computed on, and
#' otherwise passes on its arguments to the relevant coloring function. The return value is always
#' a integer vector of assigned color index so that neighboring nodes never share the same color.
#'
#' @name color_graph
#' @rdname color_graph
#'
#' @param k number of colors to use for graph coloring
#'
#' @examples
#' library(tidygraph)
#'
#' if (requireNamespace("ggraph", quietly = TRUE)) {
#'   set.seed(42)
#'
#'   play_islands(5, 10, 0.8, 3) %>%
#'     mutate(color = as.factor(color_dsatur())) %>%
#'     ggraph(layout = 'kk') +
#'     geom_edge_link(aes(alpha = ..index..), show.legend = FALSE) +
#'     geom_node_point(aes(color = color), size = 7) +
#'     theme_graph()
#' }
NULL

#' Graph Coloring over Adjacency List
#'
#' @description
#' These functions perform graph coloring using various algorithms over an adjacency list.
#'
#' In graph theory, graph coloring is a special case of graph labeling;
#' it is an assignment of labels traditionally called "colors" to elements of a graph subject
#' to certain constraints. In its simplest form, it is a way of coloring the vertices of a graph
#' such that no two adjacent vertices share the same color; this is called a vertex coloring.
#'
#' @details
#'
#' [graph_coloring_hybrid_dsatur_tabucol()] and [graph_coloring_hybrid_lmxrlf_tabucol()] use a hybrid approach
#' to run DSATUR and lmXRLF first to determine an upper bound for the graph chromatic number. It then searches
#' better solutions by running lowered chromatic number through TabuCol to check if the graph can be colored
#' with less colors.
#'
#' @param adj_list an adjacency list in the format of `list` of `integer` vector. The outer list
#' should enumerate nodes comprehensively and each integer vector enumerates corresponding neighboring nodes
#'
#' @inheritParams color_graph
#'
#' @references
#' <https://en.wikipedia.org/wiki/Graph_coloring>
#'
#' <https://github.com/brrcrites/GraphColoring>
#'
#' \insertRef{Brelaz:1979:NMC:359094.359101}{graphcoloring}
#'
#' \insertRef{Palsberg:2007:RAV:1273694.1273695}{graphcoloring}
#'
#' \insertRef{Kirovski:1998:ECL:277044.277165}{graphcoloring}
#'
#' \insertRef{Hertz:1987:UTS:44141.44146}{graphcoloring}
#'
#' @name graph_coloring
#' @rdname graph_coloring
#' @seealso [color_graph()]
#' @examples
#'
#' # Make chess board
#' if (requireNamespace("sp", quietly = TRUE)) {
#'   gt <- GridTopology(c(0,0), c(1,1), c(8,8))
#'   sg <- SpatialGrid(gt)
#'   board <- as(as(sg, "SpatialPixels"), "SpatialPolygons")
#' }
NULL

color_with <- function(f, ...) {
  expect_nodes()

  graph <- tidygraph::.G()
  adj_list <- igraph::as_adj_list(graph)
  f(adj_list, ...)
}

#' @describeIn color_graph Color graph using [graph_coloring_dsatur()]
#' @export
color_dsatur <- function() {
  color_with(graph_coloring_dsatur)
}

#' @describeIn color_graph Color graph using [graph_coloring_msc()]
#' @export
color_msc <- function() {
  color_with(graph_coloring_msc)
}

#' @describeIn color_graph Color graph using [graph_coloring_lmxrlf()]
#' @export
color_lmxrlf <- function() {
  color_with(graph_coloring_lmxrlf)
}

#' @describeIn color_graph Color graph using [graph_coloring_hybrid_lmxrlf_tabucol()]
#' @export
color_hybrid_lmxrlf_tabucol <- function() {
  color_with(graph_coloring_hybrid_lmxrlf_tabucol)
}

#' @describeIn color_graph Color graph using [graph_coloring_hybrid_dsatur_tabucol()]
#' @export
color_hybrid_dsatur_tabucol <- function() {
  color_with(graph_coloring_hybrid_dsatur_tabucol)
}

#' @describeIn color_graph Color graph using [graph_coloring_tabucol()]
#' @export
color_tabucol <- function(k) {
  color_with(graph_coloring_tabucol, k)
}
