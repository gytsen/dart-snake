import 'dart:convert';

import 'package:dart_snake/coordinate.dart';

class GameMap {
  static const int WALL_COORDINATE_SIZE = 2;
  static const int WALL_X_IDX = 0;
  static const int WALL_Y_IDX = 1;

  int height;
  int width;
  Set<Coordinate> _walls;

  GameMap(this.height, this.width, this._walls);

  GameMap.empty() {
    height = 0;
    width = 0;
    _walls = Set<Coordinate>();
  }

  bool compatibleWith(int width, int height) =>
      this.height == height && this.width == width;

  bool contains(Coordinate c) => _walls.contains(c);

  Iterable<Coordinate> get walls => _walls;

  GameMap.fromJson(String json) {
    var walls = new Set<Coordinate>();
    var decodedJson = jsonDecode(json);

    if (decodedJson is! Map) {
      throw new ArgumentError("Wall JSON should be an object");
    }

    var height = decodedJson['height'];
    if (height == null || height is! int) {
      throw new ArgumentError(
          "Height should be an int, found ${height.runtimeType} instead");
    }

    var width = decodedJson['width'];
    if (width == null || width is! int) {
      throw new ArgumentError(
          "Width should be an int, found ${width.runtimeType} instead");
    }

    var decodedWalls = decodedJson['walls'];
    if (decodedWalls == null || decodedWalls is! List) {
      throw new ArgumentError(
          "Wall list must be an array, found ${decodedWalls.runtimeType} instead");
    }

    for (var wall in decodedWalls) {
      if (wall is! List || wall.length != WALL_COORDINATE_SIZE) {
        throw new ArgumentError("Wall JSON must use arrays of exactly size 2");
      }

      var wallCoordinate = new Coordinate(wall[WALL_X_IDX], wall[WALL_Y_IDX]);
      walls.add(wallCoordinate);
    }

    this.width = width;
    this.height = height;
    this._walls = walls;
  }

  static String encode(int width, int height, Set<Coordinate> walls) {
    List<List<int>> encodedWalls = new List();

    for (var wall in walls) {
      var entry = new List<int>(WALL_COORDINATE_SIZE);
      entry[WALL_X_IDX] = wall.x;
      entry[WALL_Y_IDX] = wall.y;
      encodedWalls.add(entry);
    }

    var map = {'height': height, 'width': width, 'walls': encodedWalls};

    return jsonEncode(map);
  }
}
