# Homework 3:  Map, Fold, and More Program Manipulation
*CSci 2041: Advanced Programming Principles, Fall 2015*

**Due:** Friday, October 23 at 11:59pm


##1. Document Similarity without recursion
### ** READ THIS PART, IT EXPLAINS WHAT YOU ARE SUPPOSED TO DO! **

In this problem, we will write an entire command-line application that
computes an iterative task without any explicit recursion or looping. 

The problem our application will solve is based on the idea of
*document similarity*, which is a first step in many "big data"
applications such as improving search, automated document
classification, automated document summary, authorship attribution,
and plagiarism detection.  In this task, we are given a (text) document `d`
to classify along with a list of "representative" documents
`[r_1; r_2; ...; r_N]`, and choose the document `r_i` that is most
"similar" to `d`.   Your program will be run from the command line
with two arguments - the name of a file listing the files holding the
representative documents, and the name of a target file.  Eventually,
your program will compare this target file to each file listed in the
first file, decide which is the most similar, and print out a message
reporting the most similar document and how close it is to the target
document.

The beginnings of this application, as well as some examples you can
use to test it, are stored in the directory named "`similarity`," which
you should work in so as to avoid directory clutter.  Follow along as
we build our application:

### Reading the file list

Your program should read the list of names of representative files from a file
whose name is passed in as the first command line argument.  For
instance, if we call your program from the command line as
`similar.native replist.txt example.txt` then the file `replist.txt`
should contain a list of representative text files, one on each line.
The file `similar.ml` contains definitions for the two I/O functions
you'll need for this assignment: `file_lines : string -> string list`
takes as input a file name and returns a list of lines in the file.
Add a line to `similar.ml` that reads the file named in `Sys.argv.(1)` and
binds the list to a reasonable name.

### Reading the representative files, and the document

The other function already defined in `similar.ml` is `file_as_string :
string -> string` and given a file name, it returns the entire
contents of the file as a string. Use an appropriate `List` function to obtain a
`string list` whose elements (of type `string`) contain the text
of each representative document.

You should also use `file_as_string` to read the contents of the
document we will attempt to classify.  The name of this file will be
passed on the command line as the second argument, `Sys.argv.(2)`.

### Splitting into words

Our distance mechanism treats text documents as sets of words.  In
anticipation of this, we'll want to "split" the contents of each text file
into a list of words.  The function `split_words : string -> string list`
defined in `similar.ml` will accomplish this goal, but it has some
pecularities:

1.  First, the function doesn't handle punctuation, digits
	and other non-alphabetic characters well.  We can handle this by
	"preprocessing" the string using `String.map` to turn any
	non-alphabetic character into a space, `' '`.

2. Second, the `string list` returned will include some strings that
   are just sequences of space characters.  We can remove these from the
   result of `split_words` using a `List` higher-order function;
   `String.contains s c` will tell us if string `s` contains character
   `c`.

Define a function, `words : string -> string list` that combines the
preprocessing in step 1 with a call to `split_words` and the
postprocessing (removing whitespace strings) in step 2 into a single
function. Some examples: `words "I am *not* 42 letters long"` should
evaluate to `["I"; "am"; "not"; "letters"; "long"]` and `words
"one_word"` should evaluate to `["one"; "word"]`.  Remember, use `let`
and `List` and `String` functions only (plus `split_words`), no
recursion!

Once you've got `words` working, add two let bindings that: 

+ create a list of lists of words, one list for each representative text file
+ create a list of the words in the target text file
   
### Canonicalization

There can be many forms of the same word in a document, for example
`Run`, `RUN`, and `run` are all the same word, and `runs`, and
`running` are also forms of the same word.  The process of converting
different forms of a value to the same internal representative is
called *cannonicalization* and in text processing is also called
*stemming*.  The file `stemmer.ml` contains code to stem a word: you
can access the stemming function as `Stemmer.stem : string -> string`.
(Two notes: First, don't worry about trying to understand what this
module does; think of it as a black box.  Second, if you want to be
able to access this function in `utop`, you need to `#mod_use
"stemmer.ml";;` to read and compile it as a module for use in the
toplevel shell.)

Add let bindings to stem all of the words created in the previous step.

### Converting to sets

Since we're actually representing each text document by the _set_ of
stems it contains, rather than the _list_ of stems (so, no
duplication!), we need a function to convert lists into sets.  Add a
function definition (using `let`, not `let rec`) for the function
`to_set : 'a list -> 'a list` using an appropriate `List` higher-order
function (you may find it useful to also use `List.mem` somewhere in
your definition).  Some examples: `to_set ["a"; "b"; "a" ; "b"]` should
evaluate to `["a"; "b"]` and `to_set ["a"; "a"; "b"; "c"; "b"; "a"]` should evaluate
to `["a"; "b"; "c"]`.

Add let bindings to convert the list of lists of stems into a list of
sets of stems from the representative documents, and convert the list
of stems from the target document into a set of stems.

### Define the similarity function

