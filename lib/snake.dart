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

  /// The direction system in the snake might seem weird, it's pretty straightforward:
  /// A user might button mash between game ticks. If we actually change direction on
  /// those keypresses instead of on each game tick, we could actually be game-over in
  /// between ticks.
  ///
  /// So instead, maintain 2 directions: the current direction and the
  /// requested direction.
  ///
  /// * requested direction: can change at any time, as many times as possible and not
  ///   subject to any sort of check or verification.
  ///
  /// * actual direction: changes only once per tick, and only changes if the requested
  ///   direction is not in direct opposition of the current direction.
  ///
  late Direction direction;
  late Direction requestedDirection;

  late final List<Coordinate> body;

  Snake() {
    body = new List.empty(growable: true);
    direction = Direction.right;
    requestedDirection = Direction.right;
  }

  Snake.getDefault() {
    body = new List.empty(growable: true);
    body.add(new Coordinate(1, 0));
    body.add(new Coordinate(0, 0));
    direction = Direction.right;
    requestedDirection = Direction.right;
  }

  int get size => body.length;

  Coordinate get head => this.body[HEAD_INDEX];

  bool contains(final Coordinate c) => this.body.contains(c);

  bool headHits(final Coordinate c) => c == this.head;

  void requestChangeDirection(final Direction requested) =>
      this.requestedDirection = requested;

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

  /// Update the direction to the direction requested. An invalid change is simply
  /// ignored until the next game tick.
  void updateDirection() {
    if (!this._isValidChange()) {
      return;
    }

    direction = requestedDirection;
  }

  /// Create a new [Coordinate] for the snake to represent
  /// its new head. The head is returned instead of added directly
  /// because the caller might need to further modify the head
  /// before it's added to the snake.
  Coordinate newHead() {
    Coordinate head = this.head.copy();

    head += Snake.directionToPoint[this.direction]!;
    return head;
  }

  void addNewHead(final Coordinate newHead, {final bool preserveTail = false}) {
    body.insert(HEAD_INDEX, newHead);
    if (!preserveTail) {
      body.removeLast();
    }
  }
}
