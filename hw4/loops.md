*Please open the markdown file in text editors if it doesn’t show up correctly in GitHub viewer*

state here: (i, fi)

```
let flsearch (f: int->int) (n:int) = {
    let i = 0;
    let fi = f 0;
    let rec loop (i, fi) =
        if (i <= n && fi <= 0) then
            loop (i+1, f (i+1))
        else (i, fi)
    let i, fi = loop (i, fi);
    i
}
```

####for all f, for all n, if (f n) > 0 then f (lsearch f n) > 0
loop invariant: 
base case: flsearch f 0 = 1   by eval and precondition
inductive case:
we want to prove that for all f for all n,
when (f n) > 0 then (lsearch f n) = n
=> for all n, (i’, fi’) = loop (i, fi)
=> (i’, fi’) = ((i + 1), (f (i + 1)))

when 

####for all f, if (f 0) < 0 then for all n, i < (lsearch f n) -> (f i) < 0
base case: 
