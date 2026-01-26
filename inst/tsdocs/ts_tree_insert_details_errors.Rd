#| title: 
# ---
\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{toml <- tstoml::ts_parse_toml("a = true\\nb = [1, 2, 3]")
toml |> ts_tree_select("a") |> ts_tree_insert("foo")
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="asciicast" style="color: #B9C0CB;font-family: 'Fira Code',Monaco,Consolas,Menlo,'Bitstream Vera Sans Mono','Powerline Symbols',monospace;line-height: 1.300000"><pre>
#> Error in FUN(X&#91;&#91;i&#93;&#93;, ...) : Cannot insert into a `value` TOML element.          
</pre></div>
}}
