#| title: TOML example
# ---
\if{html}{\out{
<p>
}}


See \code{\link[tstoml:ts_language_toml]{tstoml::ts_language_toml()}} for details on the TOML grammar.\if{html}{\out{
<p>
}}


This example selects all integers in the TOML document.

\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{toml <- tstoml::ts_parse_toml(
  'a = 1\\nb = [10, 20, 30]\\nc = \{ c1 = true, c2 = 100 \}\\n'
)
toml |> ts_tree_select(query = "(integer) @integer")
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="asciicast" style="color: #B9C0CB;font-family: 'Fira Code',Monaco,Consolas,Menlo,'Bitstream Vera Sans Mono','Powerline Symbols',monospace;line-height: 1.300000"><pre>
#> <span style="color: #6F7783;"># toml (3 lines, 5 selected elements)</span>                                           
#> <span style="background-color: #66C2CD;">&gt;</span> <span style="color: #6F7783;">1 | </span>a = <span style="color: #66C2CD;">1</span>                                                                     
#> <span style="background-color: #66C2CD;">&gt;</span> <span style="color: #6F7783;">2 | </span>b = &#91;<span style="color: #66C2CD;">10</span>, <span style="color: #66C2CD;">20</span>, <span style="color: #66C2CD;">30</span>&#93;                                                          
#> <span style="background-color: #66C2CD;">&gt;</span> <span style="color: #6F7783;">3 | </span>c = \{ c1 = true, c2 = <span style="color: #66C2CD;">100</span> \}                                               
</pre></div>
}}
