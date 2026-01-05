#| title: TOML example
# ---
\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{toml <- tstoml::ts_parse_toml('
  a = 1
  b = [10, 20, 30]
  [c]
  c1 = true
  c2 = []
')
toml |> ts_tree_select(c("b", "c"), -1)
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="asciicast" style="color: #B9C0CB;font-family: 'Fira Code',Monaco,Consolas,Menlo,'Bitstream Vera Sans Mono','Powerline Symbols',monospace;line-height: 1.300000"><pre>
#> <span style="color: #6F7783;"># toml (6 lines, 2 selected elements)</span>                                           
#>   <span style="color: #6F7783;">1 | </span>                                                                          
#>   <span style="color: #6F7783;">2 | </span>  a = 1                                                                   
#> <span style="background-color: #66C2CD;">&gt;</span> <span style="color: #6F7783;">3 | </span>  b = &#91;10, 20, <span style="color: #66C2CD;">30</span>&#93;                                                        
#>   <span style="color: #6F7783;">4 | </span>  &#91;c&#93;                                                                     
#>   <span style="color: #6F7783;">5 | </span>  c1 = true                                                               
#> <span style="background-color: #66C2CD;">&gt;</span> <span style="color: #6F7783;">6 | </span>  c2 = <span style="color: #66C2CD;">&#91;&#93;</span>                                                                 
</pre></div>
}}
