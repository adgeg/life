import 'dart:math';

import 'package:equatable/equatable.dart';

class Array2D extends Equatable {
  final int width;
  final int height;
  final List<List<double>> _data;

  Array2D(this.width, this.height) : _data = List.generate(height, (x) => List.generate(width, (y) => 0));

  Array2D._(this._data)
      : width = _data[0].length,
        height = _data.length;

  factory Array2D.fromData(List<String> data) {
    final array2d = Array2D(data[0].length, data.length);
    for (var y = 0; y < data.length; y++) {
      for (var x = 0; x < data[0].length; x++) {
        array2d.set(x, y, data[y][x] == '1' ? 1 : 0);
      }
    }
    return array2d;
  }

  factory Array2D.random(int width, int height) {
    return Array2D._(List.generate(height, (y) => List.generate(width, (x) => Random().nextBool() ? 1 : 0)));
  }

  factory Array2D.randomCentered(int width, int height) {
    final widthThird = width ~/ 3;
    final heightThird = height ~/ 3;

    return Array2D._(List.generate(height, (y) {
      if (y > heightThird && y < 2 * heightThird) {
        return List.generate(width, (x) {
          if (x > widthThird && x < 2 * widthThird) return Random().nextBool() ? 1 : 0;
          return 0;
        });
      }
      return List.generate(width, (x) => 0);
    }));
  }

  int get count {
    var count = 0;
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        count = count + get(x, y).toInt();
      }
    }
    return count;
  }

  double get(int x, int y) {
    if (x < 0 || x >= width || y < 0 || y >= height) return 0;
    return _data[y][x];
  }

  void set(int x, int y, double value) {
    final int newX, newY;
    if (x < 0) {
      newX = width + x;
    } else if (x >= width) {
      newX = x - width;
    } else {
      newX = x;
    }

    if (y < 0) {
      newY = height + y;
    } else if (y >= height) {
      newY = y - height;
    } else {
      newY = y;
    }

    _data[newY][newX] = value;
  }

  Array2D translateRight() {
    final newArray = Array2D(width, height);
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        if (get(x, y) == 1) {
          newArray.set(x, y, 0);
          newArray.set(x - 1, y + 1, 1);
        }
      }
    }
    return newArray;
  }

  Array2D withFilledEdges() {
    final newArray = Array2D(width, height);
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        if (y == 0 || y == height - 1 || x == 0 || x == width - 1) {
          newArray.set(x, y, 1);
        } else {
          newArray.set(x, y, get(x, y));
        }
      }
    }
    return newArray;
  }

  @override
  List<Object?> get props => [_data];
}
