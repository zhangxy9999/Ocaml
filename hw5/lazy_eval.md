+ `take 3 (squares 3) `
```
take 3 (3 * 3)::(squares 4)
9::(take 2 (4 * 4)::(squares 5))
9::16::(take 1 (5 * 5)::(squares 6))
9::16::25::(take 0 (squares 6))
9::16::25::[]
```


+ `fold_right (&&) (map ((<) 0) (squares 2)) true`
```
fold_right (&&) (map ((<) 0) 4::(squares 3)) true
fold_right (&&) true::(map ((<) 0) (squares 3)) true

This will never reach an endunder lazy eval since the map function
will never reach to a false by having a infinite squares function.
```


+ `fold_right (||) (map (fun n -> mod 8 = 0) (factorials ())) false`
```
fold_right (||) (map (fun n -> mod 8 = 0) 1::(fac_acc 1 1)) false
fold_right (||) false::(map (fun n -> mod 8 = 0) 1::(fac_acc 2 1)) false
fold_right (||) (map (fun n -> mod 8 = 0) 1::(fac_acc 2 1)) false
fold_right (||) false::(map (fun n -> mod 8 = 0) 2::(fac_acc 3 2)) false
fold_right (||) (map (fun n -> mod 8 = 0) 2::(fac_acc 3 2)) false
fold_right (||) false::(map (fun n -> mod 8 = 0) 6::(fac_acc 4 6)) false
fold_right (||) (map (fun n -> mod 8 = 0) 6::(fac_acc 4 6)) false
fold_right (||) false::(map (fun n -> mod 8 = 0) 24::(fac_acc 5 24)) false
fold_right (||) (map (fun n -> mod 8 = 0) 24::(fac_acc 5 24)) false
fold_right (||) true::(map (fun n -> mod 8 = 0) 120::(fac_acc 6 120)) false
true
```


+ `take (sum_list (squares 1)) (factorials ())`
```
take (sum_list 1::(squares 2)) 1::(fac_acc 1 1)
take 1+(sum_list 4::(squares 3)) 1::(fac_acc 1 1)
1::(take 4+(sum_list 9::(squares 4)) (fac_acc 1 1))

This will never reach an end because the first parameter of take will
never be evaluated to 0.
```


