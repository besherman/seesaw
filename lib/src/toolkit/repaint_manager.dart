part of seesaw.toolkit;

class RepaintManager {
  static RepaintManager instance = new RepaintManager();
  
  static RepaintManager currentManager(Component c) {
    return instance;  
  }
  
  void addInvalidComponent(Component invalidComponent) {
      // TODO: add this component to a list and add something on the 
      // queue so that it gets fixed later
  }
  
  void addDirtyRegion(Component c, [Rectangle<int> region]) {
    print("dirty: " + c.runtimeType.toString());
    var root = c;
    while(c.parent != null) {
      root = c.parent;
    }
    
    if(root is Frame) {
      var frame = root as Frame,
          ctx = frame.ctx;
             
      _paint(frame, ctx);
      
    }
  }
  
  void _paint(Component c, html.CanvasRenderingContext2D ctx) {
    ctx.save();
    
    print("Painting " + c.runtimeType.toString());
    
    var tx = c.bounds.left,
        ty = c.bounds.top;    
    ctx.translate(tx, ty);
    
    ctx.beginPath();
    ctx.rect(0, 0, c.bounds.width, c.bounds.height);
    ctx.clip();
    
    ctx.save();
    c.paint(ctx);
    ctx.restore();
    
    ctx.save();
    c.paintBorder(ctx);
    ctx.restore();
    
    c.getComponents().forEach((n) => _paint(n, ctx));    
    ctx.restore();
  }
  
}