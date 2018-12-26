import 'dart:html';
import 'dart:math' show Random;
import 'dart:async' show Timer;

const int HEIGHT = 24;
const int WIDTH = HEIGHT;

const String BLACK = '#000';

const int BOX_BORDER_SIZE = 3;
const Point BORDER_TRANSPOSE = const Point(BOX_BORDER_SIZE, BOX_BORDER_SIZE);

const int FPS = 5;
const int FPS_MILLIS = 1000 ~/ FPS;
const Duration TIMEOUT = const Duration(milliseconds: FPS_MILLIS);

CanvasElement canvas;
CanvasRenderingContext2D ctx;
Random random;

Snake snake;
Point apple;


void main() {
  canvas = CanvasElement(width: 480, height: 480);

  var output = querySelector('#output');
  output.append(canvas);

  ctx = canvas.context2D;
  random = new Random();

  snake = Snake.getDefault();
  apple = generateApple();

  Timer.periodic(TIMEOUT, animate);
  document.onKeyPress.listen(handleKeypress);
}

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

void animate(Timer t) {
  window.requestAnimationFrame(gameTick);
}

void gameTick(num unused) {
  bool preserveTail = false;
  clearCanvas(canvas);

  snake.updateDirection();

  Point newHead = getNewSnakeHead();

  if(snake.body.contains(newHead)) {
    print("game over!");
  }

  if(newHead == apple) {
    apple = generateApple();
    preserveTail = true;
  }

  snake.addNewHead(newHead, preserveTail: preserveTail);

  drawPoints(snake.body);
  drawPoint(ctx, apple, color:'#F00');
}

Point getNewSnakeHead() {
  Point newHead = fromPoint(snake.head);

  newHead += Snake.directionToPoint[snake.direction];
  newHead = wrapEdge(newHead);
  return newHead;
}

void drawPoints(List<Point> points) {
  for(var point in points) {
    drawPoint(ctx, point);
  }
}

void clearCanvas(CanvasElement canvas) {
  var ctx = canvas.context2D;
  ctx.clearRect(0, 0, canvas.width, canvas.height);
}

int getBoxSize() {
  return canvas.width ~/ WIDTH;
}

int getTrimmedBoxSize() => getBoxSize() - BOX_BORDER_SIZE;

Point getCanvasDrawPoint(Point p) {
  int boxSize = getBoxSize();
  return new Point(p.x * boxSize, p.y * boxSize);
}

void drawPoint(CanvasRenderingContext2D ctx, Point p, {String color = '#000'}) {
  var size = getTrimmedBoxSize();
  var canvasPoint = getCanvasDrawPoint(p) + BORDER_TRANSPOSE;

  ctx.fillStyle = color;
  ctx.fillRect(canvasPoint.x, canvasPoint.y, size, size);
  ctx.fillStyle = BLACK;
}

Point generateApple() {
  var apple;

   do {
    apple = new Point(
      random.nextInt(WIDTH),
      random.nextInt(HEIGHT)
    );
  } while(snake.body.contains(apple));

  return apple;
}

enum Direction {
  up,
  down,
  left,
  right
}

// Utility methods for the snake class

// isValidChange checks if the requested direction change
// is actually possible.
bool isValidChange(Direction current, Direction requested) {
  return !((current == Direction.up && requested == Direction.down) ||
          (current == Direction.down && requested == Direction.up) ||
          (current == Direction.left && requested == Direction.right) ||
          (current == Direction.right && requested == Direction.left));
}

// Convenience initializer to construct a new Point from an old one
Point fromPoint(Point old) {
  return new Point(old.x, old.y);
}

Point wrapEdge(Point p) {
  int x = p.x;
  int y = p.y;

  if(p.x > WIDTH - 1) {
    x = 0;
  } else if (p.x < 0) {
    x = WIDTH - 1;
  }

  if(p.y > HEIGHT - 1) {
    y = 0;
  } else if (p.y < 0) {
    y = HEIGHT - 1;
  }

  return new Point(x, y);
}


class Snake {
  static const Map<Direction, Point> directionToPoint = {
    Direction.up: const Point(0, -1),
    Direction.down: const Point(0, 1),
    Direction.left: const Point(-1, 0),
    Direction.right: const Point(1, 0)
  };

  static const int HEAD_INDEX = 0;

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
    body.add(new Point(0, 0));
    body.add(new Point(1, 0));
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
    if(!isValidChange(direction, requestedDirection)) {
      return;
    }

    direction = requestedDirection;
  }

  void addNewHead(Point newHead, {bool preserveTail = false}) {
    body.insert(HEAD_INDEX, newHead);
    if(!preserveTail) {
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
