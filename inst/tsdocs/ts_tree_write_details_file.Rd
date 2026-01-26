#| title: 
# ---
Format a TOML file:

\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{tree <- tstoml::ts_parse_toml("config.toml")
tree |> ts_tree_format() |> ts_tree_write()
}\if{html}{\out{</div>}}
