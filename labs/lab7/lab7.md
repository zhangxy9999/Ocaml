# Lab 7: Reasoning about programs

*CSci 2041: Advanced Programming Principles, Fall 2015*

**Due:** Wednesday, October 26 at 11:59pm.


## Ground rules

You must work with a partner on this lab.  Although labs are meant to
be an open and collaborative environment, it is the responsibility of
both partners to contribute to learning the materials in every lab.
In particular, both partners are responsible for ensuring that submissions are
received by the due date, and for letting us know if one teammate does
not participate in a given lab.

# Introduction: Goals for this lab

+ Get some experience writing proofs about OCaml programs on integers

+ Get some experience writing proofs about structured natural numbers

## Answering the questions in this lab

Create a `lab7` directory in your team repository, and add a file
named `lab7-sol.md` to the directory.  You should add your solutions
to each of the three following problems under the same headings as the
problems are given.

## Binomial Coefficients

Consider the following program to compute binomial coefficients
("choose"):

```
let rec choose n k =
  if (n=k) || (k = 0) then 1
  else ((choose (n-1) (k-1))*n)/k
  ```

Use induction on _n_ to prove that for all _n_ > 0, for all _k_  > 0,
> _k_ < _n_ &rArr; `choose n k` = n! / ((n-k)! * k!)

Your proof should:
1. State the precise property P( _n_ ) you're going prove.
2. Clearly state the base case and prove it's correct.
3. Clearly state the inductive case and inductive hypothesis, and
   formally prove the inductive hypothesis implies the inductive case.

## Structured Arithmetic

```
type nat = Zero | Succ of nat

let rec to_int n = match n with
| Zero -> 0
| Succ n -> 1 + (to_int n)

let rec minus_nat m n = match (m,n) with
| (_,Zero) -> m
| (Zero,_) -> invalid_arg "minus_nat not a natural number!"
| (Succ m1, Succ n1) -> minus_nat m1 n1
```

Use structured induction on the type `nat` to prove that for all `m` &in; `nat`, for all `n` &in; `nat`,
> `(to_int m) > (to_int n)` &rArr; `to_int (minus_nat m n) = (to_int m) - (to_int n)`
Your proof should have the same components as in the previous question. 

## Structured Comparisons

```
let rec eq_nat n1 n2 = match (n1,n2) with
| (Zero,Zero) -> true
| (Zero,_) | (_, Zero) -> false
| (Succ n1', Succ n2') -> eq_nat n1' n2'
```

Use structured induction on the type `nat` to prove that for all `m` &in; `nat`, for all `n` &in; `nat`,
> `(to_int m) = (to_int n)` &hArr; `eq_nat m n`

Your proof should have the same components as in the previous questions. 


# Commit and push so that everything is up on GitHub

Now you need to just turn in your work. Commit your `lab7-sol.md` file and push
it up to your central GitHub repository. 

Verify that this worked, by using your browser to see the changes on
https://github.umn.edu.

If you do not properly push your changes to the repository we
cannot give you credit for the lab, so please remember to do this
step!

__This concludes lab 7.__

**Due:** Wednesday, October 26 at 11:59pm.

Note that any required changes must exist in your repository on
github.umn.edu. Doing the work but failing to push those changes
to your central repository will mean that we cannot see your work
and hence can't grade it.
