package lyc.compiler;

import java_cup.runtime.Symbol;
import lyc.compiler.ParserSym;
import lyc.compiler.constants.Constants;
import lyc.compiler.files.SymbolTableGenerator;
import lyc.compiler.model.*;
import static lyc.compiler.constants.Constants.*;

%%

%public
%class Lexer
%unicode
%cup
%line
%column
%throws CompilerException
%eofval{
  return symbol(ParserSym.EOF);
%eofval}


%{
  private Symbol symbol(int type){
      return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value){
      return new Symbol(type, yyline, yycolumn, value);
  }

  private boolean esCteEnteraValida(){
      long value = Long.parseLong(yytext());
      return value <= Constants.MAX_INTEGER_CONSTANT;
  }

  private boolean esCteFloatValido(){
      double cteFloat = Math.abs(Double.parseDouble(yytext()));
      return cteFloat >= Constants.MIN_FLOAT_CONSTANT && cteFloat <= Constants.MAX_FLOAT_CONSTANT;
  }

  private boolean esLongitudStringValida() {
      return yylength() <= Constants.MAX_LENGTH_STRING;
  }

  private boolean esLongitudIdValida() {
    return yylength() <= Constants.MAX_LENGTH;
  }

  private void guardarToken() {
      SymbolTableGenerator.getInstance().addToken(yytext());
  }

  private void guardarCTE(String dataType){
      SymbolTableGenerator.getInstance().addToken(yytext(), dataType);
  }

%}

DIGITO = [0-9]
LETRA = [a-zA-Z]
TEXTO = [\"].*[\"]

INIT = "init"
PUNTO = "."
INTEGER = "int"
FLOAT = "float"
STRING = "string"
PRINTF = "escribir"
SCANF = "leer"
GETPENULTIMATEPOSITION = "getPenultimatePosition"
SUMALOSULTIMOS = "sumaLosUltimos"

IGUAL_IGUAL = "=="
ASIGNACION = ":="
PUNTO_COMA = ";"

DOS_PUNTOS = ":"

AND = "AND"
OR = "OR"
NOT = "NOT"
SALTO_LINEA = "\n|\r\n|\r"
CARACTER_NO_SALTO = [^\r\n]
COMENTARIO_EN_LINEA = "*-"{CARACTER_NO_SALTO}*"-*"
ID = {LETRA}({LETRA}|{DIGITO})*
OP_SUMA = "+"
OP_REST = "-"
OP_MULT = "*"
OP_DIV = "/"
PAREN_A = "("
PAREN_C = ")"
IF = "si"
ELSE = "sino"
WHILE = "mientras"
COMA = ","

COR_A = "["
COR_C = "]"
DISTINTO = "<>"
MENOR_IGUAL = "<="
MAYOR_IGUAL = ">="
MENOR = "<"
MAYOR = ">"
LLAVE_A = "{"
LLAVE_C = "}"
CONST_ENTERA = ("0"|([1-9]{DIGITO}*))
CONST_REAL = {CONST_ENTERA}?{PUNTO} {DIGITO}*

%%


/* keywords */

<YYINITIAL>{
/* identifiers */
{OP_REST} { return symbol(ParserSym.OP_REST, yytext()); }
{PAREN_A} { return symbol(ParserSym.PAREN_A, yytext()); }
{PAREN_C} { return symbol(ParserSym.PAREN_C, yytext()); }
{ASIGNACION} { return symbol(ParserSym.ASIGNACION, yytext()); }
{DOS_PUNTOS} { return symbol(ParserSym.DOS_PUNTOS, yytext()); }
{OP_DIV} { return symbol(ParserSym.OP_DIV, yytext()); }
{INIT} { return symbol(ParserSym.INIT, yytext()); }
{PUNTO} { return symbol(ParserSym.PUNTO, yytext()); }
{INTEGER} { return symbol(ParserSym.INTEGER, yytext()); }
{FLOAT} { return symbol(ParserSym.FLOAT, yytext()); }
{STRING} { return symbol(ParserSym.STRING, yytext()); }
{IGUAL_IGUAL} { return symbol(ParserSym.IGUAL_IGUAL, yytext()); }
{PUNTO_COMA} { return symbol(ParserSym.PUNTO_COMA, yytext()); }
{CONST_ENTERA} {
                if(!esCteEnteraValida())
                  throw new InvalidIntegerException(yytext() + " esta fuera de rango permitido.");
                guardarCTE("int");
                return symbol(ParserSym.CONST_ENTERA, yytext());
            }
{PRINTF} { return symbol(ParserSym.PRINTF, yytext()); }
{SCANF} {  return symbol(ParserSym.SCANF, yytext()); }
{AND} { return symbol(ParserSym.AND, yytext()); }
{OR} { return symbol(ParserSym.OR, yytext()); }
{NOT} { return symbol(ParserSym.NOT, yytext()); }
{SALTO_LINEA} { return symbol(ParserSym.SALTO_LINEA, yytext()); }
{COMENTARIO_EN_LINEA} { /*ignore*/ }
{OP_SUMA} { return symbol(ParserSym.OP_SUMA, yytext()); }
{OP_MULT} { return symbol(ParserSym.OP_MULT, yytext()); }
{IF} { return symbol(ParserSym.IF, yytext()); }
{ELSE} { return symbol(ParserSym.ELSE, yytext()); }
{GETPENULTIMATEPOSITION} { return symbol(ParserSym.GETPENULTIMATEPOSITION, yytext()); }
{SUMALOSULTIMOS} { return symbol(ParserSym.SUMALOSULTIMOS, yytext()); }

{WHILE} { return symbol(ParserSym.WHILE, yytext()); }
{COMA} { return symbol(ParserSym.COMA, yytext()); }
{DISTINTO} { return symbol(ParserSym.DISTINTO, yytext()); }
{MENOR_IGUAL} { return symbol(ParserSym.MENOR_IGUAL, yytext()); }
{MAYOR_IGUAL} { return symbol(ParserSym.MAYOR_IGUAL, yytext()); }
{MENOR} { return symbol(ParserSym.MENOR, yytext()); }
{MAYOR} { return symbol(ParserSym.MAYOR, yytext()); }
{LLAVE_A} { return symbol(ParserSym.LLAVE_A, yytext()); }
{LLAVE_C} { return symbol(ParserSym.LLAVE_C, yytext()); }
{COR_A} {  return symbol(ParserSym.COR_A, yytext()); }
{COR_C} {  return symbol(ParserSym.COR_C, yytext()); }
{CONST_REAL} {
          if(!esCteFloatValido())
              throw new InvalidIntegerException(yytext() + " esta fuera de rango permitido.");
          guardarCTE("float");
          return symbol(ParserSym.CONST_REAL, yytext());
      }

{ID} {
            if(!esLongitudIdValida())
                throw new InvalidLengthException(yytext() + " esta fuera de rango permitido.");
            guardarToken(); 
            return symbol(ParserSym.ID,yytext()); }
{TEXTO} {
          if(!esLongitudStringValida())
              throw new InvalidLengthException("\"" + yytext() + "\""+ " excede el maximo permitido");
          guardarCTE("string");
          return symbol(ParserSym.TEXTO, yytext());
      }

"\n" { /*ignore*/ }
"\t" { /*ignore*/ }
"\n\t" { /*ignore*/ }
" "	 { /*ignore*/ }
"\r\n" { /*ignore*/ }

}
<<EOF>> { return symbol(ParserSym.EOF); }
/* error fallback */
[^] { throw new UnknownCharacterException(yytext()); }
