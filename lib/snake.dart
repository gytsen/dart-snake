import 'package:dart_snake/coordinate.dart';

enum Direction { up, down, left, right }

class Snake {
  static const Map<Direction, Coordinate> directionToPoint = {
    Direction.up: const Coordinate(0, -1),
    Direction.down: const Coordinate(0, 1),
    Direction.left: const Coordinate(-1, 0),
    Direction.right: const Coordinate(1, 0)
  };

  static const int HEAD_INDEX = 0;

  Direction direction;
  Direction requestedDirection;

  List<Coordinate> body;

  Snake() {
    body = new List<Coordinate>();
    direction = Direction.right;
    requestedDirection = Direction.right;
  }

  Snake.getDefault() {
    body = new List<Coordinate>();
    body.add(new Coordinate(1, 0));
    body.add(new Coordinate(0, 0));
    direction = Direction.right;
    requestedDirection = Direction.right;
  }

  Coordinate get head {
    return this.body[HEAD_INDEX];
  }

  void requestChangeDirection(Direction requested) {
    this.requestedDirection = requested;
  }

  /// check if a requested change of [Direction] is actually possible
  /// returns false if the requested direction is opposite of the current direction
  bool _isValidChange() {
    return !((this.direction == Direction.up &&
            this.requestedDirection == Direction.down) ||
        (this.direction == Direction.down &&
            this.requestedDirection == Direction.up) ||
        (this.direction == Direction.left &&
            this.requestedDirection == Direction.right) ||
        (this.direction == Direction.right &&
            this.requestedDirection == Direction.left));
  }

  void updateDirection() {
    if (!this._isValidChange()) {
      return;
    }

    direction = requestedDirection;
  }

  void addNewHead(Coordinate newHead, {bool preserveTail = false}) {
    body.insert(HEAD_INDEX, newHead);
    if (!preserveTail) {
      body.removeLast();
    }
  }

  bool contains(Coordinate c) => this.body.contains(c);

  bool headHits(Coordinate c) => c == this.head;
}
