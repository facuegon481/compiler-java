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

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
Identation = [\t\f]
WhiteSpace = {LineTerminator}|{Identation} // necesario???

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

AND = "AND"
OR = "OR"
NOT = "NOT"
SALTO_LINEA = "\n|\r\n|\r"
CARACTER_NO_SALTO = [^\r\n]
COMENTARIO_EN_LINEA = "*-"{CARACTER_NO_SALTO}*"-*"
ID = {LETRA}({LETRA}|{DIGITO})*
OP_SUMA = "+"
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
OP_REST = "-"

%%


/* keywords */

<YYINITIAL>{
/* identifiers */
{OP_REST} { System.out.println("Lexer found: SUB "); return symbol(ParserSym.SUB, yytext()); }
{PAREN_A} { System.out.println("Lexer found: PAREN_A "); return symbol(ParserSym.OPEN_BRACKET, yytext()); }
{PAREN_C} { System.out.println("Lexer found: PAREN_C "); return symbol(ParserSym.CLOSE_BRACKET, yytext()); }
{OP_DIV} { System.out.println("Lexer found: OP_DIV "); return symbol(ParserSym.DIV, yytext()); }
{INIT} { System.out.println("Lexer found: INIT "); return symbol(ParserSym.INIT, yytext()); }
{PUNTO} { System.out.println("Lexer found: PUNTO "); return symbol(ParserSym.PUNTO, yytext()); }
{INTEGER} { System.out.println("Lexer found: INTEGER "); return symbol(ParserSym.INTEGER, yytext()); }
{FLOAT} { System.out.println("Lexer found: FLOAT "); return symbol(ParserSym.FLOAT, yytext()); }
{STRING} { System.out.println("Lexer found: STRING "); return symbol(ParserSym.STRING, yytext()); }
{IGUAL_IGUAL} { System.out.println("Lexer found: IGUAL_IGUAL "); return symbol(ParserSym.IGUAL_IGUAL, yytext()); }
{ASIGNACION} { System.out.println("Lexer found: ASIGNACION "); return symbol(ParserSym.ASSIG, yytext()); }
{PUNTO_COMA} { System.out.println("Lexer found: PUNTO_COMA "); return symbol(ParserSym.PUNTO_COMA, yytext()); }
{CONST_ENTERA} {
                System.out.println("Lexer found: CONST_ENTERA ");
                if(!esCteEnteraValida())
                  throw new InvalidIntegerException(yytext() + " esta fuera de rango permitido.");
                guardarCTE("int");
                return symbol(ParserSym.INTEGER_CONSTANT, yytext());
            }
{PRINTF} { System.out.println("Lexer found: PRINTF "); return symbol(ParserSym.PRINTF, yytext()); }
{SCANF} { System.out.println("Lexer found: SCANF "); return symbol(ParserSym.SCANF, yytext()); }
{AND} { System.out.println("Lexer found: AND "); return symbol(ParserSym.AND, yytext()); }
{OR} { System.out.println("Lexer found: OR "); return symbol(ParserSym.OR, yytext()); }
{NOT} { System.out.println("Lexer found: NOT "); return symbol(ParserSym.NOT, yytext()); }
{SALTO_LINEA} { System.out.println("Lexer found: SALTO_LINEA "); return symbol(ParserSym.SALTO_LINEA, yytext()); }
{COMENTARIO_EN_LINEA} { /*ignore*/ }
{OP_SUMA} { System.out.println("Lexer found: OP_SUMA "); return symbol(ParserSym.PLUS, yytext()); }
{OP_MULT} { System.out.println("Lexer found: OP_MULT "); return symbol(ParserSym.MULT, yytext()); }
{IF} { System.out.println("Lexer found: IF "); return symbol(ParserSym.IF, yytext()); }
{ELSE} { System.out.println("Lexer found: ELSE "); return symbol(ParserSym.ELSE, yytext()); }
{GETPENULTIMATEPOSITION} { System.out.println("Lexer found: GETPENULTIMATEPOSITION "); return symbol(ParserSym.GETPENULTIMATEPOSITION, yytext()); }
{SUMALOSULTIMOS} { System.out.println("Lexer found: SUMALOSULTIMOS "); return symbol(ParserSym.SUMALOSULTIMOS, yytext()); }

{WHILE} { System.out.println("Lexer found: WHILE "); return symbol(ParserSym.WHILE, yytext()); }
{COMA} { System.out.println("Lexer found: COMA "); return symbol(ParserSym.COMA, yytext()); }
{DISTINTO} { System.out.println("Lexer found: DISTINTO "); return symbol(ParserSym.DISTINTO, yytext()); }
{MENOR_IGUAL} { System.out.println("Lexer found: MENOR_IGUAL "); return symbol(ParserSym.MENOR_IGUAL, yytext()); }
{MAYOR_IGUAL} { System.out.println("Lexer found: MAYOR_IGUAL "); return symbol(ParserSym.MAYOR_IGUAL, yytext()); }
{MENOR} { System.out.println("Lexer found: MENOR "); return symbol(ParserSym.MENOR, yytext()); }
{MAYOR} { System.out.println("Lexer found: MAYOR "); return symbol(ParserSym.MAYOR, yytext()); }
{LLAVE_A} { System.out.println("Lexer found: LLAVE_A "); return symbol(ParserSym.LLAVE_A, yytext()); }
{LLAVE_C} { System.out.println("Lexer found: LLAVE_C "); return symbol(ParserSym.LLAVE_C, yytext()); }
{COR_A} { System.out.println("Lexer found: COR_A "); return symbol(ParserSym.COR_A, yytext()); }
{COR_C} { System.out.println("Lexer found: COR_C "); return symbol(ParserSym.COR_C, yytext()); }
{CONST_REAL} {
          System.out.println("Lexer found: CONST_REAL ");
          if(!esCteFloatValido())
              throw new InvalidIntegerException(yytext() + " esta fuera de rango permitido.");
          guardarCTE("float");
          return symbol(ParserSym.CONST_REAL, yytext());
      }

{ID} { System.out.println("Lexer found: ID "); 
            if(!esLongitudIdValida())
                throw new InvalidLengthException(yytext() + " esta fuera de rango permitido.");
            guardarToken(); 
            return symbol(ParserSym.IDENTIFIER,yytext()); }
{TEXTO} { System.out.println("Lexer found: TEXTO ");
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
<<EOF>> { System.out.println("Lexer found: EOF "); return symbol(ParserSym.EOF); }
/* error fallback */
[^] { throw new UnknownCharacterException(yytext()); }
