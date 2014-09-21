part of seesaw.util;

abstract class Border {
  Insets<int> get insets;
  void paint(Component c, html.CanvasRenderingContext2D ctx);
}