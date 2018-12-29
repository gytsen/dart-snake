import 'dart:html';
import 'dart:math';
import 'dart:async';

import 'package:dart_snake/snake.dart';

class Game {
  static const int HEIGHT = 24;
  static const int WIDTH = HEIGHT;

  static const String BLACK = '#000';

  static const int BOX_BORDER_SIZE = 3;
  static const Point BORDER_TRANSPOSE =
      const Point(BOX_BORDER_SIZE, BOX_BORDER_SIZE);

  static const int FPS = 5;
  static const int FPS_MILLIS = 1000 ~/ FPS;
  static const Duration TIMEOUT = const Duration(milliseconds: FPS_MILLIS);

  CanvasElement canvas;
  CanvasRenderingContext2D ctx;
  Random random;

  Snake snake;
  Point apple;

  Timer timer;

  VoidCallback gameOverCallback;

  Game(VoidCallback cb) {
    canvas = CanvasElement(width: 480, height: 480);

    var output = querySelector('#output');
    output.append(canvas);

    ctx = canvas.context2D;
    random = new Random();

    snake = Snake.getDefault();
    apple = generateApple();

    gameOverCallback = cb;

    document.onKeyPress.listen(handleKeypress);
  }

  void start() {
    timer = Timer.periodic(TIMEOUT, animate);
  }

  void animate(Timer unused) {
    window.requestAnimationFrame(gameTick);
  }

  void gameTick(num unused) {
    bool preserveTail = false;
    clearCanvas();

    snake.updateDirection();

    Point head = newSnakeHead();

    if (snake.body.contains(head)) {
      timer.cancel();
      gameOverCallback();
    }

    if (head == apple) {
      apple = generateApple();
      preserveTail = true;
    }

    snake.addNewHead(head, preserveTail: preserveTail);

    drawPoints(snake.body);
    drawPoint(apple, color: '#F00');
  }

  /**
   * Draw a list of `Point`s on the canvas.
   * Note that this method automatically transforms the internal coordinate space
   * to the coordinates on the canvas.
   */
  void drawPoints(List<Point> points) {
    for (var point in points) {
      drawPoint(point);
    }
  }

  /**
   * Draw a coordinate-space point onto the canvas, which is automatically translated to
   * the correct canvas coordinate.
   * Takes an optional color string.
   */
  void drawPoint(Point p, {String color = '#000'}) {
    var size = getTrimmedBoxSize();
    var canvasPoint = getCanvasDrawPoint(p) + BORDER_TRANSPOSE;

    ctx.fillStyle = color;
    ctx.fillRect(canvasPoint.x, canvasPoint.y, size, size);
    ctx.fillStyle = BLACK;
  }

  void clearCanvas() => ctx.clearRect(0, 0, canvas.width, canvas.height);

  int getBoxSize() => canvas.width ~/ WIDTH;

  int getTrimmedBoxSize() => getBoxSize() - BOX_BORDER_SIZE;

  Point getCanvasDrawPoint(Point p) {
    int boxSize = getBoxSize();
    return new Point(p.x * boxSize, p.y * boxSize);
  }

  Point newSnakeHead() {
    Point head = copyPoint(snake.head);

    head += Snake.directionToPoint[snake.direction];
    head = wrapEdge(head);
    return head;
  }

  Point generateApple() {
    var apple;

    do {
      apple = new Point(random.nextInt(WIDTH), random.nextInt(HEIGHT));
    } while (snake.body.contains(apple));

    return apple;
  }

  // Convenience initializer to construct a new Point from an old one
  static Point copyPoint(Point old) => new Point(old.x, old.y);

  static Point wrapEdge(Point p) {
    int x = p.x;
    int y = p.y;

    if (p.x > WIDTH - 1) {
      x = 0;
    } else if (p.x < 0) {
      x = WIDTH - 1;
    }

    if (p.y > HEIGHT - 1) {
      y = 0;
    } else if (p.y < 0) {
      y = HEIGHT - 1;
    }

    return new Point(x, y);
  }

  // TODO: make this conformant to regular keyboards
  void handleKeypress(KeyboardEvent e) {
    KeyEvent wrapped = KeyEvent.wrap(e);

    switch (wrapped.keyCode) {
      case KeyCode.UP:
        snake.requestChangeDirection(Direction.up);
        break;
      case KeyCode.DOWN:
        snake.requestChangeDirection(Direction.down);
        break;
      case KeyCode.LEFT:
        snake.requestChangeDirection(Direction.left);
        break;
      case KeyCode.RIGHT:
        snake.requestChangeDirection(Direction.right);
        break;
      case 119:
        snake.requestChangeDirection(Direction.up);
        break;
      case 97:
        snake.requestChangeDirection(Direction.left);
        break;
      case 115:
        snake.requestChangeDirection(Direction.down);
        break;
      case 100:
        snake.requestChangeDirection(Direction.right);
        break;
      default:
    }
  }
}
