import 'dart:html';
import 'package:dart_snake/game.dart';
import 'package:dart_snake/game_map.dart';

TableCellElement snakeLengthElement;
TableCellElement scoreElement;
SpanElement snakeStatus;

ButtonElement startButton;
ButtonElement startWithMapButton;
ButtonElement pauseButton;
ButtonElement loadMapButton;
ButtonElement hideNotificationButton;

Element mapModal;
TextAreaElement mapTextArea;
ParagraphElement mapErrorText;
DivElement mapNotification;

Game game;

void changeStatusToAlive(SpanElement snakeStatus) {
  List<String> classesToToggle = ['is-info', 'is-warning'];
  snakeStatus.classes.removeAll(classesToToggle);
  snakeStatus.classes.add('is-success');
  snakeStatus.text = "Alive";
}

void changeStatusToDead(SpanElement snakeStatus) {
  List<String> classesToToggle = ['is-info', 'is-success'];
  snakeStatus.classes.removeAll(classesToToggle);
  snakeStatus.classes.add('is-warning');
  snakeStatus.text = "Game Over";
}

void togglePauseContainer() {
  var pauseContainer = document.querySelector('#pause');
  pauseContainer.classes.toggle('hidden');
}

void onPauseClick(MouseEvent e) {
  if (game.paused()) {
    game.start();
    pauseButton.text = "Pause";
  } else {
    game.pause();
    pauseButton.text = "Unpause";
  }
}

/// Check if we're currently running a game
/// null-aware operators FTW
bool running() => game?.running() ?? false;

void onStartClick(MouseEvent e) {
  if (running()) {
    return;
  }

  var canvas = document.querySelector('#snake-canvas');

  game ??= new Game(canvas, gameOver, onScore);

  document.onKeyPress.listen(game.handleKeypress);
  changeStatusToAlive(snakeStatus);
  togglePauseContainer();
  game.start();
}

GameMap loadMap(TextAreaElement textArea) {
  String json = textArea.value;
  return GameMap.fromJson(json);
}

void showMapError(String error) {
  mapErrorText.text = error;
  mapNotification.classes.remove('hidden');
}

/// starting a game with a map is a bit more involved,
/// since we require a JSON file and due to security reasons
/// we can't "upload" a file from disk.
///
/// Instead we show a modal with a textarea where the user
/// pastes the raw JSON, which will then parse on button press.
/// It's a little more involved, but right now the easiest way.
void showMapPicker(MouseEvent e) {
  if (running()) {
    return;
  }

  mapModal.classes.add('is-active');
}

void confirmMap(MouseEvent e) {
  GameMap map = null;

  try {
    map = loadMap(mapTextArea);
  } catch (error) {
    showMapError(error.toString());
  }

  var canvas = document.querySelector('#snake-canvas');

  game ??= new Game.withMap(canvas, gameOver, onScore, map);

  document.onKeyPress.listen(game.handleKeypress);
  changeStatusToAlive(snakeStatus);
  togglePauseContainer();
  game.start();
}

void gameOver() {
  changeStatusToDead(snakeStatus);
  togglePauseContainer();
  // fully reset the game state by forcing
  // the start button to create a new game
  game = null;
}

void onScore(int snakeLength) {
  snakeLengthElement?.text = snakeLength.toString();
  scoreElement?.text = (snakeLength - 2).toString();
}

void closeModal(MouseEvent e) => mapModal.classes.remove('is-active');

void hideNotification(MouseEvent e) => mapNotification.classes.add('hidden');

/// Annoying, yes, but best viewed as a simple
/// "constructor" that selects all relevant elements and
/// links the event listeners to them.
void main() {
  startButton = document.querySelector('#start-empty');
  startWithMapButton = document.querySelector('#start-map');
  pauseButton = document.querySelector('#pause-button');
  snakeLengthElement = document.querySelector('#snake-length');
  scoreElement = document.querySelector('#snake-score');
  snakeStatus = document.querySelector('#snake-status');
  mapModal = document.querySelector('#map-modal');
  mapTextArea = document.querySelector('#map-textarea');
  mapNotification = document.querySelector('#map-notification');
  hideNotificationButton = document.querySelector('#hide-notification');
  mapErrorText = document.querySelector('#map-error');
  loadMapButton = document.querySelector('#load-map');

  // add the event listener to all buttons that close a modal
  for (var element in document.querySelectorAll('.close-map-modal')) {
    element.onClick.listen(closeModal);
  }

  startButton.onClick.listen(onStartClick);
  startWithMapButton.onClick.listen(showMapPicker);
  pauseButton.onClick.listen(onPauseClick);
  loadMapButton.onClick.listen(confirmMap);
  hideNotificationButton.onClick.listen(hideNotification);
}
