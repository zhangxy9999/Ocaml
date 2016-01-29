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
  | Print of expr

type expType = Int | Bool | Unit 

(* Type to represent a lexical environment of the program, e.g. the current stack of variables and the values they are bound to *)
type envType = (string * result) list
 (* Type to represent a value in the program *)
 and result = IntResult of int | BoolResult of bool | UnitResult 

(* evaluate an expression in a lexical environment *)
let rec eval exp env = match exp with
  | Const n -> IntResult n
  | Boolean b -> BoolResult b
  | Add (e1,e2) -> evalInt (+) e1 e2 env
  | Mul (e1,e2) -> evalInt ( * ) e1 e2 env
  | Sub (e1,e2) -> evalInt (-) e1 e2 env
  | Div (e1,e2) -> evalInt (/) e1 e2 env
  | If (cond,thn,els) -> evalIf cond thn els env
  | Let (nm,vl,exp') -> evalLet nm vl exp' env
  | Name nm -> List.assoc nm env
  | And (e1,e2) -> evalBool (&&) e1 e2 env
  | Or (e1,e2) -> evalBool (||) e1 e2 env
  | Not e -> let (BoolResult b) = eval e env in BoolResult (not b)
  | Lt (e1, e2) -> evalComp (<) e1 e2 env
  | Eq (e1, e2) -> evalComp (=) e1 e2 env
  | Gt (e1, e2) -> evalComp (>) e1 e2 env
  | Print e -> let () = match eval e env with
		 | UnitResult -> print_string "()"
		 | IntResult i -> print_int i
		 | BoolResult b -> if b then print_string "True" else print_string "False" in
	       let () = print_string "\n" in
	       let () = flush stdout in UnitResult
and evalInt f e1 e2 env =
  let (IntResult i1) = eval e1 env in
  let (IntResult i2) = eval e2 env in
  IntResult (f i1 i2)
and evalIf cond thn els env =
  let (BoolResult b) = eval cond env in
  if b then eval thn env else eval els env
and evalLet name vl exp env =
  let r = eval vl env in
  eval exp ((name,r)::env) 
and evalBool f e1 e2 env =
  let (BoolResult b1) = eval e1 env in
  let (BoolResult b2) = eval e2 env in
  BoolResult (f b1 b2)
and evalComp cmp e1 e2 env =
  let (IntResult i1) = eval e1 env in
  let (IntResult i2) = eval e2 env in
  BoolResult (cmp i1 i2)
	     
(* Type checking/inference: Figure out type for an expression.  Fail if the expression is not well-typed.*)    
let rec typeof exp env = match exp with
  | Const _ -> Int
  | Boolean _ -> Bool
  | Add (e1,e2) | Sub (e1,e2) | Mul (e1,e2)
  | Div (e1,e2) ->
     ( match (typeof e1 env, typeof e2 env) with
       | (Int,Int) -> Int
       | _ -> failwith "Arithmetic on non-integer argument(s)")
  | And (e1,e2)
  | Or (e1,e2) ->
     ( match (typeof e1 env, typeof e2 env) with
       | (Bool,Bool) -> Bool
       | _ -> failwith "Boolean operation on non-Bool argument(s)")
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
  | Print e -> let _ = typeof e env in Unit

let e1 = Let("x",Const 3,
	     Let("y", Const 7,
		 If(Gt(Name "y", Name "x"),Print (Boolean true),Print (Boolean false))))

(* Add two well-typed programs below *)
let p1 = Let("x",Const 3,
	     Let("y", Const 7,
		 If(Lt(Name "y", Name "x"),Print (Const 1),Print (Const 0))))

let p2 = Let("x",Const 3,
		 If(Lt(Const 7, Name "x"),Print (Const 1),Print (Const 0)))

let badtype1 = Let("x", Mul(Const 7, Boolean true),
		   If (Const 1, Const 3, Print(Boolean false)))

(* Add two programs that will fail to type-check below *)
let p_err1 = Let("x", Add(Const 2, Boolean false),
		If(Const 7, Boolean true, Print (Boolean true)))

let p_err2 = Let("x", Sub(Boolean false, Boolean false),
		If(Const 7, Const 2, Print (Boolean true)))

(* here's where you define find_constants *)
let find_constants exp = let rec find_constant e acc = match e with
  | Const c -> (Const c)::acc
  | Boolean b -> (Boolean b)::acc
  | Add (e1,e2) | Sub(e1,e2) | Mul (e1,e2) 
  | Div (e1,e2) -> (find_constant e1 acc)@(find_constant e2 acc)
  | If (e1,e2,e3) -> (find_constant e1 acc)@(find_constant e2 acc)@(find_constant e3 acc)
  | Name n -> acc
  | Let (e1,e2,e3) -> (find_constant e2 acc)@(find_constant e3 acc)
  | Gt (e1,e2) | Lt (e1,e2) | Eq (e1,e2) -> acc
  | Print e -> find_constant e acc
in find_constant exp []
			  
(* here's where you define rm_vars *)
let rm_vars (p) = (
  let rec helper exp env =
    match exp with
    |Const c -> Const c
    |Boolean b -> Boolean b
    |If(e1,e2,e3) -> If((helper e1 env),(helper e2 env),(helper e3 env))
    |Print e1 -> helper e1 env
    |Add(e1,e2) -> Add((helper e1 env),(helper e1 env))
    |Sub(e1,e2) -> Sub((helper e1 env),(helper e1 env))
    |Mul(e1,e2) -> Mul((helper e1 env),(helper e1 env))
    |Div(e1,e2) -> Div((helper e1 env),(helper e1 env))
    |Lt(e1,e2) -> Lt((helper e1 env),(helper e1 env))
    |Gt(e1,e2) -> Gt((helper e1 env),(helper e1 env))
    |Eq(e1,e2)-> Eq((helper e1 env),(helper e1 env))
    |And(e1,e2) -> And((helper e1 env),(helper e1 env))
    |Or(e1,e2)-> Or((helper e1 env),(helper e1 env))
    |Not e -> Not(helper e env)
    |Let (name, v, expr) -> helper expr ([(name,typeof v env)] @ env)
    |Name n -> (match (typeof (Name n) env) with
              |Int -> Const 0
              |Bool -> Boolean false)
    in helper p []
  )

		     
	
