part of seesaw.toolkit;

class RepaintManager {
  static RepaintManager instance = new RepaintManager();
  
  static RepaintManager currentManager(Component c) {
    return instance;  
  }
  
  RepaintManager() {
      
  }
  
  void addInvalidComponent(Component invalidComponent) {
      // TODO: add this component to a list and add something on the 
      // queue so that it gets fixed later
  }
  
  Frame frameToPaint;
  
  void addDirtyRegion(Component c, [Rectangle<int> region]) {
    print("dirty: " + c.runtimeType.toString());
    var root = c;
    while(root.parent != null) {
      root = root.parent;
    }
    
    if(root is Frame) {
      frameToPaint = root as Frame;
      html.window.requestAnimationFrame(_render);
    }
  }  
  
  void _render(num highResTime) {
      print("painting " + highResTime.toString());
      frameToPaint.paint(frameToPaint.ctx);      
  }
}