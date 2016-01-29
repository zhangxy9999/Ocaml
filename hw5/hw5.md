# Homework 5: Order of evaluation in programs
*CSci 2041: Advanced Programming Principles, Fall 2015*

**Due:** Friday, November 20 at 11:59pm


##1. Exceptions and continuations

*Parsing boolean expressions, revisited*

The file `bexp.ml` contains an implementation of a prefix boolean
expression parser/evaluator like the one we wrote in homework 2.  We will be
modifying this program in several ways using our new understanding of
exceptions and continuations:

+ Start by defining a new evaluation function `keval : boolExpr ->
  string list -> (bool->bool) -> bool`.  `keval` will look pretty
  similar to the `reval` ("r" is for "recursive") already defined in
  `bexp.ml`, but will work in *continuation-passing style*: instead of
  returning the result of an evaluation up the call stack, `keval`
  "returns" its result by passing "continuations" (the `bool->bool`
  function argument) that are called to process the result.  (Note:
  ocaml may infer a more general type depending on your definition.
  If this annoys or worries you, you can always make it go away by
  explicitly declaring the types of the arguments)
  
  Note that for `And` and `Or` expressions there will be two
  subexpressions to be evaluated: in these cases, your continuation
  will need to make another recursive call to `keval` in order to
  fully evaluate the expression.

  You can test `keval` against the output of `reval` for any boolean
  expression and any list of true variables.

  Add a function `eval : boolExpr -> string list -> bool` that calls
  `keval` with an appropriate initial continuation to finish the
  transformation.

+ Next, define a new parsing function, `kparse: token list ->
  (boolExpr -> token list -> boolExpr) -> boolExpr`  (again, your
  definition may lead OCaml to infer the more general type `token
  list -> (boolExpr -> token list -> 'a) -> 'a`.  You can fix this by
  explicitly declaring the argument types).  `kparse` should function
  similarly to `rparse`, but be written in continuation passing
  style; the continuation should take the expression built by the
  current call and the tail of the token list as arguments.

  Add a function `parse : token list -> boolExpr` that calls `kparse`
  with an appropriate initial continuation.  (Note that in this case,
  the initial continuation is a little more complex, due to the need
  to check that the entire token list was read in parsing.)

+ When you're sure you've got `keval` and `kparse` working,  we'll
  modify `kparse` a bit more: add three new exception variants to
  `bexp.ml`: an `Unclosed` exception for unclosed expressions (or mismatched
  parentheses), an `Unused` exception for unused tokens in the input,
  and a `SyntaxError`  exception for syntax errors due to unexpted tokens.
 
  The unclosed expression exception should record the position in the
  token list where the subexpression began and the position where a
  closing parenthesis was expected; the syntax error and unused token
  excetptions should record the position in the token list where they
  were encountered.

  Modify `kparse` and its wrapper, `parse`, to keep track of the
  position in the token list (so the continuation will need to have
  its position passed as an argument) they are processing, and raise
  the correct exception variant when the corresponding error is
  encountered.

+ Finally, add a "driver" function, `query : string -> string set ->
  unit` that combines `lex`, `parse`, and `eval` to read an expression
  from a string, evaluate the expresision, and print the expression
  and the result of the evaluation.  `query` should also handle any
  exceptions raised by `parse` or `kparse`, by printing out an
  appropriate error  message including the location information carried by the
  exceptions.

You can use the `build_deep_not` function to build very deep lists,
allowing you to test the tail-recursion of `kparse` and `keval`.
Homework 2 also includes several examples of strings that should raise
exceptions and strings that should evaluate to true or false.

##2. Evaluations in _`lazyCaml`_
Create a file name `lazy_eval.md` in your `hw5` directory, where you
will record your answers for this question.

Consider the following _`lazyCaml`_ definitions:
```
let rec squares n = (n*n)::(squares (n+1))

let factorials () =
  let rec fac_acc n a = n*a :: (fac_acc (n+1) (n*a)) in 
  fac_acc 1 1 

let rec fold_right f lst init = match lst with
   | [] -> init
   | (h::t) -> f h (fold_right f t init)
  
let rec map f lst = match lst with
  | [] -> []
  | (h::t) -> (f h)::(map f t)
 
let rec sum_list lst = match lst with
  | [] -> 0
  | (h::t) -> h + (sum_list t)
```

Using these definitions, consider the following expressions.  For each
expression, state whether the expression evaluates to a normal form in
a finite number of steps, or the expression will never reach a normal
form under lazy evaluation.  For those expressions that will reach a
normal form, give the complete step-by-step lazy evaluation, one step
per line, of the expression.

+ `take 3 (squares 3)`

+ `fold_right (&&) (map ((<) 0) (squares 2)) true`

+ `fold_right (||)  (map (fun n -> n mod 8 = 0) (factorials ())) false`

+ `take (sum_list (squares 1)) (factorials ())`

Some things to keep in mind while evaluating these expressions:

+ You may omit the conditional step when substituting a function
  argument into the function body, e.g. it is OK to go from
  ```map (fun x -> x mod 8) z::(something...)```
  to
  ```((fun x -> x mod 8) z)::(map (fun x -> x mod 8) (something...)```
  in a single step, skipping the implicit `match z::(something...)
  with...` subtitution.

+ Otherwise, though, you should show each step, in the order required
  by lazy evaluation.


##3. Streams

In class we discussed the type `'a stream`, that allows us to
represent infinite objects similar to the type that can be built  in
_`lazyCaml`_ .  For this question, we'll write several more functions
to build and manipulate streams.  The file `streams.ml` defines the
type `'a stream` and includes some stream functions we've seen in
lecture; add your solutions to the following questions to this file.

### `pytrips`

