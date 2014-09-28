part of seesaw.button;

class ButtonModel {    
    final EventMulticaster _listeners = new EventMulticaster();
    ChangeEvent _changeEvent;
    
    bool _armed = false;
    bool _enabled = true;
    bool _pressed = false;
    bool _rollover = false;
    bool _selected = false;
    String _actionCommand = "";
    
    ButtonModel() {
        _changeEvent = new ChangeEvent(this);
    }
    
    Stream<ActionEvent> get onActionPerformed => _listeners.getEventStream(ActionEvent.ACTION_PERFORMED);
    Stream<ChangeEvent> get onStateChanged => _listeners.getEventStream(ChangeEvent.STATE_CHANGED);
    Stream<ItemEvent> get onItemStateChanged => _listeners.getEventStream(ItemEvent.ITEM_STATE_CHANGED);
    
    bool get armed => _armed;
         set armed(bool armed) {
             if(_armed != armed) { 
                _armed = armed;
                _listeners.fire(_changeEvent);
             }
         }
    bool get enabled => _enabled;
         set enabled(bool enabled) {
             if(_enabled != enabled) { 
                _enabled = enabled;
                _listeners.fire(_changeEvent);
             }
         }
    bool get pressed => _pressed;
         set pressed(bool pressed) {
             if(_pressed != pressed) { 
                _pressed = pressed;
                
                if(pressed == false && armed) {
                    _listeners.fireLazy(ActionEvent.ACTION_PERFORMED, () => new ActionEvent(this, actionCommand));
                }
                
                _listeners.fire(_changeEvent);
             }             
         }
    bool get rollover => _rollover;
         set rollover(bool rollover) {
             if(_rollover != rollover) {
                 _rollover = rollover;
                _listeners.fire(_changeEvent);
             }
         }
    bool get selected => _selected;
         set selected(bool selected) {
             if(_selected != selected) {
                 _selected = selected;
                 _listeners.fire(_changeEvent);
             }
         }
         
    String get actionCommand => _actionCommand;
           set actionCommand(String cmd) => _actionCommand = cmd;
    
}