import 'dart:html';
import 'dart:math';
import 'dart:async';

import 'package:dart_snake/coordinate.dart';
import 'package:dart_snake/snake.dart';
import 'package:dart_snake/screen.dart';
import 'package:dart_snake/game_map.dart';

typedef void ScoreCallback(int snakeLength);

class Game {
  static const int HEIGHT = 24;
  static const int WIDTH = HEIGHT;

  static const String BLACK = '#000';
  static const String RED = '#F00';
  static const String BROWN = '#B62';

  static const int FPS = 5;
  static const int FPS_MILLIS = 1000 ~/ FPS;
  static const Duration TIMEOUT = const Duration(milliseconds: FPS_MILLIS);

  late final Snake _snake;

  late final GameMap _map;

  late final Screen _screen;

  late Coordinate _apple;

  late final Random _random;

  Timer? _timer;

  /// A user supplied callback that gets called on game over
  /// this function should handle and UI changes needed to present
  /// the player with a nice game over state.
  late VoidCallback _gameOverCallback;

  /// A user supplied callback that gets called whenever the user scores
  /// a point (i.e. eats the apple). It passes the current length of the snake
  /// so that the user can present hi-scores or something should the user wish.
  late ScoreCallback _scoreCallback;

  Game(CanvasElement? canvas, VoidCallback gameOverCallback,
      ScoreCallback scoreCallback) {
    _screen = new Screen(canvas);

    _random = new Random();

    _snake = Snake.getDefault();
    _map = GameMap.empty();
    _apple = generateApple();

    _gameOverCallback = gameOverCallback;
    _scoreCallback = scoreCallback;
  }

  Game.withMap(CanvasElement canvas, VoidCallback gameOverCallback,
      ScoreCallback scoreCallback, GameMap map) {
    _screen = new Screen(canvas);

    _random = new Random();

    _snake = Snake.getDefault();
    _map = map;
    _apple = generateApple();

    _gameOverCallback = gameOverCallback;
    _scoreCallback = scoreCallback;
  }

  /// So this series of functions seems a bit weird, but that has to do with the
  /// asynchronous nature of game ticks and timing. We don't want to fry our CPU
  /// by blindly redrawing every time something changes, so we need to use the [window.requestAnimationFrame()]
  /// function to ensure we only paint on screen redraw.
  ///
  /// Next, we have our internal game tick, which in this case also dictates our "FPS".
  /// Thus, we need a periodic timer to handle that case.
  /// What we now simply do is when the start function is called, is actually create the periodic timer
  /// with the animate function as a callback.

  void start() {
    _timer = Timer.periodic(TIMEOUT, animate);
  }

  void pause() {
    _timer?.cancel();
  }

  // null-aware operators FTW
  bool running() => _timer?.isActive ?? false;

  bool paused() => !running();

  /// The animate function simply requests an animation frame,
  /// and passes the actual [gameTick] function
  /// which contains all the logic for one game tick.
  void animate(Timer unused) {
    window.requestAnimationFrame(gameTick);
  }

  /// [gameTick] contains all the logic necessary to execute exactly one
  /// game step. The basic algorithm is as follows:
  /// 1. update the [Snake]'s direction to its requested direction
  /// 2. create a new head for the snake, but don't add it yet.
  /// 3. wrap the head around the screen, if necessary
  /// 4. if the new head is present in the body, it means we crashed into ourselves,
  ///    so that's game over. On game over we stop the timer and call the user-supplied
  ///    game over callback to do bookkeeping/cleanup for the game over screen.
  /// 5. check if we hit the apple. If we did, preserve our tail on move.
  /// 6. add the new head to the [Snake].
  /// 7. redraw the screen with the new information.
  void gameTick(num unused) {
    bool preserveTail = false;

    // for now it's easy to just wipe the screen entirely
    // but later on we might only erase the coordinates that we
    // actually don't need anymore
    _screen.clear();

    _snake.updateDirection();

    final Coordinate head = _screen.wrap(_snake.newHead());

    if (isGameOver(head)) {
      _timer?.cancel();
      _gameOverCallback();
    }

    if (head == _apple) {
      _apple = generateApple();
      preserveTail = true;
      // remember to add the new head to the size
      _scoreCallback(_snake.size + 1);
    }

    _snake.addNewHead(head, preserveTail: preserveTail);

    _screen.drawCoordinates(_map.walls, color: BROWN);
    _screen.drawCoordinates(_snake.body);
    _screen.drawCoordinate(_apple, color: RED);
  }

  bool isGameOver(final Coordinate head) =>
      _snake.contains(head) || _map.contains(head);

  Coordinate generateApple() {
    Coordinate apple;

    do {
      apple = new Coordinate(
          _random.nextInt(_screen.width), _random.nextInt(_screen.height));
    } while (_snake.body.contains(apple));

    return apple;
  }

  /// FIXME: for some reason my keyboard's arrow keys don't
  /// register at all, and WASD generates the character code
  /// instead of the actual key code. These hardcoded values should
  /// be removed eventually
  void handleKeypress(final KeyboardEvent e) {
    final KeyEvent wrapped = KeyEvent.wrap(e);

    switch (wrapped.keyCode) {
      case KeyCode.UP:
      case 119:
        _snake.requestChangeDirection(Direction.up);
        break;
      case KeyCode.DOWN:
      case 115:
        _snake.requestChangeDirection(Direction.down);
        break;
      case KeyCode.LEFT:
      case 97:
        _snake.requestChangeDirection(Direction.left);
        break;
      case KeyCode.RIGHT:
      case 100:
        _snake.requestChangeDirection(Direction.right);
        break;
      default:
        break;
    }
  }
}
