(* add up the integers greater than 0 and at most n *)
let rec nsum n = if n = 0 then 0 else (if n > 0 then n + nsum (n - 1) else n + nsum (n + 1))
(* compute 0 + 1 + 2 + ... + 10 *)
let n10 = nsum (-1)
