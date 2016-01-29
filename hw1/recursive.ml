(* basic recursion *)
let rec range a b = if a >= b then [] else a::(range (a+1) b) ;;

(* tail recursion version, has a input res as future output*)
let rec range_tail a b res = if a+1>b then res else range_tail a (b-1) ((b-1)::res)

(* See if step is positive or nagative first*)
let rec range_step a b step = 
  if step > 0 then
    if a >= b then [] else a::(range_step (a+step) b step)
  else
    if a <= b then [] else a::(range_step (a+step) b step)

(* use the input number as a counter, minus 1 for each take*)
let rec take index lst = match (index,lst) with
| (_, []) -> []
| (0, _) -> []
| (n, h::t) -> h::(take (n-1) t)
