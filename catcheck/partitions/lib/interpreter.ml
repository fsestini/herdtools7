module Extract = TxtLoc.Extract ()

type value =
  | VEmpty
  | VFormula of string Logic.t
  | VSet of value list
  | VTuple of value list
  | VFun of (value -> value)
  | VProc of (value -> string Logic.t list)

and env = value StringMap.t

let unsupported what = invalid_arg ("unsupported cat construct: " ^ what)

let unsupported_at what loc =
  unsupported (Printf.sprintf "%s: %s" what (Extract.extract loc))

let unsupported_exp exp = unsupported_at "expression" (ASTUtils.exp2loc exp)
let unsupported_ins ins = unsupported_at "instruction" (ASTUtils.ins2loc ins)

let as_formula = function
  | VFormula f -> f
  | VEmpty -> Logic.disj []
  | _ -> unsupported "expected event-set expression"

let as_set = function
  | VSet vs -> vs
  | VEmpty -> []
  | _ -> unsupported "expected value-set expression"

let as_tuple = function VTuple vs -> vs | v -> [ v ]

let bind_pat (pat : AST.pat) (value : value) (env : env) : env =
  let bind_pat0 pat0 value env =
    match pat0 with None -> env | Some name -> StringMap.add name value env
  in
  match pat with
  | AST.Pvar pat0 -> bind_pat0 pat0 value env
  | AST.Ptuple pat0s ->
      let values = as_tuple value in
      if List.length pat0s <> List.length values then
        unsupported "argument arity mismatch"
      else
        List.fold_left2
          (fun env pat0 value -> bind_pat0 pat0 value env)
          env pat0s values

let rec eval_exp (env : env) : AST.exp -> value = function
  | AST.Var (_, name) -> (
      match StringMap.find_opt name env with
      | Some value -> value
      | None -> VFormula (Logic.var name))
  | AST.Konst (_, AST.Empty _) -> VEmpty
  | AST.ExplicitSet (_, []) -> VEmpty
  | AST.ExplicitSet (_, exps) -> VSet (List.map (eval_exp env) exps)
  | AST.Op (_, AST.Tuple, exps) -> VTuple (List.map (eval_exp env) exps)
  | AST.Op (_, AST.Union, exps) ->
      VFormula
        (Logic.disj (List.map (fun exp -> as_formula (eval_exp env exp)) exps))
  | AST.Op (_, AST.Inter, exps) ->
      VFormula
        (Logic.conj (List.map (fun exp -> as_formula (eval_exp env exp)) exps))
  | AST.Op (_, AST.Diff, [ exp1; exp2 ]) ->
      let f1 = as_formula (eval_exp env exp1) in
      let f2 = as_formula (eval_exp env exp2) in
      VFormula (Logic.conj [ f1; Logic.neg f2 ])
  | AST.Op1 (_, AST.Comp, exp) ->
      VFormula (Logic.neg (as_formula (eval_exp env exp)))
  | AST.Bind (_, [ b ], exp) ->
      let env = eval_binding ~is_rec:false env b in
      eval_exp env exp
  | AST.BindRec (_, [ b ], exp) ->
      let env = eval_binding ~is_rec:true env b in
      eval_exp env exp
  | AST.Fun (_, pat, body, _, _) ->
      VFun
        (fun arg ->
          let call_env = bind_pat pat arg env in
          eval_exp call_env body)
  | AST.App (_, fn, arg) -> (
      match eval_exp env fn with
      | VFun fn -> fn (eval_exp env arg)
      | _ -> unsupported "application of non-function")
  | AST.MatchSet (_, exp, empty_exp, clause) -> (
      match (as_set (eval_exp env exp), clause) with
      | [], _ -> eval_exp env empty_exp
      | value :: rest, AST.EltRem (value_pat, rest_pat, body) ->
          let env = bind_pat (AST.Pvar value_pat) value env in
          let env = bind_pat (AST.Pvar rest_pat) (VSet rest) env in
          eval_exp env body
      | _ :: _, AST.PreEltPost _ -> unsupported "pre-element-post set match")
  | exp -> unsupported_exp exp

and eval_binding ~(is_rec : bool) (env : env) (binding : AST.binding) : env =
  if is_rec then (
    let closure_env = ref env in
    let env =
      match binding with
      | _, AST.Pvar (Some name), AST.Fun (_, fn_pat, body, _, _) ->
          let fun_val =
            VFun
              (fun arg ->
                let call_env = bind_pat fn_pat arg !closure_env in
                eval_exp call_env body)
          in
          StringMap.add name fun_val env
      | _ -> unsupported "recursive non-function binding"
    in
    closure_env := env;
    env)
  else
    let _, pat, exp = binding in
    let value = eval_exp env exp in
    bind_pat pat value env

and eval_ins (env : env) (constraints : string Logic.t list) :
    AST.ins -> env * string Logic.t list = function
  | AST.Let (_, [ b ]) -> (eval_binding ~is_rec:false env b, constraints)
  | AST.Rec (_, [ b ], None) -> (eval_binding ~is_rec:true env b, constraints)
  | AST.Procedure (_, name, pat, body, _) ->
      let proc =
        VProc
          (fun arg ->
            let call_env = bind_pat pat arg env in
            let _, constraints = eval_ins_list call_env [] body in
            List.rev constraints)
      in
      let env = StringMap.add name proc env in
      (env, constraints)
  | AST.Call (_, name, arg, None) -> (
      match StringMap.find_opt name env with
      | Some (VProc proc) ->
          let constraints =
            List.rev_append (proc (eval_exp env arg)) constraints
          in
          (env, constraints)
      | Some _ -> unsupported ("call of non-procedure: " ^ name)
      | None -> unsupported ("unknown procedure: " ^ name))
  | AST.Test ((_, _, AST.Yes AST.TestEmpty, exp, None), (AST.Check | AST.Assert))
    ->
      let constr = Logic.neg (as_formula (eval_exp env exp)) in
      (env, constr :: constraints)
  | ins -> unsupported_ins ins

and eval_ins_list env constraints ins =
  List.fold_left
    (fun (env, constraints) ins -> eval_ins env constraints ins)
    (env, constraints) ins

let constraints_of_cat (ins : AST.ins list) : string Logic.t list =
  let _, constraints = eval_ins_list StringMap.empty [] ins in
  List.rev constraints
