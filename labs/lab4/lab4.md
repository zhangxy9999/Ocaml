# Lab 4
*CSci 2041: Advanced Programming Principles, Fall 2015*

**Due:** Wednesday, October 7 at 11:59pm.

## Ground rules

You must work with a partner on this lab.  Although labs are meant to
be an open and collaborative environment, it is the responsibility of
both partners to contribute to learning the materials in every lab.
In particular, both partners are responsible for ensuring that submissions are
received by the due date, and for letting us know if one teammate does
not participate in a given lab.

# Introduction: Goals for this lab

+ See another example of defining and computing on inductive data types.

+ Apply your knowledge of the OCaml type system to practice re-writing
  multi-argument functions as higher-order functions.

+ Investigate the use of type annotations to get more experience
  reasoning about the types of higher-order functions

## 1. Nested Lists

In this problem we'll define a type that allows us to express "nested
lists", that is, lists that may contain elements that are themselves
nested lists of the element type `'a`.  Here are a few examples of potential
"nested lists" we might define if they were supported by the built-in
`list` type:
```
let nl1 = [ ["where" ; ["is"; ["my"; "talisman"] ] ]; "am"; ["I"; "in"; ["limbo?"] ]]
let nl2 = [ [ [ [ 4 ]; 3 ]; 2 ]; 1; [ 2; [3] ] ]
let nl3 = [ 1; [ 2; [3; 3]; 2]; 1]
```
(Notice that if you try to compile the above declarations in OCaml,
you'll get a type error.)  To get started, create a file called
`nestedList.ml` in a `lab4` directory in your repository.

### Defining the `nestedList` type and giving some examples

Open `nestedList.ml` in your text editor and add a new type definition
that creates a type `'a nestedList` that can represent lists of the
form described above.  The cleanest way to represent structures of
this type is probably to introduce a second type that is mutually
recursive with `'a nestedList`, to represent a union of the kinds of
elements one might cons together to form nestedLists.

Once you've filled in the definition, add `let` declarations binding
`nl1`, `nl2`, and `nl3` to the values defined above (using your value
constructors in place of the pseudo-OCaml used for the informal
description.)  Make sure your code compiles (either by loading it in
`utop` with `#use` or building it with `ocamlbuild`) before moving on
to the next step.

### Two computations on `nestedList` Objects

Now add definitions for the following functions to `nestedList.ml`:

+ `flatten : 'a nestedList -> 'a list` collects all of the nested
  `'a` elements in the order they appear when traversing its
  elements "head"-first, so `flatten nl1` should evaluate to
  `["where"; "is"; "my"; "talisman"; "am"; "I"; "in"; "limbo?"]` and
  `flatten nl2` should evaluate to `[4; 3; 2; 1; 2; 3]`

+ `nest_depth : 'a nestedList -> int` computes the maximum depth of
  nesting in a nestedList,  where depth starts at 1 and increases with
  each level of nesting, so `nest_depth nl1` should evaluate to 4,
  `nest_depth nl2` should also evaluate to 4, and `nest_depth nl3`
  should evaluate to 3.

## 2. Rewriting higher-order functions

Recall that every definition and use of a multiple argument function
is actually an instance of a higher-order function, because:

+ The notation `fun x y z -> expr` is equivalent to `fun x -> fun y ->
fun z -> expr`; and
+ The notation `f x y z` is equivalent to `let f1 = (f x) in let f2 =
(f1 y) in (f2 z)`.

Furthermore, if we apply the above transformations to some OCaml code
using multiple argument functions, we'll find we can often perform
some or most of the evaluation before returning a function, using the
rules:

+ The expression `fun x -> if b then e1 else e2` is equivalent to `if
b then (fun x -> e1) else (fun x -> e2)` if `x` is not used in `b`.

+ The expression `fun x -> let y = e1 in e2` is equivalent to `let y =
e1 in fun x -> e2` if `x` is not used in `e1`.

+ The expression `fun x -> match e with | p1 -> e1 | p2 -> e2 | ... |
  pn -> en` is equivalent to `match e with | p1 -> (fun x -> e1) |
  ... pn -> (fun x -> en)` if `x` is not used in `e` or any of the
  patterns `p1`...`pn`.

+ `let` expressions can be reordered if the values do not depend on
  the names bound in them, e.g. `let n1 = e1 in let n2=e2 in e3` is
  equivalent to `let n2 = e2 in let n1 = e1 in e3` if `e1` does not
  contain `n2` and `e2` does not contain `n1`. Similarly, a `let` that
  appears as a case in a conditional can be "lifted" outside the
  conditional if neither the other branches nor the condition have a
  conflicting binding.

In this problem, we'll apply these rules to some familiar functions to
get more practice with seeing, writing, and using higher-order
functions.  As an example, consider the function `zip : 'a list -> 'b
list -> ('a * 'b) list`:
```
let rec zip l1 l2 =
  match l1 with
  | [] -> []
  | (h::t) -> match l2 with
	      | [] -> []
	      | (h'::t') -> (h,h') :: (zip t t')
```
We first remove the `let` sugar to get:
```
let rec zip = fun l1 -> fun l2 ->
  match l1 with
  | [] -> []
  | (h::t) -> match l2 with
	      | [] -> []
	      | (h'::t') -> (h,h') :: (zip t t')
```
Next, since the first matched expression doesn't depend on l2, we
rewrite as:
```
let rec zip = fun l1 ->
  match l1 with
  | [] -> fun l2 -> []
  | (h::t) -> fun l2 -> match l2 with
	      | [] -> []
	      | (h'::t') -> (h,h') :: (zip t t')
```
Next we rewrite `(zip t t')`:
```
let rec zip = fun l1 ->
  match l1 with
  | [] -> fun l2 -> []
  | (h::t) -> fun l2 -> match l2 with
	      | [] -> []
	      | (h'::t') -> (h,h') :: (let zip1 = (zip t) in zip1 t')
```
And we can "lift" the let binding outside of the `match l2`:
```
let rec zip = fun l1 ->
  match l1 with
  | [] -> fun l2 -> []
  | (h::t) -> fun l2 -> let zip1 = (zip t) in match l2 with
	      | [] -> []
	      | (h'::t') -> (h,h') :: (zip1 t')
```
And finally, we can push the `fun l2 ->` inside this let expression,
since `l2` doesn't appear in `let zip1 = (zip t)`:
```
let rec zip = fun l1 ->
  match l1 with
  | [] -> fun l2 -> []
  | (h::t) -> let zip1 = (zip t) in
	fun l2 -> match l2 with
	      | [] -> []
	      | (h'::t') -> (h,h') :: (zip1 t')
```
The file `hof_rewrite.ml` contains two other familiar list functions;
show the process of applying these rules to each of them to produce
rewritten versions that highlight their use of higher-order functions.

## Type annotations and HOF type inference

In class, we have seen that, at least for primitive value bindings, we
can tell OCaml what type we expect them to have using _type
annotations_, for example:
```
let i_1 : int = 4
```
The same kind of annotations can be applied to function bindings,
depending on how the function is bound:
```
let rec filter (f : 'a -> bool) (lst : 'a list) : 'a list = match lst with...
```
or
```
let rec filter : ('a -> bool) ->  'a list -> 'a list = fun f lst ->
match lst with...
```

The file `hof_types.ml` contains definitions for three higher-order functions.  For
each one, give a comment above that explains how you derived the type,
and then annotate the definition with this type.  You can check your
answers by building the file on the command line: an incorrect
annotation will lead to a type error when compiling.

# Commit and push so that everything is up on GitHub

Now you need to just turn in your work.
Commit your changes and push them up to your central
GitHub repository.

Verify that this worked, by using your browser to see the changes on
https://github.umn.edu.  Your team repository should have the
files `nestedList.ml`, `hof_rewrite.ml` and `hof_types.ml`.

If you do not properly push your changes to the repository we
cannot give you credit for the lab, so please remember to do this
step!

__This concludes lab 4.__

**Due:** Wednesday, October 7 at 11:59pm.

Note that any required changes must exist in your repository on
github.umn.edu. Doing the work but failing to push those changes
to your central repository will mean that we cannot see your work
and hence can't grade it.

