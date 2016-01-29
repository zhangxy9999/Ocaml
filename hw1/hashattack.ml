(*match two cases: base case and resursion. use the if statement to check if 
 the first element in the list corespond to the key, if yes cons it 
 if not move on*)
let rec forward_search f y dict = match dict with
| [] -> []
| h::t -> if (f h = y) then h::(forward_search f y t) else (forward_search f y t)

(*use the forward_search function above, pass in parameters required for for
 ward_search, and check the output list. This function can only deal with 
 string input without a function similar to .ToString()*)
let hashattack f y dict = match (forward_search f y dict) with
| [] -> "No match found"
| h::_ -> "Found a match: " ^ h
