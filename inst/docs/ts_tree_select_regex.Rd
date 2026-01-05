#| title: TOML example
# ---
\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{toml <- tstoml::ts_parse_toml(
 'apple = 1\\nalmond = 2\\nbanana = 3\\ncherry = 4\\n'
)
toml |> ts_tree_select(regex = "^a")
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="asciicast" style="color: #B9C0CB;font-family: 'Fira Code',Monaco,Consolas,Menlo,'Bitstream Vera Sans Mono','Powerline Symbols',monospace;line-height: 1.300000"><pre>
#> <span style="color: #6F7783;"># toml (4 lines, 2 selected elements)</span>                                           
#> <span style="background-color: #66C2CD;">&gt;</span> <span style="color: #6F7783;">1 | </span>apple = <span style="color: #66C2CD;">1</span>                                                                 
#> <span style="background-color: #66C2CD;">&gt;</span> <span style="color: #6F7783;">2 | </span>almond = <span style="color: #66C2CD;">2</span>                                                                
#>   <span style="color: #6F7783;">3 | </span>banana = 3                                                                
#>   <span style="color: #6F7783;">4 | </span>cherry = 4                                                                
</pre></div>
}}
