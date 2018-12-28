import 'dart:html';
import 'dart:math';

/// [Screen] implements a grid system for the snake game to be played on
/// and handles the transformation logic needed to translate from [Game]
/// coordinates to actual canvas coordinates.
/// TODO: move the raw draw calls from game.dart here
class Screen {
  static const String BLACK = '#000';

  CanvasElement canvas;
  HtmlElement output;

  int height;
  int width;

  int borderSize;
  Point borderTranspose;

  CanvasRenderingContext2D get context => canvas.context2D;

  Screen(HtmlElement output,
      {int height: 24, int width: 24, int borderSize: 3}) {
    if (output == null) {
      throw new ArgumentError("output element must not be null");
    }

    this.output = output;
    this.height = height;
    this.width = width;
    this.borderSize = borderSize;
    this.borderTranspose = new Point(borderSize, borderSize);

    canvas = new CanvasElement(width: this.width, height: this.height);
    output.append(canvas);
  }

  Screen.fromId(String selector,
      {int height: 24, int width: 24, int borderSize: 3}) {
    if (selector == null) {
      throw new ArgumentError("selector must not be null");
    } else if (!selector.startsWith('#')) {
      throw new ArgumentError("selector must select an ID");
    }

    this.output = document.querySelector(selector);
    this.height = height;
    this.width = width;
    this.borderSize = borderSize;
    this.borderTranspose = new Point(borderSize, borderSize);

    canvas = new CanvasElement(width: this.width, height: this.height);
    output.append(canvas);
  }
}
