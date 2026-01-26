#| title: 
# ---
\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{tree <- ts_parse_toml("
  [package]
  name = 'tstoml'
  version = '0.1.0'"
)
}\if{html}{\out{</div>}}

\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{ts_tree_ast(tree)
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="asciicast" style="color: #B9C0CB;font-family: 'Fira Code',Monaco,Consolas,Menlo,'Bitstream Vera Sans Mono','Powerline Symbols',monospace;line-height: 1.300000"><pre>
#> document (1)                             1|                                     
#> └─table (2)                              2|                                     
#>   ├─&#91; (3)                                 |  &#91;                                  
#>   ├─bare_key (4)                          |   package                           
#>   ├─&#93; (5)                                 |          &#93;                          
#>   ├─pair (6)                             3|                                     
#>   │ ├─bare_key (7)                        |  name                               
#>   │ ├─= (8)                               |       =                             
#>   │ └─string (9)                          |                                     
#>   │   └─literal_string (10)               |                                     
#>   │     ├─' (11)                          |         '                           
#>   │     ├─literal_string_content (12)     |          tstoml                     
#>   │     └─' (13)                          |                '                    
#>   └─pair (14)                            4|                                     
#>     ├─bare_key (15)                       |  version                            
#>     ├─= (16)                              |          =                          
#>     └─string (17)                         |                                     
#>       └─literal_string (18)               |                                     
#>         ├─' (19)                          |            '                        
#>         ├─literal_string_content (20)     |             0.1.0                   
#>         └─' (21)                          |                  '                  
</pre></div>
}}


\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{ts_tree_dom(tree)
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="asciicast" style="color: #B9C0CB;font-family: 'Fira Code',Monaco,Consolas,Menlo,'Bitstream Vera Sans Mono','Powerline Symbols',monospace;line-height: 1.300000"><pre>
#> document (1)                                                                    
#> └─table (2)<span style="color: #6F7783;"> # package</span>                                                           
#>   ├─value (9)<span style="color: #6F7783;"> # name</span>                                                            
#>   └─value (17)<span style="color: #6F7783;"> # version</span>                                                        
</pre></div>
}}
