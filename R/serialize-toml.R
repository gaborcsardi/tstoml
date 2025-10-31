#' @export

serialize_toml <- function(obj, file = NULL, collapse = FALSE, options = NULL) {
  lns <- stl_table(
    NULL,
    obj,
    options = options,
    arg = caller_arg(obj),
    call = caller_env()
  )

  # if it starts with a table or array of tables, there is an empty line
  if (lns[1] == "") {
    lns <- lns[-1]
  }

  if (is.null(file)) {
    if (collapse) {
      paste0(lns, collapse = "\n")
    } else {
      lns
    }
  } else {
    writeLines(lns, con = file)
    invisible(NULL)
  }
}

get_stl_type <- function(x) {
  if (!is.list(x)) {
    "pair"
  } else if (is_named(x)) {
    "table"
  } else if (length(x) > 0 && all(map_lgl(x, is_named))) {
    "array_of_tables"
  } else {
    "pair"
  }
}

stl_table <- function(
  name,
  obj,
  options = NULL,
  path = NULL,
  arg = caller_arg(obj),
  call = caller_env()
) {
  stopifnot(is_named(obj))
  c(
    if (!is.null(name)) {
      c("", paste0("[", paste(c(path, name), collapse = "."), "]"))
    },
    stl_table_body(
      obj,
      options = options,
      path = c(path, name),
      arg = arg,
      call = call
    )
  )
}

stl_inline <- function(
  obj,
  options = NULL,
  arg = caller_arg(obj),
  call = caller_env()
) {
  if (inherits(obj, "POSIXct")) {
    stl_offset_date_time(obj, options = options, arg = arg, call = call)
  } else if (inherits(obj, "POSIXlt")) {
    stl_local_date_time(obj, options = options, arg = arg, call = call)
  } else if (inherits(obj, "Date")) {
    stl_local_date(obj, options = options, arg = arg, call = call)
  } else if (inherits(obj, "difftime")) {
    stl_local_time(obj, options = options, arg = arg, call = call)
  } else if (is.list(obj) && is_named(obj)) {
    stl_inline_table(obj, options = options, arg = arg, call = call)
  } else if (is.list(obj)) {
    stl_inline_array(obj, options = options, arg = arg, call = call)
  } else if (is.double(obj)) {
    stl_float(obj, options = options, arg = arg, call = call)
  } else if (is.character(obj)) {
    stl_string(obj, options = options, arg = arg, call = call)
  } else if (is.integer(obj)) {
    stl_integer(obj, options = options, arg = arg, call = call)
  } else if (is.logical(obj)) {
    stl_boolean(obj, options = options, arg = arg, call = call)
  } else {
    stop(cnd(
      "Invalid argument: {arg}. Cannot convert {typename(obj)} to TOML.",
      call = call
    ))
  }
}

stl_table_body <- function(
  obj,
  options = NULL,
  inline = FALSE,
  path = NULL,
  arg = caller_arg(obj),
  call = caller_env()
) {
  types <- map_chr(obj, get_stl_type)
  wpairs <- which(types == "pair")
  wtables <- which(types == "table")
  waots <- which(types == "array_of_tables")

  c(
    unlist(
      use.names = FALSE,
      lapply(wpairs, function(idx) {
        paste0(
          names(obj)[idx],
          " = ",
          stl_inline(obj[[idx]], options = options, arg = arg, call = call)
        )
      })
    ),
    unlist(
      use.names = FALSE,
      lapply(wtables, function(idx) {
        stl_table(
          names(obj)[idx],
          obj[[idx]],
          options = options,
          path = path,
          arg = arg,
          call = call
        )
      })
    ),
    unlist(
      use.names = FALSE,
      lapply(waots, function(idx) {
        stl_array_of_tables(
          names(obj)[idx],
          obj[[idx]],
          options = options,
          path = path,
          arg = arg,
          call = call
        )
      })
    )
  )
}

