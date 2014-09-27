part of seesaw.component;

class Component {
    final String uiClassID = "ComponentUI";
    
    /**
     * The bounds of this component relative to its parent.
     */
    Rectangle<int> _bounds;

    /**
   * The parent component if attached.
   */
    Component _parent;

    /**
   * Background stroke, or null if none.
   */
    Paint _background = Color.GRAY;
    
    Paint _foreground = Color.BLACK;

    Border _border;

    bool _valid = false;
    
    String name = ""; 
    
    Font _font = new Font("Tahoma", Font.PLAIN, 11);
    
    ComponentUI _ui;

    /**
   * Child components.
   */
    final List<Component> _components = new List<Component>();

    /**
   * Unmodifiable version of _components;
   */
    UnmodifiableListView<Component> _componentsView;
    
    final EventMulticaster _listeners = new EventMulticaster();
    
    Stream<MouseEvent> _onMouseMoved;
    Stream<MouseEvent> _onMousePressed;
    Stream<MouseEvent> _onMouseReleased;
    Stream<MouseEvent> _onMouseClicked;
    Stream<MouseEvent> _onMouseDragged;
    Stream<MouseEvent> _onMouseEntered;
    Stream<MouseEvent> _onMouseExited;
    
    
    Component() {
        _onMouseMoved = _listeners.createEventStream(MouseEvent.MOUSE_MOVED);
        _onMousePressed = _listeners.createEventStream(MouseEvent.MOUSE_PRESSED);
        _onMouseReleased = _listeners.createEventStream(MouseEvent.MOUSE_RELEASED);
        _onMouseClicked = _listeners.createEventStream(MouseEvent.MOUSE_CLICKED);
        _onMouseDragged = _listeners.createEventStream(MouseEvent.MOUSE_DRAGGED);
        _onMouseEntered = _listeners.createEventStream(MouseEvent.MOUSE_ENTERED);
        _onMouseExited = _listeners.createEventStream(MouseEvent.MOUSE_EXITED);
    }
    
    Stream<MouseEvent> get onMouseMoved    => _onMouseMoved;
    Stream<MouseEvent> get onMousePressed  => _onMousePressed;
    Stream<MouseEvent> get onMouseReleased => _onMouseReleased;
    Stream<MouseEvent> get onMouseClicked  => _onMouseClicked;
    Stream<MouseEvent> get onMouseDragged  => _onMouseDragged;
    Stream<MouseEvent> get onMouseEntered  => _onMouseEntered;
    Stream<MouseEvent> get onMouseExited   => _onMouseExited;
    

    Rectangle<int> get bounds => _bounds;
                   set bounds(Rectangle<int> bounds) {
        _bounds = bounds;
        invalidateIfValid();
    }

    Paint get background => _background;
    set background(Paint background) {
        _background = background;
        repaint();
    }

    Border get border => _border;
    set border(Border border) {
        _border = border;
        revalidate();
        repaint();
    }

    Component get parent => _parent;

    bool get valid => _valid;
    
    Font get font => _font;
    set font(Font font) {
        _font = font;
        revalidate();
        repaint();
    }
    
    Paint get foreground => _foreground;
    
    bool get isFocusOwner => KeyboardFocusManager.instance.getFocusOwner() == this;

    /**
     * Resets the UI to what the UIManager thinks we should use.
     */
    void updateUI() {
        setUI(UIManager.getUI(this));
    }
    
    void setUI(ComponentUI newUI) {
        if(_ui != null) {
            _ui.uninstallUI(this);
        }
        _ui = newUI;
        if(_ui != null) {
            _ui.installUI(this);
        }
        revalidate();
        repaint();
    }
    
   /**
    * Paint this component.
    */
    void paint(html.CanvasRenderingContext2D ctx) {
        if (bounds == null) {
            return;
        }
        
        print("Painting " + this.runtimeType.toString());
        
        
        ctx.save();
        paintComponent(ctx);
        ctx.restore();
        
        ctx.save();
        paintBorder(ctx);
        ctx.restore();
        
        paintChildren(ctx);
    }
    
