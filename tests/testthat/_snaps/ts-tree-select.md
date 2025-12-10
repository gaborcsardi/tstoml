# get_selection

    Code
      ts_tree_selection(toml, default = FALSE)
    Output
      NULL
    Code
      ts_tree_selection(toml)
    Output
      [[1]]
      [[1]]$selector
      list()
      attr(,"class")
      [1] "ts_tree_selector_default" "ts_tree_selector"        
      [3] "list"                    
      
      [[1]]$nodes
      [1] 1
      
      
    Code
      ts_tree_selection(ts_tree_select(toml, "owner"))
    Output
      [[1]]
      [[1]]$selector
      list()
      attr(,"class")
      [1] "ts_tree_selector_default" "ts_tree_selector"        
      [3] "list"                    
      
      [[1]]$nodes
      [1] 1
      
      
      [[2]]
      [[2]]$selector
      [1] "owner"
      
      [[2]]$nodes
      [1] 11
      
      

# get_selected_nodes

    Code
      ts_tree_selected_nodes(toml, default = FALSE)
    Output
      integer(0)
    Code
      ts_tree_selected_nodes(toml)
    Output
      [1] 1
    Code
      ts_tree_selected_nodes(ts_tree_select(toml, "owner"))
    Output
      [1] 11

# select 1

    Code
      ts_tree_select(toml, "owner")
    Output
      # toml (23 lines, 1 selected element)
         2  | 
         3  | title = "TOML Example"
         4  | 
      >  5  | [owner]
      >  6  | name = "Tom Preston-Werner"
      >  7  | dob = 1979-05-27T07:32:00-08:00
      >  8  | 
         9  | [database]
        10  | enabled = true
        11  | ports = [ 8000, 8001, 8002 ]
        ...   
    Code
      ts_tree_select(toml, "servers", "alpha", "ip")
    Output
      # toml (23 lines, 1 selected element)
        ...   
        15  | [servers]
        16  | 
        17  | [servers.alpha]
      > 18  | ip = "10.0.0.1"
        19  | role = "frontend"
        20  | 
        21  | [servers.beta]
        ...   
    Code
      ts_tree_select(toml, "servers", "beta", 2)
    Output
      # toml (23 lines, 1 selected element)
        ...   
        20  | 
        21  | [servers.beta]
        22  | ip = "10.0.0.2"
      > 23  | role = "backend"

# [[.tstoml 1

    Code
      toml[["owner"]]
    Output
      [[1]]
      [[1]]$name
      [1] "Tom Preston-Werner"
      
      [[1]]$dob
      [1] "1979-05-27 15:32:00 UTC"
      
      
    Code
      toml[["servers", "alpha", "ip"]]
    Output
      [[1]]
      [1] "10.0.0.1"
      
    Code
      toml[["servers", "beta", 2]]
    Output
      [[1]]
      [1] "backend"
      

# [[.tstoml 2

    Code
      toml[[]]
    Output
      [[1]]
      [[1]]$a
      [1] 1
      
      [[1]]$b
      [1] 2
      
      

# I()

    Code
      ts_tree_select(toml, I(11))
    Output
      # toml (23 lines, 1 selected element)
         2  | 
         3  | title = "TOML Example"
         4  | 
      >  5  | [owner]
      >  6  | name = "Tom Preston-Werner"
      >  7  | dob = 1979-05-27T07:32:00-08:00
      >  8  | 
         9  | [database]
        10  | enabled = true
        11  | ports = [ 8000, 8001, 8002 ]
        ...   

# select_query

    Code
      ts_tree_select(toml, query = "(float) @float")
    Output
      # toml (23 lines, 3 selected elements)
        ...   
         9  | [database]
        10  | enabled = true
        11  | ports = [ 8000, 8001, 8002 ]
      > 12  | data = [ ["delta", "phi"], [3.14] ]
      > 13  | temp_targets = { cpu = 79.5, case = 72.0 }
        14  | 
        15  | [servers]
        16  | 
        ...   

---

    Code
      ts_tree_select(toml, query = list(
        "((pair (bare_key) @key (string) @str) (#eq? @key \"ip\"))", "str"))
    Output
      # toml (23 lines, 2 selected elements)
        ...   
        15  | [servers]
        16  | 
        17  | [servers.alpha]
      > 18  | ip = "10.0.0.1"
        19  | role = "frontend"
        20  | 
        21  | [servers.beta]
      > 22  | ip = "10.0.0.2"
        23  | role = "backend"

---

    Code
      ts_tree_select(toml, query = list("(float) @float", "bad"))
    Condition
      Error in `select_query()`:
      ! Invalid capture names in `select_query()`: bad.

---

    Code
      ts_tree_select(toml, query = "(table_array_element) @aot")
    Output
      # toml (23 lines, 0 selected elements)
       1 | # This is a TOML document
       2 | 
       3 | title = "TOML Example"
       4 | 
       5 | [owner]
       6 | name = "Tom Preston-Werner"
       7 | dob = 1979-05-27T07:32:00-08:00
       8 | 
       9 | [database]
      10 | enabled = true
      i 13 more lines
      i Use `print(n = ...)` to see more lines

# select refine = TRUE

    Code
      ts_tree_select(ts_tree_select(toml, "owner"), refine = TRUE, "name")
    Output
      # toml (23 lines, 1 selected element)
        ...   
         3  | title = "TOML Example"
         4  | 
         5  | [owner]
      >  6  | name = "Tom Preston-Werner"
         7  | dob = 1979-05-27T07:32:00-08:00
         8  | 
         9  | [database]
        ...   

# select1

    Code
      ts_tree_select(toml, I(11))
    Output
      # toml (23 lines, 1 selected element)
         2  | 
         3  | title = "TOML Example"
         4  | 
      >  5  | [owner]
      >  6  | name = "Tom Preston-Werner"
      >  7  | dob = 1979-05-27T07:32:00-08:00
      >  8  | 
         9  | [database]
        10  | enabled = true
        11  | ports = [ 8000, 8001, 8002 ]
        ...   
    Code
      ts_tree_select(toml, "owner", TRUE)
    Output
      # toml (23 lines, 2 selected elements)
        ...   
         3  | title = "TOML Example"
         4  | 
         5  | [owner]
      >  6  | name = "Tom Preston-Werner"
      >  7  | dob = 1979-05-27T07:32:00-08:00
         8  | 
         9  | [database]
        10  | enabled = true
        ...   

