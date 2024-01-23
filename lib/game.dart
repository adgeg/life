import 'package:life/array_2d.dart';

Array2D process(Array2D input) {
  final output = Array2D(input.width, input.height);
  for (var y = 0; y < input.height; y++) {
    for (var x = 0; x < input.width; x++) {
      final livingNeighbors = input.get(x - 1, y - 1) +
          input.get(x - 1, y) +
          input.get(x - 1, y + 1) +
          input.get(x, y - 1) +
          input.get(x, y + 1) +
          input.get(x + 1, y - 1) +
          input.get(x + 1, y) +
          input.get(x + 1, y + 1);

      if (livingNeighbors == 3) {
        output.set(x, y, 1);
      } else if (livingNeighbors == 2) {
        output.set(x, y, input.get(x, y));
      } else{
        output.set(x, y, 0);
      }
    }
  }
  return output;
}
