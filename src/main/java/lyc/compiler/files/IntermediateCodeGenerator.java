package lyc.compiler.files;

import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;

import lyc.compiler.model.Terceto;

public class IntermediateCodeGenerator implements FileGenerator {
    private static IntermediateCodeGenerator intermediateCodeGenerator;
    public static HashMap<Integer,Terceto> ListaTercetos = new HashMap<Integer,Terceto>();
    public static Integer NuevoTercetoNum = 11;

    public static IntermediateCodeGenerator getInstance() {
        if(intermediateCodeGenerator == null) {
            intermediateCodeGenerator = new IntermediateCodeGenerator();
        }
        return intermediateCodeGenerator;
    }

    @Override
    public void generate(FileWriter fileWriter) throws IOException {
        String file = "";
        for (Integer key : ListaTercetos.keySet()) {
            file += "[" + key.toString() + "] "+ ListaTercetos.get(key).toString() + "\n";
        }
        fileWriter.write(file);
    }

    public static Integer CrearTerceto(String primero, Object segundo, Object tercero) {
        Terceto nuevo = new Terceto(primero, segundo.toString(), tercero.toString());
        ListaTercetos.put(NuevoTercetoNum, nuevo);
        NuevoTercetoNum++;
        return NuevoTercetoNum - 1;
    }
}
