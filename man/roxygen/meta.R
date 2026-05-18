if (exists(".knitr_asciicast_process", envir = .GlobalEnv)) {
  rm(list = ".knitr_asciicast_process", envir = .GlobalEnv)
}

asciicast::init_knitr_engine(
  echo = TRUE,
  echo_input = FALSE,
  timeout = as.integer(Sys.getenv("ASCIICAST_TIMEOUT", 10)),
  startup = quote({
    options(cli.num_colors = 256)
    library(tsitter)
    library(tstoml)
  })
)

knitr::opts_chunk$set(
  asciicast_knitr_output = "html",
  asciicast_include_style = FALSE,
  cache = FALSE,
  cache.path = file.path(getwd(), "man/_cache/"),
  fig.path = file.path(getwd(), "man/figures"),
  error = FALSE
)

Sys.setenv("R_TS_PACKAGE" = "tstoml")
tsitter:::ts_roclet_register()

list(
  markdown = TRUE,
  restrict_image_formats = TRUE,
  roclets = c("rd", "namespace", "collate", "tsitter:::roclet_ts")
)
