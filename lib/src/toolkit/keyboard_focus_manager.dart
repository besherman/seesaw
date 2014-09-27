part of seesaw.toolkit;

class KeyboardFocusManager {
    static KeyboardFocusManager _instance = new KeyboardFocusManager();
    
    static KeyboardFocusManager get instance => _instance;
    
    Component getFocusOwner() {
        return null;
    }
}