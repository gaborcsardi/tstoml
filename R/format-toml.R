get_subtree <- function(toml, id, with_root = FALSE) {
  sel <- c(if (with_root) id, toml$children[[id]])
  while (TRUE) {
    sel2 <- unique(c(sel, unlist(toml$children[sel])))
    if (length(sel2) == length(sel)) {
      return(sel)
    }
    sel <- sel2
  }
}
