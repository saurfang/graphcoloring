expect_nodes <- function() {
  if (!tidygraph::.graph_context$free() && tidygraph::.graph_context$active() != "nodes") {
    stop("This call requires nodes to be active", call. = FALSE)
  }
}