stl_array_of_tables <- function(
  name,
  obj,
  options = options,
  path = path,
  arg = caller_arg(obj),
  call = caller_env()
) {
  unlist(lapply(seq_along(obj), function(i) {
    c(
      "",
      paste0("[[", paste0(c(path, name), collapse = "."), "]]"),
      stl_table_body(
        obj[[i]],
        options = options,
        path = c(path, name),
        arg = arg,
        call = call
      )
    )
  }))
}

stl_float <- function(
  obj,
  options = NULL,
  arg = caller_arg(obj),
  call = caller_env()
) {
  obj <- as_toml_float(obj, arg = arg, call = call)
  if (is.nan(obj)) {
    "nan"
  } else if (obj == Inf) {
    "inf"
  } else if (obj == -Inf) {
    "-inf"
  } else {
    format(obj, nsmall = 1)
  }
}

# TODO: check scalar, escape, not NA, etc.
# TODO: select between various string types
stl_string <- function(
  obj,
  options = NULL,
  arg = caller_arg(obj),
  call = caller_env()
) {
  encodeString(obj, quote = "\"")
}

stl_integer <- function(
  obj,
  options = NULL,
  arg = caller_arg(obj),
  call = caller_env()
) {
  obj <- as_toml_integer(obj, arg = arg, call = call)
  as.character(obj)
}

stl_boolean <- function(
  obj,
  options = NULL,
  arg = caller_arg(obj),
  call = caller_env()
) {
  obj <- as_toml_boolean(obj, arg = arg, call = call)
  if (obj) "true" else "false"
}

# TODO: check scalar, not NA
stl_offset_date_time <- function(
  obj,
  options = NULL,
  arg = caller_arg(obj),
  call = caller_env()
) {
  z <- format(obj, "%z")
  paste0(
    format(obj, "%Y-%m-%dT%H:%M:%S"),
    substr(z, 1, 3),
    ":",
    substr(z, 4, 5)
  )
}

# TODO: check scalar, not NA
stl_local_date_time <- function(
  obj,
  options = NULL,
  arg = caller_arg(obj),
  call = caller_env()
) {
  format(obj, "%Y-%m-%dT%H:%M:%S")
}

# TODO: check scalar, not NA
stl_local_date <- function(
  obj,
  options = NULL,
  arg = caller_arg(obj),
  call = caller_env()
) {
  format(obj, "%Y-%m-%d")
}

# TODO: check scalar, not NA
stl_local_time <- function(
  obj,
  options = NULL,
  arg = caller_arg(obj),
  call = caller_env()
) {
  secs <- as.double(obj, units = "secs")
  tics_per_second <- 1e+06
  tics_per_minute <- 6e+07
  tics_per_hour <- 3.6e+09
  tics <- secs * tics_per_second
  h <- trunc(tics / tics_per_hour)
  tics <- tics - h * tics_per_hour
  m <- trunc(tics / tics_per_minute)
  tics <- tics - m * tics_per_minute
  s <- trunc(tics / tics_per_second)
  tics <- tics - s * tics_per_second
  paste0(
    formatC(h, format = "d", width = 2, flag = "0"),
    ":",
    formatC(m, format = "d", width = 2, flag = "0"),
    ":",
    formatC(s, format = "d", width = 2, flag = "0"),
    ".",
    formatC(as.integer(tics), format = "d", width = 6, flag = "0")
  )
}

stl_inline_table <- function(
  obj,
  options = options,
  arg = caller_arg(obj),
  call = caller_env()
) {
  paste0(
    "{ ",
    paste0(
      names(obj),
      " = ",
      map_chr(obj, stl_inline, options = options),
      collapse = ", "
    ),
    " }"
  )
}

stl_inline_array <- function(
  obj,
  options = options,
  arg = caller_arg(obj),
  call = caller_env()
) {
  paste0(
    "[ ",
    paste(map_chr(obj, stl_inline, options = options), collapse = ", "),
    " ]"
  )
}
