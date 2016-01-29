type 'a lazylist = LzCons of 'a * 'a lazylist lazy_t | EmptyLL
let (@@) h t = LzCons(h,t)

let rec lztake n ll = match (n,ll) with
  | (0,_) | (_,EmptyLL) -> []
  | (_,LzCons(h,t)) -> h::(lztake (n-1) (Lazy.force t))

let rec eq_ll l1 l2 = match (l1,l2) with
  | (EmptyLL,EmptyLL) -> true
  | (_,EmptyLL) | (EmptyLL,_) -> false
  | (LzCons(h1,t1), LzCons(h2,t2)) -> (h1=h2) && (eq_ll (Lazy.force t1) (Lazy.force t2))
     
(* put your lazylist functions right here: *)
let rec lzmap f ll = match ll with
  | EmptyLL -> EmptyLL
  | LzCons(h,t) -> LzCons((f h), lazy(lzmap f (Lazy.force t)))

let rec lzfilter f ll = match ll with
  | EmptyLL -> EmptyLL
  | LzCons(h,t) -> if (f h) then LzCons(h, lazy(lzfilter f (Lazy.force t)))
                  else lzfilter f (Lazy.force t)

let rec lznatpairs (x,y) = LzCons((x,y), (if x+y=x 
  then lazy(lznatpairs (0, x+y+1))
  else lazy(lznatpairs (x+1, y-1))))

(* a w-ary tree type for question 4 part 2 *)		     
type 'a wtree = Node of 'a wtree list | Leaf of 'a 

(* non-lazy breadth-first search *)						  
let bfs t =
  let rec bfs_h tlst =
    match tlst with
    | [] -> []
    | (Leaf v)::t -> v::(bfs_h t)
    | Node(l)::t -> bfs_h (t@l)
  in bfs_h [t]

(* a demonstration. uncomment these lines and try this in utop: (bfs t1) = (bfs
 * t2)
let deeptree n x =
  let rec dtree i k =
    if i = 0 then k (Leaf x)
    else dtree (i-1) (fun r -> k (Node [r]))
  in dtree n (fun x -> x)

let yikes = deeptree (1 lsl 26) 7 	   
let t1 = Node [Leaf 4; yikes; Leaf 6]
let t2 = Node [Leaf 4; yikes; Leaf 5]*)

(* Now add lazy_bfs here, and try (eq_ll (lazy_bfs t1) (lazy_bfs t2)) in utop *)
let lazy_bfs t =
    let rec lazy_bfs_h tlst = 
        match tlst with
        | [] -> EmptyLL
        | (Leaf v)::t -> LzCons(v, lazy(lazy_bfs_h t))
        | Node(l)::t -> lazy_bfs_h (t@l)
    in lazy_bfs_h [t]
