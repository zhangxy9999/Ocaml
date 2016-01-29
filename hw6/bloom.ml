module type memset = sig
    type elt (* type of values stored in the set *)
    type t (* abstract type used to represent a set *)
    val mem : elt -> t -> bool 
    val empty : t
    val is_empty : t -> bool
    val add : elt -> t -> t
    val from_list : elt list -> t
    val union : t -> t -> t
    val inter : t -> t -> t
  end

(* Define the hashparam signature here *)		       
module type hashparam = sig
    type t
    val hashes : t -> int list
  end
(* Define SparseSet module here, using the Set.Make functor *)			  
module IntSet = Set.Make(
    struct
        type t = int
        let compare = Pervasives.compare
    end )

module SparseSet : memset with type elt = int = struct
    include IntSet
    let from_list l = List.fold_left (fun set elem -> IntSet.add elem set) IntSet.empty l
  end

(* Fill in the implementation of the memset signature here.  You'll need to expose the elt type *)
module BitSet : memset with type elt = int = struct
    type elt = int
    type t = string
    (* Some helper functions... bitwise &, bitwise | of two char values: *)
    let (&*) c1 c2 = String.make 1 (Char.chr ((Char.code c1) land (Char.code c2)))
    let (|*) c1 c2 = String.make 1 (Char.chr ((Char.code c1) lor (Char.code c2)))	  
    (* bitwise or of two strings: *)
    let rec (&@) s1 s2 = match (s1,s2) with
      | ("",s) | (s, "") -> ""
      | _ -> (s1.[0] &* s2.[0]) ^ ((Str.string_after s1 1) &@ (Str.string_after
      s2 1))
    let rec (|@) s1 s2 = match (s1,s2) with
      | ("",s) | (s, "") -> s
      | _ -> (s1.[0] |* s2.[0]) ^ ((Str.string_after s1 1) |@ (Str.string_after
      s2 1))
    (* single-character string with bit i set: *)
    let strbit i = String.make 1 (Char.chr (1 lsl (i land 7)))

    let rec make_str_t i str = if (i < 8) then str^(strbit i) else make_str_t
        (i-8) ("\000"^str)

    let empty = ""
    let is_empty str = match str with 
        | empty -> true
        | _ -> false
    let add i str = (make_str_t i "") |@ str
    let mem i str = ((String.length str) > (i/8)) && (((Char.code str.[i/8])
        land (1 lsl (i land 7))) <> 0)
    let rec union a b = a |@ b
    let rec inter a b = a &@ b
    let from_list l = List.fold_left (fun set elt -> add elt set) empty l
  end

(* Fill in the implementation of a BloomFilter, matching the memset signature, here. *)
(* You will need to add some sharing constraints to the signature below. *)
module BloomFilter(S : memset with type elt = int)(H : hashparam) : memset with type elt = H.t = struct
    type elt = H.t
    type t = S.t
    (* Implement the memset signature: *)
    let empty = S.empty
    let is_empty bf = S.is_empty bf
    let mem item bf = List.fold_left (fun set elt -> set && (S.mem elt bf)) true (H.hashes item)
    let add item bf = List.fold_left (fun set elt -> S.add elt set) bf (H.hashes item)
    let union a b = S.union a b
    let inter a b = S.inter a b
    let from_list l = S.from_list (List.fold_left (fun set elt -> set@(H.hashes
    elt)) [] l)
  end

(* A hashparam module for strings... *)
module StringHash = struct
    type t = string (* I hash values of type string *)
    let hlen = 15
    let mask = (1 lsl hlen) - 1
    let hashes s =
      let rec hlist n h = if n = 0 then [] else (h land mask)::(hlist (n-1) (h lsr hlen)) in
      hlist 4 (Hashtbl.hash s) 
  end

(* Add the IntHash module here *)
module IntHash = struct
    type t = int
    let hashes n = let h1 a = (795*a + 962) mod 1031 in
        let h2 a = (386*a + 517) mod 1031 in
            let h3 a = (937*a + 693) mod 1031
                in [(h1 n); (h2 n); (h3 n)]
  end
