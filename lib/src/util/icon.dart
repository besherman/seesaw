part of seesaw.util;

abstract class Icon {
    int get width;
    int get height;
    html.CanvasImageSource get image;
}

class ImageIcon implements Icon {
    int _width = 0;
    int _height = 0;
    String _src;
    html.ImageElement _img;
    ImageIcon(this._src, [this._width, this._height]) {
        _img = new html.ImageElement();
        _img.src = _src;
        _img.onLoad.listen((e) {
            _width = _img.width;
            _height = _img.height;
        });
    }
    
    int get width => _width;
    int get height => _height;
    html.CanvasImageSource get image => _img;
}