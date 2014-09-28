part of seesaw.stdlaf;

class StdButtonUI implements ComponentUI {
    Subscriptions _subscriptions = new Subscriptions();
    Button _button;    
    
    _BackgroundPaint _plainPaint;
    _BackgroundPaint _rolloverPaint;
    _BackgroundPaint _armedPaint;
    
    Border _plainBorder = new LineBorder(1, "#ACACAC");
    Border _rolloverBorder = new LineBorder(1, "#7EB4EA");
    Border _armedBorder = new LineBorder(1, "#569DE5");
    
    void installUI(Component c) {
        _button = c as Button;
        _rolloverPaint = new _BackgroundPaint(_button, new Color.fromHex("#ECF4FC"), new Color.fromHex("#DCECFC"));
        _plainPaint = new _BackgroundPaint(_button, new Color.fromHex("#F0F0F0"), new Color.fromHex("#E5E5E5"));
        _armedPaint = new _BackgroundPaint(_button, new Color.fromHex("#DAECFC"), new Color.fromHex("#C4E0FC"));

        //_button.border = new LineBorder(1, "#ACACAC");
        _button.border = new _ButtonBorder();
        _button.font = new Font("Tahoma", Font.PLAIN, 11);        
        _button.background = null;
        
        
        _subscriptions.add(c.onMouseEntered.listen(_mouseEntered), "mouseEntered");
        _subscriptions.add(c.onMouseExited.listen(_mouseExited), "mouseExited");
        _subscriptions.add(c.onMousePressed.listen(_mousePressed), "mousePressed");
        _subscriptions.add(c.onMouseReleased.listen(_mouseReleased), "mouseReleased");
    }
    
    void uninstallUI(Component c) {
        _subscriptions.cancelAll();
    }    
    
    void paint(html.CanvasRenderingContext2D ctx, Component c) {
        var model = _button.model;
        
        if(model.armed) {
            _armedPaint.fillRect(ctx);
            _armedBorder.paint(c, ctx);
        } else if(model.pressed || model.rollover) {
            _rolloverPaint.fillRect(ctx);
            _rolloverBorder.paint(c, ctx);
        } else {
            _plainPaint.fillRect(ctx);
            _plainBorder.paint(c, ctx);
        }
        
     
        
        var left = 0;
        if(_button.text != null) {
            ctx.fillStyle = "black";
            var text = _button.text;            
            var font = _button.font;
            ctx.font = font.toString();
            var bh = _button.bounds.height,
                bw = _button.bounds.width,
                ih = 0,
                iw = 0;
            
            if(_button.icon != null) {
                ih = _button.icon.height;
                iw = _button.icon.width;
            }
            
            var txtWidth = ctx.measureText(text).width,
                txtHeight = font.size;
            
            var iconGap = iw > 0 ? _button.iconTextGap : 0;
            
            var totWidth = iw + iconGap + txtWidth;
                                  
            
            left = (bw / 2 - totWidth / 2).round();
            var x = left + iw + iconGap;
            var y = (bh / 2 + txtHeight / 2).round();
           
            ctx.fillText(text, x, y);
        }
        
        if(_button.icon != null) {
            var bw = _button.bounds.width,
                bh = _button.bounds.height,
                iw = _button.icon.width,
                ih = _button.icon.height;
            
            var x = left;
            var y = (bh / 2 - ih / 2).round();
            ctx.drawImage(_button.icon.image, x, y);
        }         
        
        
        if(_button.isFocusOwner) {
            ctx.setLineDash([1]);
            ctx.strokeStyle = "black";
            ctx.lineWidth = 0.5;
            ctx.strokeRect(3, 3, _button.bounds.width-6, _button.bounds.height-6);
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
        _button.model.rollover = true;
        if(_button.model.pressed) {
            _button.model.armed = true;
        }
        _button.repaint();
    }
    
    void _mouseExited(MouseEvent evt) {
        _button.model.armed = false;
        _button.model.rollover = false;
        _button.repaint();
    }  
    
    void _mousePressed(MouseEvent evt) {
        _button.model.armed = true;
        _button.model.pressed = true;
        _button.repaint();
    }
    
    void _mouseReleased(MouseEvent evt) {
        _button.model.pressed = false;
        _button.model.armed = false;
        _button.repaint();
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

class _ButtonBorder implements Border {
    Insets<int> get insets => const Insets<int>(0, 0, 0, 0);
    void paint(Component c, html.CanvasRenderingContext2D ctx) {}    
}




