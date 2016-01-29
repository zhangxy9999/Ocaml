(* data type to represent an infinite data object in a "lazy" fashion *)
type 'a stream = Cons of 'a * (unit -> 'a stream)

(* Some utility functions for streams *)				
let hd (Cons(h,t)) = h
let tl (Cons(h,t)) = t ()

let rec take_s n s = match (n,s) with
| (0,_) -> []
| (_,Cons(h,t)) -> h::(take_s (n-1) (t ()))

let rec map_s f (Cons(h,t)) = Cons(f h, fun () -> map_s f (t ()))			
			
let rec merge s1 s2 = Cons(hd s1, fun () -> Cons(hd s2, fun () -> merge (tl s1) (tl s2)))

let rec filter_s p (Cons(h,t)) =
  if (p h) then Cons(h, fun () -> filter_s p (t ()))
  else filter_s p (t ())
			  
let double s = merge s s 

(* Some streams we have seen in lecture *)		     
let rec nats n = Cons(n, fun () -> nats (n+1))
let fibs = let rec fib_help f0 f1 = Cons(f0, fun () -> fib_help f1 (f0+f1)) in fib_help 0 1
let factorials = let rec fact_help n a = Cons(n*a, fun () -> fact_help (n+1) (n*a)) in fact_help 1 1

(* one more helpful function *)
let rec gcd a b =
  if a=0 then b
  else if b < a then gcd b a
  else gcd (b mod a) a
	   
(* Your solutions for problem 3 go here: *)
let rec natpairs (x,y) = Cons((x,y), fun () -> 
    if x+y=x then natpairs (0,x+y+1) else natpairs (x+1,y-1))

let rec py_triple (x,y) = (x,y,(int_of_float (sqrt (float_of_int (x*x + y*y)))))

let py_check (x,y,z) = if ((x > 0) && (x < y) && (gcd x y = 1) && (x*x + y*y = z*z)) then true else false

let pytrips = filter_s (fun x -> py_check x) (map_s (fun x -> py_triple x)
(natpairs (0,0)))

let explode s = let rec helper i =
    if i >= String.length s then [] else (s.[i])::(helper (i+1))
in helper 0

let pal_check str = (explode (String.lowercase str)) = (List.rev (explode
(String.lowercase str)))

let kleene_star lst = let rec helper a b =
    match (a,b) with
    | ([], (h::t)) -> helper lst t
    | ((h1::t1), (h2::t2)) -> Cons((h1^h2), fun () -> helper t1 (b@[(h1^h2)]))
in Cons("", fun () -> (helper lst [""]))

let palindromes lst = filter_s (fun x -> pal_check x) (kleene_star lst)



