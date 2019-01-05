import 'dart:html';
import 'dart:convert';

import 'package:dart_snake/screen.dart';
import 'package:dart_snake/coordinate.dart';
import 'package:dart_snake/game_map.dart';

Screen screen;
Set<Coordinate> map;

SpanElement wallCount;

/// Translate a mouse click on a canvas from canvas coordinates
/// to a canvas [Point]. This function takes into account the
/// possibility that the canvas might not be entirely visible.
Point getCanvasPosition(CanvasElement canvas, MouseEvent e) {
  var rect = canvas.getBoundingClientRect();
  var x = e.client.x - rect.left;
  var y = e.client.y - rect.top;
  return new Point(x, y);
}

void onClick(MouseEvent e) {
  var location = getCanvasPosition(screen.canvas, e);
  var coordinate = screen.getCoordinateFromCanvas(location);
  if (map.contains(coordinate)) {
    map.remove(coordinate);
  } else {
    map.add(coordinate);
  }

  screen.clear();
  screen.drawCoordinates(map, color: '#B62');
  wallCount.text = map.length.toString();
}

void save(MouseEvent e) {
  var output = GameMap.encode(screen.width, screen.height, map);
  download('map.json', output);
}

/// Little function to immediately download a file
/// inspired by http://stackoverflow.com/questions/3665115/create-a-file-in-memory-for-user-to-download-not-through-server
void download(String filename, String content) {
  Uri encodedContent = Uri.dataFromString(content, encoding: Utf8Codec());

  var element = document.createElement('a')
    ..setAttribute('href', encodedContent.toString())
    ..setAttribute('download', filename)
    ..style.display = 'none';

  document.body.append(element);

  element.click();

  element.remove();
}

void reset(MouseEvent e) {
  screen.clear();
  map.clear();
  wallCount.text = map.length.toString();
}

void main() {
  CanvasElement canvas = document.querySelector('#map-canvas');
  wallCount = document.querySelector('#wall-count');
  var resetButton = document.querySelector('#reset');
  var saveButton = document.querySelector('#download-map');

  saveButton.onClick.listen(save);
  resetButton.onClick.listen(reset);

  screen = new Screen(canvas);
  map = new Set<Coordinate>();

  screen.canvas.onClick.listen(onClick);
}
