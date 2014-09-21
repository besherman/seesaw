part of seesaw.event;

// 100-103 ComponentEvent
// 500-507 MouseEvent
// 701     ItemEvent
// 1001    ActionEvent
// 2001    ChangeEvent

class Event {
  int _id;
  
  /**
   * the object that the event happened in
   */
  Object _source;
  
  
  Event(this._source, this._id);
  
  Object get source => _source;
  int    get id     => _id;
  String get type   => _id.toString();
  
  String paramString() {
    StringBuffer sb = new StringBuffer();
    sb..write("type=")    
      ..write(type)
      ..write(", source=\"")
      ..write(source.toString())
      ..write("\"");
    return sb.toString();
  }
  
  String toString() => "[Event: ${paramString()}]";
}

class ComponentEvent extends Event {
    static const int COMPONENT_MOVED     = 100;
    static const int COMPONENT_RESIZED   = 101;
    static const int COMPONENT_SHOWN     = 102;
    static const int COMPONENT_HIDDEN    = 103;
    
    ComponentEvent(Component source, int id) : super(source, id);
    
    Component get component => source as Component; 
    String    get type {
      switch(id) {
        case COMPONENT_HIDDEN:  return "COMPONENT_HIDDEN";
        case COMPONENT_MOVED:   return "COMPONENT_MOVED";
        case COMPONENT_RESIZED: return "COMPONENT_RESIZED";
        case COMPONENT_SHOWN:   return "COMPONENT_SHOWN";
        default:
          return super.type;        
      }
    }
    
    String toString() => "[ComponentEvent: ${paramString()}]";
}

class InputEvent extends ComponentEvent {
  static const int SHIFT_DOWN_MASK = 1 << 6;
  static const int CTRL_DOWN_MASK = 1 << 7;
  static const int META_DOWN_MASK = 1 << 8;
  static const int ALT_DOWN_MASK = 1 << 9;
  static const int BUTTON1_DOWN_MASK = 1 << 10;
  static const int BUTTON2_DOWN_MASK = 1 << 11;
  static const int BUTTON3_DOWN_MASK = 1 << 12;
  static const int ALT_GRAPH_DOWN_MASK = 1 << 13;  
  
  /** The time (in milliseconds since the epoch) at which the event was created. */
  num _when;  
  int _modifiers;
  
  InputEvent(Component source, int id, this._when, this._modifiers): super(source, id);
  
  num get when      => _when;
  int get modifiers => _modifiers;
  
  
  String paramString() {
    StringBuffer sb = new StringBuffer();
    sb..write(super.paramString())
      ..write(", shift=")
      ..write(modifiers & SHIFT_DOWN_MASK > 0)
      ..write(", ctrl=")
      ..write(modifiers & CTRL_DOWN_MASK > 0)
      ..write(", meta=")
      ..write(modifiers & META_DOWN_MASK > 0)
      ..write(", alt=")
      ..write(modifiers & ALT_DOWN_MASK > 0)
      ..write(", b1=")
      ..write(modifiers & BUTTON1_DOWN_MASK > 0)
      ..write(", b2=")
      ..write(modifiers & BUTTON2_DOWN_MASK > 0)
      ..write(", b3=")
      ..write(modifiers & BUTTON3_DOWN_MASK > 0)
      ..write(", when=")
      ..write(when);    
    return sb.toString();
  }  
  
  String toString() => "[InputEvent: ${paramString()}]";
}

class MouseEvent extends InputEvent {
  static const int MOUSE_CLICKED =  500;
  static const int MOUSE_PRESSED =  501; 
  static const int MOUSE_RELEASED = 502;
  static const int MOUSE_MOVED =    503; 
  static const int MOUSE_ENTERED =  504;
  static const int MOUSE_EXITED =   505; 
  static const int MOUSE_DRAGGED =  506; 
  static const int MOUSE_WHEEL =    507;

  static const int NOBUTTON = 0;
  static const int BUTTON1 =  1;
  static const int BUTTON2 =  2;
  static const int BUTTON3 =  3;
  
  
  int _x;
  int _y;
  int _clickCount;
  bool _popupTrigger;
  int _button;
  
  MouseEvent(Component source, int id, num when, int modifiers,
                    this._x, this._y, this._clickCount, this._popupTrigger,
                    this._button): super(source, id, when, modifiers);
  
  int  get x            => _x;
  int  get y            => _y;
  int  get clickCount   => _clickCount;
  bool get popupTrigger => _popupTrigger;
  int  get button       => _button;
  String    get type {
    switch(id) {
      case MOUSE_CLICKED: return "MOUSE_CLICKED";
      case MOUSE_PRESSED: return "MOUSE_PRESSED"; 
      case MOUSE_RELEASED: return "MOUSE_RELEASED";
      case MOUSE_MOVED: return "MOUSE_MOVED";
      case MOUSE_ENTERED: return "MOUSE_ENTERED";
      case MOUSE_EXITED: return "MOUSE_EXITED"; 
      case MOUSE_DRAGGED: return "MOUSE_DRAGGED"; 
      case MOUSE_WHEEL: return "MOUSE_WHEEL";
      default:
        return super.type;        
    }
  }
  
  String paramString() {
    StringBuffer sb = new StringBuffer();
    sb..write(super.paramString())
      ..write(", x=")
      ..write(x)
      ..write(", y=")
      ..write(y)
      ..write(", clickCount=")
      ..write(clickCount)
      ..write(", popupTrigger=")
      ..write(popupTrigger)
      ..write(", button=")
      ..write(button);    
    return sb.toString();
  }
}


class ActionEvent extends Event {
    static const int ACTION_PERFORMED = 1001;
    
    String _command;
    
    ActionEvent(Object source, this._command): super(source, ACTION_PERFORMED);
    
    String get command => _command;
}

class ChangeEvent extends Event {
    static const int STATE_CHANGED = 2001;
    ChangeEvent(Object source): super(source, STATE_CHANGED);
}

class ItemEvent extends Event {
    static const int ITEM_STATE_CHANGED = 701;
    ItemEvent(Object source): super(source, ITEM_STATE_CHANGED);
}

