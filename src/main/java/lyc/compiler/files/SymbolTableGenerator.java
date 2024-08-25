package lyc.compiler.files;

import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class SymbolTableGenerator implements FileGenerator{
    private static SymbolTableGenerator symbolTable;

    private Map<String,SymbolTableRecord> symbols;
    private SymbolTableGenerator() {
        this.symbols = new HashMap<String,SymbolTableRecord>();
    }
    public static SymbolTableGenerator getInstance() {
        if(symbolTable == null) {
            symbolTable = new SymbolTableGenerator();
        }
        return symbolTable;
    }

    @Override
    public void generate(FileWriter fileWriter) throws IOException {
        String file = String.format("%-30s|%-30s|%-30s|%-30s\n","NOMBRE","TIPODATO","VALOR","LONGITUD");
        for (Map.Entry<String, SymbolTableRecord> entry : this.symbols.entrySet()) {
            file += String.format("%-30s", entry.getKey()) + "|" + entry.getValue().toString() + "\n";
        }
        fileWriter.write(file);
    }

    public void addToken(String token) {
        if(!this.symbols.containsKey(token)) {
            this.symbols.put(token,new SymbolTableRecord());
        }
    }

    public void addToken(String token,String dataType) {
        if(!this.symbols.containsKey(token)) {
            SymbolTableRecord data = new SymbolTableRecord(dataType,token,Integer.toString(token.length()-1));
            this.symbols.put("_" + token,data);
        }
    }
}
