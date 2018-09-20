#include <Rcpp.h>

#include "GraphColoring/Header/graph_color.h"
#include "GraphColoring/Header/dsatur.h"
#include "GraphColoring/Header/mcs.h"
#include "GraphColoring/Header/lmxrlf.h"
#include "GraphColoring/Header/hybrid_dsatur.h"
#include "GraphColoring/Header/hybrid.h"

using namespace Rcpp;

using std::vector;
using std::map;
using std::string;

using GraphColoring::Dsatur;
using GraphColoring::Mcs;
using GraphColoring::Lmxrlf;
using GraphColoring::HybridDsatur;
using GraphColoring::Hybrid;
using GraphColoring::GraphColor;

map<string, vector<string> > as_input_graph(ListOf<IntegerVector> adj_list) {
  map<string, vector<string> > input_graph;

  for(ListOf<IntegerVector>::iterator it = adj_list.begin(); it != adj_list.end(); ++it) {
    IntegerVector neighbors = as<IntegerVector>(*it);

    string node = std::to_string(it.index() + 1);
    input_graph[node] = as<vector<string> >(as<CharacterVector>(neighbors));
  }

  return input_graph;
}

IntegerVector as_coloring(GraphColor *graph, int n) {
  map<string,int> coloring = graph->color();

  IntegerVector output(n);
  for(int i = 0; i < n; ++i) {
    string node = std::to_string(i + 1);
    output(i) = coloring[node] + 1;
  }

  return output;
}

// [[Rcpp::export]]
IntegerVector graph_coloring_dsatur(ListOf<IntegerVector> adj_list) {
  GraphColor *graph = new Dsatur(as_input_graph(adj_list));
  return as_coloring(graph, adj_list.size());
}


// [[Rcpp::export]]
IntegerVector graph_coloring_msc(ListOf<IntegerVector> adj_list) {
  GraphColor *graph = new Mcs(as_input_graph(adj_list));
  return as_coloring(graph, adj_list.size());
}


// [[Rcpp::export]]
IntegerVector graph_coloring_lmxrlf(ListOf<IntegerVector> adj_list) {
  GraphColor *graph = new Lmxrlf(as_input_graph(adj_list));
  return as_coloring(graph, adj_list.size());
}


// [[Rcpp::export]]
IntegerVector graph_coloring_hybrid_dsatur(ListOf<IntegerVector> adj_list) {
  GraphColor *graph = new HybridDsatur(as_input_graph(adj_list));
  return as_coloring(graph, adj_list.size());
}


// [[Rcpp::export]]
IntegerVector graph_coloring_hybrid_tabucol(ListOf<IntegerVector> adj_list) {
  GraphColor *graph = new Hybrid(as_input_graph(adj_list));
  return as_coloring(graph, adj_list.size());
}


// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically
// run after the compilation.
//

/*** R
timesTwo(42)
*/
