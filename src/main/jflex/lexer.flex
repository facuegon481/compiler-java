package lyc.compiler;

import java_cup.runtime.Symbol;
import lyc.compiler.ParserSym;
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
  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }
%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
Identation =  [ \t\f]
WhiteSpace = {LineTerminator} | {Identation}

DIGITO				=	[0-9]
LETRA				=	[a-zA-Z]

INIT				=	"init"
PUNTO           	=   "."
INTEGER				=	"int"
FLOAT				=	"float"
STRING				=	"string"
IGUAL_IGUAL         =	"=="
ASIGNACION			=	":="
PUNTO_COMA			=	";"
PRINTF				=	"escribir"
SCANF				=	"leer"
AND					=	"AND"
OR					=	"OR"
NOT                 =   "NOT"
SALTO_LINEA		    =	"\n|\r\n|\r"
CARACTER_NO_SALTO 	= 	[^\r\n]
COMENTARIO_EN_LINEA =   "*-" {CARACTER_NO_SALTO}* "-*"
ID			        =	{LETRA}({LETRA}|{DIGITO})*
OP_SUMA		        =	"+"
OP_MULT              =	"*"
OP_DIV              =	"/"
PAREN_A			    =	"("
PAREN_C			    =	")"
IF                  =	"si"
ELSE				=	"sino"
WHILE               =	"mientras"
COMA                =	","
LITERAL             =	[\"]{CARACTER_NO_SALTO}*[\"]
DISTINTO            =	"<>"
MENOR_IGUAL         =	"<="
MAYOR_IGUAL         =	">="
MENOR               =	"<"
MAYOR               =	">"
LLAVE_A     		=	"{"
LLAVE_C   			=	"}"
CONST_ENTERA        =	(([1-9]{DIGITO}*)| 0)
CONST_REAL          =	{CONST_ENTERA}? {PUNTO} {DIGITO}*
OP_REST		        =	"-"


%%


/* keywords */

<YYINITIAL> {
  /* identifiers */
    {OP_REST} { System.out.print("SUB "); return symbol(ParserSym.SUB);}
    {PAREN_A} {System.out.print("PAREN_A "); return symbol(ParserSym.OPEN_BRACKET);}
    {PAREN_C} {System.out.print("PAREN_C "); return symbol(ParserSym.CLOSE_BRACKET);}
    {OP_DIV} {System.out.print("OP_DIV "); return symbol(ParserSym.DIV);}
    {INIT} {System.out.print("INIT "); return symbol(ParserSym.INIT);}
    {PUNTO} {System.out.print("PUNTO "); return symbol(ParserSym.PUNTO);}
    {INTEGER} {System.out.print("INTEGER "); return symbol(ParserSym.INTEGER);}
    {FLOAT} {System.out.print("FLOAT "); return symbol(ParserSym.FLOAT);}
    {STRING} {System.out.print("STRING "); return symbol(ParserSym.STRING);}
    {IGUAL_IGUAL} {System.out.print("IGUAL_IGUAL "); return symbol(ParserSym.IGUAL_IGUAL);}
    {ASIGNACION} {System.out.print("ASIGNACION "); return symbol(ParserSym.ASSIG);}
    {PUNTO_COMA} {System.out.print("PUNTO_COMA "); return symbol(ParserSym.PUNTO_COMA);}
    {PRINTF} {System.out.print("PRINTF "); return symbol(ParserSym.PRINTF);}
    {SCANF} {System.out.print("SCANF "); return symbol(ParserSym.SCANF);}
    {AND} {System.out.print("AND "); return symbol(ParserSym.AND);}
    {OR} {System.out.print("OR "); return symbol(ParserSym.OR);}
    {NOT} {System.out.print("NOT "); return symbol(ParserSym.NOT);}
    {SALTO_LINEA} {System.out.print("SALTO_LINEA "); return symbol(ParserSym.SALTO_LINEA);}
    {COMENTARIO_EN_LINEA} { /* ignore */ }
    {OP_SUMA} {System.out.print("OP_SUMA "); return symbol(ParserSym.PLUS);}
    {OP_MULT} {System.out.print("OP_MULT "); return symbol(ParserSym.MULT);}
    {IF} {System.out.print("IF "); return symbol(ParserSym.IF);}
    {ELSE} {System.out.print("ELSE "); return symbol(ParserSym.ELSE);}
    {WHILE} {System.out.print("WHILE "); return symbol(ParserSym.WHILE);}
    {COMA} {System.out.print("COMA "); return symbol(ParserSym.COMA);}
    {LITERAL} {System.out.print("LITERAL "); return symbol(ParserSym.LITERAL);}
    {DISTINTO} {System.out.print("DISTINTO "); return symbol(ParserSym.DISTINTO);}
    {MENOR_IGUAL} {System.out.print("MENOR_IGUAL "); return symbol(ParserSym.MENOR_IGUAL);}
    {MAYOR_IGUAL} {System.out.print("MAYOR_IGUAL "); return symbol(ParserSym.MAYOR_IGUAL);}
    {MENOR} {System.out.print("MENOR "); return symbol(ParserSym.MENOR);}
    {MAYOR} {System.out.print("MAYOR "); return symbol(ParserSym.MAYOR);}
    {LLAVE_A} {System.out.print("LLAVE_A "); return symbol(ParserSym.LLAVE_A);}
    {LLAVE_C} {System.out.print("LLAVE_C "); return symbol(ParserSym.LLAVE_C);}
    {CONST_REAL} {System.out.print("CONST_REAL "); return symbol(ParserSym.CONST_REAL);}


    {CONST_ENTERA} {System.out.print("CONST_ENTERA "); return symbol(ParserSym.INTEGER_CONSTANT);}
    {ID} { System.out.print("ID ");return symbol(ParserSym.IDENTIFIER, yytext()); }
    {DIGITO} {System.out.print("DIGITO "); return symbol(ParserSym.DIGITO, yytext());}
    {LETRA} {System.out.print("LETRA "); return symbol(ParserSym.LETRA, yytext());}
  /* Constants */

  /* operators */

  /* whitespace */
    {WhiteSpace} { /* ignore */ }
    <<EOF>>  {System.out.print("EOF "); return symbol(ParserSym.EOF);}
}


/* error fallback */
    [^] { throw new UnknownCharacterException(yytext()); }
