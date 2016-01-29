type 'a stream = Cons of 'a * (unit -> 'a stream)
type 'a lazylist = End | Lz of 'a * 'a lazylist lazy_t
				
let rec take_s n s = match (n,s) with
  | (0,_) -> []
  | (_,Cons(h,t)) -> h::(take_s (n-1) (t ()))

let rec lztake n ll = match(n,ll) with
  | (0,_) | (_,End) -> []
  | (_,Lz(h,t)) -> h::(lztake (n-1) (Lazy.force t))
	  
(* your definition of ustrings goes here: *)
let ustring_s s = let rec helper a =
    Cons (a,(helper (a^s)))
in helper ""

(* Add definitions for drop_while_s and take_until_s here: *)
let take_until_s s f = 
 let rec helper s f = 
  if (f s) then s else (helper s f)
  in helper s f

(* now add lz_ustring and lztake_until here: *)
let lz_ustring s= 
 let rec helper a =
  Lz (a, (helper (a^s)))
  in helper ""

(* How to convert the function from streams to lazylist *)
let lztake_until s f = 
 let rec helper s f =
  if (f s) then s else (helper s f)
 in helper s f
