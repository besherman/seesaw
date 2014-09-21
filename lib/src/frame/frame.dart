part of seesaw.frame;

class Frame extends Component {
  final RootPane _rootPane = new RootPane();
  final html.CanvasElement _canvas;
  final html.CanvasRenderingContext2D ctx; // TODO: fix this
  
  _Dispatcher _dispatcher;
  
  Frame(html.CanvasElement canvas) : _canvas = canvas, ctx = canvas.getContext("2d") {
    super.add(_rootPane);
    _dispatcher = new _Dispatcher(this);
    name = "Frame";    
    bounds = new Rectangle(0, 0, html.window.innerWidth, html.window.innerHeight);    
    html.window.onResize.listen(_resizeFrame);
    EventQueue.instance.setFrame(this);
  }
  
  void set bounds(Rectangle<int> newBounds) {
    super.bounds = newBounds;
    _canvas.width = newBounds.width;
    _canvas.height = newBounds.height;
  }
  
  void doLayout() {
    _rootPane.bounds = bounds;    
  }
  
  void dispatchEvent(Event evt) {
      if(_dispatcher.dispatchEvent(evt) == false) {
          super.dispatchEvent(evt);
      }
  }
  
  void paint(html.CanvasRenderingContext2D ctx) {
    ctx.fillStyle = "red";
    ctx.fillRect(0, 0, bounds.width, bounds.height);
  }
  
  void add(Component c) {    
    _rootPane.getContentPane().add(c);    
  }
  
  void _resizeFrame(html.Event evt) {
    bounds = new Rectangle(0, 0, html.window.innerWidth, html.window.innerHeight);
    repaint();
  }
}

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
        
        if(evt is MouseEvent) {
            MouseEvent e = evt;
            var id = evt.id;
            
            _trackMouseEnterExit(e);
            
            var x = e.x - _root.bounds.left, 
                y = e.y - _root.bounds.top;             
                       
            
            // MOUSE_RELEASED, MOUSE_CLICKED and MOUSE_DRAGGED should always be sent to the component that 
            // got the MOUSE_PRESSED
            if(id == MouseEvent.MOUSE_PRESSED && !_wasAMouseButtonDownBeforeThisEvent(e)) {
                _mousePressedTarget = _root.getMouseEventTarget(x, y, MouseEvent.MOUSE_PRESSED);
                _mouseReleasedTarget = _root.getMouseEventTarget(x, y, MouseEvent.MOUSE_RELEASED);
                _mouseClickedTarget = _root.getMouseEventTarget(x, y, MouseEvent.MOUSE_CLICKED);
                _mouseDraggedTarget = _root.getMouseEventTarget(x, y, MouseEvent.MOUSE_DRAGGED);
            }
            
            if(id == MouseEvent.MOUSE_MOVED) {
                var mouseOver = _root.getMouseEventTarget(x, y, id);
                _retargetMouseEvent(mouseOver, id, evt);
                return true;
            }
            
            if(id == MouseEvent.MOUSE_DRAGGED) {
                // if (isMouseGrab(e)) {
                _retargetMouseEvent(_mouseDraggedTarget, id, evt);
                return true;
            }            
            
            if(id == MouseEvent.MOUSE_PRESSED) {
                _retargetMouseEvent(_mousePressedTarget, id, evt);
                return true;
            }
            
            if(id == MouseEvent.MOUSE_RELEASED) {
                _retargetMouseEvent(_mouseReleasedTarget, id, evt);
                return true;
            }
            
            
            if(id == MouseEvent.MOUSE_CLICKED) {
                var mouseOver = _root.getMouseEventTarget(x, y, id);
                if(_mouseClickedTarget == mouseOver) {
                    // only send click if mouse is over the same component as we pressed on
                    _retargetMouseEvent(_mouseClickedTarget, id, evt);                    
                }
                return true;
            }
            
            if(id == MouseEvent.MOUSE_ENTERED || id == MouseEvent.MOUSE_EXITED) {
                // TODO: do something about this
                return true;
            }

        }        
        
        return false;        
    }
    
    void _trackMouseEnterExit(MouseEvent evt) {
        var x = evt.x - _root.bounds.left, 
            y = evt.y - _root.bounds.top;             
        
        var targetOver = _root.getMouseEventTarget(x, y, 
                [MouseEvent.MOUSE_ENTERED, MouseEvent.MOUSE_EXITED]);
        
        if(targetOver != _targetLastEntered) {
            if(_targetLastEntered != null && _targetLastEntered.isEventEnabled(MouseEvent.MOUSE_EXITED)) {
                _retargetMouseEvent(_targetLastEntered, MouseEvent.MOUSE_EXITED, evt);
            }
            
            if(targetOver != null && targetOver.isEventEnabled(MouseEvent.MOUSE_ENTERED)) {
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

        if(e.id == MouseEvent.MOUSE_PRESSED || e.id == MouseEvent.MOUSE_RELEASED) {
            switch(e.button) {
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
        return ((modifiers & (InputEvent.BUTTON1_DOWN_MASK
                              | InputEvent.BUTTON2_DOWN_MASK
                              | InputEvent.BUTTON3_DOWN_MASK)) != 0);
    }    
    
    void _retargetMouseEvent(Component target, int eventID, MouseEvent evt) {
        if(target == null) {
            return;
        }
        
        var x = evt.x, y = evt.y;
        for(Component component = target; component != null; component = component.parent) {
            x -= component.bounds.left;
            y -= component.bounds.top;
        }
        
        var retargeted = new MouseEvent(evt.source, eventID, evt.when, evt.modifiers, x, y, 
                evt.clickCount, evt.popupTrigger, evt.button);
        
        target.processEvent(retargeted);
    }
    
}