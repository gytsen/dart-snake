import 'package:dart_snake/game.dart';

void main() {
  var game = new Game(onGameOver);
  game.start();
}

void onGameOver() {
  print("game over!");
}
