(* lab 9 examples to convert to CPS *)
let rec map f lst = match lst with
  | [] -> []
  | h::t -> (f h)::(map f t)

let rec append l1 l2 = match l1 with
  | [] -> l2
  | h::t -> h::(append t l2)

let rec assoc_update k v lst = match lst with
  | [] -> [(k,v)]
  | (k',_)::t when k'=k -> (k,v)::t
  | kv::t -> kv::(assoc_update k v t)

type 'a btree = Node of 'a * 'a btree * 'a btree | Empty

let rec treeMin t =
  match t with
  | Empty -> None
  | Node(v,l,r) ->
     match (treeMin l, treeMin r) with
     | (None,None) -> Some v
     | (None, Some v') | (Some v', None) ->  Some (min v v')
     | (Some vl, Some vr) -> Some (min (min v vl) vr)

(* CPS versions go here: *)
let map_k f lst =
  let rec kmap lst k = match lst with
    | [] -> k []
    | h::t -> kmap t (fun result -> k ((f h)::result)) in
  kmap lst (fun x -> x)

let append_k l1 l2 = 
  let rec kappend l1 l2 k = match l1 with
   | [] -> k l2
   | h::t -> kappend t l2 (fun result -> k (h::result)) in
   kappend l1 l2 (fun x -> x)

let assoc_update_k x y lst =
  let rec kassoc x y lst k = match lst with
    | [] -> k[(x,y)]
    | (x',_)::t when x'=x -> k((x,y)::t)
    | xv::t -> kassoc x y t (fun result -> k (xv::result)) in 
   kassoc x y lst (fun x -> x)

let treeMin_k t =
 let rec min_k t k = match t with
  | Empty -> k None
  | Node(v,l,r) -> match (min_k l k, min_k r k) with
    | (None, None) -> Some v
    | (None, Some v') | (Sone v', None) -> Some (
    | (Some vl, Some vr) -> Some ()
