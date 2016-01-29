# Homework 4: Reasoning about program correctness

*CSci 2041: Advanced Programming Principles, Fall 2015*

**Due:** Friday, November 6 at 11:59pm

Your solutions to this homework should be submitted in markdown files
under the directory `hw4` in your personal class repository.  Since
you're submitting them on GitHub, your files can be in
"Github-Flavored Markdown", so if you want to use mathematical
symbols, you can use their
[HTML character entities](http://dev.w3.org/html5/html-author/charref).

## 1. Induction on integers and `nat`

*Answers to this problem should appear in a file named `naturals.md`*

In each of the following, you will use natural or structural induction
to prove that a property applies to some infinite set of elements.
For each proof, you should clearly state the property you are proving,
the base case(s) you are proving, the inductive case(s) you are
proving, and what the inductive hypothesis gives you.  Each step in
your proof must be accompanied by a justification explaining why the
step can be taken.

### `power`

Consider the following OCaml function definition:
```
let rec power x n =
  if n = 0 then 1.0
  else x *. (power x n-1)
  ```

Prove that for all `n` &in; &naturals;, for all _x_ &in; `float`:

> `power` _x_ `n` = _x_ <sup>`n`</sup>


### `pow_nat`

Let us adapt `power` to work on elements of the type `nat` defined in
lecture:

```
type nat = Zero | Succ of nat

let rec to_int n = match n with
| Zero -> 0
| Succ n' -> 1 + (to_int n')

let rec pow_nat x n = match n with
| Zero -> 1.0
| Succ n' -> x *. (pow_nat x n')
```

Use structural induction on the type `nat` to prove that for all `n`
&in; `nat`, for all _x_ &in; `float`,

> `power` _x_  (`to_int` `n`) = `pow_nat` _x_ `n`

### `less_nat`

Suppose we want to write code that compares two structured natural
numbers, `m` and `n`:

```
(* test whether m < n without converting to integers *)
let rec less_nat m n = match n with
| Zero -> false (* m is not less than Zero *)
| Succ n' -> if m = n' then true (* n = m+1 > m *)
                 else less_nat m n' (* n > m iff n-1 >= m *)
```

Use structural induction on the type `nat` to prove that for all `m`
&in; `nat`, for all `n` &in; `nat`:

> `less_nat m n` &hArr;  `(to_int m)` < `(to_int n)`.


## 2. Induction on Lists
*Answers to the following questions should appear in a file named `list.md`*

Use the following function definitions to answer this question:

```
let rec length l = match l with
| [] -> 0
| _::t -> 1 + (length t)

let reverse lst = 
  let rec tail_rev lst acc = match lst with
  | [] -> acc
  | h::t -> tail_rev t (h::acc)
  in tail_rev lst []

let tail_sum lst =
  let rec tsum lst acc = match lst with
  | [] -> acc
  | h::t -> tsum t (h+acc) 
  in tsum lst 0
```

For each of the following identities, use structural induction on
lists to prove the identity is true for all elements &ell; of type `int
list`.  Your proofs should clearly and formally state property P(&ell;)
to be proved,  the base case, the inductive case, and the inductive
hypothesis. 

+ ``length l = length (reverse l)``.

+ ``tail_sum l = tail_sum (reverse l)``

## 3. Polynomials
*Answers to this question should appear in a file named `polynomials.md`*

Code to manipulate univariate polynomials (e.g. _x_<sup>4</sup> + 3 _x_ + 1, or
(_x_-3)(_x_-7)) turns up in many computer science applications,
including graphics, error-correcting codes, computer algebra, machine
learning and optimization theory.  There are two main methods of
representing polynomials: symbolic and implicit.  The symbolic
representation is essentially another expression type:
```
(* Symbolic representation of univariate polynomials *)
type polyExpr =
| Int of int
| X
| Add of polyExpr * polyExpr
| Mul of polyExpr * polyExpr

(* degree of polynomial p *)
let rec deg p = match p with
| Int _ -> 0
| X -> 1
| Add (e1,e2) -> max (deg e1) (deg e2)
| Mul (e1,e2) -> (deg e1) + (deg e2)

(* Compute a representation of p1(p2(X)) by replacing each instance of
X in p1 with p2 *)
let rec compose p1 p2 = match p1 with
| Int _ -> p1
| X -> p2
| Add (e1, e2) -> Add (compose e1 p2, compose e2 p2)
| Mul (e1, e2) -> Mul (compose e1 p2, compose e2 p2)

(* Some simple arithmetic simplifications on polynomials *)
let rec simplify p =
	let simp_add pp = match pp with
	| (Int 0, p) | (p, Int 0) -> p
	| (Int i1, Int i2) -> Int (i1+i2)
	| (p1,p2) -> Add(p1,p2) in
	let simp_mul pp = match pp with
	| (Int 0, _) | (_, Int 0) -> Int 0
	| (Int 1, p) | (p, Int 1) -> p
	| (Int i1, Int i2) -> Int (i1*i2)
	| (p1, p2) -> Mul(p1,p2) in
	match p with
		| Int _ -> p
		| X -> p
		| Add (p1,p2) -> simp_add (simplify p1, simplify p2)
		| Mul (p1,p2) -> simp_mul (simplify p1, simplify p2)
```

Meanwhile the implicit representation represents the polynomial
&Sum;<sub>i &leq; d</sub> a<sub>i</sub> X<sup>i</sup> by
the list of d+1 coefficients
`[`a<sub>0</sub> `;` a<sub>1</sub> `;` ... `;` a<sub>d</sub> `]`:

```
(* implicit represenation by coefficient list *)
type polyList = int list

(* OLD VERSION: *)
(* let list_deg (p : polyList) = (List.length p) - 1 *)

(* CHANGED TO: *)
let list_deg (p: polyList) = match p with
| [] -> 0
| _ -> (List.length p) - 1

let rec list_add (p1:polyList)  (p2:polyList)  = match (p1,p2) with
| (p,[]) | ([],p) -> p
| (a1::t1,a2::t2) -> (a1+a2)::(list_add t1 t2)

(* convert a polyList to a polyExpr *)
let to_poly (a : polyList) =
	let rec poly_of a xi p = match a with
	| [] -> p
	| (ai::a_t) -> poly_of a_t (Mul (X,xi))  (Add (Mul(Int ai, xi) , p)) in
	poly_of a (Int 1) (Int 0)
```

Use structural induction to prove the following identities hold for
all inputs of the appropriate types:

+ ~~`deg (to_poly a) = list_deg a`~~ (no longer required for hw4, but
  you may assume it for your proof to the next problem)

+ `list_deg (list_add a1 a2) = deg (Add (to_poly a1, to_poly a2))`

+ `deg (compose p1 p2) = (deg p1)*(deg p2)`

+ `deg (simplify p) <= deg p`


## 4. Loops

*Answers to these problems should appear in a filed named `loops.md`*

Now let's practice reasoning about loops in imperative code.  In the
following problems, we will be writing "informal" proofs because we
haven't developed the tools to formally prove that some imperative
code corresponds to a particular state transformation, but the proofs
themselves should still use induction where needed and include the
same required components as in the previous sections.

### `lsearch`
Consider the following not-OCaml imperative code that searches a monotonically
increasing function `f` over the interval (0,`n`) for the smallest `i`
that causes `f` to return a value greater than 0:

```
(* Precondition: (f (i+1)) >= (f i) for all i < n, f(0) < 0 and f(n) > 0 *)  
(* Compute smallest i such that f(i) > 0 *)  
let lsearch (f: int->int) (n:int) = {
  let (i, fi) = (0, (f 0)) ;
  while i <= n && fi <= 0 {
	i := i+1 ;
    fi := (f i)
  } ;
  i
}
```
Answer the following questions in your `loops.md` file under the
heading `lsearch`:

+ What is the state maintained by this function?

+ Convert the program into a functional program `flsearch` by converting each
  assignment statement into a function that takes a state as input and outputs a
  modified state, and the while loop into a tail-recursive helper
  function.  Give the ocaml definition of `flsearch` as a code-block
  (offset by triple backticks -\`\`\`) in your homework file.

+ Informally prove the following statements about `lsearch`:
  + For all `f`, for all `n`, if `(f n) > 0` then  `f (lsearch f n) > 0`.
  + For all `f`, if `(f 0) < 0` then for all `n`, `i < (lsearch f n)` &rArr; `(f i) < 0`.


### ~~`bsearch`~~
Consider the following not-OCaml imperative code for the same task as `lsearch`:

```
(* Precondition: (f (i+1)) >= (f i) for all i < n, f(0) < 0 and f(n) > 0 *)  
(* Compute smallest i such that f(i) > 0 *)  
let bsearch (f: int->int) (n:int) = {
  let (up, lo, off, mid) =  (n,0,n/2,n/2) ;
  let fm = f mid ;
  while (up - lo > 1) {
	if fm > 0 then { up := mid }
	else { lo := mid } ;
    off := (off + 1) / 2 ;
	mid := lo + off ;
    fm := f mid
  } ;
  up
}
```
This question is no longer required for homework 4.  If you
already answered it, you may leave it in your solution for a small
amount of extra credit.
<del>

Answer the following questions in your `loops.md` file under the
heading `bsearch`:

+ What is the state maintained by this function?

+ Convert the program into a functional program `fbsearch` by converting each
  assignment statement into a function that takes a state as input and outputs a
  modified state, and the while loop into a tail-recursive helper
  function.  Give the ocaml definition of `fbsearch` as a code-block
  (offset by triple backticks - \`\`\`) in your homework file.

+ Informally prove the following statements about `bsearch`:
  + for all `f`, for all `n`, if `(f n) > 0` then `f (bsearch f n) > 0`.
  + for all `f`, for all `n`, if `n > i > j` &rArr; `(f i) >= (f j)`
    and `(f 0) < 0` and `(f n) > 0`,  then  `i < (bsearch f n)` &rArr; `(f i) < 0`.
  You may find it useful to prove a lemma about the relationship
  between `(f lo)`, `(f mid)` and `(f hi)` that the loop maintains.

+ Use these results to informally prove that for all `f`, for all `n`,
  if `f` and `n` satisfy the preconditions of `lsearch` and `bsearch`
  -- that `(f 0) < 0` and `(f n) > 0` and `j < i < n` &rArr; `(f j) <= (f i)`
  -- then `fsearch f n = bsearch f n`.
</del>
## All done!

Don't forget to commit all of your changes to your solution file
for this homework, and push them to your individual class repository
on UMN github:

+ `hw4/naturals.md`
+ `hw4/lists.md`
+ `hw4/polynomials.md`
+ `hw4/loops.md`

You can always check that your changes haved pushed
correctly by visiting the repository page on github.umn.edu.
