#| title: 
# ---
\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{toml <- tstoml::ts_parse_toml("a = [1,2,3]")
toml |> ts_tree_format()
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="asciicast" style="color: #B9C0CB;font-family: 'Fira Code',Monaco,Consolas,Menlo,'Bitstream Vera Sans Mono','Powerline Symbols',monospace;line-height: 1.300000"><pre>
#> <span style="color: #6F7783;"># toml (1 line)</span>                                                                 
#> <span style="color: #6F7783;">1 | </span>a = &#91; 1, 2, 3 &#93;                                                             
</pre></div>
}}
