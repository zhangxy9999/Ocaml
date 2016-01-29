-----------List Induction----------------

list_add l1 l2 = match (l1, l2) with
| ([], ls) | (ls, []) -> ls
| (a1::t1, a2::t2) -> (a1+a2)::(list_add t1 t2)

Prove:
length (list_add l1 l2) = max (length l1) (length l2)

Base Case: P([])
length (list_add [] l2) = max (length []) (length l2)
length (l2) = max (length []) (length l2) [by eval of list_add)
length (l2) = length (l2) [by eval of max]

Inductive Hypothesis: length (list_add l1 l2) = max (length l1) (length l2)

Inductive Case: P(x::l)
2 Cases: length l1 <= length l2, length l1 > length l2 

length l1 <= length l2:
length(list_add x::l l2) = max (length x::l) (length l2)
length((x+x2)::(list_add t t2)) = max(length x::l) (length l2) [by eval of list_add]
(how to rewrite to invoke the IH)

length l1 > length l2:
length(list_add x::l l2) = max (length x::l) (length l2)
length((x+x2)::(list_add t t2)) = max(length x::l) (length l2) [by eval of list_add]


------------------Polynomials-----------------

type polyExpr = Add of polyExpr * polyExpr
| Mul of polyExpr*polyExpr
| X
| Int of int

(* degree of a symbolic polynomial *)
let rec deg expr = match expr with
| Int _ -> 0
| X -> 1
| Add (e1,e2) -> max (deg e1) (deg e2)
| Mul (e1,e2) -> (deg e1) + (deg e2) 

(* Simplify the constants in a symbolic polynomial *)
let rec simplify expr = match expr with
| Int i -> Int i
| X -> X
| Add (e1,e2) ->
  ( match (simplify e1, simplify e2) with
    | (Int i1, Int i2) -> Int (i1+i2)
    | (s1, s2) -> Add (s1,s2) )
| Mul (e1, e2) ->
 ( match (simplify e1, simplify e2) with
    | (Int i1, Int i2) -> Int (i1*i2)
    | (s1, s2) -> Mul (s1, s2) ) 

Prove:
deg p1 = deg (simplify p1)

Base Case: P(0)

deg 0 = deg (simplify 0)
1 = deg (simplify 0) [by eval of deg]
1 = deg (0) [by eval of simplify]
1 = 1 [by eval of deg]

Inductive Hypothesis: deg p1 = deg (simplify p1)

4 Inductive Cases: Int, X, Add, Mul

x:
deg (X) = deg (simplify X)
1 = deg (simplify X) [by eval of deg]
1 = deg (X) [by eval of simplify]
1 = 1 [by eval of deg]

Int:
deg(Int p1) = deg (simplify (Int p1)
0 = deg (simplify (Int p1)) [by eval of deg]
0 = deg (Int p1) [by eval of simplify]
0 = 0 [by eval of deg]

Add:
deg(Add e1,e2) = deg (simplify (Add e1,e2))
max (deg e1) (deg e2) = deg (simplify (Add e1,e2)) [by eval of deg] 
max (deg e1) (deg e2) = deg (Int (e1+e2)) [by eval of simplify]

Mul:
deg(Mul e1,e2) = deg (simplify (Mul e1,e2))
(deg e1) + (deg e2) = deg (simplify (Mul e1,e2)) [by eval of deg]
(deg e1) + (deg e2) = deg (Int (e1*e2)) [by eval of simplify]

----------Binomial Coefficients---------------

(* Precondition: 0 <= k <= n *)
let ichoose n:int k:int = {
  let r = 1 ;
  let d = 1 ;
  let nn = n;
  while ( d <= k ) {
    r := r * nn ;
    r := r / d ;
    nn := nn - 1;
    d := d + 1
  } ;
  r
}

1. What is the state maintained by this program?

2. To help reasoning about the program, convert the while loop to a tail-recursive function choose_loop that takes a state as input and returns a state as output. Include this tail recursive function in your solution file as a code block offset by triple backticks (```). You may find it interesting to compare this implementation of ichoose with the recursive implementation from lab 7. (But not that helpful for the task at hand)

3. Informally prove that for all n, after each loop iteration, the state of the program satisfies
r = n choose d.

