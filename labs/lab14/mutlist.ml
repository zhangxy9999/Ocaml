type 'a mlist = Nil | C of 'a mcell
 and 'a mcell = { hd : 'a ; mutable tl : 'a mlist }

let rec mlist_of_list lst = match lst with
  | [] -> Nil
  | h::t -> C {hd = h; tl = mlist_of_list t }

let rec list_of_mlist ml = match ml with
  | Nil -> []
  | C mc -> mc.hd :: (list_of_mlist mc.tl)
		       
(* Create a new list with b after the first occurence of a.
   raise Not_found if lst does not contain any occurrences of a *)		       
let rec insert_after a b lst = match lst with
  | [] -> raise Not_found
  | h::t -> if h=a then h::(b::t) else h::(insert_after a b t)

(* Create a list of all items in lst that do not satisfy the predicate p *)					    
let rec exclude p lst = match lst with
  | [] -> []
  | h::t -> let et = exclude p t in
	    if (p h) then et else h::et

exception Not_found

(* Modify the list ml to insert b after the first occurence of a *)
let rec insert_after_m a b ml = match ml with
| Nil -> raise Not_found
| C mc -> if (mc.hd = a) then C{hd = (mc.hd); tl = insert_after_m a b (b::mc.tl) } (*Use an exception to quit after inserting b?*)
			 else (insert_after_m a b mc.tl)

(* Modify the list ml to exclude all items that satisfy the predicate p *)				  
let rec exclude_m p ml = match ml with
| Nil -> []
| C mc -> let et = exclude_m p mc.tl in 
	  if (p mc.hd) then C{ hd = h; tl = (exclude_m p mc.tl) } else et
