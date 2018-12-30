import 'dart:html';
import 'dart:math';

import 'package:dart_snake/coordinate.dart';

/// [Screen] implements a grid system for the snake game to be played on
/// and handles the transformation logic needed to translate from [Game]
/// coordinates to actual canvas coordinates.
class Screen {
  static const String BLACK = '#000';

  CanvasElement canvas;
  HtmlElement output;

  int height;
  int width;
  int boxSize;

  int borderSize;
  Point borderTranspose;

  CanvasRenderingContext2D get context => canvas.context2D;

  int get trimmedBoxSize => boxSize - borderSize;

  Screen(HtmlElement output,
      {int height = 24, int width = 24, int borderSize = 3, int boxSize = 20}) {
    if (output == null) {
      throw new ArgumentError("output element must not be null");
    }

    this.output = output;
    this.height = height;
    this.width = width;
    this.boxSize = boxSize;
    this.borderSize = borderSize;
    this.borderTranspose = new Point(borderSize, borderSize);

    canvas = new CanvasElement(
        width: this.width * boxSize, height: this.height * boxSize);
    output.append(canvas);
  }

  Screen.fromId(String selector,
      {int height = 24, int width = 24, int borderSize = 3, int boxSize = 20}) {
    if (selector == null) {
      throw new ArgumentError("selector must not be null");
    } else if (!selector.startsWith('#')) {
      throw new ArgumentError("selector must select an ID");
    }

    this.output = document.querySelector(selector);

    this.height = height;
    this.width = width;
    this.boxSize = boxSize;

    this.borderSize = borderSize;
    this.borderTranspose = new Point(borderSize, borderSize);

    canvas = new CanvasElement(
        width: this.width * boxSize, height: this.height * boxSize);
    output.append(canvas);
  }

  /// Small convenience method to clear the canvas quickly
  void clear() => context.clearRect(0, 0, canvas.width, canvas.height);

  /// wrap the given [Coordinate] around the screen edges
  /// if it would be out of bounds.
  /// Note that this function does not edit the original
  /// [Coordinate], but creates a new one
  Coordinate wrap(Coordinate c) {
    int x = c.x;
    int y = c.y;

    if (c.x > this.width - 1) {
      x = 0;
    } else if (c.x < 0) {
      x = this.width - 1;
    }

    if (c.y > this.height - 1) {
      y = 0;
    } else if (c.y < 0) {
      y = this.height - 1;
    }

    return new Coordinate(x, y);
  }

  /// Draw a list of [Coordinate]s on the canvas.
  /// Note that this method automatically transforms the coordinates
  /// to [Point]s on the canvas.
  void drawCoordinates(List<Coordinate> coordinates, {String color = '#000'}) {
    for (var coordinate in coordinates) {
      drawCoordinate(coordinate, color: color);
    }
  }

  /// Draw a single [Coordinate] on the canvas.
  /// The coordinate is automatically converted to a point on the canvas
  void drawCoordinate(Coordinate coordinate, {String color = '#000'}) {
    var canvasPoint = getCanvasDrawPoint(coordinate);
    var borderedCanvasPoint = canvasPoint + this.borderTranspose;

    context.fillStyle = color;
    context.fillRect(borderedCanvasPoint.x, borderedCanvasPoint.y,
        trimmedBoxSize, trimmedBoxSize);
    context.fillStyle = BLACK;
  }

  /// Convert the given [Coordinate] to a [Point] to draw
  /// on the canvas. The function asserts that the [Coordinate] is
  /// not drawn outside of the [Screen] boundaries, and crashes the program
  /// if it detects that this is attempted.
  Point getCanvasDrawPoint(Coordinate c) {
    assert(c.x >= 0 && c.x <= this.width);
    assert(c.y >= 0 && c.y <= this.height);
    return new Point(c.x * boxSize, c.y * boxSize);
  }

  Coordinate getCoordinateFromCanvas(Point p) {
    return new Coordinate(p.x ~/ boxSize, p.y ~/ boxSize);
  }
}
