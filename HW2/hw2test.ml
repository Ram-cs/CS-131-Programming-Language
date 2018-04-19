let accept_all derivation string = Some (derivation, string)
let accept_empty_suffix derivation = function
   | [] -> Some (derivation, [])
   | _ -> None

(* I have made the similar test with the homework *)

type awksub_nonterminals =
  | Animal | Cow | Types | Species | Car

let awkish_grammar =
  (Animal,
   function
     | Animal ->
         [[N Cow; N Species; N Animal];
          [N Cow]]
     | Cow ->
         [[N Car];
         [T"("; N Animal; T")"]]
     | Types ->
         [[T"god"; N Animal]]
     | Species ->
         [[T"nicer"];
         [T"than"];
         [T"is"]]
     | Car ->
         [[T"BMW"]; [T"TEXUS"]; [T"TOYOTA"]; [T"HUNDAI"]; [T"HONDA"]])


let test_1 =
  ((parse_prefix awkish_grammar accept_all ["workship"])
   = None)

let test_2 =
  ((parse_prefix awkish_grammar accept_all ["BMW"; "is"; ""; "nicer"; "than"; "HONDA"])
   = Some
 ([(Animal, [N Cow]); (Cow, [N Car]); (Car, [T "BMW"])],
  ["is"; "better"; "nicer"; "HONDA"]))

let test_3 =
  ((parse_prefix awkish_grammar accept_all ["Cow"; "is"; ""; "nicer"; "god"; "period"])
   = Some
 ([(Cow, [N Animal]); (Cow, [N Car]); (Car, [T "TOYOTA"])],
  ["Animal"; "is"; "nicer"; "period"]))

