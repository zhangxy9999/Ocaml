# Lab 5: Higher-Order List functions

*CSci 2041: Advanced Programming Principles, Fall 2015*

**Due:** Wednesday, October 12 at 11:59pm.


## Ground rules

You must work with a partner on this lab.  Although labs are meant to
be an open and collaborative environment, it is the responsibility of
both partners to contribute to learning the materials in every lab.
In particular, both partners are responsible for ensuring that submissions are
received by the due date, and for letting us know if one teammate does
not participate in a given lab.

# Introduction: Goals for this lab

+ See more examples using map, filter, fold, and reduce to express recursive functions without explicit recursion.

## Map, Fold and Reduce

Recall that in lecture we defined the following higher-order
functions:

```
let rec map f lst =
  match lst with
  | [] -> []
  | h::t -> (f h)::(map f t)

(* fold_left in Ocaml *)
let rec fold f acc lst =
  match lst with
  | [] -> acc
  | h::t -> fold f (f acc h) t

(* fold_right in Ocaml *)
let rec reduce f lst init =
  match lst with
  | [] -> init
  | h::t -> f h (reduce f t init)
```

You should copy these definitions to a file named `lab5.ml` in a `lab5` directory
in your team repository, and use this file to record your solutions to all of the
problems for the lab.  In this question, we'll see some examples of
using these functions to express other list computations.

+ `append : 'a list -> 'a list -> 'a list`: implement `append` via a
single call to `reduce`, ie:
```
let append l1 l2 = reduce ___  l1  ___
```

+ Recall that `filter : ('a -> bool) -> 'a list -> 'a list` makes a
  list of the elements of its second argument that make its first
  argument true: implement `filter` via a single class to `reduce`:
  ```
  let filter pred lst = reduce ____ lst ____
  ```

+ `list_cat : string list -> string` in a previous lab, we saw the
  `list_cat` function, which concatenates all fo the strings in a list
  together.  Implement `list_cat` by a single call to fold:

```
let list_cat = fold ___ ___
```

+ `list_fst : ('a * 'b) list -> 'a list`: Given a list of pairs,
  `list_fst` extracts a list of the first element of each pair.
  Implement `list_fst` with a single call to `map`:
```
let list_fst = map ____
```

## Intersection Size

We can represent a set of elements of type `'a` using a value of type
`'a list`, as long as we are careful to avoid adding duplicate
elements to the list.  Let's look at implementing operations on this
representation of sets using higher-order list functions:

+ `mem : 'a -> 'a list -> bool` evaluates to true if and only if its
  first argument appears in its second argument.  Give a definition of
  `mem` in terms of a `map` followed by a `reduce`:
```
let mem x lst = reduce ___  (map  ___  lst) ___
```
  In this form you can accomplish this without introducing any
  additional bindings.

+ `count_intersection : 'a list -> 'a list -> int` returns the number
  of elements in the intersection of its arguments.  Give a definition
  of `count_intersection` in terms of `fold`:

```
let count_intersection lst1 lst2 = fold ____  0 lst2 
```
  You may assume that lst1 and lst2 represent proper sets, that is,
  they have no repeated elements.

+ `check_set : 'a list -> bool` checks that its argument represents a
  set, that is, it has no repeated elements.  There are several ways
  to implement `check_set` in terms of the higher-order list
  functions; one involves a `fold` that accumulates a pair of type `'a
  list * bool`.  Add an implementation of `check_set` to `lab5.ml`.
  This one is trickier; if you don't see how to solve it with a few
  minutes of collaborative thinking, go ahead and move on.

## `assoc_max`

Recall that a `('key,'value)` associative list can be represented as an
`('key * 'value) list` of pairs, and the function `assoc : 'a -> ('a * 'b) list
-> 'b` looks up the value associated with its first argument in an
associative list.   In this problem, we'll write a function that finds
the `'key` that maps to the largest `'value` stored in an associate list:
`assoc_max : ('a * 'b) list -> 'a option`.  For example, `assoc_max
[("a",3), ("b",0)]` should evaluate to `Some "a"`, since `3 > 0`.  Give an
implementation of `assoc_max` in terms of `fold`; you'll need
to process the result with a pattern match, since the `fold` needs to
track both a key and a value, while `assoc_max` needs to return a
value option.

# Commit and push so that everything is up on GitHub

Now you need to just turn in your work. Commit your changes and push
them up to your central GitHub repository. 

Verify that this worked, by using your browser to see the changes on
https://github.umn.edu.

If you do not properly push your changes to the repository we
cannot give you credit for the lab, so please remember to do this
step!

__This concludes lab 5.__

**Due:** Wednesday, October 12 at 11:59pm.

Note that any required changes must exist in your repository on
github.umn.edu. Doing the work but failing to push those changes
to your central repository will mean that we cannot see your work
and hence can't grade it.
