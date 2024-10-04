package lyc.compiler.files;

import lyc.compiler.constants.Constants;

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
        if(type == null) {
            return "";
        }
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getValue() {
        if(value == null) {
            return "";
        }
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getLength() {
        if(length == null | this.type != Constants.STRING_TYPE) {
            return "";
        }
        return length;
    }

    public void setLength(String length) {
        this.length = length;
    }
}
