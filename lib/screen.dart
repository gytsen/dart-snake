import 'dart:html';

import 'package:dart_snake/coordinate.dart';

int wrappingClamp(final int value, final int min, final int max) {
  if (value < min) {
    return max;
  } else if (value > max) {
    return min;
  } else {
    return value;
  }
}

/// [Screen] implements a grid system for the snake game to be played on
/// and handles the transformation logic needed to translate from [Game]
/// coordinates to actual canvas coordinates.
class Screen {
  static const String BLACK = '#000';

  late CanvasElement canvas;
  late int height;
  late int width;
  static const int boxSize = 20;
  static const int borderSize = 3;

  static const Point borderTranspose = const Point(borderSize, borderSize);

  CanvasRenderingContext2D get context => canvas.context2D;

  int get trimmedBoxSize => boxSize - borderSize;

  Screen(final CanvasElement? canvas) {
    if (canvas == null) {
      throw new ArgumentError("Must pass a CanvasElement!");
    } else if (canvas.height?.remainder(boxSize) != 0 ||
        canvas.width?.remainder(boxSize) != 0) {
      throw new ArgumentError(
          "${canvas.height} or ${canvas.width} is not divisible by ${boxSize}");
    }

    this.height = canvas.height! ~/ boxSize;
    this.width = canvas.width! ~/ boxSize;
    this.canvas = canvas;
    // clear any previously drawn stuff on the canvas
    clear();
  }

  /// Small convenience method to clear the canvas quickly
  void clear() => context.clearRect(0, 0, canvas.width!, canvas.height!);

  /// wrap the given [Coordinate] around the screen edges
  /// if it would be out of bounds.
  /// Note that this function does not edit the original
  /// [Coordinate], but creates a new one
  Coordinate wrap(final Coordinate c) => new Coordinate(
      wrappingClamp(c.x, 0, this.width - 1),
      wrappingClamp(c.y, 0, this.height - 1));

  /// Draw a list of [Coordinate]s on the canvas.
  /// Note that this method automatically transforms the coordinates
  /// to [Point]s on the canvas.
  void drawCoordinates(final Iterable<Coordinate> coordinates,
      {String color = '#000'}) {
    for (var coordinate in coordinates) {
      drawCoordinate(coordinate, color: color);
    }
  }

  /// Draw a single [Coordinate] on the canvas.
  /// The coordinate is automatically converted to a point on the canvas
  void drawCoordinate(final Coordinate coordinate, {String color = '#000'}) {
    final canvasPoint = getCanvasDrawPoint(coordinate);
    final borderedCanvasPoint = canvasPoint + Screen.borderTranspose;

    context.fillStyle = color;
    context.fillRect(borderedCanvasPoint.x, borderedCanvasPoint.y,
        trimmedBoxSize, trimmedBoxSize);
    context.fillStyle = BLACK;
  }

  /// Convert the given [Coordinate] to a [Point] to draw
  /// on the canvas. The function asserts that the [Coordinate] is
  /// not drawn outside of the [Screen] boundaries, and crashes the program
  /// if it detects that this is attempted.
  Point getCanvasDrawPoint(final Coordinate c) {
    assert(c.x >= 0 && c.x <= this.width);
    assert(c.y >= 0 && c.y <= this.height);
    return new Point(c.x * boxSize, c.y * boxSize);
  }

  /// Convert the given [Point] to a [Coordinate]. Useful for click handlers
  /// to see where in the grid a user clicked.
  Coordinate getCoordinateFromCanvas(final Point p) {
    return new Coordinate(p.x ~/ boxSize, p.y ~/ boxSize);
  }
}
