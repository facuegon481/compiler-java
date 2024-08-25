package lyc.compiler;

import java_cup.runtime.Symbol;
import lyc.compiler.ParserSym;
import lyc.compiler.constants.Constants;import lyc.compiler.files.SymbolTableGenerator;import lyc.compiler.model.*;
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
      return value >= Constants.MIN_INTEGER_CONSTANT && value <= Constants.MAX_INTEGER_CONSTANT;
  }

  private boolean esCteFloatValido(){
      double cteFloat = Math.abs(Double.parseDouble(yytext()));
      return cteFloat >= Constants.MIN_FLOAT_CONSTANT && cteFloat <= Constants.MAX_FLOAT_CONSTANT;
  }

  private boolean esLongitudStringValida() {
      return yylength() <= Constants.MAX_LENGTH_STRING;
  }

  private void guardarToken() {
      SymbolTableGenerator.getInstance().addToken(yytext());
  }

  private void guardarCTE(String dataType){
      SymbolTableGenerator.getInstance().addToken(yytext(),dataType);
  }

%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
Identation = [\t\f]
WhiteSpace = {LineTerminator}|{Identation}

DIGITO = [0-9]
LETRA = [a-zA-Z]
TEXTO = [\"].*[\"]

INIT = "init"
PUNTO = "."
INTEGER = "int"
FLOAT = "float"
STRING = "string"
IGUAL_IGUAL = "=="
ASIGNACION = ":="
PUNTO_COMA = ";"
PRINTF = "escribir"
SCANF = "leer"
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

LITERAL = [\"]{CARACTER_NO_SALTO}*[\"]
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
{OP_REST} { System.out.println("SUB "); return symbol(ParserSym.SUB, yytext()); }
{PAREN_A} { System.out.println("PAREN_A "); return symbol(ParserSym.OPEN_BRACKET, yytext()); }
{PAREN_C} { System.out.println("PAREN_C "); return symbol(ParserSym.CLOSE_BRACKET, yytext()); }
{OP_DIV} { System.out.println("OP_DIV "); return symbol(ParserSym.DIV, yytext()); }
{INIT} { System.out.println("INIT "); return symbol(ParserSym.INIT, yytext()); }
{PUNTO} { System.out.println("PUNTO "); return symbol(ParserSym.PUNTO, yytext()); }
{INTEGER} { System.out.println("INTEGER "); return symbol(ParserSym.INTEGER, yytext()); }
{FLOAT} { System.out.println("FLOAT "); return symbol(ParserSym.FLOAT, yytext()); }
{STRING} { System.out.println("STRING "); return symbol(ParserSym.STRING, yytext()); }
{IGUAL_IGUAL} { System.out.println("IGUAL_IGUAL "); return symbol(ParserSym.IGUAL_IGUAL, yytext()); }
{ASIGNACION} { System.out.println("ASIGNACION "); return symbol(ParserSym.ASSIG, yytext()); }
{PUNTO_COMA} { System.out.println("PUNTO_COMA "); return symbol(ParserSym.PUNTO_COMA, yytext()); }
{CONST_ENTERA} {
                System.out.println("CONST_ENTERAsa ");
                System.out.println(yytext());
                if(!esCteEnteraValida()){
                  throw new InvalidIntegerException(yytext() + " esta fuera de rango permitido.");
                }
                guardarCTE("int");
                return symbol(ParserSym.CONST_ENTERA, yytext());
            }
{PRINTF} { System.out.println("PRINTF "); return symbol(ParserSym.PRINTF, yytext()); }
{SCANF} { System.out.println("SCANF "); return symbol(ParserSym.SCANF, yytext()); }
{AND} { System.out.println("AND "); return symbol(ParserSym.AND, yytext()); }
{OR} { System.out.println("OR "); return symbol(ParserSym.OR, yytext()); }
{NOT} { System.out.println("NOT "); return symbol(ParserSym.NOT, yytext()); }
{SALTO_LINEA} { System.out.println("SALTO_LINEA "); return symbol(ParserSym.SALTO_LINEA, yytext()); }
{COMENTARIO_EN_LINEA} { /*ignore*/ }
{OP_SUMA} { System.out.println("OP_SUMA "); return symbol(ParserSym.PLUS, yytext()); }
{OP_MULT} { System.out.println("OP_MULT "); return symbol(ParserSym.MULT, yytext()); }
{IF} { System.out.println("IF "); return symbol(ParserSym.IF, yytext()); }
{ELSE} { System.out.println("ELSE "); return symbol(ParserSym.ELSE, yytext()); }
{WHILE} { System.out.println("WHILE "); return symbol(ParserSym.WHILE, yytext()); }
{COMA} { System.out.println("COMA "); return symbol(ParserSym.COMA, yytext()); }
{LITERAL} { System.out.println("LITERAL "); return symbol(ParserSym.LITERAL, yytext()); }
{DISTINTO} { System.out.println("DISTINTO "); return symbol(ParserSym.DISTINTO, yytext()); }
{MENOR_IGUAL} { System.out.println("MENOR_IGUAL "); return symbol(ParserSym.MENOR_IGUAL, yytext()); }
{MAYOR_IGUAL} { System.out.println("MAYOR_IGUAL "); return symbol(ParserSym.MAYOR_IGUAL, yytext()); }
{MENOR} { System.out.println("MENOR "); return symbol(ParserSym.MENOR, yytext()); }
{MAYOR} { System.out.println("MAYOR "); return symbol(ParserSym.MAYOR, yytext()); }
{LLAVE_A} { System.out.println("LLAVE_A "); return symbol(ParserSym.LLAVE_A, yytext()); }
{LLAVE_C} { System.out.println("LLAVE_C "); return symbol(ParserSym.LLAVE_C, yytext()); }
{CONST_REAL} {
          System.out.println("CONST_REAL ");
          if(!esCteFloatValido())
              throw new InvalidIntegerException(yytext() + " esta fuera de rango permitido.");
          guardarCTE("float");
          return symbol(ParserSym.CONST_REAL, yytext());
      }

{ID} { System.out.println("ID "); guardarToken(); return symbol(ParserSym.IDENTIFIER,yytext()); }
{TEXTO} {
          if(!esLongitudStringValida())
              throw new InvalidLengthException("\"" + yytext() + "\""+ " excede el maximo permitido");
          guardarCTE("string");
          return symbol(ParserSym.TEXTO, yytext());
      }

"\n"				{}
"\t"				{}
"\n\t"				{}
" "					{}
"\r\n"				{}
}

/* error fallback */
[^] { throw new UnknownCharacterException(yytext()); }
