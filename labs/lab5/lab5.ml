let rec map f lst = match lst with
| [] -> []
| h::t -> (f h)::(map f t)

      (* fold_left in Ocaml *)
let rec fold f acc lst = match lst with
| [] -> acc
| h::t -> fold f (f acc h) t

(* fold_right in Ocaml *)
let rec reduce f lst init = match lst with
| [] -> init
| h::t -> f h (reduce f t init)


(* append: 'a list -> 'a list -> 'a list *)
(* make using a single call to reduce *)
let append l1 l2 = reduce (fun x y -> x::y) l1 l2

(* filter: ('a -> bool) -> 'a list -> 'a list *)
(* make using a single call to reduce *)
(* File did not save from lab, had to restart, Need to fix Filter*)
let filter pred lst = reduce (fun x init-> if pred x then x::init else init )lst []

(* list_cat: string list -> string *)
(* make list_cat using a single call to fold *)
let list_cat = fold (^) ""

(* list_fst: ('a * 'b) list -> 'a list *)
(* make using a single call to map*)
let list_fst = map (fun x -> match x with  (a,b) -> a)

(* mem: 'a -> 'a list -> bool *)
(* give a definition of mem in terms of map followed by reduce*)
let mem x lst = reduce (||) (map (fun y -> y=x) lst) false

(*count_intersection: 'a list -> 'a list -> int*)
(* make using fold*)
let count_intersection lst1 lst2 = fold (fun acc y ->if (mem y lst1) then acc+1 else acc) 0 lst2

(* check_set: 'a list -> bool *)
let rec check_set lst = match lst with
| [] -> true
| (a,b)::t -> if (mem h t) then (false && (check_set t)) else (true &&
(check_set t))

(* assoc_max: ('a * 'b) list -> 'a option *)
let rec assoc_max lst = match lst with
| [] -> None
| (a,b)::t -> if (fold (fun x y -> match y with (i,j) -> if j >= x then i
else b) b t)
then a
else (assoc_max t)

(* make in terms of fold *)

(* TA COMMENT (leid0065): Unfinished but sufficient attempt. 1/1 *)
