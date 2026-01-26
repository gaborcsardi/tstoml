#| title: 
# ---
\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{tree <- tstoml::ts_parse_toml("a = true\\nb = [1, 2, 3]")
tree |> ts_tree_select("new") |> ts_tree_update(as.list(4:6))
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="asciicast" style="color: #B9C0CB;font-family: 'Fira Code',Monaco,Consolas,Menlo,'Bitstream Vera Sans Mono','Powerline Symbols',monospace;line-height: 1.300000"><pre>
#> <span style="color: #6F7783;"># toml (3 lines)</span>                                                                
#> <span style="color: #6F7783;">1 | </span>a = true                                                                    
#> <span style="color: #6F7783;">2 | </span>b = &#91;1, 2, 3&#93;                                                               
#> <span style="color: #6F7783;">3 | </span>new = &#91; 4, 5, 6 &#93;                                                           
</pre></div>
}}
