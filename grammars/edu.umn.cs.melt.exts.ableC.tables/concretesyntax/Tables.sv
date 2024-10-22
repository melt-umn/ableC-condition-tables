grammar edu:umn:cs:melt:exts:ableC:tables:concretesyntax;

imports edu:umn:cs:melt:ableC:concretesyntax as cnc;

imports edu:umn:cs:melt:exts:ableC:tables:abstractsyntax;

imports silver:langutil;

marking terminal Table_t 'table' lexer classes {cnc:Keyword, cnc:Global};

terminal NewLine2_t /[\r]?\n/;
terminal TrueTV_t   'T';
terminal FalseTV_t  'F';
terminal StarTV_t   '*';

disambiguate NewLine2_t, cnc:NewLine_t
{
  pluck NewLine2_t;
}


concrete production table_c
top::cnc:PrimaryExpr_c ::= 'table' '{' trows::TableRows_c '}'
{
  top.ast = table(trows.ast);
}


tracked nonterminal TableRows_c with ast<TableRows>;

concrete production tableRowSnoc_c
top::TableRows_c ::= trowstail::TableRows_c  n::NewLine2_t  trow::TableRow_c
layout { cnc:Spaces_t }
{
  top.ast = tableRowSnoc(trowstail.ast, trow.ast);
}

concrete production tableRowOne_c
top::TableRows_c ::= trow::TableRow_c
{
  top.ast = tableRowOne(trow.ast);
}


tracked nonterminal TableRow_c  with ast<TableRow>;

concrete production tableRow_c
top::TableRow_c ::= e::cnc:Expr_c ':' tvs::TruthValueList_c
{
  top.ast = tableRow(e.ast, tvs.ast);
}


tracked nonterminal TruthValueList_c with ast<TruthFlagList>;

concrete production tvlistCons_c
top::TruthValueList_c ::= tv::TruthValue_c  tvltail::TruthValueList_c
{
  top.ast = tvlistCons(tv.ast, tvltail.ast);
}

concrete production tvlistOne_c
top::TruthValueList_c ::= tv::TruthValue_c
{
  top.ast = tvlistOne(tv.ast);
}


tracked nonterminal TruthValue_c with ast<TruthFlag>;

concrete production tvTrue_c
top::TruthValue_c ::= truetv::TrueTV_t
{
  top.ast = tvTrue();
}

concrete production tvFalse_c
top::TruthValue_c ::= falsetv::FalseTV_t
{
  top.ast = tvFalse();
}

concrete production tvStar_c
top::TruthValue_c ::= startv::StarTV_t
{
  top.ast = tvStar();
}