We define the similarity between two documents to be the ratio of the
size of the intersection of their stem sets to the size of the union
of their stem sets.  Add function definitions that use `List`
functions to compute the `intersection_size : 'a list -> 'a list ->
int`, the intersection size of two sets represented by lists (you may
assum the inputs are proper sets with no repeated elements);
`union_size : 'a list -> 'a list -> int`, the size of the union of two
sets represented by lists; and `similarity : 'a list -> 'a list ->
float`.  (Don't forget to convert to floats before the division!)
Some examples: `intersection_size ["a"; "b"] ["a"]` should evaluate to
`1`, `union_size ["a"; "b"] ["a"]` should evaluate to `2` and
`similarity ["a"; "b"] ["a"]` should evaluate to `0.5`.

### Compute the closest document

Now that we have stem sets for all of the representative files and the
target file, and a function to compute set similarity, we can compute
which representative file is most simliar to the target text file, and
its similarity to the target file.  Add a let binding that finds the
name of the most similar representative file (Recall that much
earlier, you computed a list of representative file names) and the
similarity in one `List` function call.  Two notes:

+ You might find one of the 2 list functions useful for this task
(e.g. one of `List.map2`, `List.fold_left2`, `List.fold_right2`...)

+ You'll probably find it easier to define the element processing
  function using a separate let binding, for readability.


### Print out the result

Finally, now that you have the result, print out two lines telling us
the result.  On the first line, you should print ` "The most similar
file to <target file name> was <representative file name>"`, and on
the second line, print "Similarity: <score>".

Testing it out: the directory `corpus` contains a set of 10 text files
taken from the beginnings of 10 random wikipedia articles.  The files
`rlist1` and `rlist2` contain different subsets of the corpus. If you
build your application using `ocamlbuild -lib str similar.native`,
then you should see the following behaviors:
```
(repo-user1234/hw3/similarity ) % ./similar.native rlist2 corpus/archivproduktion.txt 
The most similar file to corpus/archivproduktion.txt was ./corpus/liltroy.txt
Similarity: 0.102803738318
(repo-user1234/hw3/similarity ) % ./similar.native rlist2 corpus/christinecaughey.txt 
The most similar file to corpus/christinecaughey.txt was ./corpus/beatrizenriquezdearana.txt
Similarity: 0.0809248554913
(repo-user1234/hw3/similarity ) % ./similar.native rlist1 corpus/charlesfrench.txt 
The most similar file to corpus/charlesfrench.txt was ./corpus/archivproduktion.txt
Similarity: 0.0915492957746
(repo-user1234/hw3/similarity ) % ./similar.native rlist1 corpus/liltroy.txt 
The most similar file to corpus/liltroy.txt was ./corpus/mrmusic.txt
Similarity: 0.103703703704
```
##2. Computing With Program Representations

In the directory `program`, there are several files related to program representations.
The file `program.ml` contains an implementation of the data structure 
for representing simple programs that we covered in Lectures 15-17,
along with the type-checking algorithm and evaluation program.  The
file `interpreter.ml` includes a parser that transforms prefix-form
programs into syntax trees, type-checks these trees, and evaluates
them.  There are also two very non-descriptively named example
programs, `program1.interp` and `program2.interp`.  Look over these
programs carefully to convince yourself that you understand how they
work, since you'll be modifying them to add new functionality in this
problem.  (Note: to see `interpreter.ml` or one of the
`program1.interp` or `program2.interp` programs in action, you'll need
to build `interpreter.native` by running `ocamlbuild -lib str
interpreter.native` in the `program` directory.)

### Adding Input Statements

So far, programs in our example can do a lot of interesting things:
for instance, they can run loops, define and call functions, perform
arithmetic and boolean computations, and print out the results of
these computations.  But, there's no way in our language to read an
input from the user.  Let's add a command, `readint` that reads a
single integer into the program.  Programs use this command as if it
were an integer-valued expression, so for example, `(let i readint (print
i))` is a program that reads an integer, binds it to the name `i` and
then prints out `i`. In order to do this, we'll need to:

+ Add a new variant to the `expr` type in `program.ml` for a `Readint`.
+ Add a new variant to the `token` type in `interpreter.ml` for the
`readint` keyword.
+ Modify the lexing functions to correctly detect and output `readint`
tokens
+ Modify the parsing function to correctly parse the expression
`readint`
+ Modify the type checking function, `typeof`, to infer the right type
of `readint`
+ Modify the evaluation function to read an integer whenever it
  encounters a `Readint` expression.  You can use the ocaml function
  `read_int ()` to read an integer from the standard input.

Once you've got this all working, you can modify the example program
`program1.interp` so that it reads the values `m` and `n` as input and
then prints the gcd of these values.  (Go ahead and test it out.)

### Constant Folding

A common compiler optimization is to find expressions that contain
only constants and to simplify these expressions before running the
program.  For example, if a loop contains the expression `Add(Const 1,
Mul (Const 2, Mul (Const 3, Const 7)))` the compiler might replace it
with `(Const 43)`, saving one addition and two multiplication
operations every time we execute the loop.  In this problem, we'll
write a function, `const_fold : expr -> expr` that performs this
optimization on a program tree from our language.

Your function should take as input an expression, identify all
subexpressions that consist only of constants and operations on
constants (add, multiply, divide, subtract, and, or, not, comparisons)
and return a new expression that simplifies those expressions to the
constants they represent.  In addition, your program should also
detect and simplify the following situations:
+ `While(Boolean false, body)` should simplify to `Seq []`, an empty
sequence;
+ `If (Boolean true, thn,els)` should simplify to `thn`; 
+ `If (Boolean false, thn, els)` should simplify to `els`;
+ Any constant expression before the last one in a `Seq` can be
  removed; An expression of the form `Seq [e]` where `e` is a constant
  expression can be simplified to `e`.
+ `Let(s,v,b)` can be simplified to `b` if both `b` and `v` can be
  simplified to constants.

Add your definition of `const_fold` to `interpreter.ml` and modify
`interpreter.ml` so that it peforms constant folding on `progExpr`,
checks to make sure that the resulting program has the same type as
`progExpr`, and then evaluates the constand-folded program rather than
the original.

## All done!

Don't forget to commit all of your changes to the various files edited
for this homework, and push them to your individual class repository
on UMN github:

+ `similarity/similar.ml`
+ `program/program.ml`
+ `program/interpreter.ml`
+ `program/program1.interp`

You can always check that your changes haved pushed
correctly by visiting the repository page on github.umn.edu.
