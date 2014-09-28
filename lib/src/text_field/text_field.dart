part of seesaw.text_field;

class TextField extends Component {
    final String uiClassID = "TextFieldUI";
    
    String _text;
    
    TextField(this._text) {        
        updateUI();
    }
    
    String get text => _text;
    set text(String newText) {
        if(newText == null) {
            newText = "";
        }
        if(newText != _text) {
            _text = newText;
            repaint();
        }
    }
}