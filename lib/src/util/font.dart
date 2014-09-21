part of seesaw.util;

class Font {
    static final int PLAIN       = 0;
    static final int BOLD        = 1;
    static final int ITALIC      = 2;
    
    static final Map<String, Font> _cache = <String, Font>{}; 
    
    final String _name;
    final int _style;
    final int _size;
    final String _str;
    
    factory Font(String name, int style, int size) {
        String str = _buildString(name, style, size);
        var font = _cache[str];
        if(font == null) {
            font = new Font._internal(name, style, size, str);
            _cache[str] = font;
        }
        return font;
    }
    
    Font._internal(this._name, this._style, this._size, this._str);
    
    String get name => _name;
    int get size => _size;
    bool get bold => (_style & BOLD) != 0;
    bool get italic => (_style & ITALIC) != 0;
    bool get plain => _style == 0;   
    
    String toString() => _str;    
    
    static String _buildString(String name, int style, int size) {
        var builder = new List<String>();
        if((style & ITALIC) != 0)  {
            builder.add("italic");
        }
        if((style & BOLD) != 0) {
            builder.add("bold");
        }
        builder.add("${size}pt");
        builder.add(name);
        return builder.join(" ");
    }
}