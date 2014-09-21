part of seesaw.dialog;

class Dialog extends Component {
  /**
   * Paint this component.
   */
   void paint(html.CanvasRenderingContext2D ctx) {
     
   }
  
}

class DialogBorder implements Border {
  final Insets<int> insets = new Insets<int>(30, 6, 6, 6);
  final String _outerLine = "#8C8C8C";
  final String _innserFill = "#C8C8C8";
  final int _outerLineWidth = 1;
  
  void paint(Component c, html.CanvasRenderingContext2D ctx) {
    var bounds = c.bounds;
    ctx.strokeStyle = _outerLine;
    ctx.lineWidth = _outerLineWidth;  
    
    ctx.strokeRect(_outerLineWidth/2, _outerLineWidth/2, 
      bounds.width - _outerLineWidth, bounds.height - _outerLineWidth);    
    
    ctx.fillStyle = "#C8C8C8";
    // top
    ctx.fillRect(1, 1, bounds.width - 2, 30);

    // left
    ctx.fillRect(1, 1, 6, bounds.height - 2);

    // bottom
    ctx.fillRect(1, bounds.height - 7, bounds.width - 2, 6);

    // right
    ctx.fillRect(bounds.width - 7, 1, 6, bounds.height - 2);
    
    var title = "Hello, world!";
    ctx.font = "16px Tahoma";
    ctx.fillStyle = "#505050";
    
    var titleWidth = ctx.measureText(title).width;    
    ctx.fillText(title, bounds.width / 2 - titleWidth / 2, 23);
  }
}

