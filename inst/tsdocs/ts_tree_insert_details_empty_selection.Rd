#| title: 
# ---
\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{toml <- tstoml::ts_parse_toml("a = true\\nb = [1, 2, 3]")
toml |> ts_tree_select("nonexistent") |> ts_tree_insert("foo")
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="asciicast" style="color: #B9C0CB;font-family: 'Fira Code',Monaco,Consolas,Menlo,'Bitstream Vera Sans Mono','Powerline Symbols',monospace;line-height: 1.300000"><pre>
#> <span style="color: #6F7783;"># toml (2 lines, 0 selected elements)</span>                                           
#> <span style="color: #6F7783;">1 | </span>a = true                                                                    
#> <span style="color: #6F7783;">2 | </span>b = &#91;1, 2, 3&#93;                                                               
</pre></div>
}}
