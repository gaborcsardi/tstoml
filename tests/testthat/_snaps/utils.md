# max_or_na

    Code
      max_or_na(1:10)
    Output
      [1] 10
    Code
      max_or_na(c(1:10, NA))
    Output
      [1] NA
    Code
      max_or_na(c(1:10, NA), na.rm = TRUE)
    Output
      [1] 10
    Code
      max_or_na(integer(0))
    Output
      [1] NA
    Code
      max_or_na(numeric(0))
    Output
      [1] NA

# plural

    Code
      plural(0)
    Output
      [1] "s"
    Code
      plural(1)
    Output
      [1] ""
    Code
      plural(2)
    Output
      [1] "s"

