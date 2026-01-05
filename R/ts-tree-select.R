#' @ts ts_tree_select_true TOML example
#'
#' ```{asciicast}
#' toml <- tstoml::ts_parse_toml('
#'   a = 1
#'   b = [10, 20, 30]
#'   [c]
#'   c1 = true
#'   c2 = []
#' ')
#' toml |> ts_tree_select(c("b", "c"), TRUE)
#' ```
#'
#' @ts ts_tree_select_examples TOML examples
#'
#' ## Examples
#'
#' TODO
NULL

#' @export

ts_tree_select1.ts_tree_toml.ts_tree_selector_default <- function(
  tree,
  node,
  slt
) {
  1L
}

#' @export

ts_tree_mark_selection1.ts_tree_toml <- function(tree, node) {
  parent <- tree$parent[node]
  if (tree$type[node] == "table_array_element") {
    tree$parent[tree$dom_children[[node]]]
  } else if (
    !is.na(parent) &&
      tree$type[parent] == "table_array_element" &&
      tree$type[node] %in% c("bare_key", "quoted_key", "dotted_key")
  ) {
    # this is AOT _element_, select it like a table, but not the [[ ]] tokens
    tree$children[[parent]][c(-1, -3)]
  } else if (tree$type[node] %in% c("bare_key", "quoted_key")) {
    get_dom_subtree(tree, node, with_root = FALSE)
  } else {
    node
  }
}

get_dom_subtree <- function(tree, id, with_root = FALSE) {
  sel <- c(if (with_root) id, tree$dom_children[[id]])
  while (TRUE) {
    sel2 <- unique(c(sel, unlist(tree$dom_children[sel])))
    if (length(sel2) == length(sel)) {
      return(sel)
    }
    sel <- sel2
  }
}

#' @title
#' Select parts of a TOML tree-sitter tree
#' @usage
#' \method{ts_tree_select}{tstoml}(tree, ..., refine = FALSE)
#' @param tree
#' \eval{ts:::doc_insert("ts::ts_tree_select_param_tree", "tstoml")}
#' @param ...
#' \eval{ts:::doc_insert("ts::ts_tree_select_param_dots", "tstoml")}
#' @param refine
#' \eval{ts:::doc_insert("ts::ts_tree_select_param_refine", "tstoml")}
#' @return
#' \eval{ts:::doc_insert("ts::ts_tree_select_return", "tstoml")}
#'
#' @description
#' \eval{ts:::doc_insert("ts::ts_tree_select_description", "tstoml")}
#' @details
#' \eval{ts:::doc_insert("ts::ts_tree_select_details", "tstoml")}
#' \eval{ts:::doc_insert("tstoml::ts_tree_select_examples", "tstoml")}
#' \eval{ts:::doc_extra()}
#' @export

ts_tree_select.tstoml <- function(tree, ..., refine = FALSE) {
  NextMethod()
}
