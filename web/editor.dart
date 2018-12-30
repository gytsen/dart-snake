import 'dart:html';

import 'package:dart_snake/screen.dart';
import 'package:dart_snake/coordinate.dart';
import 'package:dart_snake/wall_parser.dart';

Screen screen;
List<Coordinate> map;

Point getCanvasPosition(CanvasElement canvas, MouseEvent e) {
  var rect = canvas.getBoundingClientRect();
  var x = e.client.x - rect.left;
  var y = e.client.y - rect.top;
  return new Point(x, y);
}

void onClick(MouseEvent e) {
  var location = getCanvasPosition(screen.canvas, e);
  var coordinate = screen.getCoordinateFromCanvas(location);
  map.add(coordinate);
  screen.drawCoordinates(map, color: '#B62');
}

void onSave(MouseEvent e) {
  var output = WallParser.encode(map);
  print(output);
}

void main() {
  var output = document.querySelector('#editor');
  var saveButton = document.querySelector('#save');
  saveButton.onClick.listen(onSave);
  screen = new Screen(output);
  map = new List<Coordinate>();
  screen.canvas.onClick.listen(onClick);
}
