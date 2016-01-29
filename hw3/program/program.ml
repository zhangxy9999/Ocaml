type expr =
  Const of int | Boolean of bool
  | Add of expr * expr
  | Sub of expr * expr
  | Mul of expr * expr
  | Div of expr * expr
  | If of expr * expr * expr
  | Let of string * expr * expr
  | Name of string
  | And of expr * expr
  | Or of expr * expr
  | Not of expr
  | Lt of expr * expr
  | Eq of expr * expr
  | Gt of expr * expr
  | Seq of expr list
  | While of expr * expr
  | Set of string * expr
  | Fun of string * expType * expr
  | Apply of expr * expr
  | Print of expr
  | Readint
 and expType = Int | Bool | Unit | FunType of expType * expType

(* Type to represent a state of the program, e.g. the current stack of variables and the values they are bound to *)
type stType = (string * result) list
 (* Type to represent a value in the program *)
 and result = IntResult of int | BoolResult of bool | UnitResult | FunResult of expr*string*stType
											      
(* Searches the stack and updates the most recent binding with the new value *)
let rec assign name value state =
  match state with
  | [] -> failwith "assign to unbound name"
  | (n,v)::t when n=name -> (name,value)::t
  | b::t -> b::(assign name value t)		 

(* pop a variable binding off the stack *)
let rec pop name state =
  match state with
  | [] -> failwith "popping unbound name: internal error"
  | (n,v)::t when n=name -> t
  | b::t -> b::(pop name t)

