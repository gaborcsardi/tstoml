# update_selected errors

    Code
      toml <- load_toml(text = toml_example_text())
    Condition
      Error in `load_toml()`:
      ! could not find function "load_toml"
    Code
      update_selected(select(toml, "owner"), list(name = "new_name"))
    Condition
      Error in `get_selection()`:
      ! could not find function "get_selection"
    Code
      update_selected(select(toml, "servers"), "invalid")
    Condition
      Error in `get_selection()`:
      ! could not find function "get_selection"

