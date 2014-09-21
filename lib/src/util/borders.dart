part of seesaw.util;

class LineBorder implements Border {
  final Insets<int> insets;
  final String stroke;
  final int lineWidth;
  
  LineBorder(int lineWidth, String stroke): 
         lineWidth = lineWidth, stroke = stroke, 
         insets = new Insets<int>(lineWidth, lineWidth, lineWidth, lineWidth);
         
  void paint(Component c, html.CanvasRenderingContext2D ctx) {
    ctx.strokeStyle = stroke;
    ctx.lineWidth = lineWidth; 
    ctx.strokeRect(lineWidth/2, lineWidth/2, c.bounds.width - lineWidth, c.bounds.height - lineWidth);    
  }
}
