# Lab 8: More reasoning about programs

*CSci 2041: Advanced Programming Principles, Fall 2015*

**Due:** Wednesday, November 4 at 11:59pm.


## Ground rules

You must work with a partner on this lab.  Although labs are meant to
be an open and collaborative environment, it is the responsibility of
both partners to contribute to learning the materials in every lab.
In particular, both partners are responsible for ensuring that submissions are
received by the due date, and for letting us know if one teammate does
not participate in a given lab.

# Introduction: Goals for this lab

+ Get some experience writing proofs about OCaml programs on
  structured types

+ Practice writing informal proofs about imperative programs

## Answering the questions in this lab

Create a `lab8` directory in your team repository, and add a file
named `lab8-sol.md` to the directory.  You should add your solutions
to each of the three following problems under the same headings as the
problems are given.

## List induction
Using the following code to produce the element-wise sum of two lists:

```
let rec list_add l1 l2 = match (l1, l2) with
| ([], ls) | (ls, []) -> ls
| (a1::t1, a2::t2) -> (a1+a2)::(list_add t1 t2)
```

Prove that for all `l1` &in; `int list`, for all `l2` &in; `int list`,
>  `length (list_add l1 l2)` = `max (length l1) (length l2)`

You might find it convenient to consider this by cases, such as
when `length l1 <= length l2` and when `length l1 > length l2`.

Don't forget that your proof should clearly state the property you are
trying to prove, the base case, the inductive case, and what you get from
the inductive hypothesis.  Each step in your proof should include a
formal justification.

## Polynomials
Let's reason about the following code for symbolic representation of polynomials:

```
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
```

Prove that ``simplify`` preserves the degree of a polynomial in this
representation:

For all `p1` &in; `polyExpr`,
>  `deg p1` = `deg (simplify p1)`.


## Binomial Coefficients

Consider the following not-OCaml iterative program to compute binomial coefficients:

```
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
```

1. What is the state maintained by this program?

2. To help reasoning about the program, convert the while loop to a
tail-recursive function ``choose_loop`` that takes a state as input and returns a
state as output.  Include this tail recursive function in your
solution file as a code block offset by triple backticks (\`\`\`).
You may find it interesting to compare this implementation of `ichoose` with the recursive
implementation from lab 7.  (But not that helpful for the task at hand)


3. Informally prove that for all `n`, after each loop iteration, the state of the
program satisfies

> `r` = `n` choose `d`. 

(Here the proof will be "informal" because we haven't formally proven
the equivalence of `choose_loop` and the while loop in `ichoose`; but
you should still use induction and include the same justification as
you would in any other proof)

# Commit and push so that everything is up on GitHub

Now you need to just turn in your work. Commit your `lab8-sol.md` file and push
it up to your central GitHub repository. 

Verify that this worked, by using your browser to see the changes on
https://github.umn.edu.

If you do not properly push your changes to the repository we
cannot give you credit for the lab, so please remember to do this
step!

__This concludes lab 8.__

**Due:** Wednesday, November 4 at 11:59pm.

Note that any required changes must exist in your repository on
github.umn.edu. Doing the work but failing to push those changes
to your central repository will mean that we cannot see your work
and hence can't grade it.
