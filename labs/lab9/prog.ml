type expr =
  Int of int | Bool of bool
  | Add of expr*expr
  | Seq of expr list
  | If of expr*expr*expr
  | Gt of expr*expr
  | Set of string*expr
  | Name of string
  | While of expr*expr

type result = IntR of int | BoolR of bool | UnitR

let rec assign n v st = match st with
  | [] -> [(n,v)]
  | (nm,_)::t when nm=n -> (n,v)::t
  | nv::t -> nv::(assign n v t)
					      
let rec eval expr st = match expr with
  | Int i -> (IntR i, st)
  | Bool b -> (BoolR b, st)
  | Add(e1,e2) -> evalAdd e1 e2 st
  | Seq el -> evalSeq el st
  | If(c,thn,els) -> evalIf c thn els st
  | Gt(e1,e2) -> evalGt e1 e2 st
  | Set(nm,vexp) -> let (v,s') = eval vexp st in (UnitR, assign nm v s')
  | Name nm -> (List.assoc nm st, st) (* possible site of "ERROR 000" *)
  | While(c,b) -> evalWhile c b st
and evalAdd e1 e2 st =
  let (v1,st1) = eval e1 st in
  let (v2,st2) = eval e2 st1 in
  match (v1,v2) with
  | (IntR i1, IntR i2) -> (IntR (i1+i2), st2)
  | _ -> raise (ArgumentMismatch 1)
and evalSeq el st = match el with
  | [] -> (UnitR, st)
  | [e] -> eval e st
  | e1::el1 -> let (_,st1) = eval e1 st in evalSeq el1 st1
and evalIf c thn els st = match eval c st with
  | (BoolR true, st') -> eval thn st'
  | (BoolR false, st') -> eval els st'
  | _ -> raise ()
and evalGt e1 e2 st =
  let (v1,st1) = eval e1 st in
  let (v2,st2) = eval e2 st1 in
  match (v1,v2) with
  | (IntR i1, IntR i2) -> (BoolR (i1 > i2), st2)
  | _ -> raise ()
and evalWhile c b st = match (eval c st) with
  | (BoolR false, st') -> (UnitR, st')
  | (BoolR true, st') -> let (_,st2) = eval b st' in evalWhile c b st2
  | _ -> raise ()

let runProg expr =
	

let p0 = Seq [ Set ("y", Seq []);
	       While (Gt (Name "x", Name"y"),
		      Seq [ Set("y", Add (Name "x", Int (-1)));
			    Set("x", Add (Name "y", Int 1))]) ;
	       Name "y"]

let p1 = Set ("x", Add (Seq [], Bool true))

let p2 = While (If (Int 1, Bool false, Bool true),
		Seq [ Set ("x", Gt (Name "x", Name "x"));
		      Set ("y", If(Name "x", Name "y", Bool false)) ])
						       
let p3 = Seq [ Set ("x", Int 0);
	       While (Gt (Name "x", Bool false), Set ("x", Add (Name "x", Int (-1)))) ;
	       If (Int 1, Name "y", Seq []) ]

let p4 = While(Int 1,
	       If (Gt(Name "x", Name"y"),
		   Set ("x", Add(Name "x", Int(-1))),
		   Set ("y", Add(Name "y", Int(-1)))))
