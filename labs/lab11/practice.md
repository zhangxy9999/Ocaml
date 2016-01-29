val strange: string -> 'a

the exception strange has type string and is also applied with some value x. 
So raise will be type string -> with 'a because we do not have more infomation about x

let filter_k f lst = 
 let rec help f lst k = match lst with
 | [] -> k
 | h::t -> if (f h) then help f t (fun result -> k(f h))
  		    else help f t (fun result -> k result)
 in help f lst (fun x -> x)

let append_k l1 l2 = match l1 with
 let rec help l1 l2 k = match l1 with
 | [] -> k l2
 | h::t -> help t l2 (fun x -> k h)
 in help l1 l2 (fun x -> x)

let rec zip_k l1 l2 = 
 let rec help l1 l2 k = match (l1,l2) with
 | ([],_) | (_,[]) -> k[]
 | (h::t),(h'::t') -> help t t' (fun result -> k((h,h')::result))
 in help l1 l2 (fun x -> x)
