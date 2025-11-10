#' Write a tstoml object to a file
#'
#' @param toml tstoml object.
#' @param file File or connection to write to. Both binary and text
#'   connections are supported. Use `stdout()` to output to the screen.
#' @return Nothing.
#'
#' @seealso [load_toml()] to create a tstoml object from a TOML file or
#'   string. [unserialize_selected()] obtain a TOML string for a tstoml
#'   object.
#' @export

save_toml <- function(toml, file = NULL) {
  file <- file %||% attr(toml, "file")
  if (is.null(file)) {
    stop(cnd(
      "Don't know which file to save TOML document to. You need to \\
       specify the `file` argument."
    ))
  }

  text <- attr(toml, "text")
  if (length(text) > 0 && text[length(text)] != 0xa) {
    text <- c(text, as.raw(0xa))
  }
  if (inherits(file, "connection")) {
    if (summary(file)$mode == "wb") {
      writeBin(text, con = file)
    } else {
      cat(rawToChar(text), file = file)
    }
  } else {
    writeBin(text, con = file)
  }
  invisible()
}
