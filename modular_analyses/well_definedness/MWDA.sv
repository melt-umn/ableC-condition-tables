grammar well_definedness;

{- This Silver specification does not generate a useful working 
   compiler, it only serves as a grammar for running the modular
   well-definedness analysis.
 -}

import edu:umn:cs:melt:ableC:concretesyntax as cst;
import edu:umn:cs:melt:ableC:drivers:compile;
import edu:umn:cs:melt:exts:ableC:tables;

parser extendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;
  edu:umn:cs:melt:exts:ableC:tables;
} 

function main
IOVal<Integer> ::= args::[String] io_in::IOToken
{
  return ioval(io_in,0);
}
