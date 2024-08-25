grammar edu:umn:cs:melt:exts:ableC:tables:abstractsyntax;

imports edu:umn:cs:melt:ableC:abstractsyntax:host as abs;
imports edu:umn:cs:melt:ableC:abstractsyntax:construction as abs;
imports edu:umn:cs:melt:ableC:abstractsyntax:env as abs;

imports silver:langutil;
imports silver:langutil:pp;

abstract production table
top::abs:Expr ::= trows::TableRows
{
  top.pp = pp"table { ${box(trows.pp)} }";
  attachNote extensionGenerated("ableC-condition-tables");
  forward fwrd =
    abs:stmtExpr(
      @trows.preDecls,
      disjunction(mapConjunction(transpose(trows.ftExprss))));
  forwards to 
    if !null(trows.errors) then
      abs:errorExpr(trows.errors)
    else @fwrd;
}

-- Table Rows --
----------------
tracked nonterminal TableRows with pp, errors,
  ftExprss, rlen, preDecls, abs:controlStmtContext;

translation attribute preDecls :: abs:Stmt;
synthesized attribute ftExprss :: [[abs:Expr]];
synthesized attribute rlen :: Integer;

abstract production tableRowSnoc
top::TableRows ::= trowstail::TableRows  trow::TableRow
{
  top.pp = ppConcat([trowstail.pp, line(), trow.pp]);
  attachNote extensionGenerated("ableC-condition-tables");

  top.errors := trowstail.errors ++ trow.errors;
  top.errors <-
    if trow.rlen == trowstail.rlen then [] else
      [errFromOrigin(trow,
        "The number of T,F,* entries in table row must be the same " ++
        "as the preceding rows")];

  top.rlen = trow.rlen;
  top.ftExprss = trowstail.ftExprss ++ [trow.ftExprs];
  top.preDecls = abs:seqStmt(@trowstail.preDecls, @trow.preDecls);
}

abstract production tableRowOne
top::TableRows ::= trow::TableRow
{
  top.pp = trow.pp;
  top.errors := trow.errors;
  top.rlen = trow.rlen;
  top.ftExprss = [trow.ftExprs];
  top.preDecls = @trow.preDecls;
}

-- Table Row --
---------------
tracked nonterminal TableRow with pp, errors,
  ftExprs, rlen, preDecls;

synthesized attribute ftExprs :: [abs:Expr];

abstract production tableRow
top::TableRow ::= e::abs:Expr tvl::TruthFlagList
{
  top.pp = ppConcat([e.pp, text(" : "), tvl.pp]);
  attachNote extensionGenerated("ableC-condition-tables");
  top.errors := e.errors;
  top.rlen = tvl.rlen;
  top.ftExprs = tvl.ftExprs;
  
  top.errors <-
    if abs:typeAssignableTo(abs:builtinType(abs:nilQualifier(), abs:boolType()), e.abs:typerep) then []
    else [errFromOrigin(e, "Condition expression expected type boolean (got " ++ show(80, e.abs:typerep) ++ ")")];
  
  -- Generate a name
  nondecorated local ident :: abs:Name =
    abs:name("__table_condition_" ++ toString(genInt()));
  
  top.preDecls =
    abs:declStmt(
      abs:variableDecls(
        abs:nilStorageClass(),
        abs:nilAttribute(),
        abs:directTypeExpr(
          abs:builtinType(abs:nilQualifier(), abs:boolType())),
        abs:consDeclarator(
          abs:declarator(
            ident,
            abs:baseTypeExpr(),
            abs:nilAttribute(),
            abs:justInitializer(abs:exprInitializer(@e))),
          abs:nilDeclarator()
        )
      )
    ); -- _Bool ident = e;
  
  tvl.rowExpr = 
    abs:declRefExpr(ident);
}

-- Truth Value List
-------------------
tracked nonterminal TruthFlagList with pp, rowExpr, ftExprs, rlen;

inherited attribute rowExpr :: abs:Expr;
-- the expression in the table row.  It is passed down to the TF*
-- values to be used in the translation to the host language.

abstract production tvlistCons
top::TruthFlagList ::= tv::TruthFlag  tvltail::TruthFlagList
{
  top.pp = ppConcat([tv.pp, text(" "), tvltail.pp]);
  top.rlen = 1 + tvltail.rlen;
  top.ftExprs = tv.ftExpr :: tvltail.ftExprs;

  tv.rowExpr = top.rowExpr;
  tvltail.rowExpr = top.rowExpr;
}

abstract production tvlistOne
top::TruthFlagList ::= tv::TruthFlag
{
  top.pp = tv.pp;
  top.rlen = 1;
  top.ftExprs = [tv.ftExpr];
 
  tv.rowExpr = top.rowExpr;
}


-- Truth Values
---------------
tracked nonterminal TruthFlag with pp, rowExpr, ftExpr;

synthesized attribute ftExpr :: abs:Expr;

abstract production tvTrue
top::TruthFlag ::=
{
  top.pp = text("T");
  top.ftExpr = top.rowExpr;
}

abstract production tvFalse
top::TruthFlag ::=
{
  top.pp = text("F");
  attachNote extensionGenerated("ableC-condition-tables");
  top.ftExpr = abs:notExpr(top.rowExpr);
}

abstract production tvStar
top::TruthFlag ::=
{ 
  top.pp = text("*");
  attachNote extensionGenerated("ableC-condition-tables");
  top.ftExpr =
    abs:realConstant(
      abs:integerConstant("1", false, abs:noIntSuffix()));
}

-- table helper functions
-------------------------
function disjunction
abs:Expr ::= es::[abs:Expr]
{
  return if length(es) == 1 then head(es)
         else abs:orExpr(head(es), disjunction(tail(es)));
}
function mapConjunction
[abs:Expr] ::= ess::[[abs:Expr]]
{
  return if null(ess) then [] 
         else cons(conjunction(head(ess)),
                     mapConjunction(tail(ess)));
}
function conjunction
abs:Expr ::= es::[abs:Expr]
{
  return if length(es) == 1 then head(es)
         else abs:andExpr(head(es), conjunction(tail(es)));
}
function transpose
[[a]] ::= m::[[a]]
{
  return
    case m of
    | [] :: _ -> []
    | _       -> map(head,m) :: transpose(map(tail,m))
    end;
}

