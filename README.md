# Snake

A little snake game written in Dart.

## what's in the box?
Right now this package provides a working game interface along with a small map editor
for generating your own maps. It also provides a few classes that abstract working with the 
canvas and processing the internal game state.

## Building the code
The code was developed using the Dart 2.1.0 SDK. Earlier versions may work, but are not 
guaranteed to work.

To get started, run the following
```bash
pub get
webdev serve
```

If all builds well, you can point your browser to `localhost:8080` and the game should run there.

## To do
The following (non-exhaustive) list is still to do:
* Document remaining code
* Make another cleanup pass at `main.dart` and `editor.dart`. The code works but it's still quite sloppy.
* Use the `GameMap.isCompatible()` method in `main.dart` to actually check if the map we're loading is 
compatible with the canvas size we're playing on.
* Make another pass at the map loading code in `main.dart`, right now it's all thrown in a big try/catch block
that pokemon catches any exception that comes out there. 