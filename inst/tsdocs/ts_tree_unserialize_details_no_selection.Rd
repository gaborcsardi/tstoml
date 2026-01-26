#| title: 
# ---
\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{tree <- tstoml::ts_parse_toml(
"a = 1\\nb = [10.0, 20, 30]\\nc = \{ c1 = true, c2 = [] \}"
)
}\if{html}{\out{</div>}}

\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{ts_tree_unserialize(tree)
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="asciicast" style="color: #B9C0CB;font-family: 'Fira Code',Monaco,Consolas,Menlo,'Bitstream Vera Sans Mono','Powerline Symbols',monospace;line-height: 1.300000"><pre>
#> &#91;&#91;1&#93;&#93;                                                                           
#> &#91;&#91;1&#93;&#93;$a                                                                         
#> &#91;1&#93; 1                                                                           
#>                                                                                 
#> &#91;&#91;1&#93;&#93;$b                                                                         
#> &#91;&#91;1&#93;&#93;$b&#91;&#91;1&#93;&#93;                                                                    
#> &#91;1&#93; 10                                                                          
#>                                                                                 
#> &#91;&#91;1&#93;&#93;$b&#91;&#91;2&#93;&#93;                                                                    
#> &#91;1&#93; 20                                                                          
#>                                                                                 
#> &#91;&#91;1&#93;&#93;$b&#91;&#91;3&#93;&#93;                                                                    
#> &#91;1&#93; 30                                                                          
#>                                                                                 
#>                                                                                 
#> &#91;&#91;1&#93;&#93;$c                                                                         
#> &#91;&#91;1&#93;&#93;$c$c1                                                                      
#> &#91;1&#93; TRUE                                                                        
#>                                                                                 
#> &#91;&#91;1&#93;&#93;$c$c2                                                                      
#> list()                                                                          
#>                                                                                 
#>                                                                                 
#>                                                                                 
</pre></div>
}}
