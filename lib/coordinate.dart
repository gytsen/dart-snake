import 'dart:math';

/// Coordinate represents a location on the grid that
/// [Screen] constructs. While functionally equivalent to
/// [Point] from the regular dart math class, [Coordinate] is
/// meant to disambiguate between points located on the grid that
/// [Game] uses and the points the canvas actually uses for drawing
/// the game.
class Coordinate {
  int x;
  int y;

  Coordinate(int x, int y);

  Coordinate.fromPoint(Point p) {
    x = p.x;
    y = p.y;
  }

  Coordinate copy() {
    return new Coordinate(x, y);
  }
}
