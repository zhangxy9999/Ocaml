Write the step-by-step lazy evaluation of each of the following _`lazyCaml`_ expressions; or if the expression does not terminate with a normal form, state why:
```
take 2 (dfs (crazytree 2 "run"))
```
```
take 2 (dfs (Node(crazytree 1 “arun”, crazytree 2 “buffalorun”)))
take 2 ((dfs crazytree 1 “arun”)@(dfs crazytree 2 “buffalorun”))

Doesn’t terminate, never fulfill the moving on condition for take.
````




```
treefind (crazytree 1 "?") "abuffalo?"
```
````
treefind (Node(crazytree 0 “a?”, crazytree 1 “buffalo?”) “abuffalo?”)
(treefind (crazytree 0 “a?”) “abuffalo?”) || (treefind (crazytree 1 “buffalo?) “abuffalo?”)
(treefind (Leaf “a?”) “abuffalo?”) || .....
false || (treefind (Node(crazytree 0 “abuffalo?, crazytree 1 “buffalobuffalo?)) “abuffalo?”)
false || (treefind (crazytree 0 “abuffalo?”) “abuffalo?”) || (treefind (crazytree 1 “buffalobuffalo?”) “abuffalo?”)
false || (treefind (Leaf “abuffalo?”) “abuffalo?”) || .....
false || true || ......
true
```



```
treefind (crazytree 1 "!") "buffalobuffalo!"
```
```
treefind (Node(crazytree 0 “a!”, crazytree 1 “buffalo!”) “buffalobuffalo!”)
(treefind (crazytree 0 “a!”) “buffalobuffalo!”) || (treefind (crazytree 1 “buffalo!”) “buffalobuffalo!”)
(treefind (Leaf “a!”) “buffalobuffalo!”) || ......
false || (treefind (Node(crazytree 0 “abuffalo!”, crazytree 1 “buffalobuffalo!”)) “buffalobuffalo!”)
(treefind (crazytree 0 “abuffalo!”) “buffalobuffalo!”) || (treefind (crazytree 1 “buffalobuffalo!”) “buffalobuffalo!”)
(treefind (Leaf “abuffalo!”) “buffalobuffalo!”) || .....
false  || ......
treefind (creazytree 1 “buffalobuffalo!”) “buffalobuffalo!”

Doesn’t treminate, creazytree will never output “buffalobuffalo!”.
````
