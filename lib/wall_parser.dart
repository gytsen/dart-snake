import 'dart:convert';

import 'package:dart_snake/coordinate.dart';

/// Convenience class that handles converting walls from and to JSON, so that
/// [Game]'s can load and export level files easily as JSON.
class WallParser {
  static const int WALL_COORDINATE_SIZE = 2;
  static const int WALL_X_IDX = 0;
  static const int WALL_Y_IDX = 1;

  static List<Coordinate> decode(String json) {
    var walls = new List<Coordinate>();
    var decodedJson = jsonDecode(json);

    if (decodedJson is! List) {
      throw new ArgumentError("Wall JSON should be an array of coordinates");
    }

    for (var wall in decodedJson) {
      if (wall is! List || wall.length != WALL_COORDINATE_SIZE) {
        throw new ArgumentError("Wall JSON must use arrays of exactly size 2");
      }

      var wallCoordinate = new Coordinate(wall[WALL_X_IDX], wall[WALL_Y_IDX]);
      walls.add(wallCoordinate);
    }
    return walls;
  }

  static String encode(List<Coordinate> walls) {
    List<List<int>> output = new List();

    for (var wall in walls) {
      var entry = new List<int>(WALL_COORDINATE_SIZE);
      entry[WALL_X_IDX] = wall.x;
      entry[WALL_Y_IDX] = wall.y;
      output.add(entry);
    }

    return jsonEncode(output);
  }
}
