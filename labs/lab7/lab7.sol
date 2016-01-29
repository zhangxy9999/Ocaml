*********Binary Coefficients***********

let rec choose n k = 
 if (n=k) || (k = 0) then 1
 else ((choose (n-1) (k-1))*n)/k


Base Case: 
P(0):  0 = (0(0-1)(k-1))/k = 0 (*Anything times zero = zero)

Inductive case:
P(n) = P(x+1)

((choose x (k-1))*(x+1))/k <=> (x+1)!/(((x+1)-k)! * k!)
(x!/((x-(k-1))! * (k-1)!))(x+1)/k = (x+1)!/(((x+1)-k)! * k)! *[by IH]**
((x+1)!/((x-k+1)! * (k-1)!)/k = (x+1)!/(((x+1)-k)! * k)! [by arith]
((x+1)!/((x-k+1)! * (k-1)! * k) = (x+1)!/(((x+1)-k)! * k)! [by arith]
((x+1)!/((x-k+1)! * k!) = (x+1)!/(((x+1)-k)! * k)! [by arith]
(x+1)!/(((x+1)-k)! * k)! = (x+1)!/(((x+1)-k)! * k)! [by arith]

**********Structured Arithmetic***********
type nat = Zero |Succ of nat

let rec to_int n = match n with
| Zero -> 0
| Succ n -> 1 + (to_int n)

let rec minus_nat m n = match (m,n) with
| (_, Zero) -> m
| (Zero, _) -> invalid_arg "minus_nat not a natural number!"
| (Succ m1, Succ n1) -> minus_nat m1 n1

Base Case:
P(0):

0 = (to_int O) = (to_int Zero) = 0

Inductive Case: 
P(x) = P(Succ x)

to_int (minus_nat x n) = (to_int x) - (to_int n)
to_int (minus_nat (Succ x) n) = (to_int((minus_nat x n'))) // n'= Succ n


******Structured Comparisons***********

let rec eq_nat n1 n2 = match (n1,n2) with
| (Zero, Zero) -> true
| (Zero, _) | (_, Zero) -> false
| (Succ n1', Succ n2') -> eq_nat n1' n2'

Base Case:
P(0):

eq_nat 0 0 (because n1 = n2 in this case) = true
Hittiing the (zero, zero) case

Inductive Case
P(n1) = P(Succ n)

Inductive Hypothesis:
(to_int n1 = to_int n2) = eq_nat n1 n2

3 cases

for both n,n2 > 0 

to_int(Succ n) = to_int(n2) = eq_nat (Succ n) (n2)
1+to_int(n) = 1 + to_int n2 = eq_nat (Succ n) n2 (by eval of to_int)
to_int(n) = to_int(n2) = eq_nat (Succ n) n2 (arithmetic)
to_int(n) = to_int(n2) = eq_nat (n) (n2') (by eval of eq_nat) (true by IH)

for n2 = 0:
to_int(Succ n) = to_int (n2) = eq_nat (Succ n) (n2)
1+to_int(n) = 0 = eq_nat(Succ n) (n2) (by eval of to_int)
1+to_int(n) = 0 = eq_nat(n) (0) (by eval of eq_nat) = false


for n2 > 0 and not = to n
to_int(Succ n) = to_int(n2) = eq_nat(Succ n) (n2)
1+to_int(n) = 1+to_int(n2) = eq_nat (Succ n ) (n2) (assuming first half is false, by eval of to_int) 
1+to_int(n) = 1+to_int(n2) = eq_nat n n2' (by eval of eq_nat, will recurse until n or n2 hits zero and return false) (true by IH)

