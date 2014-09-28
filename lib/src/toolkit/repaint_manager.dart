part of seesaw.toolkit;

class RepaintManager {
    static final int PAINT_AFTER_MS = 1;
    static final int VALIDATE_AFTER_MS = 3000;
    
    static final RepaintManager _instance = new RepaintManager();

    static RepaintManager currentManager(Component c) {
        return _instance;
    }

    Timer _paintTimer;
    Timer _validateTimer;


    RepaintManager() {
    }

    void addInvalidComponent(Component invalidComponent) {
        // TODO: add this component to a list and add something on the
        // queue so that it gets fixed later
    }

    Frame frameToPaint;

    void addDirtyRegion(Component c, [Rectangle<int> region]) {
        //print("dirty: " + c.runtimeType.toString());
        var root = c;
        while (root.parent != null) {
            root = root.parent;
        }

        if (root is Frame) {
            frameToPaint = root as Frame;
            if(_paintTimer == null || !_paintTimer.isActive) {
                _paintTimer = new Timer(Duration.ZERO, () => html.window.requestAnimationFrame(_render));
            } 
        }
    }

    void _render(num highResTime) {        
        frameToPaint.paint(frameToPaint.ctx);
    }
}
