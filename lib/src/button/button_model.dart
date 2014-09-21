part of seesaw.button;

class ButtonModel {    
    final EventMulticaster _listeners = new EventMulticaster();
    Stream<ActionEvent> _onActionPerformed;
    Stream<ChangeEvent> _onStateChanged;
    Stream<ItemEvent> _onItemStateChanged;
    ChangeEvent _changeEvent;
    
    bool _armed = false;
    bool _enabled = true;
    bool _pressed = false;
    bool _rollover = false;
    bool _selected = false;
    
    ButtonModel() {
        _onActionPerformed = _listeners.createEventStream(ActionEvent.ACTION_PERFORMED);
        _onStateChanged = _listeners.createEventStream(ChangeEvent.STATE_CHANGED);
        _onItemStateChanged = _listeners.createEventStream(ItemEvent.ITEM_STATE_CHANGED);
        _changeEvent = new ChangeEvent(this);
    }
    
    Stream<ActionEvent> get onActionPerformed => _onActionPerformed;
    Stream<ChangeEvent> get onStateChanged => _onStateChanged;
    Stream<ItemEvent> get onItemStateChanged => _onItemStateChanged;
    
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
    
}