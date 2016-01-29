*Please open the markdown file in text editors if it doesn’t show up correctly in GitHub viewer*

###length l = length (reverse l)
base case: P([]): length (reverse []) = length ([])
length (reverse [])
= length [] by definition of reverse (proved in class)
inductive case: P(x::l): length (reverse x::l) = length (x::l)
IH:length (reverse l) => length l
length (reverse (x::l))
= length (reverse l@[x])        by definition of tail_reverse
= length (reverse l) + length [x] by definition of length
= length l + length [x]         by IH
= length [x] + length l         by commutative rule
= length ([x]@l)                by definition of length
= length (x::l)                 by property of list


###tail_sum l = tail_sum (reverse l)
base case: P([]): tail_sum (reverse []) = tail_sum ([])
tail_sum (reverse [])
= tail_sum []   by definition of reverse

inductive case: P(x::l): tail_sum (reverse x::l) = tail_sum (x::l)
IH:tail_sum (reverse l) => tail_sum l
tail_sum (reverse (x::l))
= tail_sum (reverse l@[x])          by definition of reverse
= tail_sum (reverse l) + tail_sum [x]  by definition of length
= tail_sum l + tail_sum [x]         by IH
= tail_sum [x] + tail_sum l         by commutative rule
= tail_sum ([x]@l)                  by definition of tail_sum
= tail_sum (x::l)                   by property of list
