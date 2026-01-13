#| title: TOML example
# ---
\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{toml <- tstoml::ts_parse_toml(
  '[table]\\na = 1\\nb = [10, 20, 30]\\nc = \{ c1 = true, c2 = [] \}\\n'
)
toml <- toml |> ts_tree_select("table", "b")
}\if{html}{\out{</div>}}

\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{# selects the first two elements in the document node, ie. "table"
toml |> ts_tree_select(1:2)
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="asciicast" style="color: #B9C0CB;font-family: 'Fira Code',Monaco,Consolas,Menlo,'Bitstream Vera Sans Mono','Powerline Symbols',monospace;line-height: 1.300000"><pre>
#> <span style="color: #6F7783;"># toml (4 lines, 1 selected element)</span>                                            
#> <span style="background-color: #66C2CD;">&gt;</span> <span style="color: #6F7783;">1 | </span><span style="color: #66C2CD;">&#91;table&#93;</span>                                                                   
#> <span style="background-color: #66C2CD;">&gt;</span> <span style="color: #6F7783;">2 | </span><span style="color: #66C2CD;">a = 1</span>                                                                     
#> <span style="background-color: #66C2CD;">&gt;</span> <span style="color: #6F7783;">3 | </span><span style="color: #66C2CD;">b = &#91;10, 20, 30&#93;</span>                                                          
#> <span style="background-color: #66C2CD;">&gt;</span> <span style="color: #6F7783;">4 | </span><span style="color: #66C2CD;">c = \{ c1 = true, c2 = &#91;&#93; \}</span>                                                
</pre></div>
}}


\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{# selects the first two elements inside "table" and "b"
toml |> ts_tree_select(1:2, refine = TRUE)
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="asciicast" style="color: #B9C0CB;font-family: 'Fira Code',Monaco,Consolas,Menlo,'Bitstream Vera Sans Mono','Powerline Symbols',monospace;line-height: 1.300000"><pre>
#> <span style="color: #6F7783;"># toml (4 lines, 2 selected elements)</span>                                           
#>   <span style="color: #6F7783;">1 | </span>&#91;table&#93;                                                                   
#>   <span style="color: #6F7783;">2 | </span>a = 1                                                                     
#> <span style="background-color: #66C2CD;">&gt;</span> <span style="color: #6F7783;">3 | </span>b = &#91;<span style="color: #66C2CD;">10</span>, <span style="color: #66C2CD;">20</span>, 30&#93;                                                          
#>   <span style="color: #6F7783;">4 | </span>c = \{ c1 = true, c2 = &#91;&#93; \}                                                
</pre></div>
}}