---

    Code
      ts_tree_select(toml, "owner", FALSE)
    Condition
      Error in `ts_tree_select1.ts_tree.logical()`:
      ! Invalid logical selector in `ts_tree_select()`: only scalar `TRUE` is supported.

# select1_true

    Code
      ts_tree_select(toml, "products")
    Output
      [90m# toml (11 lines, 1 selected element)[39m
        [90m 1[39m[90m | [39m# A TOML document with all types of arrays of tables
        [90m 2[39m[90m | [39m
      [46m>[49m [90m 3[39m[90m | [39m  [36m[[products]][39m
      [46m>[49m [90m 4[39m[90m | [39m[36m  name = "Hammer"[39m
      [46m>[49m [90m 5[39m[90m | [39m[36m  sku = 738594937[39m
      [46m>[49m [90m 6[39m[90m | [39m[36m[39m
      [46m>[49m [90m 7[39m[90m | [39m  [36m[[products]][39m
      [46m>[49m [90m 8[39m[90m | [39m[36m  name = "Nail"[39m
      [46m>[49m [90m 9[39m[90m | [39m[36m  sku = 284758393[39m
      [46m>[49m [90m10[39m[90m | [39m[36m  color = "gray"[39m
        [90m11[39m[90m | [39m  
    Code
      ts_tree_select(toml, "products", TRUE)
    Output
      [90m# toml (11 lines, 2 selected elements)[39m
        [90m 1[39m[90m | [39m# A TOML document with all types of arrays of tables
        [90m 2[39m[90m | [39m
      [46m>[49m [90m 3[39m[90m | [39m  [[[36mproducts[39m]]
      [46m>[49m [90m 4[39m[90m | [39m  [36mname = "Hammer"[39m
      [46m>[49m [90m 5[39m[90m | [39m  [36msku = 738594937[39m
        [90m 6[39m[90m | [39m
      [46m>[49m [90m 7[39m[90m | [39m  [[[36mproducts[39m]]
      [46m>[49m [90m 8[39m[90m | [39m  [36mname = "Nail"[39m
      [46m>[49m [90m 9[39m[90m | [39m  [36msku = 284758393[39m
      [46m>[49m [90m10[39m[90m | [39m  [36mcolor = "gray"[39m
        [90m11[39m[90m | [39m  
    Code
      ts_tree_select(toml, "products", TRUE, TRUE)
    Output
      [90m# toml (11 lines, 5 selected elements)[39m
        [90m 1[39m[90m | [39m# A TOML document with all types of arrays of tables
        [90m 2[39m[90m | [39m
        [90m 3[39m[90m | [39m  [[products]]
      [46m>[49m [90m 4[39m[90m | [39m  name = [36m"Hammer"[39m
      [46m>[49m [90m 5[39m[90m | [39m  sku = [36m738594937[39m
        [90m 6[39m[90m | [39m
        [90m 7[39m[90m | [39m  [[products]]
      [46m>[49m [90m 8[39m[90m | [39m  name = [36m"Nail"[39m
      [46m>[49m [90m 9[39m[90m | [39m  sku = [36m284758393[39m
      [46m>[49m [90m10[39m[90m | [39m  color = [36m"gray"[39m
        [90m11[39m[90m | [39m  

---

    Code
      ts_tree_select(ts_parse_toml("a=1\nb=2\n[tab]\nc=3\n"), TRUE)
    Output
      [90m# toml (4 lines, 3 selected elements)[39m
      [46m>[49m [90m1[39m[90m | [39ma=[36m1[39m
      [46m>[49m [90m2[39m[90m | [39mb=[36m2[39m
      [46m>[49m [90m3[39m[90m | [39m[36m[tab][39m
      [46m>[49m [90m4[39m[90m | [39m[36mc=3[39m

---

    Code
      ts_tree_select(ts_parse_toml("[a.b.c]\nx=1\n"), TRUE)
    Output
      [90m# toml (2 lines, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39m[36m[a.[36mb[36m.c][39m
      [46m>[49m [90m2[39m[90m | [39m[36mx=[39m[36m[36m1[36m[39m

---

    Code
      ts_tree_select(ts_parse_toml("a.b.c=1\nb=2\nc=3"), TRUE)
    Output
      [90m# toml (3 lines, 3 selected elements)[39m
      [46m>[49m [90m1[39m[90m | [39ma.[36mb[39m.c=[36m1[39m
      [46m>[49m [90m2[39m[90m | [39mb=[36m2[39m
      [46m>[49m [90m3[39m[90m | [39mc=[36m3[39m

---

    Code
      txt <- "[a.b.c]\na=1\nb=2\n"
      print(ts_parse_toml(txt)[], n = Inf)
    Output
      [38;5;246m# A data frame: 19 x 20[39m
            id parent field_name type       code  start_byte end_byte start_row
         [3m[38;5;246m<int>[39m[23m  [3m[38;5;246m<int>[39m[23m [3m[38;5;246m<chr>[39m[23m      [3m[38;5;246m<chr>[39m[23m      [3m[38;5;246m<chr>[39m[23m      [3m[38;5;246m<int>[39m[23m    [3m[38;5;246m<int>[39m[23m     [3m[38;5;246m<int>[39m[23m
      [38;5;250m 1[39m     1     [31mNA[39m [31mNA[39m         document   [31mNA[39m             0       16         0
      [38;5;250m 2[39m     2      1 [31mNA[39m         table      [31mNA[39m             0       16         0
      [38;5;250m 3[39m     3      2 [31mNA[39m         [          [              0        1         0
      [38;5;250m 4[39m     4      2 [31mNA[39m         dotted_key [31mNA[39m             1        6         0
      [38;5;250m 5[39m     5      4 [31mNA[39m         dotted_key [31mNA[39m             1        4         0
      [38;5;250m 6[39m     6      5 [31mNA[39m         bare_key   a              1        2         0
      [38;5;250m 7[39m     7      5 [31mNA[39m         .          .              2        3         0
      [38;5;250m 8[39m     8      5 [31mNA[39m         bare_key   b              3        4         0
      [38;5;250m 9[39m     9      4 [31mNA[39m         .          .              4        5         0
      [38;5;250m10[39m    10      4 [31mNA[39m         bare_key   c              5        6         0
      [38;5;250m11[39m    11      2 [31mNA[39m         ]          ]              6        7         0
      [38;5;250m12[39m    12      2 [31mNA[39m         pair       [31mNA[39m             8       11         1
      [38;5;250m13[39m    13     12 [31mNA[39m         bare_key   a              8        9         1
      [38;5;250m14[39m    14     12 [31mNA[39m         =          =              9       10         1
      [38;5;250m15[39m    15     12 [31mNA[39m         integer    1             10       11         1
      [38;5;250m16[39m    16      2 [31mNA[39m         pair       [31mNA[39m            12       15         2
      [38;5;250m17[39m    17     16 [31mNA[39m         bare_key   b             12       13         2
      [38;5;250m18[39m    18     16 [31mNA[39m         =          =             13       14         2
      [38;5;250m19[39m    19     16 [31mNA[39m         integer    2             14       15         2
      [38;5;246m# i 12 more variables: start_column <int>, end_row <int>, end_column <int>,[39m
      [38;5;246m#   is_missing <lgl>, has_error <lgl>, expected <list>, children <I<list>>,[39m
      [38;5;246m#   tws <chr>, dom_parent <int>, dom_type <chr>, dom_name <chr>,[39m
      [38;5;246m#   dom_children <I<list>>[39m
    Code
      ts_tree_select(ts_parse_toml(txt), "a", TRUE)
    Output
      [90m# toml (3 lines, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39m[36m[a.b.c][39m
      [46m>[49m [90m2[39m[90m | [39m[36ma=[39m[36m[36m1[36m[39m
      [46m>[49m [90m3[39m[90m | [39m[36mb=[39m[36m[36m2[36m[39m
    Code
      ts_tree_selection(ts_tree_select(ts_parse_toml(txt), "a", TRUE))
    Output
      [[1]]
      [[1]]$selector
      list()
      attr(,"class")
      [1] "ts_tree_selector_default" "ts_tree_selector"        
      [3] "list"                    
      
      [[1]]$nodes
      [1] 1
      
      
      [[2]]
      [[2]]$selector
      [1] "a"
      
      [[2]]$nodes
      [1] 6
      
      
      [[3]]
      [[3]]$selector
      [1] TRUE
      
      [[3]]$nodes
      [1] 8
      
      
    Code
      ts_tree_select(ts_parse_toml(txt), "a", TRUE, TRUE)
    Output
      [90m# toml (3 lines, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39m[36m[a.b.c][39m
      [46m>[49m [90m2[39m[90m | [39m[36ma=1[39m
      [46m>[49m [90m3[39m[90m | [39m[36mb=2[39m
    Code
      ts_tree_selection(ts_tree_select(ts_parse_toml(txt), "a", TRUE, TRUE))
    Output
      [[1]]
      [[1]]$selector
      list()
      attr(,"class")
      [1] "ts_tree_selector_default" "ts_tree_selector"        
      [3] "list"                    
      
      [[1]]$nodes
      [1] 1
      
      
      [[2]]
      [[2]]$selector
      [1] "a"
      
      [[2]]$nodes
      [1] 6
      
      
      [[3]]
      [[3]]$selector
      [1] TRUE
      
      [[3]]$nodes
      [1] 8
      
      
      [[4]]
      [[4]]$selector
      [1] TRUE
      
      [[4]]$nodes
      [1] 2
      
      

---

    Code
      txt <- "a.b.c = 1"
      print(ts_parse_toml(txt)[], n = Inf)
    Output
      [38;5;246m# A data frame: 11 x 20[39m
            id parent field_name type       code  start_byte end_byte start_row
         [3m[38;5;246m<int>[39m[23m  [3m[38;5;246m<int>[39m[23m [3m[38;5;246m<chr>[39m[23m      [3m[38;5;246m<chr>[39m[23m      [3m[38;5;246m<chr>[39m[23m      [3m[38;5;246m<int>[39m[23m    [3m[38;5;246m<int>[39m[23m     [3m[38;5;246m<int>[39m[23m
      [38;5;250m 1[39m     1     [31mNA[39m [31mNA[39m         document   [31mNA[39m             0        9         0
      [38;5;250m 2[39m     2      1 [31mNA[39m         pair       [31mNA[39m             0        9         0
      [38;5;250m 3[39m     3      2 [31mNA[39m         dotted_key [31mNA[39m             0        5         0
      [38;5;250m 4[39m     4      3 [31mNA[39m         dotted_key [31mNA[39m             0        3         0
      [38;5;250m 5[39m     5      4 [31mNA[39m         bare_key   a              0        1         0
      [38;5;250m 6[39m     6      4 [31mNA[39m         .          .              1        2         0
      [38;5;250m 7[39m     7      4 [31mNA[39m         bare_key   b              2        3         0
      [38;5;250m 8[39m     8      3 [31mNA[39m         .          .              3        4         0
      [38;5;250m 9[39m     9      3 [31mNA[39m         bare_key   c              4        5         0
      [38;5;250m10[39m    10      2 [31mNA[39m         =          =              6        7         0
      [38;5;250m11[39m    11      2 [31mNA[39m         integer    1              8        9         0
      [38;5;246m# i 12 more variables: start_column <int>, end_row <int>, end_column <int>,[39m
      [38;5;246m#   is_missing <lgl>, has_error <lgl>, expected <list>, children <I<list>>,[39m
      [38;5;246m#   tws <chr>, dom_parent <int>, dom_type <chr>, dom_name <chr>,[39m
      [38;5;246m#   dom_children <I<list>>[39m
    Code
      ts_tree_select(ts_parse_toml(txt), "a", TRUE)
    Output
      [90m# toml (1 line, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39ma.b.c = [36m1[39m
    Code
      ts_tree_selection(ts_tree_select(ts_parse_toml(txt), "a", TRUE))
    Output
      [[1]]
      [[1]]$selector
      list()
      attr(,"class")
      [1] "ts_tree_selector_default" "ts_tree_selector"        
      [3] "list"                    
      
      [[1]]$nodes
      [1] 1
      
      
      [[2]]
      [[2]]$selector
      [1] "a"
      
      [[2]]$nodes
      [1] 5
      
      
      [[3]]
      [[3]]$selector
      [1] TRUE
      
      [[3]]$nodes
      [1] 7
      
      
    Code
      ts_tree_select(ts_parse_toml(txt), "a", TRUE, TRUE)
    Output
      [90m# toml (1 line, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39ma.b.c = [36m1[39m
    Code
      ts_tree_selection(ts_tree_select(ts_parse_toml(txt), "a", TRUE, TRUE))
    Output
      [[1]]
      [[1]]$selector
      list()
      attr(,"class")
      [1] "ts_tree_selector_default" "ts_tree_selector"        
      [3] "list"                    
      
      [[1]]$nodes
      [1] 1
      
      
      [[2]]
      [[2]]$selector
      [1] "a"
      
      [[2]]$nodes
      [1] 5
      
      
      [[3]]
      [[3]]$selector
      [1] TRUE
      
      [[3]]$nodes
      [1] 7
      
      
      [[4]]
      [[4]]$selector
      [1] TRUE
      
      [[4]]$nodes
      [1] 11
      
      

---

    Code
      txt <- "a = { b = { c = 1, d = 2 }, e = 3 }"
      print(ts_parse_toml(txt)[], n = Inf)
    Output
      [38;5;246m# A data frame: 27 x 20[39m
            id parent field_name type         code  start_byte end_byte start_row
         [3m[38;5;246m<int>[39m[23m  [3m[38;5;246m<int>[39m[23m [3m[38;5;246m<chr>[39m[23m      [3m[38;5;246m<chr>[39m[23m        [3m[38;5;246m<chr>[39m[23m      [3m[38;5;246m<int>[39m[23m    [3m[38;5;246m<int>[39m[23m     [3m[38;5;246m<int>[39m[23m
      [38;5;250m 1[39m     1     [31mNA[39m [31mNA[39m         document     [31mNA[39m             0       35         0
      [38;5;250m 2[39m     2      1 [31mNA[39m         pair         [31mNA[39m             0       35         0
      [38;5;250m 3[39m     3      2 [31mNA[39m         bare_key     a              0        1         0
      [38;5;250m 4[39m     4      2 [31mNA[39m         =            =              2        3         0
      [38;5;250m 5[39m     5      2 [31mNA[39m         inline_table [31mNA[39m             4       35         0
      [38;5;250m 6[39m     6      5 [31mNA[39m         {            {              4        5         0
      [38;5;250m 7[39m     7      5 [31mNA[39m         pair         [31mNA[39m             6       26         0
      [38;5;250m 8[39m     8      7 [31mNA[39m         bare_key     b              6        7         0
      [38;5;250m 9[39m     9      7 [31mNA[39m         =            =              8        9         0
      [38;5;250m10[39m    10      7 [31mNA[39m         inline_table [31mNA[39m            10       26         0
      [38;5;250m11[39m    11     10 [31mNA[39m         {            {             10       11         0
      [38;5;250m12[39m    12     10 [31mNA[39m         pair         [31mNA[39m            12       17         0
      [38;5;250m13[39m    13     12 [31mNA[39m         bare_key     c             12       13         0
      [38;5;250m14[39m    14     12 [31mNA[39m         =            =             14       15         0
      [38;5;250m15[39m    15     12 [31mNA[39m         integer      1             16       17         0
      [38;5;250m16[39m    16     10 [31mNA[39m         ,            ,             17       18         0
      [38;5;250m17[39m    17     10 [31mNA[39m         pair         [31mNA[39m            19       24         0
      [38;5;250m18[39m    18     17 [31mNA[39m         bare_key     d             19       20         0
      [38;5;250m19[39m    19     17 [31mNA[39m         =            =             21       22         0
      [38;5;250m20[39m    20     17 [31mNA[39m         integer      2             23       24         0
      [38;5;250m21[39m    21     10 [31mNA[39m         }            }             25       26         0
      [38;5;250m22[39m    22      5 [31mNA[39m         ,            ,             26       27         0
      [38;5;250m23[39m    23      5 [31mNA[39m         pair         [31mNA[39m            28       33         0
      [38;5;250m24[39m    24     23 [31mNA[39m         bare_key     e             28       29         0
      [38;5;250m25[39m    25     23 [31mNA[39m         =            =             30       31         0
      [38;5;250m26[39m    26     23 [31mNA[39m         integer      3             32       33         0
      [38;5;250m27[39m    27      5 [31mNA[39m         }            }             34       35         0
      [38;5;246m# i 12 more variables: start_column <int>, end_row <int>, end_column <int>,[39m
      [38;5;246m#   is_missing <lgl>, has_error <lgl>, expected <list>, children <I<list>>,[39m
      [38;5;246m#   tws <chr>, dom_parent <int>, dom_type <chr>, dom_name <chr>,[39m
      [38;5;246m#   dom_children <I<list>>[39m
    Code
      ts_tree_select(ts_parse_toml(txt), "a", TRUE)
    Output
      [90m# toml (1 line, 2 selected elements)[39m
      [46m>[49m [90m1[39m[90m | [39ma = { b = [36m{ c = 1, d = 2 }[39m, e = [36m3[39m }
    Code
      ts_tree_selection(ts_tree_select(ts_parse_toml(txt), "a", TRUE))
    Output
      [[1]]
      [[1]]$selector
      list()
      attr(,"class")
      [1] "ts_tree_selector_default" "ts_tree_selector"        
      [3] "list"                    
      
      [[1]]$nodes
      [1] 1
      
      
      [[2]]
      [[2]]$selector
      [1] "a"
      
      [[2]]$nodes
      [1] 5
      
      
      [[3]]
      [[3]]$selector
      [1] TRUE
      
      [[3]]$nodes
      [1] 10 26
      
      
    Code
      ts_tree_select(ts_parse_toml(txt), "a", TRUE, TRUE)
    Output
      [90m# toml (1 line, 2 selected elements)[39m
      [46m>[49m [90m1[39m[90m | [39ma = { b = { c = [36m1[39m, d = [36m2[39m }, e = 3 }
    Code
      ts_tree_selection(ts_tree_select(ts_parse_toml(txt), "a", TRUE, TRUE))
    Output
      [[1]]
      [[1]]$selector
      list()
      attr(,"class")
      [1] "ts_tree_selector_default" "ts_tree_selector"        
      [3] "list"                    
      
      [[1]]$nodes
      [1] 1
      
      
      [[2]]
      [[2]]$selector
      [1] "a"
      
      [[2]]$nodes
      [1] 5
      
      
      [[3]]
      [[3]]$selector
      [1] TRUE
      
      [[3]]$nodes
      [1] 10 26
      
      
      [[4]]
      [[4]]$selector
      [1] TRUE
      
      [[4]]$nodes
      [1] 15 20
      
      

---

    Code
      txt <- "a = { b.c.d = 1, d = 2 }"
      print(ts_parse_toml(txt)[], n = Inf)
    Output
      [38;5;246m# A data frame: 22 x 20[39m
            id parent field_name type         code  start_byte end_byte start_row
         [3m[38;5;246m<int>[39m[23m  [3m[38;5;246m<int>[39m[23m [3m[38;5;246m<chr>[39m[23m      [3m[38;5;246m<chr>[39m[23m        [3m[38;5;246m<chr>[39m[23m      [3m[38;5;246m<int>[39m[23m    [3m[38;5;246m<int>[39m[23m     [3m[38;5;246m<int>[39m[23m
      [38;5;250m 1[39m     1     [31mNA[39m [31mNA[39m         document     [31mNA[39m             0       24         0
      [38;5;250m 2[39m     2      1 [31mNA[39m         pair         [31mNA[39m             0       24         0
      [38;5;250m 3[39m     3      2 [31mNA[39m         bare_key     a              0        1         0
      [38;5;250m 4[39m     4      2 [31mNA[39m         =            =              2        3         0
      [38;5;250m 5[39m     5      2 [31mNA[39m         inline_table [31mNA[39m             4       24         0
      [38;5;250m 6[39m     6      5 [31mNA[39m         {            {              4        5         0
      [38;5;250m 7[39m     7      5 [31mNA[39m         pair         [31mNA[39m             6       15         0
      [38;5;250m 8[39m     8      7 [31mNA[39m         dotted_key   [31mNA[39m             6       11         0
      [38;5;250m 9[39m     9      8 [31mNA[39m         dotted_key   [31mNA[39m             6        9         0
      [38;5;250m10[39m    10      9 [31mNA[39m         bare_key     b              6        7         0
      [38;5;250m11[39m    11      9 [31mNA[39m         .            .              7        8         0
      [38;5;250m12[39m    12      9 [31mNA[39m         bare_key     c              8        9         0
      [38;5;250m13[39m    13      8 [31mNA[39m         .            .              9       10         0
      [38;5;250m14[39m    14      8 [31mNA[39m         bare_key     d             10       11         0
      [38;5;250m15[39m    15      7 [31mNA[39m         =            =             12       13         0
      [38;5;250m16[39m    16      7 [31mNA[39m         integer      1             14       15         0
      [38;5;250m17[39m    17      5 [31mNA[39m         ,            ,             15       16         0
      [38;5;250m18[39m    18      5 [31mNA[39m         pair         [31mNA[39m            17       22         0
      [38;5;250m19[39m    19     18 [31mNA[39m         bare_key     d             17       18         0
      [38;5;250m20[39m    20     18 [31mNA[39m         =            =             19       20         0
      [38;5;250m21[39m    21     18 [31mNA[39m         integer      2             21       22         0
      [38;5;250m22[39m    22      5 [31mNA[39m         }            }             23       24         0
      [38;5;246m# i 12 more variables: start_column <int>, end_row <int>, end_column <int>,[39m
      [38;5;246m#   is_missing <lgl>, has_error <lgl>, expected <list>, children <I<list>>,[39m
      [38;5;246m#   tws <chr>, dom_parent <int>, dom_type <chr>, dom_name <chr>,[39m
      [38;5;246m#   dom_children <I<list>>[39m
    Code
      ts_tree_select(ts_parse_toml(txt), "a", TRUE)
    Output
      [90m# toml (1 line, 2 selected elements)[39m
      [46m>[49m [90m1[39m[90m | [39ma = { b.[36mc[39m.d = [36m1[39m, d = [36m2[39m }
    Code
      ts_tree_select(ts_parse_toml(txt), "a", TRUE, TRUE)
    Output
      [90m# toml (1 line, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39ma = { b.c.d = [36m1[39m, d = 2 }
    Code
      ts_tree_select(ts_parse_toml(txt), "a", TRUE, TRUE, TRUE)
    Output
      [90m# toml (1 line, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39ma = { b.c.d = [36m1[39m, d = 2 }

---

    Code
      txt <- "a = [ 1, 2, 3 ]"
      ts_tree_select(ts_parse_toml(txt), "a", TRUE)
    Output
      [90m# toml (1 line, 3 selected elements)[39m
      [46m>[49m [90m1[39m[90m | [39ma = [ [36m1[39m, [36m2[39m, [36m3[39m ]
    Code
      ts_tree_select(ts_parse_toml(txt), "a", TRUE, TRUE)
    Output
      [90m# toml (1 line, 0 selected elements)[39m
      [90m1[39m[90m | [39ma = [ 1, 2, 3 ]

# select1_key

    Code
      ts_tree_select(toml, "owner")
    Output
      [90m# toml (23 lines, 1 selected element)[39m
        [90m 2 [39m[90m | [39m
        [90m 3 [39m[90m | [39mtitle = "TOML Example"
        [90m 4 [39m[90m | [39m
      [46m>[49m [90m 5 [39m[90m | [39m[36m[owner][39m
      [46m>[49m [90m 6 [39m[90m | [39m[36mname = "Tom Preston-Werner"[39m
      [46m>[49m [90m 7 [39m[90m | [39m[36mdob = 1979-05-27T07:32:00-08:00[39m
      [46m>[49m [90m 8 [39m[90m | [39m[36m[39m
        [90m 9 [39m[90m | [39m[database]
        [90m10 [39m[90m | [39menabled = true
        [90m11 [39m[90m | [39mports = [ 8000, 8001, 8002 ]
        [90m...[39m   
    Code
      ts_tree_select(toml, "owner", "name")
    Output
      [90m# toml (23 lines, 1 selected element)[39m
        [90m...[39m   
        [90m 3 [39m[90m | [39mtitle = "TOML Example"
        [90m 4 [39m[90m | [39m
        [90m 5 [39m[90m | [39m[owner]
      [46m>[49m [90m 6 [39m[90m | [39mname = [36m"Tom Preston-Werner"[39m
        [90m 7 [39m[90m | [39mdob = 1979-05-27T07:32:00-08:00
        [90m 8 [39m[90m | [39m
        [90m 9 [39m[90m | [39m[database]
        [90m...[39m   
    Code
      ts_tree_select(toml, "nothere")
    Output
      [90m# toml (23 lines, 0 selected elements)[39m
      [90m 1[39m[90m | [39m# This is a TOML document
      [90m 2[39m[90m | [39m
      [90m 3[39m[90m | [39mtitle = "TOML Example"
      [90m 4[39m[90m | [39m
      [90m 5[39m[90m | [39m[owner]
      [90m 6[39m[90m | [39mname = "Tom Preston-Werner"
      [90m 7[39m[90m | [39mdob = 1979-05-27T07:32:00-08:00
      [90m 8[39m[90m | [39m
      [90m 9[39m[90m | [39m[database]
      [90m10[39m[90m | [39menabled = true
      [90mi 13 more lines[39m
      [90mi Use `print(n = ...)` to see more lines[39m
    Code
      ts_tree_select(toml, "owner", "nothere")
    Output
      [90m# toml (23 lines, 0 selected elements)[39m
      [90m 1[39m[90m | [39m# This is a TOML document
      [90m 2[39m[90m | [39m
      [90m 3[39m[90m | [39mtitle = "TOML Example"
      [90m 4[39m[90m | [39m
      [90m 5[39m[90m | [39m[owner]
      [90m 6[39m[90m | [39mname = "Tom Preston-Werner"
      [90m 7[39m[90m | [39mdob = 1979-05-27T07:32:00-08:00
      [90m 8[39m[90m | [39m
      [90m 9[39m[90m | [39m[database]
      [90m10[39m[90m | [39menabled = true
      [90mi 13 more lines[39m
      [90mi Use `print(n = ...)` to see more lines[39m

---

    Code
      ts_tree_select(toml, "products")
    Output
      [90m# toml (11 lines, 1 selected element)[39m
        [90m 1[39m[90m | [39m# A TOML document with all types of arrays of tables
        [90m 2[39m[90m | [39m
      [46m>[49m [90m 3[39m[90m | [39m  [36m[[products]][39m
      [46m>[49m [90m 4[39m[90m | [39m[36m  name = "Hammer"[39m
      [46m>[49m [90m 5[39m[90m | [39m[36m  sku = 738594937[39m
      [46m>[49m [90m 6[39m[90m | [39m[36m[39m
      [46m>[49m [90m 7[39m[90m | [39m  [36m[[products]][39m
      [46m>[49m [90m 8[39m[90m | [39m[36m  name = "Nail"[39m
      [46m>[49m [90m 9[39m[90m | [39m[36m  sku = 284758393[39m
      [46m>[49m [90m10[39m[90m | [39m[36m  color = "gray"[39m
        [90m11[39m[90m | [39m  
    Code
      ts_tree_select(toml, "products", TRUE, "name")
    Output
      [90m# toml (11 lines, 2 selected elements)[39m
        [90m 1[39m[90m | [39m# A TOML document with all types of arrays of tables
        [90m 2[39m[90m | [39m
        [90m 3[39m[90m | [39m  [[products]]
      [46m>[49m [90m 4[39m[90m | [39m  name = [36m"Hammer"[39m
        [90m 5[39m[90m | [39m  sku = 738594937
        [90m 6[39m[90m | [39m
        [90m 7[39m[90m | [39m  [[products]]
      [46m>[49m [90m 8[39m[90m | [39m  name = [36m"Nail"[39m
        [90m 9[39m[90m | [39m  sku = 284758393
        [90m10[39m[90m | [39m  color = "gray"
        [90m11[39m[90m | [39m  
    Code
      ts_tree_select(toml, "products", TRUE, "notthere")
    Output
      [90m# toml (11 lines, 0 selected elements)[39m
      [90m 1[39m[90m | [39m# A TOML document with all types of arrays of tables
      [90m 2[39m[90m | [39m
      [90m 3[39m[90m | [39m  [[products]]
      [90m 4[39m[90m | [39m  name = "Hammer"
      [90m 5[39m[90m | [39m  sku = 738594937
      [90m 6[39m[90m | [39m
      [90m 7[39m[90m | [39m  [[products]]
      [90m 8[39m[90m | [39m  name = "Nail"
      [90m 9[39m[90m | [39m  sku = 284758393
      [90m10[39m[90m | [39m  color = "gray"
      [90mi 1 more line[39m
      [90mi Use `print(n = ...)` to see more lines[39m

---

    Code
      ts_tree_select(toml, "a")
    Output
      [90m# toml (3 lines, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39m[36m[a.[36mb[36m.c][39m
      [46m>[49m [90m2[39m[90m | [39m[36mx=[39m[36m[36m1[36m[39m
      [46m>[49m [90m3[39m[90m | [39m[36my=[39m[36m[36m2[36m[39m
    Code
      ts_tree_select(toml, "a", "b")
    Output
      [90m# toml (3 lines, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39m[36m[a.b.c][39m
      [46m>[49m [90m2[39m[90m | [39m[36mx=[39m[36m[36m1[36m[39m
      [46m>[49m [90m3[39m[90m | [39m[36my=[39m[36m[36m2[36m[39m
    Code
      ts_tree_select(toml, "a", "b", "c")
    Output
      [90m# toml (3 lines, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39m[36m[a.b.c][39m
      [46m>[49m [90m2[39m[90m | [39m[36mx=1[39m
      [46m>[49m [90m3[39m[90m | [39m[36my=2[39m
    Code
      ts_tree_select(toml, "a", "b", "notthere")
    Output
      [90m# toml (3 lines, 0 selected elements)[39m
      [90m1[39m[90m | [39m[a.b.c]
      [90m2[39m[90m | [39mx=1
      [90m3[39m[90m | [39my=2

---

    Code
      ts_tree_select(toml, "a")
    Output
      [90m# toml (2 lines, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39ma.[36mb[39m.c=[36m1[39m
        [90m2[39m[90m | [39md=2
    Code
      ts_tree_select(toml, "a", "b")
    Output
      [90m# toml (2 lines, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39ma.b.c=[36m1[39m
        [90m2[39m[90m | [39md=2
    Code
      ts_tree_select(toml, "a", "b", "c")
    Output
      [90m# toml (2 lines, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39ma.b.c=[36m1[39m
        [90m2[39m[90m | [39md=2
    Code
      ts_tree_select(toml, "a", "b", "notthere")
    Output
      [90m# toml (2 lines, 0 selected elements)[39m
      [90m1[39m[90m | [39ma.b.c=1
      [90m2[39m[90m | [39md=2

---

    Code
      ts_tree_select(toml, "a")
    Output
      [90m# toml (1 line, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39ma = [36m{ b = { c = 1, d = 2 }, e = 3 }[39m
    Code
      ts_tree_select(toml, "a", "b")
    Output
      [90m# toml (1 line, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39ma = { b = [36m{ c = 1, d = 2 }[39m, e = 3 }
    Code
      ts_tree_select(toml, "a", "b", "c")
    Output
      [90m# toml (1 line, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39ma = { b = { c = [36m1[39m, d = 2 }, e = 3 }
    Code
      ts_tree_select(toml, "a", "b", "notthere")
    Output
      [90m# toml (1 line, 0 selected elements)[39m
      [90m1[39m[90m | [39ma = { b = { c = 1, d = 2 }, e = 3 }

---

    Code
      ts_tree_select(toml, "a")
    Output
      [90m# toml (1 line, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39ma = [36m{ b.c = 1, d = 2 }[39m
    Code
      ts_tree_select(toml, "a", "b")
    Output
      [90m# toml (1 line, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39ma = { b.c = [36m1[39m, d = 2 }
    Code
      ts_tree_select(toml, "a", "b", "c")
    Output
      [90m# toml (1 line, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39ma = { b.c = [36m1[39m, d = 2 }
    Code
      ts_tree_select(toml, "a", "b", "notthere")
    Output
      [90m# toml (1 line, 0 selected elements)[39m
      [90m1[39m[90m | [39ma = { b.c = 1, d = 2 }

---

    Code
      ts_tree_select(toml, "a")
    Output
      [90m# toml (1 line, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39ma = [36m[ 1, 2, 3 ][39m
    Code
      ts_tree_select(toml, "a", "notthere")
    Output
      [90m# toml (1 line, 0 selected elements)[39m
      [90m1[39m[90m | [39ma = [ 1, 2, 3 ]
    Code
      ts_tree_select(toml, "a", 1)
    Output
      [90m# toml (1 line, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39ma = [ [36m1[39m, 2, 3 ]
    Code
      ts_tree_select(toml, "a", 1, "notthere")
    Output
      [90m# toml (1 line, 0 selected elements)[39m
      [90m1[39m[90m | [39ma = [ 1, 2, 3 ]

# select1_numeric

    Code
      ts_tree_select(toml, 0)
    Condition
      [1m[33mError[39m in `ts_tree_select1.ts_tree.integer()`:[22m
      [33m![39m Zero indices are not allowed in ts selectors.

---

    Code
      ts_tree_select(toml, "products")
    Output
      [90m# toml (11 lines, 1 selected element)[39m
        [90m 1[39m[90m | [39m# A TOML document with all types of arrays of tables
        [90m 2[39m[90m | [39m
      [46m>[49m [90m 3[39m[90m | [39m  [36m[[products]][39m
      [46m>[49m [90m 4[39m[90m | [39m[36m  name = "Hammer"[39m
      [46m>[49m [90m 5[39m[90m | [39m[36m  sku = 738594937[39m
      [46m>[49m [90m 6[39m[90m | [39m[36m[39m
      [46m>[49m [90m 7[39m[90m | [39m  [36m[[products]][39m
      [46m>[49m [90m 8[39m[90m | [39m[36m  name = "Nail"[39m
      [46m>[49m [90m 9[39m[90m | [39m[36m  sku = 284758393[39m
      [46m>[49m [90m10[39m[90m | [39m[36m  color = "gray"[39m
        [90m11[39m[90m | [39m  
    Code
      ts_tree_select(toml, "products", TRUE, 1)
    Output
      [90m# toml (11 lines, 2 selected elements)[39m
        [90m 1[39m[90m | [39m# A TOML document with all types of arrays of tables
        [90m 2[39m[90m | [39m
        [90m 3[39m[90m | [39m  [[products]]
      [46m>[49m [90m 4[39m[90m | [39m  name = [36m"Hammer"[39m
        [90m 5[39m[90m | [39m  sku = 738594937
        [90m 6[39m[90m | [39m
        [90m 7[39m[90m | [39m  [[products]]
      [46m>[49m [90m 8[39m[90m | [39m  name = [36m"Nail"[39m
        [90m 9[39m[90m | [39m  sku = 284758393
        [90m10[39m[90m | [39m  color = "gray"
        [90m11[39m[90m | [39m  
    Code
      ts_tree_select(toml, "products", TRUE, -1)
    Output
      [90m# toml (11 lines, 2 selected elements)[39m
        [90m 2[39m[90m | [39m
        [90m 3[39m[90m | [39m  [[products]]
        [90m 4[39m[90m | [39m  name = "Hammer"
      [46m>[49m [90m 5[39m[90m | [39m  sku = [36m738594937[39m
        [90m 6[39m[90m | [39m
        [90m 7[39m[90m | [39m  [[products]]
        [90m 8[39m[90m | [39m  name = "Nail"
        [90m 9[39m[90m | [39m  sku = 284758393
      [46m>[49m [90m10[39m[90m | [39m  color = [36m"gray"[39m
        [90m11[39m[90m | [39m  
    Code
      ts_tree_select(toml, "products", TRUE, c(1, -1))
    Output
      [90m# toml (11 lines, 4 selected elements)[39m
        [90m 1[39m[90m | [39m# A TOML document with all types of arrays of tables
        [90m 2[39m[90m | [39m
        [90m 3[39m[90m | [39m  [[products]]
      [46m>[49m [90m 4[39m[90m | [39m  name = [36m"Hammer"[39m
      [46m>[49m [90m 5[39m[90m | [39m  sku = [36m738594937[39m
        [90m 6[39m[90m | [39m
        [90m 7[39m[90m | [39m  [[products]]
      [46m>[49m [90m 8[39m[90m | [39m  name = [36m"Nail"[39m
        [90m 9[39m[90m | [39m  sku = 284758393
      [46m>[49m [90m10[39m[90m | [39m  color = [36m"gray"[39m
        [90m11[39m[90m | [39m  

---

    Code
      ts_tree_select(toml, "products", 1)
    Output
      [90m# toml (11 lines, 1 selected element)[39m
        [90m1  [39m[90m | [39m# A TOML document with all types of arrays of tables
        [90m2  [39m[90m | [39m
      [46m>[49m [90m3  [39m[90m | [39m  [[[36mproducts[39m]]
      [46m>[49m [90m4  [39m[90m | [39m  [36mname = "Hammer"[39m
      [46m>[49m [90m5  [39m[90m | [39m  [36msku = 738594937[39m
        [90m6  [39m[90m | [39m
        [90m7  [39m[90m | [39m  [[products]]
        [90m8  [39m[90m | [39m  name = "Nail"
        [90m...[39m   
    Code
      ts_tree_select(toml, "products", -1)
    Output
      [90m# toml (11 lines, 1 selected element)[39m
        [90m...[39m   
        [90m 4 [39m[90m | [39m  name = "Hammer"
        [90m 5 [39m[90m | [39m  sku = 738594937
        [90m 6 [39m[90m | [39m
      [46m>[49m [90m 7 [39m[90m | [39m  [[[36mproducts[39m]]
      [46m>[49m [90m 8 [39m[90m | [39m  [36mname = "Nail"[39m
      [46m>[49m [90m 9 [39m[90m | [39m  [36msku = 284758393[39m
      [46m>[49m [90m10 [39m[90m | [39m  [36mcolor = "gray"[39m
        [90m11 [39m[90m | [39m  

---

    Code
      ts_tree_select(toml, "a")
    Output
      [90m# toml (3 lines, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39m[36m[a.[36mb[36m.c][39m
      [46m>[49m [90m2[39m[90m | [39m[36mx=[39m[36m[36m1[36m[39m
      [46m>[49m [90m3[39m[90m | [39m[36my=[39m[36m[36m2[36m[39m
    Code
      ts_tree_select(toml, "a", 1)
    Output
      [90m# toml (3 lines, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39m[36m[a.b.c][39m
      [46m>[49m [90m2[39m[90m | [39m[36mx=[39m[36m[36m1[36m[39m
      [46m>[49m [90m3[39m[90m | [39m[36my=[39m[36m[36m2[36m[39m
    Code
      ts_tree_select(toml, "a", 1, 1)
    Output
      [90m# toml (3 lines, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39m[36m[a.b.c][39m
      [46m>[49m [90m2[39m[90m | [39m[36mx=1[39m
      [46m>[49m [90m3[39m[90m | [39m[36my=2[39m
    Code
      ts_tree_select(toml, "a", 1, 2)
    Output
      [90m# toml (3 lines, 0 selected elements)[39m
      [90m1[39m[90m | [39m[a.b.c]
      [90m2[39m[90m | [39mx=1
      [90m3[39m[90m | [39my=2

---

    Code
      ts_tree_select(toml, "a")
    Output
      [90m# toml (2 lines, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39ma.[36mb[39m.c=[36m1[39m
        [90m2[39m[90m | [39md=2
    Code
      ts_tree_select(toml, "a", 1)
    Output
      [90m# toml (2 lines, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39ma.b.c=[36m1[39m
        [90m2[39m[90m | [39md=2
    Code
      ts_tree_select(toml, "a", 1, 1)
    Output
      [90m# toml (2 lines, 1 selected element)[39m
      [46m>[49m [90m1[39m[90m | [39ma.b.c=[36m1[39m
        [90m2[39m[90m | [39md=2
    Code
      ts_tree_select(toml, "a", 1, 2)
    Output
      [90m# toml (2 lines, 0 selected elements)[39m
      [90m1[39m[90m | [39ma.b.c=1
      [90m2[39m[90m | [39md=2

---

    Code
      ts_tree_select(toml, "products", 1)
    Output
      [90m# toml (11 lines, 1 selected element)[39m
        [90m1  [39m[90m | [39m# A TOML document with all types of arrays of tables
        [90m2  [39m[90m | [39m
      [46m>[49m [90m3  [39m[90m | [39m  [[[36mproducts[39m]]
      [46m>[49m [90m4  [39m[90m | [39m  [36mname = "Hammer"[39m
      [46m>[49m [90m5  [39m[90m | [39m  [36msku = 738594937[39m
        [90m6  [39m[90m | [39m
        [90m7  [39m[90m | [39m  [[products]]
        [90m8  [39m[90m | [39m  name = "Nail"
        [90m...[39m   
    Code
      ts_tree_select(toml, "products", -1)
    Output
      [90m# toml (11 lines, 1 selected element)[39m
        [90m...[39m   
        [90m 4 [39m[90m | [39m  name = "Hammer"
        [90m 5 [39m[90m | [39m  sku = 738594937
        [90m 6 [39m[90m | [39m
      [46m>[49m [90m 7 [39m[90m | [39m  [[[36mproducts[39m]]
      [46m>[49m [90m 8 [39m[90m | [39m  [36mname = "Nail"[39m
      [46m>[49m [90m 9 [39m[90m | [39m  [36msku = 284758393[39m
      [46m>[49m [90m10 [39m[90m | [39m  [36mcolor = "gray"[39m
        [90m11 [39m[90m | [39m  
    Code
      ts_tree_select(toml, "products", 1, "name")
    Output
      [90m# toml (11 lines, 1 selected element)[39m
        [90m1  [39m[90m | [39m# A TOML document with all types of arrays of tables
        [90m2  [39m[90m | [39m
        [90m3  [39m[90m | [39m  [[products]]
      [46m>[49m [90m4  [39m[90m | [39m  name = [36m"Hammer"[39m
        [90m5  [39m[90m | [39m  sku = 738594937
        [90m6  [39m[90m | [39m
        [90m7  [39m[90m | [39m  [[products]]
        [90m...[39m   

