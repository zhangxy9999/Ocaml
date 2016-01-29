open Bloom
module BloomSparseInt = BloomFilter(SparseSet)(IntHash)
module BloomBitInt = BloomFilter(SparseSet)(IntHash)
let rec getListOfInt n = if n = 0 then [] else 
    (Random.int (int_of_float(2. ** 30. -. 1.)))::(getListOfInt (n - 1))
let rec getListOfInt2 n = 
    let rec helper n lst = if n = 0 then lst 
    else helper (n-1) (Random.int (int_of_float(2. ** 30. -. 1.)) :: lst) in 
    helper n []
let insert_list = getListOfInt2 200
let a = Sys.time()
let createSparseInt = BloomSparseInt.from_list insert_list
let b = Sys.time()
let buildTimeSparseInt = b -. a
let a = Sys.time()
let createBitInt = BloomBitInt.from_list insert_list
let b = Sys.time()
let buildTimeBitInt = b -. a
let test_list = getListOfInt2 1000000
let a = Sys.time()
let falsePosiNum_SparseInt = List.fold_left (fun counter elt -> if
    (BloomSparseInt.mem elt createSparseInt) then counter+1 else counter) 0 test_list
let b = Sys.time()
let testTimeSparseInt = b -. a
let a = Sys.time()
let falsePosiNum_BitInt =  List.fold_left (fun counter elt -> if
    (BloomBitInt.mem elt createBitInt) then counter + 1 else counter) 0 test_list
let b = Sys.time()
let testTimeBitInt = b -. a



module BloomSparseString = BloomFilter(SparseSet)(StringHash)
module BloomBitString = BloomFilter(BitSet)(StringHash)
let file_lines fname = 
  let in_file = open_in fname in
  let rec loop acc =
    let next_line = try Some (input_line in_file) with End_of_file -> None in
    match next_line with
    | (Some l) -> loop (l::acc)
    | None -> acc
  in
  let lines = try List.rev (loop []) with _ -> [] in
  let () = close_in in_file in
  lines
let insert_list = file_lines "top-2k.txt"
let test_list = file_lines "top-1m.txt"
let a = Sys.time()
let createSparseString = BloomSparseString.from_list insert_list
let b = Sys.time()
let buildTimeSparseString = b -. a
let a = Sys.time()
let createBitString = BloomBitString.from_list insert_list
let b = Sys.time()
let buildTimeBitString = b -. a
let a = Sys.time()
let falsePosiNum_SparseString = List.fold_left (fun counter elt -> if
    (BloomSparseString.mem elt createSparseString) then counter + 1 else counter) 0 test_list
let b = Sys.time()
let testTimeSparseString = b -. a
let a = Sys.time()
let falsePosiNum_BitString = List.fold_left (fun counter elt -> if
    (BloomBitString.mem elt createBitString) then counter + 1 else counter) 0 test_list
let b = Sys.time()
let testTimeBitString = b -. a
let printLine1 = Printf.sprintf "SparseInt      : build time =   %fs test time = %fs false positive = %d\n" buildTimeSparseInt testTimeSparseInt falsePosiNum_SparseInt
let printLine2 = Printf.sprintf "BitInt         : build time =   %fs test time = %fs false positive = %d\n" buildTimeBitInt testTimeBitInt falsePosiNum_BitInt
let printLine3 = Printf.sprintf "SparseString   : build time =   %fs test time = %fs false positive = %d\n" buildTimeSparseString testTimeSparseString falsePosiNum_SparseString
let printLine4 = Printf.sprintf "BitString      : build time =  %fs test time = %fs false positive = %d\n" buildTimeBitString testTimeBitString falsePosiNum_BitString
let () = print_string (printLine1^printLine2^printLine3^printLine4)
