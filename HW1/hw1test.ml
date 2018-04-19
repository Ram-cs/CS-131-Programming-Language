(*1*)
let my_subset_test0 = subset [2;2;1] [2;2;1]
let my_subset_test1 = not (subset [2;2;1] [2;2;1])
let my_subset_test2 = subset [1;1;1] [2;2;1]

(*2*)
let my_equal_sets_test0 = equal_sets [1;1;1] [1;1;1]
let my_equal_sets_test1 = equal_sets [2;1;2] [1;1;1]
let my_equal_sets_test2 = not (equal_sets [1;1;1] [1;1;1])

(*3*)
let my_set_union_test0 = equal_sets (set_union [] [2;3;5]) [2;3;5]
let my_set_union_test1 = set_union [1;2;3] [1;2;5]
let my_set_union_test2 = set_union [2;3;5] []

(*4*)
let my_set_intersection_test0 =
  equal_sets (set_intersection [1;2;3] [1;2;3]) [1;2;3]
let set_intersection_test1 =
  equal_sets (set_intersection [] []) []
let set_intersection_test2 =
  equal_sets (set_intersection [] [1;2;3]) []

(*5*)
let my_set_diff_test0 = equal_sets (set_diff [1;3;4] [1;4;3;1]) []
let my_set_diff_test1 = equal_sets (set_diff [1;3;2;6] [1;4;3;1]) [2;6]
let my_set_diff_test2 = equal_sets (set_diff [] [1;4;3;1]) []

(*6*)
let my_computed_fixed_point_test0 =
  computed_fixed_point (=) (fun x -> x / 6) 1000000000 = 100
let my_computed_fixed_point_test1 =
  computed_fixed_point (=) sqrt 16. = 5.

(*7*)
let my_computed_periodic_point_test0 =
  computed_periodic_point (=) (fun x -> x / 6) 0 (-21) = -12
let my_computed_periodic_point_test1 =
  computed_periodic_point (=) (fun x -> x *. x -. 10.) 43 0.5 = -22.

(*8*)
let my_while_away_test0 = while_away ((+) 4) ((>) 10) 2 = [4; 8]
let my_while_away_test1 = while_away ((+) 5) ((>) 20) 2 = [5; 10; 15; 20]

(*9*)
let my_rle_decode_test0 = rle_decode [3,3; 2,4] = [3; 3; 3; 4; 4]
let my_rle_decode_test1 = rle_decode [2,"c"; 1,"b"; 1,"d"] = ["c"; "c"; "b"; "d"]

(*10*)
type awksub_nonterminals =
  | Zeep | Helicopter | Motorcycle | Boeing | Car

let awksub_rules =
   [Zeep, [T"("; N Zeep; T")"];
    Zeep, [N Car];
    Zeep, [N Zeep; N Boeing; N Zeep];
    Zeep, [N Motorcycle; N Helicopter];
    Zeep, [N Helicopter; N Motorcycle];
    Helicopter, [T"$"; N Zeep];
    Motorcycle, [T"++"];
    Motorcycle, [T"--"; N Helicopter];
    Boeing, [T"+"];
    Boeing, [T"-"];
    Car, [T"BMW"];
    Car, [T"Lexus"];
    Car, [T"Mercedes"];
    Car, [T"Ford"];
    Car, [T"Toyota"];
    Car, [T"Honda"]]

let awksub_grammar = Zeep, awksub_rules
let my_awksub_test0 =
  filter_blind_alleys awksub_grammar = awksub_grammar

 let my_awksub_test1 =
  filter_blind_alleys (Zeep, List.tl awksub_rules) = (Zeep, List.tl awksub_rules)

 let my_awksub_test2 =
  filter_blind_alleys (Zeep, List.tl (List.tl (List.tl awksub_rules))) =
    filter_blind_alleys (Zeep, List.tl (List.tl awksub_rules))

type giant_nonterminals =
  | Laptops | Printer | Dell | Apple | Hp 

let giant_grammar =
  Laptops,
  [Apple, [T"strongOne"];
   Hp, [];
   Dell, [T"affordable"];
   Printer, [T"differentBrand"];
   Laptops, [N Dell];
   Laptops, [N Apple];
   Dell, [N Laptops];
   Hp, [N Laptops];
   Hp, [N Laptops; T","; N Apple]]


let giant_test0 =
  filter_blind_alleys giant_grammar = giant_grammar

let giant_test1 =
filter_blind_alleys (Printer, List.tl (snd giant_grammar)) =
(Printer,
 [(Hp, []); (Dell, [T "stillOkay"]); (Printer, [T "strongOne!"]);
  (Laptops, [N Dell]); (Dell, [N Laptops]); (Hp, [N Laptops])]);;




