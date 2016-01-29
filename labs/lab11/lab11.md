# Lab 11: Midterm review

*CSci 2041: Advanced Programming Principles, Fall 2015*

**Due:** Wednesday, November 25 at 11:59pm.


## Ground rules

You must work with a partner on this lab.  Although labs are meant to
be an open and collaborative environment, it is the responsibility of
both partners to contribute to learning the materials in every lab.
In particular, both partners are responsible for ensuring that submissions are
received by the due date, and for letting us know if one teammate does
not participate in a given lab.

# Introduction: Goals for this lab

Since there will be only one lecture before the next lab, we'll use
this lab to review topics for the midterm.

## Answering the questions in this lab

Create a `lab11` directory in your team repository.

## Reasoning about programs

```
type bitlist = C0 | C1 | L0 of bitlist | L1 of bitlist
let rec bitlen blst = match blst with
| C0 | C1 -> 1
| L0 b | L1 b -> 1 + (bitlen b)

let rec bitweight blst = match blst with
| C0 -> 0
| C1 -> 1
| L0 b -> bitweight b
| L1 b -> 1 + (bitweight b)
```

In a file named induction.md:

+ State the principle of structural induction for type `bitlist`

+ Prove by induction that for all `bl`&in;`bitlist`, `bitweight bl <=
  bitlen bl`.

## Take a look at the practice midterm

In a file named `practice.md`, record your solution to at least one problem
from the [midterm 2 practice problems](https://github.umn.edu/csci2041-f15/hw2041-f15/blob/master/midterm2-practice.md).
Discuss other problems with your partner as time allows.

# Commit and push so that everything is up on GitHub

Now you need to just turn in your work. Commit your `induction.md`
and `practice.md` files and push them up to your central GitHub repository. 

Verify that this worked, by using your browser to see the changes on
https://github.umn.edu.

If you do not properly push your changes to the repository we
cannot give you credit for the lab, so please remember to do this
step!

__This concludes lab 11.__

**Due:** Wednesday, November 25 at 11:59pm.

Note that any required changes must exist in your repository on
github.umn.edu. Doing the work but failing to push those changes
to your central repository will mean that we cannot see your work
and hence can't grade it.
