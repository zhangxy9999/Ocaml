(* Your inferred type:'a -> ('a -> 'b) -> 'b
   Explanation of type: Passing some type 'a and some function to be applied to 'a ('a -> 'b) which returns the new value 'b
   Annotate the definition below:
*)
let (|>) : 'a -> ('a -> 'b ) -> 'b)  = fun x f -> (f x)


(* Your inferred type: ('a -> bool) -> 'a list -> 'a list * 'a list
   Explanation of type: Passing in a predicate and a list. Returns a list of list 
   Annotate the definition below: lt rec partition *)
let rec partition (p : ('a -> bool)) (lst : 'a list) : ('a list * 'a list) =
  match lst with
  | [] -> ([],[])
  | h::t -> let (l1,l2) = (partition p t) in
	    if (p h) then (h::l1, l2) else (l1,h::l2)

					     
(* Your inferred type: ('a -> bool) -> 'a list -> bool 
   Explanation of type: Passing in a function to test if value is equal toand a list to check values. If value is equal return true else false.
   Annotate the definition below: *)
let rec (exists: ('a -> bool) -> 'a list -> bool)  = fun p ->
  function
  | [] -> false
  | (h::t) -> (p h) || (exists p t)
