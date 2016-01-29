# Lab 14: Side Effects and Mutable Data Structures

*CSci 2041: Advanced Programming Principles, Fall 2015*

**Due:** Wednesday, December 16 at 11:59pm.


## Ground rules

You must work with a partner on this lab.  Although labs are meant to
be an open and collaborative environment, it is the responsibility of
both partners to contribute to learning the materials in every lab.
In particular, both partners are responsible for ensuring that submissions are
received by the due date, and for letting us know if one teammate does
not participate in a given lab.

# Introduction: Goals for this lab

+ Work with side effects and mutable data structures

## Answering the questions in this lab

Create a `lab14` directory in your team repository and copy the
`mutlist.ml`, `mutbloom.ml`, `bloom.cmo`,`bloom.cmi`, `bloomtest.cmo`,
and `bloomtest.cmi` files to this directory; we'll work with the
contents of these files in the following sections.

## Mutable lists

`mutlist.ml` defines the type `'a mlist`, a mutable list data
structure, and functions `mlist_of_list` and `list_of_mlist`
for converting between OCaml `list` values and `mlist` values.

In this problem, we'll write a few functions to manipulate mutable
lists; the equivalent immutable list versions already appear in
`mutlist.ml`:

+ `insert_after_m : 'a -> 'a -> 'a mlist -> unit`: this function
  performs a destructive update to its `mlist` argument: `insert_after_m
  a b ml` should modify ml so that the value `b` appears after the
  first instance of `a` in `ml`.  For example:
```
# let m1 = mlist_of_list [2;3;5;11] ;;
val m1 : int mlist = C {hd = 2; tl = C {hd = 3; tl = C {hd = 5; tl = C {hd = 11; tl = Nil}}}}
# insert_after_m 5 7 ml;;
- : unit = ()
# list_of_mlist m1 ;;
- : int list = [2; 3; 5; 7; 11]
```
  `insert_after_m` should raise `Not_found` if no instance of `b` is
  encountered.

+ `exclude_m : ('a -> bool) -> 'a mlist -> 'a mlist`: this function
  destructively updates an mlist; `exclude_m p ml` should return a
  list that excludes all elements of `ml` that satisfy the predicate
  `p`.  For example:
```
# let m2 = mlist_of_list [1;2;3;4;5;6;7;8;9;10] ;;
# exclude_m (fun x -> x mod 2 = 0) m2 ;;
- : int mlist = C {hd = 1; tl = C {hd = 3; tl = C {hd = 5; tl = C {hd = 7; tl = C {hd = 9; tl = Nil}}}}}
# list_of_mlist m2 ;;
- : int list = [1; 3; 5; 7; 9]
# exclude_m (fun x -> x mod 3 = 1) m2 ;;
- : int mlist = C {hd = 3; tl = C {hd = 5; tl = C {hd = 9; tl = Nil}}}                                                                                            
# list_of_mlist m2 ;;
- : int list = [1; 3; 5; 9]
```
  (Notice that only elements after the first element that does not
  satisfy `p` are permanently removed from the list.  Why?  How could
  we change the interface to exclude_m to prevent this problem?)

## Mutable BitSets and Bloom Filters revisited

In HW6, we created an implementation of sets treating strings as
bitmaps.  The `bloomtest` results reported in `hw6.md` were accurate -
the `BitSet` module is 5-10x faster than `SparseSet` for membership
testing in bloom filters, but 100x slower for creating sets, because
we built strings by concatenating them together one character at a
time.  However, now that we know that strings are mutable, we can
avoid this expense in the from_list and bitwise helper functions by
creating a string of the appropriate length to hold the result, and
setting bits as needed.  The file `mutbloom.ml` contains a partially
completed implementation of this idea.  In order to test it in utop,
you will need to `#load "bloom.cmo"` and `#load "bloomtest.cmo"`;
let's fill in the rest of the `BitSetMutable` module:

+ The bitwise and operator, `(&@) : string -> string -> string`,
  should create a string long enough to hold the bitwise logical-and
  of its arguments, where we imagine that the shorter string is padded
  with `'\000'` characters.  (Note: to create a string of `l` copies
  of some character `c`, we can use `String.make l c`.)

+ The function `set_bit : string -> int -> string`: `set_bit s i`
  should return either the string `s` or a `'\000'`-padded copy of `s`
  with bit `i` set to `1`.  (Note that the `extend` function can
  efficiently produce a padded copy of `s` to a given length.)

Once you've implemented the rest of `BitSetMutable`, uncomment the
line that runs a timed test to see how much we've improved the Bloom filter
construction time. 

## Do a Happy Dance

**Congratulations, you're done with everything but the final exam**

You might want to check out the practice exam before then; see moodle
for details.

# Commit and push so that everything is up on GitHub

Now you need to just turn in your work. Commit your `mutlist.ml` and `mutbloom.ml`
files and push them up to your central GitHub repository. 

Verify that this worked, by using your browser to see the changes on
https://github.umn.edu.

If you do not properly push your changes to the repository we
cannot give you credit for the lab, so please remember to do this
step!

__This concludes lab 14.__

**Due:** Wednesday, December 16 at 11:59pm.

Note that any required changes must exist in your repository on
github.umn.edu. Doing the work but failing to push those changes
to your central repository will mean that we cannot see your work
and hence can't grade it.
