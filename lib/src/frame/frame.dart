part of seesaw.frame;

class Frame extends Component {
    final RootPane _rootPane = new RootPane();
    final html.CanvasElement _canvas;
    final html.CanvasRenderingContext2D ctx;
    _DOMMouseEventHandler _domMouseEventHandler;
    _DOMWindowEventHandler _domWindowEventHandler;
    _Dispatcher _dispatcher;


    Frame(html.CanvasElement canvas)
            : _canvas = canvas,
              ctx = canvas.getContext("2d") {
        super.add(_rootPane);
        _dispatcher = new _Dispatcher(this);
        name = "Window";

        _domMouseEventHandler = new _DOMMouseEventHandler(this);
        _domMouseEventHandler.register();

        _domWindowEventHandler = new _DOMWindowEventHandler(this);
        _domWindowEventHandler.register();
    }

    void set bounds(Rectangle<int> newBounds) {
        _canvas.width = newBounds.width;
        _canvas.height = newBounds.height;
        super.bounds = newBounds;
    }

    void doLayout() {
        _rootPane.bounds = bounds;
    }

    void dispatchEvent(Event evt) {
        if (_dispatcher.dispatchEvent(evt) == false) {
            super.dispatchEvent(evt);
        }
    }

    void add(Component c) {
        _rootPane.getContentPane().add(c);
    }

}

/******************************************************************************
 * Dispatcher
 *****************************************************************************/
class _Dispatcher {
    /** the top most component (the frame) */
    final Component _root;

    /** the component that got the MOUSE_PRESSED event */
    Component _mousePressedTarget;
    Component _mouseReleasedTarget;
    Component _mouseClickedTarget;
    Component _mouseDraggedTarget;

    /** The last component the mouse entered */
    Component _targetLastEntered;

    _Dispatcher(this._root);


    bool dispatchEvent(Event evt) {
        // find the deepest child that will accept this event

        if (evt is MouseEvent) {
            MouseEvent e = evt;
            var id = evt.id;

            _trackMouseEnterExit(e);

            var x = e.x - _root.bounds.left,
                    y = e.y - _root.bounds.top;


            // MOUSE_RELEASED, MOUSE_CLICKED and MOUSE_DRAGGED should always be sent to the component that
            // got the MOUSE_PRESSED
            if (id == MouseEvent.MOUSE_PRESSED && !_wasAMouseButtonDownBeforeThisEvent(e)) {
                _mousePressedTarget = _root.getMouseEventTarget(x, y, MouseEvent.MOUSE_PRESSED);
                _mouseReleasedTarget = _root.getMouseEventTarget(x, y, MouseEvent.MOUSE_RELEASED);
                _mouseClickedTarget = _root.getMouseEventTarget(x, y, MouseEvent.MOUSE_CLICKED);
                _mouseDraggedTarget = _root.getMouseEventTarget(x, y, MouseEvent.MOUSE_DRAGGED);
            }

            if (id == MouseEvent.MOUSE_MOVED) {
                var mouseOver = _root.getMouseEventTarget(x, y, id);
                _retargetMouseEvent(mouseOver, id, evt);
                return true;
            }

            if (id == MouseEvent.MOUSE_DRAGGED) {
                // if (isMouseGrab(e)) {
                _retargetMouseEvent(_mouseDraggedTarget, id, evt);
                return true;
            }

            if (id == MouseEvent.MOUSE_PRESSED) {
                _retargetMouseEvent(_mousePressedTarget, id, evt);
                return true;
            }

            if (id == MouseEvent.MOUSE_RELEASED) {
                _retargetMouseEvent(_mouseReleasedTarget, id, evt);
                return true;
            }


            if (id == MouseEvent.MOUSE_CLICKED) {
                var mouseOver = _root.getMouseEventTarget(x, y, id);
                if (_mouseClickedTarget == mouseOver) {
                    // only send click if mouse is over the same component as we pressed on
                    _retargetMouseEvent(_mouseClickedTarget, id, evt);
                }
                return true;
            }

            if (id == MouseEvent.MOUSE_ENTERED || id == MouseEvent.MOUSE_EXITED) {
                // TODO: do something about this
                return true;
            }

        }

        return false;
    }

