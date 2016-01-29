# Lab 10: Lazy Evaluation and Streams

*CSci 2041: Advanced Programming Principles, Fall 2015*

**Due:** Wednesday, November 18 at 11:59pm.


## Ground rules

You must work with a partner on this lab.  Although labs are meant to
be an open and collaborative environment, it is the responsibility of
both partners to contribute to learning the materials in every lab.
In particular, both partners are responsible for ensuring that submissions are
received by the due date, and for letting us know if one teammate does
not participate in a given lab.

# Introduction: Goals for this lab

+ Practice with lazy evaluation

+ See an example of defining a stream generator

+ Get some experience writing stream and lazylist functions

## Answering the questions in this lab

Create a `lab10` directory in your team repository, and copy the files
`lazylabval.md` and `lab10streams.ml` to this directory.

## Lazy Evaluation
Consider the following function definitions, in _`lazyCaml`_ (same
syntax as OCaml, but using lazy evaluation):

```
let rec take n lst = match (n,lst) with
| (0,_) | (_,[]) -> []
| (_,h::t) -> h::(take (n-1) t)

type 'a tree = Leaf of 'a | EmptyT | Node of 'a tree * 'a tree

let rec dfs t = match t with
| EmptyT -> []
| Leaf v -> [v]
| Node(l,r) -> (dfs l) @ (dfs r)

let rec crazytree n v = if n = 0 then (Leaf v) else
	Node(crazytree (n-1) ("a"^v), crazytree n ("buffalo"^v))

let rec treefind t v = match t with
| EmptyT -> False
| Leaf v' -> v'=v
| Node(l,r) -> (treefind l v) || (treefind r v)
```

The file `lazylabval.md` contains three _`lazyCaml`_ expressions using
these definitions.   Give the full step-by-step evaluation of each of
these expressions; or if the expression does not terminate with a
normal form, state why this is the case.

## Streams and Lazy lists

In class we presented the data structures `'a stream` and `'a
lazylist` as ways to represent possibly infinite data structure within
the eager evaluation order of OCaml.  The file `lab10streams.ml` has
definitions for these data types and the utility functions `take_s`
and `lz_take` to be used in completing this lab.  Now add four
function definitions to this file:

+ `ustring_s : string -> string stream` takes a string `s` as input and
  generates the list of all strings that are 0 or more concatenations
  of `s` with itself.  Example evaluations: `take_s 3 (ustring_s
  "yo")` should evaluate to `[""; "yo"; "yoyo"]` and `take_s 4
  (ustring_s "boo")` should evaluate to
  `[""; "boo"; "booboo"; "boobooboo"]`.

+ `take_until_s : 'a stream -> ('a -> bool) -> 'a list` takes a stream
  and a predicate, and evaluates the predicate on each element of the
  stream until the predicate returns true, returning a list of all of
  the items before this element.   For example `take_until_s
  (ustring_s "a") (fun s -> String.length s = 4)` should evaluate to
  `["";"a";"aa";"aaa"]`

+ `lz_ustring : string -> string lazylist` generates a `string
  lazylist` with the same elements as `ustring`.

+ `lz_take_until: 'a lazylist -> ('a -> bool) -> 'a list` performs the
  same function as `take_until` with a lazy list instead of a string.
  Make sure to watch out for the `End` case that is not present in
  streams.


# Commit and push so that everything is up on GitHub

Now you need to just turn in your work. Commit your `lab10streams.ml`
and `lazylabval.md` files and push them up to your central GitHub repository. 

Verify that this worked, by using your browser to see the changes on
https://github.umn.edu.

If you do not properly push your changes to the repository we
cannot give you credit for the lab, so please remember to do this
step!

__This concludes lab 10.__

**Due:** Wednesday, November 18 at 11:59pm.

Note that any required changes must exist in your repository on
github.umn.edu. Doing the work but failing to push those changes
to your central repository will mean that we cannot see your work
and hence can't grade it.
