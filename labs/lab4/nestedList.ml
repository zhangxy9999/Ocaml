type 'a nestedItem = Ele of 'a | Nested of 'a nestedItem list
type 'a nestedList = 'a nestedItem list

(* flatten : 'a nestedList -> 'a list *)
let rec flatten = function 
	| [] -> []
	| (Ele h)::t -> h::flatten t
	| (Nested i)::t -> (flatten i) @ (flatten t)

(* nest_depth : 'a nestedList -> int *)
let rec nest_depth = function
	| [] -> 1
	| (Ele h)::t -> nest_depth t
	| (Nested i)::t -> 1 + (nest_depth t)

let nl1 = [ Nested [Ele "where" ;Nested [Ele "is"; Nested [Ele "my"; Ele "talisman"] ] ]; Ele "am"; Nested [Ele "I"; Ele "in"; Nested [Ele "limbo?"] ]]
let nl2 = [ Nested [ Nested [ Nested [ Ele 4 ]; Ele 3 ]; Ele 2 ]; Ele 1; Nested [ Ele 2; Nested [ Ele 3] ] ]
let nl3 = [ Ele 1; Nested [ Ele 2; Nested [ Ele 3; Ele 3]; Ele 2]; Ele 1]