(* evaluate an expression: return the value and the new program state *)		 
let rec eval exp state = match exp with
  | Const n -> (IntResult n, state)
  | Boolean b -> (BoolResult b, state)
  | Add (e1,e2) -> evalInt (+) e1 e2 state
  | Mul (e1,e2) -> evalInt ( * ) e1 e2 state
  | Sub (e1,e2) -> evalInt (-) e1 e2 state
  | Div (e1,e2) -> evalInt (/) e1 e2 state
  | If (cond,thn,els) -> evalIf cond thn els state
  | Let (nm,vl,exp') -> evalLet nm vl exp' state
  | Name nm -> (List.assoc nm state, state)
  | And (e1,e2) -> evalBool (&&) e1 e2 state
  | Or (e1,e2) -> evalBool (||) e1 e2 state
  | Not e -> let (BoolResult b, st') = eval e state in (BoolResult (not b), st')
  | Lt (e1, e2) -> evalComp (<) e1 e2 state
  | Eq (e1, e2) -> evalComp (=) e1 e2 state
  | Gt (e1, e2) -> evalComp (>) e1 e2 state
  | Seq elist -> evalSeq elist state
  | While (cond,body) -> evalWhile cond body state
  | Set (name, e) -> let (vl, st') = eval e state in (UnitResult, assign name vl st')
  | Fun (argname,_,body) -> (FunResult (body,argname,state), state) (* "Captures" current environment at definition. *)
  | Apply (f,e) -> evalFunc f e state
  | Print e -> let (r,st') = eval e state in
	       let () = match r with
		 | UnitResult -> print_string "()"
		 | IntResult i -> print_int i
		 | BoolResult b -> if b then print_string "True" else print_string "False"
		 | FunResult _ -> print_string "<fun>" in
	       let () = print_string "\n" in
	       let () = flush stdout in
	       (UnitResult, st')
  | Readint -> (IntResult (read_int()), state)
and evalInt f e1 e2 state =
  let (IntResult i1, st1) = eval e1 state in
  let (IntResult i2, st2) = eval e2 st1 in
  IntResult (f i1 i2), st2
and evalIf cond thn els state =
  let (BoolResult b, st') = eval cond state in
  if b then eval thn st' else eval els st'
and evalLet name vl exp state =
  let (r, st') = eval vl state in
  let (r', st'') = eval exp ((name,r)::st') in
  (r', pop name st'')
and evalBool f e1 e2 state =
  let (BoolResult b1, st1) = eval e1 state in
  let (BoolResult b2, st2) = eval e2 st1 in
  BoolResult (f b1 b2), st2
and evalComp cmp e1 e2 state =
  let (r1, st1) = eval e1 state in
  let (r2, st2) = eval e2 st1 in
  (BoolResult (cmp r1 r2), st2)
and evalSeq elist st = match elist with (* Whee, tail recursion. *)
  | [] -> (UnitResult, st)
  | e::[] -> eval e st
  | e::t -> let (_, st') = eval e st in
	    evalSeq t st'
and evalWhile cond body st = (* Note the tail recursion. An infinite while loop won't blow the stack *)
  let (BoolResult b, st') = eval cond st in
  if (not b) then (UnitResult, st') else
    let (_, st'') = eval body st' in
    evalWhile cond body st''  
and evalFunc f arg state = (* Note: we need to evaluate the function with environment at time of definition *)
  let (FunResult (body,argname,def_st), st') = eval f state in
  let (argval, st'') = eval arg st' in (* but computing its argument could change state at call site *)
  let (result, _) = eval body ((argname,argval)::def_st) in
  (result, st'') (* So state after call must be the state after argument computation *)

(* Type checking/inference: Figure out type for an expression.  Fail if the expression is not well-typed.*)    
let rec typeof exp env = match exp with
  | Const _ -> Int
  | Boolean _ -> Bool
  | Add (e1,e2) | Sub (e1,e2) | Mul (e1,e2)
  | Div (e1,e2) ->
     ( match (typeof e1 env, typeof e2 env) with
       | (Int,Int) -> Int
       | _ -> failwith "Arithmetic on non-integer arguments")
  | And (e1,e2)
  | Or (e1,e2) ->
     ( match (typeof e1 env, typeof e2 env) with
       | (Bool,Bool) -> Bool
       | _ -> failwith "Boolean operation on non-Bool arguments")
  | Not e -> if (typeof e env) = Bool then Bool else failwith "Not of non-Boolean"
  | Lt (e1,e2)
  | Gt (e1,e2) ->
     ( match (typeof e1 env, typeof e2 env) with
       | (Int,Int) -> Bool
       | _ -> failwith "Comparison of non-integer values" )
  | Eq (e1,e2) ->
     ( match (typeof e1 env, typeof e2 env) with
       | (Int,Int) | (Bool,Bool) | (Unit,Unit) -> Bool
       | _ -> failwith "Equality test on incompatible values" )
  | If (cond,thn,els) ->
     if not ((typeof cond env) = Bool) then failwith "If on non-boolean condition" else
       let (t1,t2) = (typeof thn env, typeof els env) in
       if (t1 = t2) then t1 else failwith "Different types for then/else branches"
  | Name name -> (try List.assoc name env with Not_found -> failwith ("Unbound variable "^name))
  | Let (name,vl,e) ->
     let t = typeof vl env in
     typeof e ((name,t)::env)
  | Seq elist -> seqType elist env
  | While (c,body) ->
     ( match (typeof c env, typeof body env) with
       | (Bool, _) -> Unit
       | _ -> failwith "Non-boolean condition for while")
  | Set (name, e) -> if (typeof (Name name) env) = (typeof e env) then Unit else failwith "assign type mismatch"
  | Fun (argname, argType, body) ->
     let resType = typeof body ((argname,argType)::env) in
     FunType (argType,resType)
  | Apply (e1,e2) ->
     ( match (typeof e1 env) with
       | FunType (argtype, restype) -> if (typeof e2 env) = argtype then restype
				       else failwith "incompatible function argument"
       | _ -> failwith "Apply of non-function value")
  | Print e -> let _ = typeof e env in Unit
  | Readint -> Int
and seqType el env = match el with
  | [] -> Unit
  | [e] -> typeof e env
  | e::rest -> let _ = typeof e env in seqType rest env

(*let rec const_fold expr = match expr with
  | Const c -> Const c
  | Boolean b -> Boolean b
  | Add (Const a, Const b) -> 
  | Sub (Const a, Const b) -> a - b
  | Mul (Const a, Const b) -> a * b
  | Div (Const a, Const b) -> a / b
  | While (Boolean false, body) -> Seq []
  | If (Boolean true, thn, els) -> const_fold thn
  | If (Boolean false, t, e) -> const_fold e
  | Add (e1, e2) | Sub (e1, e2) | Mul (e1, e2) | Div (e1, e2) ->
          ((const_fold e1), (const_fold e2))
  | If (Boolean b, e1, e2) -> ((const_fold e1), (const_fold e2))
  | While (Boolean b, e) -> (const_fold e)*)
