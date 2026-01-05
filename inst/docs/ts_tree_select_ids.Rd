#| title: TOML example
# ---
\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{toml <- tstoml::ts_parse_toml(
  'a = 1\\nb = [10, 20, 30]\\nc = \{ c1 = true, c2 = [] \}\\n'
)
ts_tree_dom(toml)
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="asciicast" style="color: #B9C0CB;font-family: 'Fira Code',Monaco,Consolas,Menlo,'Bitstream Vera Sans Mono','Powerline Symbols',monospace;line-height: 1.300000"><pre>
#> document (1)                                                                    
#> ├─value (5)<span style="color: #6F7783;"> # a</span>                                                                 
#> ├─array (9)<span style="color: #6F7783;"> # b</span>                                                                 
#> │ ├─value (11)                                                                  
#> │ ├─value (13)                                                                  
#> │ └─value (15)                                                                  
#> └─inline_table (20)<span style="color: #6F7783;"> # c</span>                                                         
#>   ├─value (25)<span style="color: #6F7783;"> # c1</span>                                                             
#>   └─array (30)<span style="color: #6F7783;"> # c2</span>                                                             
</pre></div>
}}


\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{toml |> ts_tree_select(I(9))
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="asciicast" style="color: #B9C0CB;font-family: 'Fira Code',Monaco,Consolas,Menlo,'Bitstream Vera Sans Mono','Powerline Symbols',monospace;line-height: 1.300000"><pre>
#> <span style="color: #6F7783;"># toml (3 lines, 1 selected element)</span>                                            
#>   <span style="color: #6F7783;">1 | </span>a = 1                                                                     
#> <span style="background-color: #66C2CD;">&gt;</span> <span style="color: #6F7783;">2 | </span>b = <span style="color: #66C2CD;">&#91;10, 20, 30&#93;</span>                                                          
#>   <span style="color: #6F7783;">3 | </span>c = \{ c1 = true, c2 = &#91;&#93; \}                                                
</pre></div>
}}
