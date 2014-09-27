part of seesaw.button;

class Button extends Component {
    final String uiClassID = "ButtonUI";
    String _text = "";
    html.ImageElement _defaultIcon;
    ButtonModel _model;
    
    StreamSubscription<ActionEvent> _actionPerformedSubscription; 
    StreamSubscription<ItemEvent> _itemStateChangedSubscription;
    StreamSubscription<ChangeEvent> _stateChangedSubscription;
    
    Button() {
        model = new ButtonModel();  
        updateUI();
    }
    
    String get text => _text;
    
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
        
    html.ImageElement get icon => _defaultIcon;
    
    set icon(html.ImageElement icon) {
        if(_defaultIcon != icon) {
            var oldValue = _defaultIcon;
            _defaultIcon = icon;
            
            if(oldValue == null || icon == null) {
                revalidate();
            } else if(oldValue.width != icon.width || oldValue.height != icon.height) {
                revalidate();
            }                                  
              
            repaint();
        }
    }
                      
    ButtonModel get model => _model;
    
    set model(ButtonModel newModel) {
        var oldModel = _model;
        
        if(oldModel != null) {
            _actionPerformedSubscription.cancel();
            _itemStateChangedSubscription.cancel();
            _stateChangedSubscription.cancel();
        }
        
        _model = newModel;
        
        if(newModel != null) {
            _actionPerformedSubscription = newModel.onActionPerformed.listen(_onModelActionPerformed);
            _itemStateChangedSubscription = newModel.onItemStateChanged.listen(_onModelItemStateChanged);
            _stateChangedSubscription = newModel.onStateChanged.listen(_onModelStateChanged);
        }
        
        if(oldModel != newModel) {
            revalidate();
            repaint();
        }
    }
//    
//    void paint(html.CanvasRenderingContext2D ctx) {
//        super.paint(ctx);
//        ctx.fillStyle = "black";
//        ctx.font = font.toString();        
//        var width = ctx.measureText(text).width;
//        ctx.fillText(text, bounds.width / 2 - width / 2, bounds.height / 2 + font.size / 2);
//    }
    
    void _onModelActionPerformed(ActionEvent evt) {
        
    }
    
    void _onModelItemStateChanged(ItemEvent evt) {
        
    }
    
    void _onModelStateChanged(ChangeEvent evt) {
        
    }
    
    
}