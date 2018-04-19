
type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal;;



let rec convert_gramer_support a b = 
    match a with
    [] -> b
    | h::t -> if List.mem h b == true then convert_gramer_support t b
              else 
                h::(convert_gramer_support t b);;

let rec non_term_t eq f x = 
  if eq x (f x) then x 
  else
    non_term_t eq f (f x);;

let convert_grammar gram1 =
    let rec list_list nt r = match r with
    [] -> []
    | (n_t, rh)::t -> if nt = n_t then rh::(list_list nt t) else list_list nt t in
    (fst gram1), fun nt -> let snd_val = snd gram1 in (list_list nt (snd_val));;


(* Idea behind parsing, please refer to the text file*)
let parse_prefix gram =
let value = (snd gram)  
and value_fst = fst gram in


  let rec append_list rh = function
      | [] -> rh
      | h::t -> h::(append_list rh t)
    in 

    let rec parse_func lhs = function
      |[] -> lhs
      | h::t -> if t = [] then append_list lhs t else h::(parse_func lhs t)
    in


  let rec fun_1 value x = function
        | [] -> (fun i j k -> None)
        | h::t -> (fun i j k -> let p = t and match_list = fun_2 value h in
            let match_or = match_list i (j @ [(x, h)]) k and match_v = fun_1 value x p in 
            match match_or with
                | None -> match_v i j k 
                | z -> match_or)

  and term_nonterm lhs = function
      |[] -> lhs
      | h::t -> if t <> [] then (parse_func lhs t)
                         else
                            h::(term_nonterm lhs t)
    
  and fun_2 value = function
        | (T t_sym)::t -> (fun i j -> function
                | [] -> None
                | kment_h::kment_t ->
                    let matcher = fun_2 value t in 
                        if kment_h <> t_sym then None 
                         else
                            matcher i  j kment_t)
        | [] -> (fun i j k -> i j k) | (N x)::t -> (fun i j k ->
                let i_tmp = fun_2 value t i and parser = term_nonterm t and match_v = fun_1 value x (value x) in 
            match_v i_tmp j k)  in fun i k -> fun_1 value (value_fst) (value (value_fst)) i [] k
;;

