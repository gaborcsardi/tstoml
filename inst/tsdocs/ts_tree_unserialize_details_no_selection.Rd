#| title: 
# ---
\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{tree <- tstoml::ts_parse_toml(
"a = 1\\nb = [10.0, 20, 30]\\nc = \{ c1 = true, c2 = [] \}"
)
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="asciicast" style="color: #B9C0CB;font-family: 'Fira Code',Monaco,Consolas,Menlo,'Bitstream Vera Sans Mono','Powerline Symbols',monospace;line-height: 1.300000"><pre>
#>                                                                                 
</pre></div>
}}


\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{ts_tree_unserialize(tree)
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="asciicast" style="color: #B9C0CB;font-family: 'Fira Code',Monaco,Consolas,Menlo,'Bitstream Vera Sans Mono','Powerline Symbols',monospace;line-height: 1.300000"><pre>
#> [[1]]                                                                           
#> [[1]]$a                                                                         
#> [1] 1                                                                           
#>                                                                                 
#> [[1]]$b                                                                         
#> [[1]]$b[[1]]                                                                    
#> [1] 10                                                                          
#>                                                                                 
#> [[1]]$b[[2]]                                                                    
#> [1] 20                                                                          
#>                                                                                 
#> [[1]]$b[[3]]                                                                    
#> [1] 30                                                                          
#>                                                                                 
#>                                                                                 
#> [[1]]$c                                                                         
#> [[1]]$c$c1                                                                      
#> [1] TRUE                                                                        
#>                                                                                 
#> [[1]]$c$c2                                                                      
#> list()                                                                          
#>                                                                                 
#>                                                                                 
#>                                                                                 
</pre></div>
}}
