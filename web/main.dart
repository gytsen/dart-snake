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
  if (game == null) {
    game = new Game(canvas, onGameOver, onScore);
  }

  document.onKeyPress.listen(game.handleKeypress);
  changeStatusToAlive(snakeStatus);
  togglePauseContainer();
  game.start();
}

GameMap loadMap(TextAreaElement textArea) {
  String json = textArea.value;
  return GameMap.fromJson(json);
}

void onMapConfirm(MouseEvent e) {
  try {
    GameMap map = loadMap(mapTextArea);
    var canvas = document.querySelector('#snake-canvas');
    if (game == null) {
      game = new Game.withMap(canvas, onGameOver, onScore, map);
    }

    document.onKeyPress.listen(game.handleKeypress);
    changeStatusToAlive(snakeStatus);
    togglePauseContainer();
    game.start();
  } catch (error) {
    mapErrorText.text = error.toString();
    mapNotification.classes.remove('hidden');
  }
}

void onMapStartClick(MouseEvent e) {
  if (running()) {
    return;
  }

  mapModal.classes.add('is-active');
}

void onGameOver() {
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

void closeModal(MouseEvent e) {
  mapModal.classes.remove('is-active');
}

void hideNotification(MouseEvent e) {
  mapNotification.classes.add('hidden');
}

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

  for (var element in document.querySelectorAll('.close-map-modal')) {
    element.onClick.listen(closeModal);
  }

  startButton.onClick.listen(onStartClick);
  startWithMapButton.onClick.listen(onMapStartClick);
  pauseButton.onClick.listen(onPauseClick);
  loadMapButton.onClick.listen(onMapConfirm);
  hideNotificationButton.onClick.listen(hideNotification);
}
