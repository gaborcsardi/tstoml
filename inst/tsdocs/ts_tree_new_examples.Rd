#| title: TOML examples
# ---
\if{html}{\out{<div class="sourceCode r"><p style="display:none">&nbsp;}}\preformatted{toml <- ts::ts_tree_new(
  tstoml::ts_language_toml(),
  text = "[table]\\nkey = \\"value\\""
)
toml
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="asciicast" style="color: #B9C0CB;font-family: 'Fira Code',Monaco,Consolas,Menlo,'Bitstream Vera Sans Mono','Powerline Symbols',monospace;line-height: 1.300000"><pre>
#> <span style="color: #6F7783;"># toml (2 lines)</span>                                                                
#> <span style="color: #6F7783;">1 | </span>&#91;table&#93;                                                                     
#> <span style="color: #6F7783;">2 | </span>key = "value"                                                               
</pre></div>
}}
