open Bloom
open Bloomtest
let rec rand_list n acc = if n=0 then acc else (rand_list (n-1) ((Random.int ((1 lsl 30)-1))::acc))

module BitSetMutable : memset with type elt = int = struct
    type elt = int
    type t = string
    let mem i s = (String.length s > (i/8)) && ((Char.code s.[i/8]) land (1 lsl (i land 7))) <> 0
    let empty = ""
    (* Some helper functions... bitwise &, bitwise | of two char values: *)
    let (&.) c1 c2 = Char.chr ((Char.code c1) land (Char.code c2))
    let (|.) c1 c2 = Char.chr ((Char.code c1) lor (Char.code c2))	  
    let shortlong s1 s2 = if String.length s1 < String.length s2 then (s1,s2) else (s2,s1)

    let rec (|@) s1 s2 =
      let (sh,lng) = shortlong s1 s2 in
      let result = String.copy lng in
      String.iteri (fun i c -> result.[i] <- c |. result.[i]) sh ; result 

    (* fill in the bitwise AND function below.  If two strings have unequal length, 
       we imagine the shorter string being padded with '\000' chars.  ehe result 
       should have the same length as the longer string, however: *)
    let rec (&@) s1 s2 = 
	let (sh,lng) = shortlong s1 s2 in 
	let result = String.copy lng in 
	String.iteri (fun i c -> result[i] <- c &. result.[i] sh; result

    (* single character with bit i set: *)
    let chrbit i = Char.chr (1 lsl (i land 7))

    (* create a string with bit i set *)			    
    let rec make_str_t i =
      let result = String.make ((i+8)/8) '\000' in
      result.[i/8] <- chrbit i ; result
												    
    let is_empty s = (s = String.make (String.length s) '\000')
    let add i s = s |@ (make_str_t i)
    (* if s is too short to set bit i, extend it with zeroes: *)
    let extend s i =
      let s' = String.make ((i+8)/8) '\000' in
      String.blit s 0 s' 0 (String.length s) ; s'
			 
    (* s with bit i set.  we may need to extend s first: *)
    let rec set_bit s i = if ( i < 8) then ( s^(strbit.i) ) else (set_bit (i-8) ("\000" ^ s))
											    		      
    let from_list l = List.fold_left set_bit "" l
    let union s1 s2 = s1 |@ s2
    let inter s1 s2 = s1 &@ s2 
  end

(* Make a BloomFilter module using BitSetMutable and IntHash *)
module BloomBitMutInt = BloomFilter(BitSetMutable)(IntHash)

(* Make a TimeTest module using the BloomBitInt module *)
module Tester = TimeTest(BloomBitMutInt)

(* Make some test and insertion lists: *)
let ilist = rand_list 200 []
let tlist = rand_list 1000000 []
		      
(* Run a TimeTest.  Uncomment this line when BitSetMutable is finished: *)
let () = Tester.run_test ilist tlist "BitSetMut" 
