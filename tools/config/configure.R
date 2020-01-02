# Prepare your package for installation here.
# Use 'define()' to define configuration variables.
# Use 'configure_file()' to substitute configuration values.

dir.create("src/GraphColoring", showWarnings = FALSE)
file.copy("src/GraphColoring-raw/Header", "src/GraphColoring", recursive = TRUE)
file.copy("src/GraphColoring-raw/Source", "src/GraphColoring", recursive = TRUE)
unlink("src/GraphColoring/Source/main.cpp")
unlink("src/GraphColoring/Source/test.cpp")

cpp_files <- list.files(
  "src/GraphColoring",
  "\\.cpp$",
  full.names = TRUE,
  recursive = TRUE
)
for (file in cpp_files) {
  lines <- readLines(file, warn = FALSE)

  lines <- gsub("using std::cout;", "", lines, fixed = TRUE)
  lines <- gsub("using std::cerr;", "", lines, fixed = TRUE)

  lines <- gsub("cout", "Rcout", lines, fixed = TRUE)
  lines <- gsub("cerr", "Rcerr", lines, fixed = TRUE)

  lines <- gsub("std::Rcout", "Rcout", lines, fixed = TRUE)
  lines <- gsub("std::Rcerr", "Rcerr", lines, fixed = TRUE)

  lines <- gsub("srand(time(NULL));", "", lines, fixed = TRUE)
  lines <- gsub("rand\\(\\) % ([A-Za-z->_.]+\\(\\))", "Rcpp::sample(\\1, 1)[0] - 1", lines, perl = TRUE)
  lines <- gsub("rand\\(\\) % ([A-za-z->]+)", "Rcpp::sample(\\1, 1)[0] - 1", lines, perl = TRUE)

  lines <- c(
    "#include <Rcpp.h>",
    "using Rcpp::Rcout;",
    "using Rcpp::Rcerr;",
    lines,
    ""
  )

  writeLines(lines, file)
}

h_files <- list.files(
  "src/GraphColoring",
  "\\.h$",
  full.names = TRUE,
  recursive = TRUE
)
for (file in h_files) {
  lines <- readLines(file, warn = FALSE)

  lines <- c(
    lines,
    ""
  )

  writeLines(lines, file)
}
