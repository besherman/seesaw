part of seesaw.frame;

/**
 * A RootPane has:
 *    - a glassPane (Component)
 *    - a contentPane (Component)
 *    - a menu (MenuBar) 
 * 
 * The root pane does the layout by painting the menu at the top
 * (if it is set) and the contentPane fills the rest. If the 
 * glassPane is visible it is painted on top.
 * 
 * In Swing the contentPane and the menu is handled by a JLayeredPane
 */
class RootPane extends Component {
    final Component _contentPane = new Component();
    Component _glassPane;
    Object _menu;

    RootPane() {
        super.add(_contentPane);
        name = "RootPane";
        _contentPane.name = "ContentPane";        
    }

    void doLayout() {
        // TODO: don't create the bounds unless we have changed size
        _contentPane.bounds = new Rectangle<int>(0, 0, bounds.width, bounds.height);
    }

    void add(Component c) {
        throw new UnsupportedError("Can not add components directly to a RootPane, use getContentPane().add()");
    }

    Component getContentPane() => _contentPane;
}
