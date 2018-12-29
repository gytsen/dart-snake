import 'dart:math';

/// Coordinate represents a location on the grid that
/// [Screen] constructs. While functionally equivalent to
/// [Point] from the regular dart math class, [Coordinate] is
/// meant to disambiguate between points located on the grid that
/// [Game] uses and the points the canvas actually uses for drawing
/// the game.
class Coordinate {
  final int x;
  final int y;

  // TODO: Point uses SMI hashing internally, need it?
  int get hashCode => x.hashCode + y.hashCode;

  const Coordinate(int x, int y)
      : this.x = x,
        this.y = y;

  /// Quickly create a new [Coordinate] to modify without
  /// editing the existing instance's members.
  Coordinate copy() {
    return new Coordinate(x, y);
  }

  bool operator ==(other) {
    if (other is! Coordinate) return false;
    return x == other.x && y == other.y;
  }

  Coordinate operator +(Coordinate other) {
    return new Coordinate(x + other.x, y + other.y);
  }
}
