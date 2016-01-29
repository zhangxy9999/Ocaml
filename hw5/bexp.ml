(* boolexpr parsing with continuations and descriptive exceptions *)
type boolExpr =
  Bool of bool
  | And of boolExpr*boolExpr
  | Or of boolExpr*boolExpr
  | Not of boolExpr
  | Var of string

type token = AND | OR | NOT | LIT of bool | OP | CL | NM of string

let rec lex str = 
  let splitlist = Str.full_split (Str.regexp "\\b\\|(\\|)") str in
  let rec tok_splits = function
    | [] -> []
    | (Str.Delim "(")::t -> OP::(tok_splits t)
    | (Str.Delim ")")::t -> CL::(tok_splits t)
    | (Str.Delim _)::t -> tok_splits t
    | (Str.Text s)::t ->
       match String.trim s with
       | "" -> tok_splits t
       | "not" -> NOT::(tok_splits t) | "and" -> AND::(tok_splits t) | "or" -> OR::(tok_splits t)
       | "true" -> (LIT true)::(tok_splits t) | "false" -> (LIT false)::(tok_splits t)
       | "(" -> OP::(tok_splits t) | ")" -> CL::(tok_splits t)
       | _ as s -> (NM s)::(tok_splits t) in
  tok_splits splitlist
				 
let rparse tlist =
  let rec phelp tlist =
    match tlist with
    | (LIT b)::t -> (Bool b, t)
    | (NM s)::t -> (Var s, t)
    | OP::NOT::t -> let (e,t') = phelp t in begin match t' with CL::t'' -> (Not e, t'') | _ -> failwith "unclosed not" end
    | OP::AND::t ->
       let (e1, t1) = phelp t in
       let (e2, t2) = phelp t1 in
       begin match t2 with CL::t' -> (And (e1,e2), t') | _ -> failwith "unclosed and" end
    | OP::OR::t ->
       let (e1,t1) = phelp t in
       let (e2,t2) = phelp t1 in
       begin match t2 with CL::t' -> (Or (e1,e2), t') | _ -> failwith "unclosed or" end
    | _ -> failwith "unexpected token" in
  match phelp tlist with
  | (e,[]) -> e
  | _ -> failwith "tokens beyond end of expression"

(* evaluate a boolExpr (bExp), assuming that only the variables in the (string) list tvars are true *)
let rec reval bExp tvars = match bExp with
  | Bool b -> b
  | And (e1,e2) -> (reval e1 tvars) && (reval e2 tvars)
  | Or (e1,e2) -> (reval e1 tvars) || (reval e2 tvars)
  | Not e -> not (reval e tvars)
  | Var s -> List.mem s tvars

(* try this in utop: reval (rparse (build_deep_not (1 lsl 18))) [] *)		      
let build_deep_not n =
  let rec build_close_str n acc = if n=0 then acc else build_close_str (n-1) (CL::acc) in
  let rec build_not_str n acc = if n=0 then acc else build_not_str (n-1) (OP::(NOT::acc))
  in build_not_str n ((LIT true)::build_close_str n [])


(* Here's where you build the continuations & descriptive exceptions-based versions *)

exception Unclosed of int * int
exception Unused of int
exception SyntaxError of int

let rec keval bExp tvars (f : bool -> bool) = match bExp with
  | Bool b -> f b
  | And (e1,e2) -> keval e1 tvars (fun x1 -> keval e2 tvars (fun x2 -> (f (x1 &&
  x2))))
  | Or (e1,e2) -> keval e1 tvars (fun x1 -> keval e2 tvars (fun x2 -> (f (x1 ||
  x2))))
  | Not e -> keval e tvars (fun x -> f (not x))
  | Var v -> (f (List.mem v tvars))

let eval bExp vars = keval bExp vars (fun x -> x)

let rec kparse tlist n f = match tlist with
| (LIT b)::t -> f (Bool b, t, n + 1)
| (NM s)::t -> f (Var s, t, n)
| (OP::NOT::t) -> kparse t (n+2) (fun (exp, tt, n2) -> begin match tt with
    | CL::ttt -> f ((Not exp), ttt, n2+1)
    | _ -> raise (Unclosed (n,n2)) end)
| (OP::AND::t) -> kparse t (n+2) (fun (l, tt, n2) -> kparse tt n2 (fun (r, ttt,
n3) -> begin match ttt with
    | CL::tttt -> f (And(l,r), tttt, n3+1)
    | _ -> raise (Unclosed (n,n3)) end))
| (OP::OR::t) -> kparse t (n+2) (fun (l, tt, n2) -> kparse tt n2 (fun (r, ttt,
n3) -> begin match ttt with
    | CL::tttt -> f (Or(l,r), tttt, n3+1)
    | _ -> raise (Unclosed (n,n3)) end))

let parse lst = match kparse lst 1 (fun x -> x) with
| (a, [], b) -> a
| (a, _, b) -> raise (Unused b)

let query str strset = parse (lex str)