    void paintComponent(html.CanvasRenderingContext2D ctx) {
        var p = parent != null ? parent.toString() : "null";
        print("i am '" + toString() + "' and my parent is '" + p + "'");
        if(_ui != null) {
            _ui.update(ctx, this);
        }
    }

    /**
     * Paints the border if it is set.
     */
    void paintBorder(html.CanvasRenderingContext2D ctx) {
        if (border != null) {
            border.paint(this, ctx);
        }
    }   
    
    void paintChildren(html.CanvasRenderingContext2D ctx) {
        getComponents().forEach((c) {
            ctx.save();
            var tx = c.bounds.left,
                ty = c.bounds.top;    
            ctx.translate(tx, ty);
            
            ctx.beginPath();
            ctx.rect(0, 0, c.bounds.width, c.bounds.height);
            ctx.clip();
            
            c.paint(ctx);
            
            ctx.restore();                        
        });
    }
    
    String toString() {
        return "${runtimeType} name=${name}";
    }
    
    /**
     * Schedule a later validate().
     */
    void revalidate() {
        invalidate();
        RepaintManager.currentManager(this).addInvalidComponent(this);
    }

    /**
   * Makes this component invalid, meaning that the layout has to change.
   */
    void invalidate() {
        _valid = false;
        invalidateParent();
    }

    /**
   * Invalidates this component, if it is valid.
   */
    void invalidateIfValid() {
        if (_valid) {
            invalidate();
        }
    }

    /**
   * Makes the parent invalid.
   */
    void invalidateParent() {
        if (parent != null) {
            parent.invalidateIfValid();
        }
    }

    void validate() {
        if (!_valid) {
            validateTree();
        }
    }

    void validateTree() {
        if (!_valid) {
            doLayout();

            getComponents().forEach((c) => c.validateTree());
        }
        _valid = true;
    }


    /**
   * Asks the component to lay out its children.
   */
    void doLayout() {
    }

    /**
   * Repaint this component.
   */
    void repaint() {
        var mgr = RepaintManager.currentManager(this);
        mgr.addDirtyRegion(this);
    }



    /**
   * Returns this component's [RootPane] or null if this is it.
   */
    Object getRootPane() {
        return _parent != null ? _parent.getRootPane() : null;
    }

    /**
   * Add a child component.
   */
    void add(Component c) {
        if (c._parent != null) {
            throw new StateError("trying to add a component that already has a parent");
        }
        if(c == this) {
            throw new StateError("trying to add a component to itself");
        }
        c._parent = this;
        _components.add(c);
        invalidateIfValid();
    }

    List<Component> getComponents() {
        if (_componentsView == null) {
            _componentsView = new UnmodifiableListView(_components);
        }
        return _componentsView;
    }

    /**
     * Dispatches an event to this component or one of its sub components.
     */
    void dispatchEvent(Event evt) {
        print("component got asked to handle an event: " + evt.toString());
    }
    

    Component getMouseEventTarget(int x, int y, dynamic eventIDs) {
        for (Component child in getComponents()) {
            var visible = true; // TODO: check the component
            
            Point<int> pointInChild = new Point<int>(x - bounds.left, y - bounds.top);
            if (visible && child.bounds.containsPoint(pointInChild)) {
                // a child contains the bounds, does it have a better match?
                var better = child.getMouseEventTarget(pointInChild.x, pointInChild.y, eventIDs);
                if (better != null) {
                    return better;
                } else if(child.isEventEnabled(eventIDs)){
                    return child;
                }
            }
        }
        
        if(bounds.containsPoint(new Point<int>(bounds.left, bounds.top)) && isEventEnabled(eventIDs)) {
            return this;
        }
        
        return null;
    }
    
    /**
     * Returns true if there are listeners for the given event ID.
     * eventIDs can either be an int or a List<int>
     */
    bool isEventEnabled(dynamic eventIDs) {
        if(eventIDs is int) {
            return _listeners.isEventEnabled(eventIDs);
        }
        List<int> list = eventIDs as List<int>;
        return list.any((id) => _listeners.isEventEnabled(id));
    }

    void processEvent(Event evt) {
        _listeners.fire(evt);
    }
}