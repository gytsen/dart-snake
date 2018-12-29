import 'dart:html';
import 'dart:math';
import 'dart:async';

import 'package:dart_snake/coordinate.dart';
import 'package:dart_snake/snake.dart';
import 'package:dart_snake/screen.dart';

class Game {
  static const int HEIGHT = 24;
  static const int WIDTH = HEIGHT;

  static const String BLACK = '#000';

  static const int FPS = 5;
  static const int FPS_MILLIS = 1000 ~/ FPS;
  static const Duration TIMEOUT = const Duration(milliseconds: FPS_MILLIS);

  Random random;

  Snake snake;
  Screen screen;

  Coordinate apple;

  Timer timer;

  VoidCallback gameOverCallback;

  Game(VoidCallback cb) {
    var output = querySelector('#output');
    screen = new Screen(
      output,
    );

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
    screen.clear();

    snake.updateDirection();

    Coordinate head = newSnakeHead();

    if (snake.body.contains(head)) {
      timer.cancel();
      gameOverCallback();
    }

    if (head == apple) {
      apple = generateApple();
      preserveTail = true;
    }

    snake.addNewHead(head, preserveTail: preserveTail);

    screen.drawCoordinates(snake.body);
    screen.drawCoordinate(apple, color: '#F00');
  }

  Coordinate newSnakeHead() {
    Coordinate head = snake.head.copy();

    head += Snake.directionToPoint[snake.direction];
    head = screen.wrap(head);
    return head;
  }

  Coordinate generateApple() {
    var apple;

    do {
      apple = new Coordinate(
          random.nextInt(screen.width), random.nextInt(screen.height));
    } while (snake.body.contains(apple));

    return apple;
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
