#' @export

ts_tree_unserialize.ts_tree_toml <- function(tree) {
  sel <- ts_tree_selected_nodes(tree)
  as.list(lapply(sel, unserialize_element, tree = tree))
}
