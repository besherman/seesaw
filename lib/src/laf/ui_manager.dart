part of seesaw.laf;

class UIManager {
    static ComponentUI getUI(Component c) {
        switch(c.uiClassID) {
            case "ButtonUI": return new StdButtonUI();
            case "TextFieldUI": return new StdTextFieldUI();
        }
        
        throw new UnimplementedError("No UI for ${c.uiClassID} was found in the LAF");
    }
}