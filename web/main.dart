import 'dart:html';
import 'package:dart_snake/game.dart';

void main() {
  var startButton = document.querySelector('#start');
  startButton.onClick.listen(onClick);
}

void onClick(MouseEvent e) {
  const String level = '''
  [[4,4],[4,6],[4,8],[6,4],[6,6],[6,8],[8,4],[8,6],[8,8]]
  ''';
  var game = new Game.withLevel(onGameOver, level);
  game.start();
}

void onGameOver() {
  print("game over!");
}
