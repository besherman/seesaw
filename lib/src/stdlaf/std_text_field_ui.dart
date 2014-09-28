part of seesaw.stdlaf;

class StdTextFieldUI implements ComponentUI {
    TextField _field;
    
    void installUI(Component c) {
        _field = c;
        c.border = new LineBorder(1, "#ABADB3");
        c.background = Color.WHITE;
    }
    
    void uninstallUI(Component c) {
        
        
    }
    
    void paint(html.CanvasRenderingContext2D ctx, Component c) {
        ctx.font = _field.font.toString();
        ctx.fillStyle = _field.foreground.getFillStyle(ctx);
        
        var text = _field.text;
        
        var bh = _field.bounds.height,
            bw = _field.bounds.width;
        
        var txtWidth = ctx.measureText(text).width;
        var txtHeight = _field.font.size;
        
        var x = 3;
        var y = (bh / 2 - txtHeight / 2 + txtHeight).round();
        
        ctx.fillText(text, x, y);
    }   
    
    void update(html.CanvasRenderingContext2D ctx, Component c) {
        if(c.background != null) {
            ctx.fillStyle = c.background.getFillStyle(ctx);
            ctx.fillRect(0, 0, c.bounds.width, c.bounds.height);
        }
        paint(ctx, c);
    }
}