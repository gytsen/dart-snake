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

  // TODO: Point uses SMI hashing internally, need it?
  int get hashCode => x.hashCode + y.hashCode;

  Coordinate(this.x, this.y);

  Coordinate.fromPoint(Point p) {
    x = p.x;
    y = p.y;
  }

  Coordinate copy() {
    return new Coordinate(x, y);
  }

  bool operator ==(other) {
    if (!(other is Coordinate)) return false;
    return x == other.x && y == other.y;
  }

  Coordinate operator +(Coordinate other) {
    return new Coordinate(x + other.x, y + other.y);
  }
}
