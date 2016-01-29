(* Recursion, tail recursion, nested functions.  Your definitions of unzip, list_product, and list_deriv go here. *)

(*function type: ('a * 'b) list -> 'a list * 'b list 
  Reason: matching the pair element to the head of the pair list*)
let rec unzip lst = match lst with 
| [] -> [],[]
| (h,t)::tail -> let xs,ys = unzip tail in h::xs,t::ys 

(*Need a result as input then using tail recursive*)
let rec list_cat lst = match lst with
| [] -> ""
| h::t -> h ^ list_cat t

let rec list_cat_tail lst res = match lst with
| [] -> res
| h::t -> list_cat_tail t (res ^ h)

(*Very interesting question. Three cases: base case, only two elements left, and three or more elements on the list. I defined a helper function computing the deriv from two elements and cons it into the recursive call*)
let rec list_deriv lst = match lst with
| [] -> []
| h::t::[] -> [t-h]
| h::t -> let deriv = match t with hx::tx -> (hx - h) in deriv::(list_deriv t)
