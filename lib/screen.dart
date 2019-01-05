import 'dart:html';
import 'dart:math';

import 'package:dart_snake/coordinate.dart';

/// [Screen] implements a grid system for the snake game to be played on
/// and handles the transformation logic needed to translate from [Game]
/// coordinates to actual canvas coordinates.
class Screen {
  static const String BLACK = '#000';

  CanvasElement canvas;
  int height;
  int width;
  int boxSize;

  int borderSize;
  Point borderTranspose;

  CanvasRenderingContext2D get context => canvas.context2D;

  int get trimmedBoxSize => boxSize - borderSize;

  Screen(CanvasElement canvas, {int borderSize = 3, int boxSize = 20}) {
    if (canvas == null || canvas is! CanvasElement) {
      throw new ArgumentError("Must pass a CanvasElement!");
    } else if (canvas.height.remainder(boxSize) != 0 ||
        canvas.width.remainder(boxSize) != 0) {
      throw new ArgumentError(
          "${canvas.height} or ${canvas.width} is not divisible by ${boxSize}");
    }

    this.height = canvas.height ~/ boxSize;
    this.width = canvas.width ~/ boxSize;
    this.boxSize = boxSize;
    this.borderSize = borderSize;
    this.borderTranspose = new Point(borderSize, borderSize);
    this.canvas = canvas;
    // clear any previously drawn stuff on the canvas
    clear();
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
  void drawCoordinates(Iterable<Coordinate> coordinates,
      {String color = '#000'}) {
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

  /// Convert the given [Point] to a [Coordinate]. Useful for click handlers
  /// to see where in the grid a user clicked.
  Coordinate getCoordinateFromCanvas(Point p) {
    return new Coordinate(p.x ~/ boxSize, p.y ~/ boxSize);
  }
}
