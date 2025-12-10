# ts_tree_dom

    Code
      toml <- ts_parse_toml(toml_example_text())
      ts_tree_dom(toml)
    Output
      document (1)
      +-value (6) # title
      +-table (11) # owner
      | +-value (18) # name
      | \-value (26) # dob
      +-table (27) # database
      | +-value (34) # enabled
      | +-array (38) # ports
      | | +-value (40)
      | | +-value (42)
      | | \-value (44)
      | +-array (49) # data
      | | +-array (51)
      | | | +-value (53)
      | | | \-value (59)
      | | \-array (66)
      | |   \-value (68)
      | \-inline_table (74) # temp_targets
      |   +-value (79) # cpu
      |   \-value (84) # case
      \-table (86) # servers
        +-table (90) # alpha
        | +-value (100) # ip
        | \-value (108) # role
        \-table (113) # beta
          +-value (123) # ip
          \-value (131) # role

---

    Code
      toml <- ts_parse_toml(toml_aot_example())
      ts_tree_dom(toml)
    Output
      document (1)
      \-array_of_tables (3) # products
        +-table_array_element (5)
        | +-value (10) # name
        | \-value (18) # sku
        \-table_array_element (21)
          +-value (26) # name
          +-value (34) # sku
          \-value (38) # color

---

    Code
      toml <- ts_parse_toml(toml_aot_example2())
      ts_tree_dom(toml)
    Output
      document (1)
      \-array_of_tables (3) # products
        +-table_array_element (5)
        | +-value (10) # name
        | +-value (18) # sku
        | \-array_of_tables (19) # dimensions
        |   \-table_array_element (21)
        |     +-value (29) # length
        |     +-value (33) # width
        |     \-value (37) # height
        \-table_array_element (40)
          +-value (45) # name
          +-value (53) # sku
          +-value (57) # color
          \-array_of_tables (62) # dimensions
            \-table_array_element (64)
              +-value (72) # length
              +-value (76) # width
              \-value (80) # height

