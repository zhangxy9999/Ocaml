(*#load "str.cma"
#mod_use "Stemmer.ml"*)
(* The only explicit recursion in this file should be in this pre-defined function *)
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

let file_as_string fname = String.concat "\n" (file_lines fname)
			 
let split_words = Str.split (Str.regexp "\\b") 

(* Your code goes here: *)
(* Read the list of representative text files *)
let get_list fname = file_lines fname
(* Read	the contents of each text file: *)
let read_content fname = file_as_string fname
let read_contents fnames = List.map file_as_string (file_lines fnames)

(* Read the contents of the target text file *)

				   
(* Define the function that converts a string into a list of words *)			
let words doc = List.filter (let f x = not (String.contains x ' ') in f)
                            (split_words (String.map (let f x = (if (
                                ((Char.code x > 96) && (Char.code x < 123)) ||
                                ((Char.code x > 64) && (Char.code x < 91)))
                            then x else ' ') in f) doc))
					   
(* Store the list of words from each representative *)
let get_rep_listoflist fname = List.map words (read_contents fname)

(* Convert the target text file into a list of words *)
let get_target_wordlist fname = words (read_content fname)

(* Use Stemmer.stem to stem all of the words in the input, but only if I can make stemmer work. *)
let stem_reps fname = List.map (let f x = List.map Stemmer.stem x in f) (get_rep_listoflist fname)
let stem_targ fname = List.map Stemmer.stem (get_target_wordlist fname)
(* Define a function to convert a list into a set *)
let to_set lst = List.rev (List.fold_left (fun acc h -> if (List.mem h acc) then
    acc else h::acc) [] lst)

(* Convert all of the stem lists into stem sets *)
let clean_reps fname = List.map to_set (stem_reps fname)
let clean_targ fname = to_set (stem_targ fname)

(* Define the similarity function between two sets: size of intersection / size of union *)			
let union_size l1 l2 = List.length (List.fold_left (fun lst ele -> if (List.mem
ele lst) then lst else ele::lst) l1 l2)

let intersection_size l1 l2 = List.length (List.filter (fun x -> List.mem x l2)
l1)

let similarity a b = (float_of_int (intersection_size a b)) /. (float_of_int
(union_size a b))

(* Find the most similar representative file *)
let find_maxsim rname tname = List.fold_left max 0. (List.map (similarity
(clean_targ tname)) (clean_reps rname))

let find_file rname tname = "The most similar file to " ^ tname ^ " was " ^ 
    (List.fold_left (fun acc x -> if (similarity (clean_targ tname) (clean_targ
    x)) = (find_maxsim rname tname) then acc ^ x else acc ^ "") "" (get_list
    rname))

let find_max rname tname = "Similarity: " ^ string_of_float (List.fold_left max
    0. (List.map (similarity (clean_targ tname)) (clean_reps rname)))
(* print the result *)
let get_result rname tname = (find_file rname tname) ^ "/n" ^ (find_max rname
tname)
;;

let () = print_endline (find_file Sys.argv.(1) Sys.argv.(2))
let () = print_endline (find_max Sys.argv.(1) Sys.argv.(2))
(* this last line just makes sure the output prints before the program exits *)			    
let () = flush stdout
