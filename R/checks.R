#' tstoml options
#'
#' Options that control the behavior of tstoml functions.
#'
#' TODO
#'
#' @name tstoml_options
NULL

as_toml_float <- function(
  x,
  arg = caller_arg(x),
  call = caller_env()
) {
  if (is.numeric(x) && length(x) == 1) {
    if (!is.na(x)) {
      return(x)
    } else {
      return(NaN)
    }
  }

  stop(cnd(
    "Invalid argument: `{arg}` contains an atomic numeric vector of length \\
     {length(x)}. TOML only supports numeric scalars and lists.",
    call = call
  ))
}

as_toml_boolean <- function(
  x,
  arg = caller_arg(x),
  call = caller_env()
) {
  if (is.logical(x) && length(x) == 1 && !is.na(x)) {
    return(x)
  }

  if (!is.logical(x) || length(x) != 1) {
    stop(call(
      "Invalid argument: `{arg}` contains an atomic logical vector of length \\
       {length(x)}. TOML only supports logical scalars and lists.",
      call = call
    ))
  }

  stop(call(
    "Invalid argument: `{arg}` contains a logical `NA`. TOML does not support \\
    logical `NA` values.",
    call = call
  ))
}

as_toml_integer <- function(
  x,
  arg = caller_arg(x),
  call = caller_env()
) {
  if (is.integer(x) && length(x) == 1 && !is.na(x)) {
    return(x)
  }

  if (!is.integer(x) || length(x) != 1) {
    stop(call(
      "Invalid argument: `{arg}` contains an atomic integer vector of length \
       {length(x)}. TOML only supports integer scalars and lists.",
      call = call
    ))
  }

  stop(call(
    "Invalid argument: `{arg}` contains an integer `NA`. TOML does not support \
    integer `NA` values.",
    call = call
  ))
}
