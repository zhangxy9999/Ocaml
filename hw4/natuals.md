*Please open the markdown file in text editors if it doesn’t show up correctly in GitHub viewer*

##power
base case: show that power 0 x = x^0
           P(0) = power 0 x
                = 1.0           by eval
                = x^0           by identity of power of natural number
IH: power n x = x^n
step case: show that power n x = x^n where power (n-1) x = x^(n-1) holds by the inductive hypothesis
           P(n) = power n x
                = x *. power (n-1) x    by eval
                = x *. x^(n-1)          by IH
                = x^n                   since n-1 plus one is n


##pow_nat
for all n, P(n) if P(Zero) and P(Succ n) if P(n) holds

base case: P(Zero, x) = power Zero x => x^(to_int Zero) 
power (Zero, x)
= 1.0               by definition of power
= x^0               by identity of power of natural number
= x^(to_int Zero)`  by definition of to_int`

inductive case: P(Succ n, x) => x^(to_int Succ n)
IH:  power n x = x^(to_Int (Succ n))
power (Succ n, x)
= x * power n x        by definition of power
= x * x^(to_int n)     by IH
= x^(to_int (n+1))      by identity of power of natural number
= x^(to_int (Succ n))   by definition of to_int


##less_nat
base case: P(x Zero) = less_nat x Zero => (to_int x) < (to_int Zero)
less_nat x Zero
= False                         by eval
= (to_int x) < (to_int Zero)    by property of to_int

IH: for all y belongs to Nat, less_nat x y = (to_int x) < (to_int y)
inductive case: P (x, Succ y) => (to_int x) < (to_int (Succ y))
less_nat x (Succ y)
= less_nat x (1+y)              by definition of to_int
= (to_int x) < (to_int (y+1))   by IH
= (to_int x) < (to_int (Succ y)) by definition of to_int
