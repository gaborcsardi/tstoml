#| title: 
# ---
\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{toml <- tstoml::ts_parse_toml(
  'a = 1\\nb = [10.0, 20, 30]\\nc = \{ c1 = true, c2 = 100 \}'
)
toml |> ts_tree_query("[(float) (integer)] @number")
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="asciicast" style="color: #B9C0CB;font-family: 'Fira Code',Monaco,Consolas,Menlo,'Bitstream Vera Sans Mono','Powerline Symbols',monospace;line-height: 1.300000"><pre>
#> $patterns                                                                       
#> <span style="color: #999999;"># A data frame: 1 × 4</span>                                                           
#>      id name  pattern                         match_count                       
#>   <span style="font-style: italic;color: #999999;">&lt;int&gt;</span> <span style="font-style: italic;color: #999999;">&lt;chr&gt;</span> <span style="font-style: italic;color: #999999;">&lt;chr&gt;</span>                                 <span style="font-style: italic;color: #999999;">&lt;int&gt;</span>                       
#> <span style="color: #c2c2c2;">1</span>     1 <span style="color: #E88388;">NA</span>    <span style="color: #999999;">"</span>&#91;(float) (integer)&#93; @number\\n<span style="color: #999999;">"</span>           5                       
#>                                                                                 
#> $captures                                                                       
#> <span style="color: #999999;"># A data frame: 1 × 2</span>                                                           
#>      id name                                                                    
#>   <span style="font-style: italic;color: #999999;">&lt;int&gt;</span> <span style="font-style: italic;color: #999999;">&lt;chr&gt;</span>                                                                   
#> <span style="color: #c2c2c2;">1</span>     1 number                                                                  
#>                                                                                 
#> $matched_captures                                                               
#> <span style="color: #999999;"># A data frame: 5 × 12</span>                                                          
#>      id pattern match type    start_byte end_byte start_row start_column end_row
#>   <span style="font-style: italic;color: #999999;">&lt;int&gt;</span>   <span style="font-style: italic;color: #999999;">&lt;int&gt;</span> <span style="font-style: italic;color: #999999;">&lt;int&gt;</span> <span style="font-style: italic;color: #999999;">&lt;chr&gt;</span>        <span style="font-style: italic;color: #999999;">&lt;int&gt;</span>    <span style="font-style: italic;color: #999999;">&lt;int&gt;</span>     <span style="font-style: italic;color: #999999;">&lt;int&gt;</span>        <span style="font-style: italic;color: #999999;">&lt;int&gt;</span>   <span style="font-style: italic;color: #999999;">&lt;int&gt;</span>
#> <span style="color: #c2c2c2;">1</span>     1       1     1 integer          4        5         0            4       0
#> <span style="color: #c2c2c2;">2</span>     1       1     2 float           11       15         1            5       1
#> <span style="color: #c2c2c2;">3</span>     1       1     3 integer         17       19         1           11       1
#> <span style="color: #c2c2c2;">4</span>     1       1     4 integer         21       23         1           15       1
#> <span style="color: #c2c2c2;">5</span>     1       1     5 integer         47       50         2           22       2
#> <span style="color: #999999;"># ℹ 3 more variables: end_column &lt;int&gt;, name &lt;chr&gt;, code &lt;chr&gt;</span>                  
#>                                                                                 
</pre></div>
}}