    void _trackMouseEnterExit(MouseEvent evt) {
        var x = evt.x - _root.bounds.left,
                y = evt.y - _root.bounds.top;

        var targetOver = _root.getMouseEventTarget(x, y, [MouseEvent.MOUSE_ENTERED, MouseEvent.MOUSE_EXITED]);

        if (targetOver != _targetLastEntered) {
            if (_targetLastEntered != null && _targetLastEntered.isEventEnabled(MouseEvent.MOUSE_EXITED)) {
                _retargetMouseEvent(_targetLastEntered, MouseEvent.MOUSE_EXITED, evt);
            }

            if (targetOver != null && targetOver.isEventEnabled(MouseEvent.MOUSE_ENTERED)) {
                _retargetMouseEvent(targetOver, MouseEvent.MOUSE_ENTERED, evt);
            }

            _targetLastEntered = targetOver;
        }
    }

    /**
     * Returns true if any other buttons were pressed other than the one 
     * that caused this event. 
     */
    bool _wasAMouseButtonDownBeforeThisEvent(MouseEvent e) {
        int modifiers = e.modifiers;

        if (e.id == MouseEvent.MOUSE_PRESSED || e.id == MouseEvent.MOUSE_RELEASED) {
            switch (e.button) {
                case MouseEvent.BUTTON1:
                    modifiers ^= InputEvent.BUTTON1_DOWN_MASK;
                    break;
                case MouseEvent.BUTTON2:
                    modifiers ^= InputEvent.BUTTON2_DOWN_MASK;
                    break;
                case MouseEvent.BUTTON3:
                    modifiers ^= InputEvent.BUTTON3_DOWN_MASK;
                    break;
            }
        }
        /* modifiers now as just before event */
        return ((modifiers & (InputEvent.BUTTON1_DOWN_MASK | InputEvent.BUTTON2_DOWN_MASK | InputEvent.BUTTON3_DOWN_MASK)) != 0);
    }

    void _retargetMouseEvent(Component target, int eventID, MouseEvent evt) {
        if (target == null) {
            return;
        }

        var x = evt.x,
                y = evt.y;
        for (Component component = target; component != null; component = component.parent) {
            x -= component.bounds.left;
            y -= component.bounds.top;
        }

        var retargeted = new MouseEvent(evt.source, eventID, evt.when, evt.modifiers, x, y, evt.clickCount, evt.popupTrigger, evt.button);

        target.processEvent(retargeted);
    }
}



/******************************************************************************
 * Window event handler
 *****************************************************************************/
class _DOMWindowEventHandler {
    Frame _frame;
    _DOMWindowEventHandler(this._frame);

    void register() {
        html.window.onResize.listen(_resizeFrame);
        _resizeFrame(null);
    }

    void _resizeFrame(html.Event evt) {
        _frame.bounds = new Rectangle(0, 0, html.window.innerWidth, html.window.innerHeight);
    }
}

/******************************************************************************
 * Mouse event handler
 *****************************************************************************/
class _DOMMouseEventHandler {
    Frame _frame;

    /** keep track of which buttons have been pressed */
    int _mousePressedButtons = 0;

    /** we need to know so we can filter out duplicates */
    int _lastX = -1;
    int _lastY = -1;

    _DOMMouseEventHandler(Frame this._frame);

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
        if (e.client.x == _lastX && e.client.y == _lastY) {
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
        switch (e.button) {
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
        switch (e.button) {
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
        if (_mousePressedButtons & InputEvent.BUTTON1_DOWN_MASK > 0) {
            buttons.add(1);
        }
        if (_mousePressedButtons & InputEvent.BUTTON2_DOWN_MASK > 0) {
            buttons.add(2);
        }
        if (_mousePressedButtons & InputEvent.BUTTON3_DOWN_MASK > 0) {
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

        if (e.type == "mousedown") {
            modifiers |= _mousePressedButtons;
        }
        return modifiers;
    }

}
