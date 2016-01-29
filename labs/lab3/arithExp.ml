
<<<<<<< HEAD
type arithToken = PLUS | TIMES | NEG | CONST of float
=======
type arithToken = PLUS | TIMES | NEG | DIVISION| CONST of float
>>>>>>> bc36ad4f78c49152adb1741a01b71f8d1d74e493
						       
let token_list s =
  (* Don't worry if you don't understand these first two lines.
     They separate a string into a list of substrings separated by one 
     or more whitespace characters, for example if s = "1.3    4.5 +" then 
     wlist will be ["1.3"; "4.5"; "+"] *)    
  let sep_re = Str.regexp "\\( \\|\012\\|\r\\|\n\\|\t\\)+" in
  let wlist = Str.split sep_re s in
  let rec tokens wl = match wl with
    | "+"::t -> PLUS :: (tokens t)
    | "*"::t -> TIMES :: (tokens t)
    | "-"::t -> NEG::(tokens t)
<<<<<<< HEAD
=======
    | "/"::t -> DIVISION::(tokens t)
>>>>>>> bc36ad4f78c49152adb1741a01b71f8d1d74e493
    | s::t -> (CONST (float_of_string s))::(tokens t)
    | [] -> []
  in tokens wlist 

<<<<<<< HEAD
type arithExpr = ConstExpr of float | NegExpr of arithExpr | AddExpr of arithExpr * arithExpr | MultExpr of arithExpr * arithExpr
=======
type arithExpr = ConstExpr of float | NegExpr of arithExpr | AddExpr of arithExpr * arithExpr | MultExpr of arithExpr * arithExpr | DiviExpr of arithExpr * arithExpr
>>>>>>> bc36ad4f78c49152adb1741a01b71f8d1d74e493
															     
let rpnParse tlist = 
  let rec parser tlist stk = match tlist with 
    | [] -> stk
    | (CONST f)::t -> parser t ((ConstExpr f)::stk)
    | NEG::t -> (match stk with e1::stk' -> parser t ((NegExpr e1)::stk') | _ -> failwith "stack underflow")  
    | PLUS::t -> (match stk with e1::e2::stk' -> parser t ((AddExpr (e1,e2))::stk') | _ -> failwith "stack underflow")
    | TIMES::t -> (match stk with e1::e2::stk' -> parser t ((MultExpr (e1,e2))::stk') | _ -> failwith "stack underflow")
<<<<<<< HEAD
=======
    | DIVISION::t -> (match stk with e1::e2:stk' -> parser t ((DiviExpr (e1,e2))::stk') | _ -> failwith "stack underflow")
>>>>>>> bc36ad4f78c49152adb1741a01b71f8d1d74e493
  in let stack = parser tlist [] in
     match stack with
     |[e] -> e
     | _ -> failwith "nonempty stack" 
  
let rec arithExpEval = function
  | ConstExpr f -> f 
  | NegExpr e -> 0. -. (arithExpEval e)
  | AddExpr (e1,e2) -> (arithExpEval e1) +. (arithExpEval e2)
  | MultExpr (e1,e2) -> (arithExpEval e1) *. (arithExpEval e2)
<<<<<<< HEAD
=======
  | DiviExper (e1,e2) -> (arithExpEval e1) /. (arithExpEval e2)
>>>>>>> bc36ad4f78c49152adb1741a01b71f8d1d74e493

(* Add let expressions binding to two arithExpr values here... *)

(* and strings that create each of these expressions in RPN here *)

(* and two bindings that evaluate strings that correspond to division in RPN here *)
					       
