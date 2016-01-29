# Lab 13: Modules

*CSci 2041: Advanced Programming Principles, Fall 2015*

**Due:** Wednesday, December 9 at 11:59pm.


## Ground rules

You must work with a partner on this lab.  Although labs are meant to
be an open and collaborative environment, it is the responsibility of
both partners to contribute to learning the materials in every lab.
In particular, both partners are responsible for ensuring that submissions are
received by the due date, and for letting us know if one teammate does
not participate in a given lab.

# Introduction: Goals for this lab

+ Work with module declarations

+ Work with module signatures

+ Work with functors

## Answering the questions in this lab

Create a `lab13` directory in your team repository and copy the
'dict.ml' file to this directory; we'll work with the contents of this
file in the following sections.

## Dictionaries

A dictionary is a very common and important data structure in computer
science, maintaining a mapping between keys of type `'k` and values of
type `'v`.  In this class, we have used associative lists as
dictionaries several times, but of course this is not the only
possible implementation of a dictionary.  There are several
alternatives that could be faster or more memory-efficient, and
abstracting this detail would make it easier to replace associative
lists with another implementation.

The file `dict.ml` already contains definitions of two modules that
implement dictionaries: `ListDict` is the familiar associative list
implementation, and `TreeDict` uses randomized binary search trees to
represent dictionaries.  You can have a look at both, although
understanding the randomized BST implementation is not really
important for the lab.

## Function Dictionaries

A third method of implementing dictionaries is by functions, e.g. a
dictionary with keys of type `'k` and values of type `'v` is a
function `d : 'k -> 'v` such that looking up the binding for `key` is
accomplished by calling `(d key)`.  In this implememtation:

+ The empty dictionary is the function `empty = fun k -> raise Not_found`

+ Adding `(key,vl)` binding is accomplished by creating a new function
that tests whether its input `k` is `key` (and returns `vl` if so) and otherwise
calls the old dictionary with `k`.

+ Updating a binding is identical to adding the binding

At the top of `dict.ml`, fill in the definition of the `FunDict`
module, declaring the type of `('k,'v)` function dictionaries, and
implementing the `empty` function dictionary, and the functions `add : 'k -> 'v ->
('k,'v) t -> ('k,'v) t`, `insert`, and `lookup : 'k -> ('k,'v) t ->
'v`.

## Abstraction

Of course, as the modules are implemented so far, the details of the
data structures are transparent.  In order to make the types abstract,
we'll need to restrict the `FunDict`, `ListDict`, and `TreeDict`
modules to a signature with abstract representation for the type
`('k,'v) t`.  Add a signature declaration for a `DICT` module
signature that has a type (`('k,'v) t`), the `empty` dictionary, the
`add` function, the `lookup` function, and the `update` function.
Restrict `FunDict` to this signature.

Notice that `TreeDict` and `ListDict` both support an additional
operation, `fold`, on elements of type `t`.  Declare a second
interface, `FOLDABLEDICT`, that supports all of the `DICT` operations
and `fold` as well.  (This declaration can be made quite short using
inclusion.)

## Functors

Notice that the `TreeDictUtil` module provides functions that would be
useful for many different representations of dictionaries.  Generalize
this module by converting it into a functor, `DictUtil`, that operates
on `FOLDABLEDICT` modules to allow creation of utility modules for any
foldable dictionary module.

## Functors again

The `dict.ml` file also contains the beginning of the declaration for
a second functor, `DictTest`, that allows us to test whether two
dictionary modules have the same behavior for some input.  Uncomment
and complete the `DictTest` functor, so that the `DictTest.test`
function adds the list of bindings in `ins_list` to an empty `DT1.t`
and an empty `DT2.t`, then tests whether the two dictionaries give back
the same values when looking up each element in `test_list`.  If all
of the elements yield the same value, `DictTest.test` should return
`None`, and if there is some key `k` in `test_list` such that `DT1.lookup k d1` and
`DT2.lookup k d2` return differing results, `DictTest.test` should
evaluate to `Some k`.

## Test them out

Add a few lines asserting that `FunDict` and `ListDict` have the same
behavior for a test setup of your choosing, and a few lines asserting
that `TreeDict` and `ListDict` also have the same behavior for this
test setup.

# Commit and push so that everything is up on GitHub

Now you need to just turn in your work. Commit your `dict.ml`
file and push it up to your central GitHub repository. 

Verify that this worked, by using your browser to see the changes on
https://github.umn.edu.

If you do not properly push your changes to the repository we
cannot give you credit for the lab, so please remember to do this
step!

__This concludes lab 13.__

**Due:** Wednesday, December 9 at 11:59pm.

Note that any required changes must exist in your repository on
github.umn.edu. Doing the work but failing to push those changes
to your central repository will mean that we cannot see your work
and hence can't grade it.
