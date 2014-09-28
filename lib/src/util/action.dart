part of seesaw.util;

typedef void ActionPerformed(ActionEvent evt);

class Action {
    final EventMulticaster _listeners = new EventMulticaster();
    String _name;
    Icon _icon;
    bool _enabled;
        
    ActionPerformed actionPerformed; // public
    
    Action({String name: "", Icon icon, bool enabled: true, ActionPerformed action}): 
                          _name = name, _icon = icon, _enabled = enabled {
        this.actionPerformed = (action != null) ? action : (e) {};
    }
    
    String get name => _name;
    set name(String newName) {
        if(newName != _name) {
            String oldValue = _name;
            _name = newName;
            _listeners.fireLazy(PropertyChangeEvent.PROPERTY_CHANGED, 
                    () => new PropertyChangeEvent(this, "name", oldValue, _name));
        }
    }
    
    Icon get icon => _icon;
    set icon(Icon newIcon) {
        if(newIcon != _icon) {
            Icon oldValue = _icon;
            _icon = newIcon;
            _listeners.fireLazy(PropertyChangeEvent.PROPERTY_CHANGED, 
                    () => new PropertyChangeEvent(this, "icon", oldValue, _icon));            
        }
    }
    
    bool get enabled => _enabled;
    set enabled(bool newEnabled) {
        if(newEnabled != _enabled) {
            bool oldValue = _enabled;
            _enabled = newEnabled;
            _listeners.fireLazy(PropertyChangeEvent.PROPERTY_CHANGED, 
                    () => new PropertyChangeEvent(this, "enabled", oldValue, _enabled));
        }        
    }    
    
    Stream<PropertyChangeEvent> get onPropertyChange => _listeners.getEventStream(PropertyChangeEvent.PROPERTY_CHANGED);
}