part of seesaw.event;

/**
 * Takes events from the DOM and passes them on in the way that we prefer.
 */
class EventQueue {
    static final EventQueue instance = new EventQueue();

    Frame _frame;

    /** keep track of which buttons have been pressed */
    int _mousePressedButtons = 0;
    
    /** we need to know so we can filter out duplicates */
    int _lastX = -1;
    int _lastY = -1;

    void setFrame(Frame frame) {
        _frame = frame;
        register();
    }

    void register() {
        html.window.onResize.listen(_onResize);
        html.window.onMouseMove.listen(_onMouseMove);
        html.window.onMouseDown.listen(_onMouseDown);
        html.window.onMouseUp.listen(_onMouseUp);
        html.window.onMouseWheel.listen(_onMouseWheel);

        html.window.onClick.listen(_onClick);

        html.document.onMouseLeave.listen(_onMouseLeave);
        html.document.onMouseEnter.listen(_onMouseEnter);

        // Prevents right click context menu
        html.document.onContextMenu.listen((evt) {
            evt.preventDefault();
        });
    }

    void _onResize(html.Event e) {
    }

    void _onMouseMove(html.MouseEvent e) {
        if(e.client.x == _lastX && e.client.y == _lastY) {
            // we always get a moved togeather with clicked, down and up 
            return;
        }
        var id = _mousePressedButtons == 0 ? MouseEvent.MOUSE_MOVED : MouseEvent.MOUSE_DRAGGED;        
        var evt = new MouseEvent(_frame, id, e.timeStamp, _getModifiers(e), e.client.x, e.client.y, 0, false, MouseEvent.NOBUTTON);
        _frame.dispatchEvent(evt);
        _lastX = e.client.x;
        _lastY = e.client.y;
    }

    void _onMouseLeave(html.MouseEvent e) {
        var evt = new MouseEvent(_frame, MouseEvent.MOUSE_EXITED, e.timeStamp, _getModifiers(e), e.client.x, e.client.y, 0, false, MouseEvent.NOBUTTON);

        _frame.dispatchEvent(evt);
    }

    void _onMouseEnter(html.MouseEvent e) {
        var evt = new MouseEvent(_frame, MouseEvent.MOUSE_ENTERED, e.timeStamp, _getModifiers(e), e.client.x, e.client.y, 0, false, MouseEvent.NOBUTTON);

        _frame.dispatchEvent(evt);
    }

    void _onMouseDown(html.MouseEvent e) {
        switch(e.button) {
            case 0:
                _mousePressedButtons |= InputEvent.BUTTON1_DOWN_MASK;
                break;
            case 1:
                _mousePressedButtons |= InputEvent.BUTTON2_DOWN_MASK;
                break;
            case 2:
                _mousePressedButtons |= InputEvent.BUTTON3_DOWN_MASK;
                break;
        }
        
        var evt = new MouseEvent(_frame, MouseEvent.MOUSE_PRESSED, e.timeStamp, _getModifiers(e), e.client.x, e.client.y, 0, false, _getButtons(e));
        _frame.dispatchEvent(evt);        
    }

    void _onMouseUp(html.MouseEvent e) {
        switch(e.button) {
            case 0:
                _mousePressedButtons ^= InputEvent.BUTTON1_DOWN_MASK;
                break;
            case 1:
                _mousePressedButtons ^= InputEvent.BUTTON2_DOWN_MASK;
                break;
            case 2:
                _mousePressedButtons ^= InputEvent.BUTTON3_DOWN_MASK;
                break;
        }

        var evt = new MouseEvent(_frame, MouseEvent.MOUSE_RELEASED, e.timeStamp, _getModifiers(e), e.client.x, e.client.y, 0, false, _getButtons(e));
        _frame.dispatchEvent(evt);        
    }

    void _onClick(html.MouseEvent e) {
        var evt = new MouseEvent(_frame, MouseEvent.MOUSE_CLICKED, e.timeStamp, _getModifiers(e), e.client.x, e.client.y, 0, false, _getButtons(e));

        _frame.dispatchEvent(evt);
    }

    void _onMouseWheel(html.WheelEvent e) {

    }

    static int _getButtons(html.MouseEvent e) {
        var buttons = 0;
        switch (e.button) {
            case 0:
                buttons = MouseEvent.BUTTON1;
                break;
            case 1:
                buttons = MouseEvent.BUTTON2;
                break;
            case 2:
                buttons = MouseEvent.BUTTON3;
                break;
        }
        return buttons;
    }

    void _printDebug() {
        var buttons = new List<int>();
        if(_mousePressedButtons & InputEvent.BUTTON1_DOWN_MASK > 0) {
            buttons.add(1);
        }
        if(_mousePressedButtons & InputEvent.BUTTON2_DOWN_MASK > 0) {
            buttons.add(2);
        }
        if(_mousePressedButtons & InputEvent.BUTTON3_DOWN_MASK > 0) {
            buttons.add(3);
        }
        
        var down = buttons.join(",");
        print("Buttons down are: ${down}");
    }

    int _getModifiers(html.MouseEvent e) {
        int modifiers = 0;
        modifiers |= e.altKey ? InputEvent.ALT_DOWN_MASK : 0;
        modifiers |= e.ctrlKey ? InputEvent.CTRL_DOWN_MASK : 0;
        modifiers |= e.shiftKey ? InputEvent.SHIFT_DOWN_MASK : 0;

        if(e.type == "mousedown") {
            modifiers |= _mousePressedButtons;
        }
        return modifiers;
    }

}
