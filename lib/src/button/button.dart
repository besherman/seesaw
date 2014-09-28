part of seesaw.button;

class Button extends Component {
    final String uiClassID = "ButtonUI";
    String _text = "";
    Icon _defaultIcon;
    ButtonModel _model;
    int _iconTextGap = 4;
    Action _action;
    Subscriptions _actionSubscriptions = new Subscriptions();
    
    
    EventMulticaster _listeners = new EventMulticaster();    
    Subscriptions _subscriptions = new Subscriptions();
    
    Button({String text: "", Icon icon, Action action}) {
        model = new ButtonModel();  
        updateUI();
        this.text = text;
        this.icon = icon;
        this.action = action;
    }
    
    Stream<ActionEvent> get onActionPerformed => _listeners.getEventStream(ActionEvent.ACTION_PERFORMED);
    
    Action get action => _action;
    set action(Action action) {
        _action = action;
        _copyActionsProperties();
        _actionSubscriptions.cancelAll();
        _actionSubscriptions.add(onActionPerformed.listen(action.actionPerformed), "actionPerformed");    
        _actionSubscriptions.add(action.onPropertyChange.listen((e) => _copyActionsProperties()), "propertyChange");
    }
    
    void _copyActionsProperties() {
        text = _action.name;
        icon = _action.icon;
        //enabled = _action.enabled;
    }
    
    String get text => _text;
    
    String get actionCommand {
        String cmd = model.actionCommand;        
        return cmd != null ? cmd : text; 
    }
    
    set actionCommand(String cmd) => model.actionCommand = cmd;
    
    set text(String text) {
        if(text == null) {
            text = "";
        }
        if(text != _text) {
            _text = text;
            revalidate();
            repaint();
       }
    }
           
    bool get selected => _model.selected;
    
    set selected(bool selected) {
       _model.selected = selected;
    }
        
    Icon get icon => _defaultIcon;
    
    set icon(Icon icon) {
        if(_defaultIcon != icon) {
            _defaultIcon = icon;            
            revalidate();              
            repaint();
        }
    }
    
    int get iconTextGap => _iconTextGap;
    set iconTextGap(int gap) {
        _iconTextGap = gap;
        repaint();
    }
    
                      
    ButtonModel get model => _model;
    
    set model(ButtonModel newModel) {
        var oldModel = _model;
        
        if(oldModel != null) {
            _subscriptions.cancelAll();
        }
        
        _model = newModel;
        
        if(newModel != null) {            
            _subscriptions.add(newModel.onActionPerformed.listen(_onModelActionPerformed), "onActionPerformed");
            _subscriptions.add(newModel.onItemStateChanged.listen(_onModelItemStateChanged), "onItemStateChanged");
            _subscriptions.add(newModel.onStateChanged.listen(_onModelStateChanged), "onStateChanged");
        }
        
        if(oldModel != newModel) {
            revalidate();
            repaint();
        }
    }
    
    void _onModelActionPerformed(ActionEvent evt) {
        _listeners.fireLazy(ActionEvent.ACTION_PERFORMED, () => new ActionEvent(this, actionCommand));
    }
    
    void _onModelItemStateChanged(ItemEvent evt) {
        
    }
    
    void _onModelStateChanged(ChangeEvent evt) {
        
    }
    
    
}