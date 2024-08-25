package lyc.compiler.files;

public class SymbolTableRecord {

    private String type;
    private String value;
    private String length;

    public SymbolTableRecord(){
        this.type = null;
        this.value = null;
        this.length = null;
    }

    public SymbolTableRecord(String type, String value, String length){
        this.type = type;
        this.value = value;
        this.length = length;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getLength() {
        return length;
    }

    public void setLength(String length) {
        this.length = length;
    }
}
