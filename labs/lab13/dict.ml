(* dict.ml - dictionary implementations for lab 13 *) 		     

(* eventually, you'll add a signature for dictionaries here *)
module type DICT = sig
  type 
  val empty : 'a -> 'b
  val add : 'k -> 'v -> ('k,'v) t -> ('k,'v) t
  val update : 'k -> ('k,'v)t -> 'v
  val lookup : 'k -> ('k,'v)t -> 'v
 end
 `
(* and one for foldable dictionaries here: *)
module FOLDABLEDICT = struct
   include DICT
   let fold f a d = List.fold_left f a d 
 end

(* Fill in the definition of dictionaries using functions, e.g. (f key) = val *)
module FunDict : DICT = struct
   type ('k,'v) t = d : 'k -> 'v
   let empty = fun k -> raise Not_found
   let add k v d =  if (k = v) then  else d k
   let update k d =  
   let lookup k d = d k
  end

(* You'll want to restrict this with a signature eventually: *)		   
module ListDict = struct
    type ('k,'v) t = ('k*'v) list
    let empty = []
    let add k v d = (k,v)::d
    let lookup k d = List.assoc k d
    let rec update k v d = match d with
      | [] -> [(k,v)]
      | (key,_)::t when key=k -> (k,v)::t
      | kv::t -> kv::(update k v t)
    let rec fold f a d = List.fold_left f a d
  end

(* And a signature will come in handy here too *)		    
module TreeDict = struct
    type ('k,'v) t = Node of ('k*'v)*(('k,'v) t)*(('k,'v) t)*int | Empty
    let empty = Empty
    let size t = match t with
      | Empty -> 0
      | Node(_,_,_,n) -> n

    let rotright p = match p with
      | Node(_,Empty,_,_) -> p
      | Node(pv,Node(qv,ql,qr,qn),pr,pn) ->
	 let pn' = (size qr) + (size pr) + 1 in
	 let p' = Node(pv,qr,pr,pn')  in
	 Node(qv,ql,p',pn)

    let rotleft q = match q with
      | Node(_,_,Empty,_) -> q
      | Node(qv,ql,Node(pv,pl,pr,pn),qn) ->
	 let qn' = (size ql) + (size pl) + 1 in
	 let q' = Node(qv,ql,pl,qn') in
	 Node(pv,q',pr,qn)
				  
    let rec rootinsert k v t = match t with
      | Empty -> Node((k,v),Empty,Empty,1)
      | Node((rk,rv),lt,rt,n) ->
	 if k = rk then Node((rk,v),lt,rt,n) else
	   if k < rk then (rotright (Node((rk,rv),rootinsert k v lt,rt,n+1)))
	   else rotleft (Node((rk,rv),lt,rootinsert k v lt, n+1))
			
    let rec insert k v t = match t with
      | Empty -> Node((k,v),Empty,Empty,1)
      | Node((rk,rv),lt,rt,n) ->
	 if (k = rk) then Node((k,v),lt,rt,n) else
	   if (k < rk) then Node((rk,rv),insert k v lt, rt, n+1)
	   else Node((rk,rv),lt,insert k v rt, n+1)
		    
    let add k v t = match t with
      | Empty -> Node((k,v),Empty,Empty,1)
      | Node(_,_,_,n) -> if Random.int (n+1) = 0 then rootinsert k v t else insert k v t

    let update = insert

    let rec lookup k t = match t with
      | Empty -> raise Not_found
      | Node((rk,rv),lt,rt,n) ->
	 if k = rk then rv else
	   if k < rk then lookup k lt
	   else lookup k rt

    let rec fold f a d = match d with
      | Empty -> a
      | Node(kv,lt,rt,_) ->
	 let a1 = fold f a lt in
	 fold f (f a1 kv) rt
  end

(* Uncommment and complete the functor definition below... 		    
module DictTest(DT1: DICT)(DT2: DICT) = struct
    let test ins_list testlist =
  end
 *)
		    
(* Make this work with any FOLDABLEDICT *)
module TreeDictUtils (TreeDict : FOLDABLEDICT) = struct
    let count_keys d = TreeDict.fold (fun c kv -> c+1) 0 d
    let keys d = TreeDict.fold (fun l (k,v) -> (k::l)) [] d
    let exists_key p d = TreeDict.fold (fun b (k,v) -> b || (p k)) false d
    let exists_val p d = TreeDict.fold (fun b (k,v) -> b || (p v)) false d
    let for_all_keys p d = TreeDict.fold (fun b (k,v) -> b && (p k)) true d
    let for_all_vals p d = TreeDict.fold (fun b (k,b) -> b && (p v)) true d
  end


(* add a few test calls testing whether FunDict and ListDict, and TreeDict and ListDict behave the same way*)
let () = ()
