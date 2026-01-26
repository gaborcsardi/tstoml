#| title: TOML example
# ---
\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{toml <- tstoml::ts_parse_toml("
  [package]
  name = 'tstoml'
  version = '0.1.0'
")
toml
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="asciicast" style="color: #B9C0CB;font-family: 'Fira Code',Monaco,Consolas,Menlo,'Bitstream Vera Sans Mono','Powerline Symbols',monospace;line-height: 1.300000"><pre>
#> <span style="color: #6F7783;"># toml (4 lines)</span>                                                                
#> <span style="color: #6F7783;">1 | </span>                                                                            
#> <span style="color: #6F7783;">2 | </span>  &#91;package&#93;                                                                 
#> <span style="color: #6F7783;">3 | </span>  name = 'tstoml'                                                           
#> <span style="color: #6F7783;">4 | </span>  version = '0.1.0'                                                         
</pre></div>
}}


\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{toml |> ts_tree_select("package", "name") |> ts_tree_delete()
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="asciicast" style="color: #B9C0CB;font-family: 'Fira Code',Monaco,Consolas,Menlo,'Bitstream Vera Sans Mono','Powerline Symbols',monospace;line-height: 1.300000"><pre>
#> <span style="color: #6F7783;"># toml (2 lines)</span>                                                                
#> <span style="color: #6F7783;">1 | </span>&#91;package&#93;                                                                   
#> <span style="color: #6F7783;">2 | </span>  version = '0.1.0'                                                         
</pre></div>
}}
