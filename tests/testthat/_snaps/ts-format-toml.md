# ts_format_toml

    Code
      writeLines(ts_format_toml(text = "foo=1\n\n\nbar=2"))
    Output
      foo = 1
      bar = 2

---

    Code
      writeLines(ts_format_toml(text = "foo=1\n\n\nbar=2", options = list()))
    Output
      foo = 1
      bar = 2

