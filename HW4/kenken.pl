

/*source:-This test case from Piazza*/
kenken_large_testcase(
  10,
  [
  +(4, [[1|1]]),
  *(504, [[1|2], [1|3], [1|4]]),
  *(270, [[1|5], [2|5], [2|6]]),
  +(5, [[1|6]]),
  *(20, [[1|7], [1|8]]),
  +(3, [[1|9]]),
  *(20, [[1|10], [2|10], [2|9]]),
  +(3, [[2|1]]),
  *(42, [[2|2], [2|3]]),
  +(12, [[2|4], [3|4]]),
  +(4, [[2|7]]),
  *(7, [[2|8], [3|8]]),
  +(16, [[3|1], [4|1]]),
  *(30, [[3|2], [4|2], [4|3]]),
  +(2, [[3|3]]),
  /(9, [3|5], [4|5]),
  +(23, [[3|6], [3|7], [4|7]]),
  *(192, [[3|9], [4|9], [4|10]]),
  +(6, [[3|10]]),
  *(70, [[4|4], [5|4], [6|4]]),
  -(3, [4|6], [5|6]),
  +(5, [[4|8]]),
  -(6, [5|1], [5|2]),
  +(3, [[5|3]]),
  +(2, [[5|5]]),
  *(80, [[5|7], [5|8], [6|8]]),
  +(25, [[5|9], [5|10], [6|10]]),
  +(2, [[6|1]]),
  +(11, [[6|2], [6|3]]),
  +(4, [[6|5]]),
  +(22, [[6|6], [7|6], [7|5]]),
  *(162, [[6|7], [7|7], [7|8]]),
  *(35, [[6|9], [7|9], [8|9]]),
  +(19, [[7|1], [8|1], [9|1]]),
  +(21, [[7|2], [8|2], [9|2]]),
  *(9, [[7|3], [8|3]]),
  /(3, [7|4], [8|4]),
  *(30, [[7|10], [8|10], [9|10]]),
  +(8, [[8|5]]),
  +(2, [[8|6]]),
  +(7, [[8|7]]),
  +(4, [[8|8]]),
  *(480, [[9|3], [9|4], [10|4]]),
  +(7, [[9|5]]),
  +(1, [[9|6]]),
  *(18, [[9|7], [9|8]]),
  *(320, [[9|9], [10|9], [10|10]]),
  *(20, [[10|1], [10|2], [10|3]]),
  +(10, [[10|5], [10|6]]),
  -(7, [10|7], [10|8])
  ]
).

kenken_testcase(
  6,
  [
   +(11, [[1|1], [2|1]]),
   /(2, [1|2], [1|3]),
   *(20, [[1|4], [2|4]]),
   *(6, [[1|5], [1|6], [2|6], [3|6]]),
   -(3, [2|2], [2|3]),
   /(3, [2|5], [3|5]),
   *(240, [[3|1], [3|2], [4|1], [4|2]]),
   *(6, [[3|3], [3|4]]),
   *(6, [[4|3], [5|3]]),
   +(7, [[4|4], [5|4], [5|5]]),
   *(30, [[4|5], [4|6]]),
   *(6, [[5|1], [5|2]]),
   +(9, [[5|6], [6|6]]),
   +(8, [[6|1], [6|2], [6|3]]),
   /(2, [6|4], [6|5])
  ]
).

plain_kenken_testcase(
4,
[
+(7, [[1|1],[1|2]]),
-(3, [1|3],[2|3]),
*(6, [[2|1],[2|2],[3|2]]),
/(2, [3|1], [4|1]),
*(12,[[3|3],[3|4]]),
*(24,[[4|2],[4|3],[4|4]])
]
).

/*     plain_kenken_testcase(N,C), plain_kenken(N, C, T).        */

kenken_mytest(
4,
[
+(7, [[1|1],[1|2]]),
-(3, [1|3],[2|3]),
*(6, [[2|1],[2|2],[3|2]]),
/(2, [3|1], [4|1]),
*(12,[[3|3],[3|4]]),
*(24,[[4|2],[4|3],[4|4]])

]
).

/*%*********S, subtract, product, divide formula**********/
sum(Item1, Item2, Total):- Total #= Item1 + Item2.
subt_ract(Item1, Item2, Total):- Total #= Item1 - Item2.
subt_ract(Item1, Item2, Total):- Total #= Item2 - Item1.
product(Item1, Item2, Total):- Total #= Item1 * Item2.
divide(Item1, Item2, Total):- Total #= Item1 / Item2.
divide(Item1, Item2, Total):- Total #= Item2 / Item1.

minus_one(Input1, Result):- Result #= Input1 - 1.
not_equal_minus(I, Result):- Result  #= I * I.


find_entry(X,I1, J1,Res):-
    find_nth(X, I1,_, X1, _, _),
    find_nth(X1, J1,_, Res, _, _).


calculation_helper(X, I1, J1, I2, J2, X1, X2):-
    fidn_ith_jth(X, I1, J1, X1),
    fidn_ith_jth(X, I2, J2, X2).

row_column_helper(_, [], _).
row_column_helper(I, J, I1, J1, _, []):-
    minus_one(I, I1),
    minus_one(J, J1).

