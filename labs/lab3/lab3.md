# Lab 3: Inductive and User-defined types

*CSci 2041: Advanced Programming Principles, Fall 2015*

**Due:** Wednesday, September 30 at 11:59pm.

## Ground rules

You must work with a partner on this lab.  Although labs are meant to
be an open and collaborative environment, it is the responsibility of
both partners to contribute to learning the materials in every lab.
In particular, both partners are responsible for ensuring that submissions are
received by the due date, and for letting us know if one teammate does
not participate in a given lab.

# Introduction: Goals for this lab

+ Apply your knowledge of user-defined types and value constructors to
  define a new OCaml data type and write some functions that
  manipulate this type.

+ See an example of an inductively-defined type and a function that
  computes with this type, and get some experience with these
  computations by extending the type with a new variant.

## 1. `number`

Add a file named `number.ml` to the lab3 directory of your team
repository.  This is where you'll write the answers for this question.

### Declare a `number` type and some constants

The first step of this problem is to declare a new union type,
`number`, that should have two value constructors: one that takes an
`int` as its value and one that takes a `float`. Make sure that your
type declaration compiles correctly.

Now add let declarations binding two names to `number` values that
hold `int`s and let declarations binding two names to `number` values
that hold `float`s.

### `number` conversions

Now that we have succesfully declared the type, let's add three
conversion functions:

+ `to_int : number -> int option` should take argument `n : number`,
  and if `n` holds an integer `i` should evaluate to `Some i`,
  otherwise it should evaluate to `None`.

+ `to_float : number -> float option` should take argument `n :
  number` and if `n` holds a float `x`, should evaluate to `Some x`,
  otherwise it should evaluate to `None`.

+ `float_of_number : number -> float` should _coerce_ the value it
  holds to a floating point value.  Recall that the function
  `float_of_int : int -> float` can be used to coerce an `int` to a
  `float` in OCaml.

### `number` arithmetic

Define the `number` operators `+>` and `*>` with type `number ->
number -> number` that perform addition and multiplication on
`number`s:  if both arguments hold  `int` values then the
result should also hold an `int`, while if either argument holds a
`float` value the result also holds a `float` value.

## An RPN Arithmetic calculator

The file that we are about to inspect relies on the `Str` module. When
using ocamlbuild, this dependency will be automatically detected 
and this module will be loaded. However, `utop` will not do this and we must
instruct `utop` to load this library manually. We will do this by editing a file 
**at the root of your home directory(e.g., /home/xxx1234/)** called 
`.ocamlinit`. This file is automatically loaded by `utop` on startup. Open this 
file in an editor and add a line containing `#load "str.cma";;`. 
Compiled ocaml modules have the extension `cma` and there are some number 
of default locations that ocaml will look for compiled ocaml modules. So,
adding `#load "str.cma";;` to `~/.ocamlinit` (`~` is a kind of macro that
means "my home directory") instructs `utop` to look for the `Str` module
and loaded it on start up.

Let's look more at using inductively defined types to represent expressions
The file `arithExp.ml` contains type declarations related to
representing airthmetic expressions over floating point numbers, and
parsing their representation from *Reverse Polish Notation* strings.

>_Aside: Reverse Polish what now?_
>
>An expression in RPN uses postfix operators, so "a b +" is the sum of
>"a" and "b", "a b *" is the product, and so on.  Values in the
>expression can be thought of as accumulating on a stack, and each
>arithmetic operation pops its argument(s) from the stack and pushes the result.
>Well-formed expressions result in exactly one value.  This has the
>interesting property that parentheses are never needed to express the
>order of operations.

The function `token_list` converts a string into a list of
`arithToken`s, and will result in a run-time error if the string
contains anything that is not `"+"`, `"*"`, `"-"` (for unary negation),
or a floating point number.  The function `rpnParse` interprets a list
of tokens as an RPN expression and attempts to build an arithExpr that
corresponds to this expression: notice that the nested `parser`
function uses an `arithExpr list` to keep track of the expression
stack and uses matching to "pop" values off the stack.  Finally, the
function `arithExpEval` evaluates an `arithExpr` and returns the
floating point value.  So to evaluate a string `s` as an RPN arithmetic
expression, we would call `arithExpEval (rpnParse (token_list s))`.

### Testing it out

At the bottom of the file, add declarations for two `arithExpr`
values.  The first should correspond to the (usual, infix) expression
`1.414 + (3.14 * 2)` and the second can correspond to an expression of
your choosing.  Then add two strings that represent these expressions
in RPN.  You can `#use` the file in `utop` and check whether the composition
`rpnParse` and `token_list` computes the same `arithExpr` values from
these strings.

### Extending the code

Now let's extend the code to add division to the calculator, so for
example the string `"1 2 /"` will evaluate to `0.5`.  (Feel free to
subsitute a different division operator if you like, as long as it's
not `"+"`, `"*"`, or `"-"`.)  We'll need to:

+ Add a new null-ary value constructor to the type `arithToken` to
  represent the division operator.

+ Extend the `tokens` helper function in `token_list` to recognize the
  division operator in a string.

+ Extend the `arithExpr` type with a new value constructor that holds
  a pair of `arithExpr`s.

+ Extend the `parser` helper function in `rpnParse` to handle the
  division token.  (This will look a lot like the cases for `PLUS` and
  `TIMES`, but needs a little care because of the order of elements on
  the stack...)

+ Extend the `arithExpEval` function to handle values constructed
   using the new variant for division expressions.

You can test out your changes by adding lines of the form `let divresult
= arithExpEval (rpnParse (token_list (* YOUR STRING HERE *) ) )` to
the end of the file and `#use`ing the file in utop.  Leave at least two such
test cases in the file when you commit and push the lab.  (Besides
testing the functionality on well-formed expressions, it's also a good
idea to make sure your functions correctly handle ill-formed inputs.)

# Commit and push so that everything is up on GitHub

Now you need to just turn in your work.
Commit your changes and push them up to your central
GitHub repository.

Verify that this worked, by using your browser to see the changes on
https://github.umn.edu.  Your team repository should have both the
file `number.ml` and `arithExp.ml`.

If you do not properly push your changes to the repository we
cannot give you credit for the lab, so please remember to do this
step!

__This concludes lab 3.__

**Due:** Wednesday, September 30 at 11:59pm.

Note that any required changes must exist in your repository on
github.umn.edu. Doing the work but failing to push those changes
to your central repository will mean that we cannot see your work
and hence can't grade it.

