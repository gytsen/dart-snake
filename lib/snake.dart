import 'dart:math';

enum Direction { up, down, left, right }

class Snake {
  static const Map<Direction, Point> directionToPoint = {
    Direction.up: const Point(0, -1),
    Direction.down: const Point(0, 1),
    Direction.left: const Point(-1, 0),
    Direction.right: const Point(1, 0)
  };

  static const int HEAD_INDEX = 0;

  // isValidChange checks if the requested direction change
  // is actually possible.
  static bool isValidChange(Direction current, Direction requested) {
    return !((current == Direction.up && requested == Direction.down) ||
        (current == Direction.down && requested == Direction.up) ||
        (current == Direction.left && requested == Direction.right) ||
        (current == Direction.right && requested == Direction.left));
  }

  Direction direction;
  Direction requestedDirection;

  List<Point> body;

  Snake() {
    body = new List<Point>();
    direction = Direction.right;
    requestedDirection = Direction.right;
  }

  Snake.getDefault() {
    body = new List<Point>();
    body.add(new Point(1, 0));
    body.add(new Point(0, 0));
    direction = Direction.right;
    requestedDirection = Direction.right;
  }

  Point get head {
    return this.body[HEAD_INDEX];
  }

  void requestChangeDirection(Direction requested) {
    this.requestedDirection = requested;
  }

  void updateDirection() {
    if (!Snake.isValidChange(direction, requestedDirection)) {
      return;
    }

    direction = requestedDirection;
  }

  void addNewHead(Point newHead, {bool preserveTail = false}) {
    body.insert(HEAD_INDEX, newHead);
    if (!preserveTail) {
      body.removeLast();
    }
  }

  bool contains(Point p) {
    return this.body.contains(p);
  }

  bool headHits(Point p) {
    return p == this.head;
  }
}