/*get the row and column*/
fidn_ith_jth(X, I, J, Res) :-
    row_column_helper(I, J, I1, J1, _, []),
    find_entry(X, I1, J1 ,Res).


/*Get the element at nth*/
find_nth([], _, _, [], [], []).
find_nth([Head | _], 0,0, Head, _, _).
find_nth([_ | Tail], I, Res, X, P, Q) :-
    minus_one(I, N), find_nth(Tail, N,Res, X, P, Q), not_equal_minus(P, Q).

/*%***********Finding S, subtract, product and_ divide***********/

add(_, [], 0).
add(X, Var, Res) :-
    [[I|J]|T] = Var,
    fidn_ith_jth(X, I, J, E),
    add(X, T, Z),
    sum(Z, E, Res).

subtraction(X, Var1, Var2, Res) :-
    [I1|J1] = Var1, [I2|J2] = Var2,
    calculation_helper(X, I1, J1, I2, J2, X1, X2),
    subt_ract(X1, X2, Res).

multiply(_, [], 1).
multiply(X, Var, Res) :-
    [[I|J]|T] = Var,
    fidn_ith_jth(X, I, J, E),
    multiply(X, T, Z),
    product(Z, E, Res).

division(X, Var1, Var2, Res) :-
    [I1|J1] = Var1, [I2|J2] = Var2,
    calculation_helper(X, I1, J1, I2, J2, X1, X2),
    divide(X1, X2, Res).

/*%*************Given constraints*************/
constraint(X, +(Res, Var)) :-
    add(X, Var, Res).

constraint(X, -(Res, Col, Row)) :-
    subtraction(X, Col, Row, Res).
    

constraint(X, *(Res, Var)) :-
    multiply(X, Var, Res).

constraint(X, /(Res, Col, Row)) :-
    division(X, Col, Row, Res).
   

constraints(_, []).
constraints(X, Var) :-
    [Head | Tail] = Var,
    constraint(X, Head),
    constraints(X, Tail).

/************ Kenken   *********/
equal_equal_minus(_, []).
do_append(E, X, Res):- append([E], Res, X).

column_support([], _, []).
column_support(Head, Tail, I, X):-
    find_nth(Head, I,_,E, _, _),
    column(Tail, I, Res),
    do_append(E, X, Res).

column([], _, []).
column(Var, I, X) :-
    [Head|Tail] = Var,
    column_support(Head, Tail, I, X),
    equal_equal_minus(_, []).

fd_diff(Col) :- fd_all_different(Col).

unique_col(N, X, Result, N1, T):-
    (minus_one(N, Result); column(X, Result, Res); N1 #= Result; T #= Res).

check_column(_, 0) :- !.
check_column(X, N) :-
    minus_one(N, N1),
    column(X, N1, T),
    fd_diff(T),
    check_column(X, N1).

check_row([]).
check_row(Var) :-
    [Head | Tail] = Var, 
    fd_diff(Head),
    check_row(Tail).

lengths_match(Var, N) :-
    [Head | Tail] = Var,
    length(Head, N), lengths_match(Tail, N).
lengths_match([Head], N) :-
    length(Head, N).


kenken_supportive(T, N):-
    length(T, N),
    lengths_match(T, N).

fd_domain_finally(N, L) :-
    fd_domain(L, 1, N).

kenken_supportive_st(T, N):-
    kenken_supportive(T, N),maplist(fd_domain_finally(N), T).

kenken_supportive_st_one(T, N):-
    check_column(T, N),
    check_row(T).

kenken_supportive_one(T, C, N):-
    kenken_supportive_st(T, N),
    constraints(T, C),
    kenken_supportive_st_one(T, N).

kenken(N, C, T) :-
    kenken_supportive_one(T, C, N),
    maplist(fd_labeling, T).


/*************** plain_kenken******************/
perm(Head, P):-
    permutation(P, Head).
    
length_n(R, N, N1, R1):-
    length(R, N),
    minus_one(N, N1), append(R1, [N], R).

good_matrix_list(0, _) :- !.
good_matrix_list(N, R) :-
    length_n(R, N, N1, R1),    
    good_matrix_list(N1, R1).

matrix_plain_domain([], _) :- !.
matrix_plain_domain(Var, N) :-
    [Head | Tail] = Var,
    good_matrix_list(N, P),
    perm(Head, P),
    matrix_plain_domain(Tail, N).


unique_column_plain_kenken(X, N, N1, R):-
    minus_one(N, N1),  column(X, N1, T), perm(T, R).

plain_unique_column(_, 0, _) :- !.
plain_unique_column(X, N, R) :-
    unique_column_plain_kenken(X, N, N1, R),
    plain_unique_column(X, N1, R).

helper_query(N, T, C):-
    matrix_plain_domain(T, N),
    constraints(T, C).

plain_ken_result(N, C, T):-
    kenken_supportive(T, N),
    good_matrix_list(N, R), helper_query(N, T, C),
    plain_unique_column(T, N, R).

plain_kenken(N, C, T) :-
    plain_ken_result(N, C, T).




