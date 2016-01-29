(* Type inference examples.  For each  *)

(* Intended type of pairwith: 'a -> 'a list -> '(a * b) list
   Actual type: val pairwith : 'a -> 'b list -> ('a * 'b) list = <fun>
   Explanation: Pass in value x with list lst, then pattern matching check if lst is empty if [] then return [] otherwise create a tuple of (passed in value, head of list) then perform recusion to go through the rest of the list.
 *)
let rec pairwith x lst = 
  match lst with
  | [] -> []
  | (h::t) -> (x,h) :: pairwith x t


(* Intended type of has_any: 'a -> 'a list -> bool
   Actual type: 'a ->'a list -> bool = <fun>
   Explanation: Pass in two values some type x and list lst. Has_any performs a pattern matching on lst. If [] then returns []. Otherwise it will call the head of list. If value 'a = the head of list it will return true. Else it will perform recursion to check the rest of list until it either finds value 'a or [].
 *)
let rec has_any x lst =
  match lst with
  | [] -> false
  | (h::t) -> x=h || has_any x t

(* Intended type of lookup: 'a -> ('a * 'a) list ->
   Actual type:'a -> ('a * string) list -> string = <fun>
   Explanation: Lookup passes two values key and lst, with lst being a tuple of ('a, string). Lookup performs pattern matching of lst to check the values in the list of lst. if [] then will return "no match". Otherwise calls the first tuple of list lst and checks the x value of the tuple. If the x value of the tuple matches key, then return the y string v. Else performs recrusion of lookup to check the rest of list lst.
 *)
let rec lookup key lst =
  match lst with
  | [] -> "No Match"
  | (k,v)::t -> if k=key then v else lookup key t
				

(* Intended type of first_of_first :  'a list list -> 'a -> 'a
   Actual type: 
   Explanation: Passing in lst which is a list of a list. Then calling recursion function fst with value l. The function will perform a pattern matching to return the first value inside of lst. If empty then [].
 *)				
let first_of_first lst =
  let rec fst l = match l with
    | [] -> []
    | h::t -> h in
  let f1 = fst lst in
  fst f1
