part of seesaw.stdlaf;

class StdButtonUI implements ComponentUI {
    StreamSubscription<MouseEvent> _mouseEnteredSubscription, _mouseExitedSubscription,
                                   _mousePressedSubscription, _mouseReleasedSubscription;
    Button _button;
    
    Paint _plainPaint;
    Paint _hoverPaint;
    
    void installUI(Component c) {
        _button = c as Button;
        _hoverPaint = new _BackgroundPaint(_button, new Color.fromHex("#ECF4FC"), new Color.fromHex("#DCECFC"));
        _plainPaint = new _BackgroundPaint(_button, new Color.fromHex("#F0F0F0"), new Color.fromHex("#E5E5E5"));

        _button.border = new LineBorder(1, "#ACACAC");
        _button.font = new Font("Tahoma", Font.PLAIN, 11);        
        _button.background = _plainPaint;
        
        
        _mouseEnteredSubscription = c.onMouseEntered.listen(_mouseEntered);
        _mouseExitedSubscription = c.onMouseExited.listen(_mouseExited);
        _mousePressedSubscription = c.onMousePressed.listen(_mousePressed);
        _mouseReleasedSubscription = c.onMouseReleased.listen(_mouseReleased);
    }
    
    void uninstallUI(Component c) {
        _mouseEnteredSubscription.cancel();
        _mouseExitedSubscription.cancel();
        _mousePressedSubscription.cancel();
        _mouseReleasedSubscription.cancel();
    }    
    
    void paint(html.CanvasRenderingContext2D ctx, Component c) {
        if(_button.text != null) {
            ctx.fillStyle = "black";
            var text = _button.text;
            var bounds = _button.bounds;
            var font = _button.font;
            ctx.font = font.toString();        
            var width = ctx.measureText(text).width;
            
            var x = (bounds.width / 2 - width / 2).round();
            var y = (bounds.height / 2 + font.size / 2).round();
           
            ctx.fillText(text, x, y);
        }
    }
    
    void update(html.CanvasRenderingContext2D ctx, Component c) {
        if(c.background != null) {
            ctx.fillStyle = c.background.getFillStyle(ctx);
            ctx.fillRect(0, 0, c.bounds.width, c.bounds.height);
        }
        paint(ctx, c);
    }
    
    void _mouseEntered(MouseEvent evt) {
        _button.background = _hoverPaint;
        _button.border = new LineBorder(1, "#7EB4EA");        
    }
    
    void _mouseExited(MouseEvent evt) {
        _button.background = _plainPaint;
        _button.border = new LineBorder(1, "#ACACAC");
    }  
    
    void _mousePressed(MouseEvent evt) {
        print("pressed");
    }
    
    void _mouseReleased(MouseEvent evt) {
        print("released");    
    }
}

class _BackgroundPaint implements Paint {
    Component _component;
    int _lastHeight = -1;
    List<Color> _colors;
    LinearGradient _gradient;     
    
    _BackgroundPaint(this._component, Color c1, Color c2): _colors = [c1, c2];
    
    void fillRect(html.CanvasRenderingContext2D ctx) {
        var height = _component.bounds.height;
        if(height != _lastHeight) {
            _gradient = new LinearGradient(new Point<int>(0, 0), new Point<int>(0, height), [0, 1], _colors);
            _lastHeight = height;
        }
        ctx.fillStyle = _gradient.getFillStyle(ctx);
        ctx.fillRect(0, 0, _component.bounds.width, height);
    }
    
    Object getFillStyle(html.CanvasRenderingContext2D ctx) {
        return _colors[0].getFillStyle(ctx);
    }
}




