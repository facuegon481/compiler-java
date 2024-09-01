package lyc.compiler;

import lyc.compiler.factories.LexerFactory;
import lyc.compiler.model.CompilerException;
import lyc.compiler.model.InvalidIntegerException;
import lyc.compiler.model.InvalidLengthException;
import lyc.compiler.model.UnknownCharacterException;
import org.apache.commons.text.CharacterPredicates;
import org.apache.commons.text.RandomStringGenerator;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import static com.google.common.truth.Truth.assertThat;
import static lyc.compiler.constants.Constants.MAX_LENGTH;
import static org.junit.jupiter.api.Assertions.assertThrows;

public class LexerTest {

  private Lexer lexer;

  @Test 
  public void comment() throws Exception{
    scan("*-This is a comment-*");
    assertThat(nextToken()).isEqualTo(ParserSym.EOF);
  }

  @Test 
  public void invalidStringConstantLength() {
    assertThrows(InvalidLengthException.class, () -> {
      scan("\"%s\"".formatted(getRandomString()));
      nextToken();
    });
  }

  @Test 
  public void invalidIdLength() {
    assertThrows(InvalidLengthException.class, () -> {
      scan(getRandomString());
      nextToken();
    });
  }

  @Test 
  public void invalidPositiveIntegerConstantValue() {
    assertThrows(InvalidIntegerException.class, () -> {
      scan("%d".formatted(9223372036854775807L));
      nextToken();
    });
  }

  @Test @Disabled//PREGUNTAR ESTO - EN TEORIA NO TENIAMOS QUE RECONOCER ESTO EN EL LEXICO PERO HAY UN TEST PARA DETECTAR NEGATIVOS.
  public void invalidNegativeIntegerConstantValue() {
    assertThrows(InvalidIntegerException.class, () -> {
      scan("%d".formatted(-9223372036854775807L));
      nextToken();
    });
  }


  @Test 
  public void assignmentWithExpressions() throws Exception {
    scan("c:=d*(e-21)/4");
    assertThat(nextToken()).isEqualTo(ParserSym.ID);
    assertThat(nextToken()).isEqualTo(ParserSym.ASIGNACION);
    assertThat(nextToken()).isEqualTo(ParserSym.ID);
    assertThat(nextToken()).isEqualTo(ParserSym.OP_MULT);
    assertThat(nextToken()).isEqualTo(ParserSym.PAREN_A);
    assertThat(nextToken()).isEqualTo(ParserSym.ID);
    assertThat(nextToken()).isEqualTo(ParserSym.OP_REST);
    assertThat(nextToken()).isEqualTo(ParserSym.CONST_ENTERA);
    assertThat(nextToken()).isEqualTo(ParserSym.PAREN_C);
    assertThat(nextToken()).isEqualTo(ParserSym.OP_DIV);
    assertThat(nextToken()).isEqualTo(ParserSym.CONST_ENTERA);
    assertThat(nextToken()).isEqualTo(ParserSym.EOF);
  }

  @Test
  public void testLeerTexto() throws Exception {
    Path path = Paths.get("src/main/resources/input/test.txt");
    try {
      String content = Files.readString(path);
      scan(content);
      var token = nextToken();
      while(token != ParserSym.EOF)
      {
        token = nextToken();
      }
    }
    catch(Exception e){
      throw new Exception(e.getMessage());
    }
  }

  @Test
  public void getPenultimatePositionTest() throws Exception {
    scan("x := getPenultimatePosition([3, 8.2, 2, 55.5])");
    assertThat(nextToken()).isEqualTo(ParserSym.ID);
    assertThat(nextToken()).isEqualTo(ParserSym.ASIGNACION);
    assertThat(nextToken()).isEqualTo(ParserSym.GETPENULTIMATEPOSITION);
    assertThat(nextToken()).isEqualTo(ParserSym.PAREN_A);
    assertThat(nextToken()).isEqualTo(ParserSym.COR_A);
    assertThat(nextToken()).isEqualTo(ParserSym.CONST_ENTERA);
    assertThat(nextToken()).isEqualTo(ParserSym.COMA);
    assertThat(nextToken()).isEqualTo(ParserSym.CONST_REAL);
    assertThat(nextToken()).isEqualTo(ParserSym.COMA);
    assertThat(nextToken()).isEqualTo(ParserSym.CONST_ENTERA);
    assertThat(nextToken()).isEqualTo(ParserSym.COMA);
    assertThat(nextToken()).isEqualTo(ParserSym.CONST_REAL);
    assertThat(nextToken()).isEqualTo(ParserSym.COR_C);
    assertThat(nextToken()).isEqualTo(ParserSym.PAREN_C);
    assertThat(nextToken()).isEqualTo(ParserSym.EOF);
  }

  @Test
  public void sumaLosUltimosTest() throws Exception {
    scan("x := sumaLosUltimos(4; [28, 13.5, 4, 5.5, 17, 52])");
    assertThat(nextToken()).isEqualTo(ParserSym.ID);
    assertThat(nextToken()).isEqualTo(ParserSym.ASIGNACION);
    assertThat(nextToken()).isEqualTo(ParserSym.SUMALOSULTIMOS);
    assertThat(nextToken()).isEqualTo(ParserSym.PAREN_A);
    assertThat(nextToken()).isEqualTo(ParserSym.CONST_ENTERA);
    assertThat(nextToken()).isEqualTo(ParserSym.PUNTO_COMA);
    assertThat(nextToken()).isEqualTo(ParserSym.COR_A);
    assertThat(nextToken()).isEqualTo(ParserSym.CONST_ENTERA);
    assertThat(nextToken()).isEqualTo(ParserSym.COMA);
    assertThat(nextToken()).isEqualTo(ParserSym.CONST_REAL);
    assertThat(nextToken()).isEqualTo(ParserSym.COMA);
    assertThat(nextToken()).isEqualTo(ParserSym.CONST_ENTERA);
    assertThat(nextToken()).isEqualTo(ParserSym.COMA);
    assertThat(nextToken()).isEqualTo(ParserSym.CONST_REAL);
    assertThat(nextToken()).isEqualTo(ParserSym.COMA);
    assertThat(nextToken()).isEqualTo(ParserSym.CONST_ENTERA);
    assertThat(nextToken()).isEqualTo(ParserSym.COMA);
    assertThat(nextToken()).isEqualTo(ParserSym.CONST_ENTERA);
    assertThat(nextToken()).isEqualTo(ParserSym.COR_C);
    assertThat(nextToken()).isEqualTo(ParserSym.PAREN_C);
    assertThat(nextToken()).isEqualTo(ParserSym.EOF);
  }

  @Test 
  public void unknownCharacter() {
    assertThrows(UnknownCharacterException.class, () -> {
      scan("#");
      nextToken();
    });
  }

  @AfterEach
  public void resetLexer() {
    lexer = null;
  }

  private void scan(String input) {
    lexer = LexerFactory.create(input);
  }

  private int nextToken() throws IOException, CompilerException {
    return lexer.next_token().sym;
  }

  private static String getRandomString() {
    return new RandomStringGenerator.Builder()
            .filteredBy(CharacterPredicates.LETTERS)
            .withinRange('a', 'z')
            .build().generate(MAX_LENGTH * 2);
  }

}
