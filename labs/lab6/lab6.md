# Lab 6: Manipulating Programs as Data

*CSci 2041: Advanced Programming Principles, Fall 2015*

**Due:** Wednesday, October 21 at 11:59pm.


## Ground rules

You must work with a partner on this lab.  Although labs are meant to
be an open and collaborative environment, it is the responsibility of
both partners to contribute to learning the materials in every lab.
In particular, both partners are responsible for ensuring that submissions are
received by the due date, and for letting us know if one teammate does
not participate in a given lab.

# Introduction: Goals for this lab

+ Get more comfortable with the `expr` data type we've been designing
in class for representing simple programs

+ See some examples of writing functions to manipulate values of this
type


## Writing simple programs as `expr` values

The file `program.ml` contains a declaration of the type `expr` for
representing programs that we've been discussing in class.  It also
includes the definition of the `eval` function that evaluates an
`expr` given a lexical environment binding names to values (called
initially with `[]`) and a type-checking function, `typeof`, that
infers the type of a program, raising an exception if the expression
is not well-typed.  Take a look at these definitions and see if you
understand how they work.

Once you've convinced yourself that you understand them, add bindings
for two programs that are well-typed.  Your programs should involve
control flow and use let bindings, but otherwise they can compute
anything you like.  Evaluate these programs in `utop` to see if they
behave as you expect, and check their types using `typeof`.  Then add
two more program values, but make these values correspond to programs
with type errors.  Confirm that calling `typeof` on these programs
results in an exception.

## Computing on  `expr` values: finding constants

Add a definition for a function `find_constants : expr ->
expr list` that traverses a program `expr` and assembles a list of all
of the boolean and integer constants present in the expression. So for
example, evaluating `find_constants e1` should result in the list
`[ Const 3; Const 7; Boolean true; Boolean false]`, and evaluating
`find_constants badtype1` should result in the list
`[Const 7; Boolean true; Const 1; Const 3; Boolean false]`. 

## Manipulating `expr` values: removing variables

Now add a definition for a function `rm_vars: expr -> expr` that
creates a copy of its argument with all of the `Name` sub expressions
replaced by constants.  Your program will need to keep track of the
_types_ of names: a name that is bound to an integer value should
be replaced by `Const 0` and a name that is bound to a boolean value
should be replaced by `Boolean false`.  Some sample evaluations:

+ `rm_vars e1` should evaluate to
  `Let ("x", Const 3, Let( "y", Const 7, If (Gt(Const 0, Const 0), Print
  (Boolean true), Print (Boolean false))))`
 + `rm_vars Let("artoo", Const 42, Name "artoo")` should evaluate to
   `Let ("artoo", Const 42, Const 0)`.
 + `rm_vars Let("z", Boolean true, If(Name "z", Name "z", Not(Name
  "z")))` should evaluate to `Let("z", Boolean true, If(Boolean false,
  Boolean false, Not(Boolean false)))`.


# Commit and push so that everything is up on GitHub

Now you need to just turn in your work. Commit your changes and push
them up to your central GitHub repository. 

Verify that this worked, by using your browser to see the changes on
https://github.umn.edu.

If you do not properly push your changes to the repository we
cannot give you credit for the lab, so please remember to do this
step!

__This concludes lab 6.__

**Due:** Wednesday, October 21 at 11:59pm.

Note that any required changes must exist in your repository on
github.umn.edu. Doing the work but failing to push those changes
to your central repository will mean that we cannot see your work
and hence can't grade it.
