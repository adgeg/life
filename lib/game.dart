import 'package:life/array_2d.dart';

Array2D process(Array2D input) {
  final output = Array2D(input.width, input.height);
  for (var y = 0; y < input.height; y++) {
    for (var x = 0; x < input.width; x++) {
      output.set(
        x,
        y,
        switch (input.livingNeighbors(x, y)) {
          3 => 1,
          2 => input.get(x, y),
          _ => 0,
        },
      );
    }
  }
  return output;
}

extension on Array2D {
  double livingNeighbors(int x, int y) {
    return get(x - 1, y - 1) +
        get(x - 1, y) +
        get(x - 1, y + 1) +
        get(x, y - 1) +
        get(x, y + 1) +
        get(x + 1, y - 1) +
        get(x + 1, y) +
        get(x + 1, y + 1);
  }
}