A pythagorean triple is a tuple of positive integers, `(x,y,z)` such that (i)
`x < y`; (ii) `x*x + y*y = z*z`; and `gcd x y = 1`.  (examples
include: `(3,4,5)` and `(5,12,13)`.  In this problem, we'll create a
stream that generates all pythagorean triples.

+ In the file `streams.ml`, add a definition for a stream generator
  `natpairs : int*int -> (int * int) stream` that can output all possible
  pairs of positive integers.  Your function should generate the pairs
  in "diagonal" order, by listing in order of increasing first
  component all the pairs that some to 1, then all the pairs that sum
  to 2, then 3, then 4, and so on.  Some example evaluations: `take_s
  10 (natpairs (0,0))` evaluates to
  `[(0, 0); (0, 1); (1, 0); (0, 2); (1, 1); (2, 0); (0, 3); (1, 2); (2, 1); (3, 0)]`;
  `take_s 4 (natpairs (4,5))` should evaluate to
  `[(4, 5); (5, 4); (6, 3); (7, 2)]`; and `take_s 3 (natpairs (12,1))`
  should evaluate to `[(12, 1); (13, 0); (0, 14)]`.

+ Next, add two functions that will help us: `py_triple : int*int ->
  int*int*int` takes a pair (x,y) of integers and adds a third element that
  is the integer floor of the hypotenuse length of the right triangle
  with sides given by the pair (x,y); and `py_check : int*int*int ->
  bool` checks that a triple satisfies the conditions for a
  pythagorean triple.  Some example evaluations: `py_triple (3,7)`
  evaluates to `(3,7,7)` and `py_triple (0,1)` evaluates to
  `(0,1,1)`; `py_check (3,4,5)` evaluates to true, `py_check (4,3,5)`
  evaluates to false, and `py_check (6,8,10)` evaluates to false.

+ Finally, use the higher-order stream functions included in
  `streams.ml` along with the previous functions to define a stream
  `pytrips : (int*int*int) stream` that includes all pythagorean
  triples.  Evaluating  `take_s 4 pytrips` should result in the list
  `[(3, 4, 5); (5, 12, 13); (8, 15, 17); (7, 24, 25)]`.
  

### Palindrome generator

A _palindrome_ is a string that reads the same backwards and forwards,
such as "racecar" or "madamimadam" or "amanaplanacanalpanama".  (Or
more boringly, "b", "bb", "aba", "dad")  In this problem, we'll write
a `string stream` generator that lists all of the palindromes that can
be created by appending together 0 or more strings from a given list
of words.

+ Start by adding a definition for the function `pal_check : string ->
  bool` that checks whether its argument is a palindrome to
  `hw5streams.ml`.  Your implementation should be
  case-insensitive. Some example evaluations: `pal_check "Abba"`,
  `pal_check "dAD"`, `pal_check ""`, and `pal_check "raceCar"` 
  should evaluate to `true`; and `pal_check "abc"`, `pal_check "aB"`,
  and `pal_check "nomnomcookies"` should evaluate
  to `false`.
  
+ Next, add the OCaml definition for the function `kleene_star:
  string list -> string stream` to `hw5streams.ml`.  The _Kleene
  Closure_ (also called the Kleene Star) of a list `L` of strings is the
  (inifinite) set of strings that can be constructed by concatenating
  together 0 or more strings from the list `L` (allowing for repeats).
  So for example, the Kleene star of the list `["1";"0"]` is the set
  {`""`,`"1"`, `"0"`,`"11"`, `"01"`,`"10"`,`"00"`, `"111"`,...}, and
  the Kleene star of the list `["to";"infty";"beyond"]` starts out
  with {`""`,`"to"`,`"infty"`,`"beyond"`,`"toto"`,`"inftyto"`,`"beyondto"`,
  `"toinfty"`,`"inftyinfty"`, `"beyondinfty"`...}. 

+ Finally, use an appropriate higher-order stream function to create
  the stream generator `palindromes : string list -> string stream`
  that takes a list of strings and returns a stream with all of the
  palindromes that can be created by concatenating 0 or more strings
  from the input list together.

##4. Lazy lists

In class we also discussed OCaml's built-in facility for lazy
evaluation via the `lazy` keyword and `Lazy` module.  The file
`lazylist.ml` includes our definition of the `'a lazylist` data type,
which we'll investigate further in this problem.

### lazy list functions

Give  OCaml defintions for the following functions that extend the
corresponding stream or list functions to work with `lazylist`:

+ `lzmap : ('a -> 'b) -> 'a lazylist -> 'b lazylist` .

+ `lzfilter : ('a -> bool) -> 'a lazylist -> 'a lazylist`

+ `lznatpairs : (int * int) -> (int * int) lazylist`

### lazy bfs

`lazylist.ml` also includes the declaration of a datatype `'a wtree`,
for arbitrary-width trees, and an eager algorithm `bfs` for breadth-first
traversal of a tree.  Add a definition for `lazy_bfs : 'a wtree -> 'a
lazylist` that computes the elements of the breadth-first search in
a lazy fashion.  As with our in-class demonstration of lazy
*depth*-first search, you can use the (commented-out for faster
evaluation) `deeptree` function to create very large trees that differ
at various points in the breadth-first search to see the effect of
laziness in comparing the breadth-first search of two trees.  (Notice
that to build a deep enough tree without exhausting the call stack,
`deeptree` uses continuations.)

## All done!

Don't forget to commit all of your changes to the various files edited
for this homework, and push them to your individual class repository
on UMN github:

+ `bexp.ml`
+ `lazy_eval.md`
+ `streams.ml`
+ `lazylist.ml`

You can always check that your changes haved pushed
correctly by visiting the repository page on github.umn.edu.
