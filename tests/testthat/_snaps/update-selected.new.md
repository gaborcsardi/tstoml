# update_selected errors

    Code
      toml <- ts_parse_toml(text = toml_example_text())
      update_selected(select(toml, "owner"), list(name = "new_name"))
    Condition
      Error in `get_selection()`:
      ! could not find function "get_selection"
    Code
      update_selected(select(toml, "servers"), "invalid")
    Condition
      Error in `get_selection()`:
      ! could not find function "get_selection"

