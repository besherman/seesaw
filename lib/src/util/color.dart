part of seesaw.util;

class Color implements Paint {
    static final Color WHITE = new Color.fromHex("#FFFFFF"); 
    static final Color SILVER = new Color.fromHex("#C0C0C0"); 
    static final Color GRAY = new Color.fromHex("#808080"); 
    static final Color BLACK = new Color.fromHex("#000000"); 
    static final Color RED = new Color.fromHex("#FF0000"); 
    static final Color MAROON = new Color.fromHex("#800000"); 
    static final Color YELLOW = new Color.fromHex("#FFFF00"); 
    static final Color OLIVE = new Color.fromHex("#808000"); 
    static final Color LIME = new Color.fromHex("#00FF00"); 
    static final Color GREEN = new Color.fromHex("#008000"); 
    static final Color AQUA = new Color.fromHex("#00FFFF"); 
    static final Color TEAL = new Color.fromHex("#008080"); 
    static final Color BLUE = new Color.fromHex("#0000FF"); 
    static final Color NAVY = new Color.fromHex("#000080"); 
    static final Color FUCHSIA = new Color.fromHex("#FF00FF"); 
    static final Color PURPLE = new Color.fromHex("#800080");    
    
    final String _fillStyle;
    
    Color.fromHex(String hex): _fillStyle = hex;
    Color.fromRgb(int r, int g, int b): _fillStyle = "rgb(${r},${g},${b})";
    Color.fromRgba(int r, int g, int b, int a): _fillStyle = "rgba(${r},${g},${b},${a})";

    Object getFillStyle(html.CanvasRenderingContext2D ctx) => _fillStyle;
}