### bitweight b1 <= bitlen b1

for all p, ( p (C0) ^ P (C1) ) ^ p(x) -> P(L0 x ), P(x) -> P(L1 x)

## Base Case 

bitweight CO  <= bitlen C0 
0 <= 1 [by eval]

bitweight C1 <= bitlen C1 
1 <= 1 [by eval]

## IH

bitweight b1 <= bitlen b1

#IC

bitweight (l0 x) <= bitlen (l0 x)
bitweight x <= 1 + bitlen x [by eval, true by IH]

bitweight (l1 x) <= bitlen (l1 x)
1 + bitweight x <= 1+ bitlen x [by eval, true by IH]





