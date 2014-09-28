part of seesaw.laf;

abstract class ComponentUI {    
    void installUI(Component c);
    void uninstallUI(Component c);
    void paint(html.CanvasRenderingContext2D ctx, Component c);    
    void update(html.CanvasRenderingContext2D ctx, Component c);
}