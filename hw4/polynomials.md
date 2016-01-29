####list_deg (list_add a1 a2) = deg (Add (to_poly a1, to_poly a2))
base case: P([]) = for all l2, list_deg (list_add [] l2) = 
    deg (Add (to_poly [], to_poly l2))
list_deg (list_add [] l2)
= list_deg l2           by eval
= deg (to_poly l2)      by definition of deg
= deg (Add (to_poly [], tp_poly l2))    by definition of to_poly

inductive case: P(l1) -> P(n::l1)
IH: list_deg (list_add a1 a2) = deg (Add (to_poly a1, to_poly a2))
list_deg (list_add h::l1 l2)
= list_deg (h+h2)::(list_add l1 t2)         by definition of list_add
= List.length (l1 t2) - 1 + 1               by definition of list_deg
= max (List.length l1, List.length l2 - 1)  by definition of max
= max (list_deg h::l1, list_deg l2)         by definition of list_deg
= deg (Add (to_poly h::l1, to_poly l2))     by IH


#### deg (compose p1 p2) = (deg p1) * (deg p2)
base case: P(0) = for all l2, deg (compose (Int 0) l2) = 
    (deg (Int 0)) * (deg l2)
deg (compose (Int 0) l2)
= deg (Int 0)   by eval
= 0             by eval

inductive case: P(n) => P(n+1)
IH: deg (compose p1 p2) = (deg p1) * (deg p2)



#### deg (simplify p) <= deg p
base case: P(0) = deg (simplify (Int 0)) <= deg (Int 0)
deg (simplify (Int 0))
= deg (Int 0)   by eval
= deg (Int 0)   by equation
property hold for base case

inductive case:
