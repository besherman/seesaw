part of seesaw.util;

class LinearGradient implements Paint {
    Point<int> _start;
    Point<int> _end;
    List<double> _stops;
    List<Color> _colors;
    
    LinearGradient(Point<int> this._start, Point<int> this._end, List<double> this._stops, List<Color> this._colors);
    
    Object getFillStyle(html.CanvasRenderingContext2D ctx) {
        var gradient = ctx.createLinearGradient(_start.x, _start.y, _end.x, _end.y);
        for(int i = 0; i < _stops.length; i++) {
            gradient.addColorStop(_stops[i], _colors[i].getFillStyle(ctx));
        }
        return gradient;
    }
    
    static LinearGradient createVertical(int height, Color c1, Color c2) => new LinearGradient(new Point<int>(0, 0), new Point(0, height), [0, 1], [c1, c2]);
}