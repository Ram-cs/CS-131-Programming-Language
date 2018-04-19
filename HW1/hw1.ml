
(*PROBLEM==> 1  *)
let rec subset a b = 
	match a with
	[] -> true
	|h::t -> if List.mem h b = false then false
			else
				subset t b;;

(*PROBLEM ==> 2  *)
let rec equal_sets a b = (subset a b) && (subset b a);;

(*PROBLEM ==> 3  *)
let rec set_union a b = 
	match a with
	[] -> b
	| h::t -> if List.mem h b == true then set_union t b
			  else 
			  	h::(set_union t b)

(*PROBLEM ==> 4  *)
let rec set_intersection a b = 
	match a with
	[] -> []
	| h::t -> if List.mem h b == true then h::(set_intersection t b)
			  else
			  	 set_intersection t b;;

(*PROBLEM ==> 5  *)
let rec set_diff a b =
	match a with
	[] -> []
	| h::t -> if List.mem h b == false then h::(set_diff t b)
			  else
			  		set_diff t b;;
	(*a−b, that is, the set of all members of a that are not also members of b. but not other way*)

(*PROBLEM ==> 6  *)
let rec computed_fixed_point eq f x = 
	if eq x (f x) then x 
	else
		computed_fixed_point eq f (f x);;

(*PROBLEM ==> 7  *)
let rec computed_periodic_point eq f p x = match p with
	 0 -> x
	| _ -> if (eq (f(computed_periodic_point eq f (p-1) (f x))) x) then x
		   else 
		   		computed_periodic_point eq f p (f x);;

(*PROBLEM ==> 8  *)
let rec while_away s p x =
	if not(p x) then []
	else
		x::(while_away s p (s x));;

(*PROBLEM ==> 9  *)
let rec rle_decode lp = 
	match lp with
	[] -> []
	|(x,y)::t -> if x = 0 then rle_decode(t)
		else 
		y::rle_decode ((x-1, y)::t);;

(*PROBLEM ==> 10 *)

type ('nonterminal, 'terminal) symbol = 
	 N of 'nonterminal
	| T of 'terminal;;

let symboll r = 
        match r with
        (x,y) -> x;;

let is_subset input = function
	 N s -> subset [s] input;
	| T s -> true;;

let rec terminal_nonterminal input = function
	 [] -> true
	| h::t -> match h with
			h->if (not (is_subset input h)) then false 
		      else 
		          terminal_nonterminal input t;;

let rec find_safe_li input = function
	 [] -> input
	| (a, b)::t -> match t with 
				t ->if (not (terminal_nonterminal input b))
					then find_safe_li input t
					else 
						(if (not(subset [a] input)) then find_safe_li (a::input) t 
					    else 
							find_safe_li input t);;

let extra_func_fixed (input, rule) = ((find_safe_li input rule), rule);;

let count_rules (input, rule) =  
	fst(computed_fixed_point (fun (a, _) (b, _) -> equal_sets a b) extra_func_fixed ([], rule));;

let rec found_and_increament_list input = function
	[] -> []
	| (a, b)::t -> match t with
				t -> if (not(terminal_nonterminal input b)) then  found_and_increament_list input t 
					else (a, b)::(found_and_increament_list input t);;

let filter_blind_alleys g = 
	match g with
	| (x, y) -> (x, found_and_increament_list (count_rules ([], y)) y);;


















