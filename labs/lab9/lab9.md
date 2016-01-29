# Lab 9: Exceptions and Continuations

*CSci 2041: Advanced Programming Principles, Fall 2015*

**Due:** Wednesday, November 11 at 11:59pm.


## Ground rules

You must work with a partner on this lab.  Although labs are meant to
be an open and collaborative environment, it is the responsibility of
both partners to contribute to learning the materials in every lab.
In particular, both partners are responsible for ensuring that submissions are
received by the due date, and for letting us know if one teammate does
not participate in a given lab.

# Introduction: Goals for this lab

+ Practice writing OCaml code using exceptions

+ Practice writing OCaml code in continuation-passing style

## Answering the questions in this lab

Create a `lab9` directory in your team repository, and copy the files
`prog.ml` and `kfuncs.ml` to this directory.

## Exceptions

The file `prog.ml` contains a datatype representing a small (but
Turing complete) part of our fragment of a programming language and an
evaluation function for programs in this datatype.  It also defines
five values representing miserable failures of programs, literally:
evaluating any of these programs with an initially empty state will
result in an unhelpful exception.   Add exceptions to represent each
of these situations (including enough information to give a useful
debugging message) and modify `eval` so that it raises the appropriate
exception in each of these cases.

Once you're done, add the OCaml definition for a function `runProg :
expr -> unit` that runs its argument with an empty initial state and prints
out the result of the program evaluation.  If any exceptions are
raised by `eval`, `runProg` should handle the exception by printing a
useful error message.  (For example, the message printed for an unbound
name should include the name.)

## Continuations

The file `kfuncs.ml` includes four non-tail recursive functions, and a
continuation-passing version of the first, `map_k`.  Let's transform
the rest of these functions to continuation-passing style: add OCaml
definitions for the following functions:

+ `append_k : 'a list -> 'a list -> 'a list`: Just like in `map_k`,
  you can define an internal helper function that takes the
  continuation `k` as an argument; since `l2` is never modified you
  could leave it off to make your tail calls a bit simpler to read

+ `assoc_update_k: 'a -> 'b -> ('a * 'b) list -> ('a * 'b) list`
  updates the binding associated with a key in an associative list, or
  adds the binding if none is found.  Using a local helper function
  will also help make the tail calls simpler here.

+ `treeMin_k : 'a btree -> 'a` finds the minimum value in a binary
  tree.  This one is a bit tricker to write cleanly.  You might
  consider writing a separate helper function for the continuation:
  `min_k : 'a -> ('a option -> 'b) -> 'a option -> 'b`, which handles
  the logic of matching the `'a option` computed recursively,
  computing the min, and passing it to a continuation.

# Commit and push so that everything is up on GitHub

Now you need to just turn in your work. Commit your files and push
it up to your central GitHub repository. 

Verify that this worked, by using your browser to see the changes on
https://github.umn.edu.

If you do not properly push your changes to the repository we
cannot give you credit for the lab, so please remember to do this
step!

__This concludes lab 9.__

**Due:** Wednesday, November 11 at 11:59pm.

Note that any required changes must exist in your repository on
github.umn.edu. Doing the work but failing to push those changes
to your central repository will mean that we cannot see your work
and hence can't grade it.
