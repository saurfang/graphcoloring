#include <Rcpp.h>

#include "GraphColoring/Header/coloring_algorithm.hpp"
#include "GraphColoring/Header/dsatur.hpp"
#include "GraphColoring/Header/mcs.hpp"
#include "GraphColoring/Header/lmxrlf.hpp"
#include "GraphColoring/Header/hybrid_dsatur.hpp"
#include "GraphColoring/Header/hybrid_lmxrlf.hpp"

using namespace Rcpp;

using std::vector;
using std::map;
using std::string;

using GraphColoring::Dsatur;
using GraphColoring::Mcs;
using GraphColoring::Lmxrlf;
using GraphColoring::HybridDsatur;
using GraphColoring::HybridLmxrlf;
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


//' @describeIn graph_coloring Color graph using DSATUR algorithm
//' \insertCite{Brelaz:1979:NMC:359094.359101}{graphcoloring}
//' @export
// [[Rcpp::export]]
IntegerVector graph_coloring_dsatur(ListOf<IntegerVector> adj_list) {
  GraphColor *graph = new Dsatur(as_input_graph(adj_list));
  return as_coloring(graph, adj_list.size());
}

//' @describeIn graph_coloring Color graph using Maximum Cardinality Search(MCS) algorithm
//' \insertCite{Palsberg:2007:RAV:1273694.1273695}{graphcoloring}
//' @export
// [[Rcpp::export]]
IntegerVector graph_coloring_msc(ListOf<IntegerVector> adj_list) {
  GraphColor *graph = new Mcs(as_input_graph(adj_list));
  return as_coloring(graph, adj_list.size());
}

//' @describeIn graph_coloring Color graph using Least-constraining Most-constrained eXtended RLF(lmXRLF) algorithm
//' \insertCite{Kirovski:1998:ECL:277044.277165}{graphcoloring}
//' @export
// [[Rcpp::export]]
IntegerVector graph_coloring_lmxrlf(ListOf<IntegerVector> adj_list) {
  GraphColor *graph = new Lmxrlf(as_input_graph(adj_list));
  return as_coloring(graph, adj_list.size());
}

//' @describeIn graph_coloring Color graph using a hybrid of DASTUR and TabuCol algorithm
//' \insertCite{Kirovski:1998:ECL:277044.277165,Brelaz:1979:NMC:359094.359101,Hertz:1987:UTS:44141.44146}{graphcoloring}
//' @export
// [[Rcpp::export]]
IntegerVector graph_coloring_hybrid_dsatur_tabucol(ListOf<IntegerVector> adj_list) {
  GraphColor *graph = new HybridDsatur(as_input_graph(adj_list));
  return as_coloring(graph, adj_list.size());
}

//' @describeIn graph_coloring Color graph using a hybrid of lmXRLF and TabuCol algorithm
//' \insertCite{Kirovski:1998:ECL:277044.277165,Hertz:1987:UTS:44141.44146}{graphcoloring}
//' @export
// [[Rcpp::export]]
IntegerVector graph_coloring_hybrid_lmxrlf_tabucol(ListOf<IntegerVector> adj_list) {
  GraphColor *graph = new HybridLmxrlf(as_input_graph(adj_list));
  return as_coloring(graph, adj_list.size());
}

//' @describeIn graph_coloring Color graph using TabuCol algorithm
//' \insertCite{Hertz:1987:UTS:44141.44146}{graphcoloring}
//' @export
// [[Rcpp::export]]
IntegerVector graph_coloring_tabucol(ListOf<IntegerVector> adj_list, int k, int tabu_size = 25, int rep = 100, int nbmax = 1000) {
  GraphColor *graph = new Tabucol(as_input_graph(adj_list), k, tabu_size, rep, nbmax);
  IntegerVector coloring = as_coloring(graph, adj_list.size());

  if(!graph->is_valid()) {
    stop("Graph cannot be colored with " + std::to_string(k) + " colors!");
  }

  return coloring;
}


// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically
// run after the compilation.
//

/*** R
timesTwo(42)
*/
