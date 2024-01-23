class Array2D {
  final int width;
  final int height;
  final List<List<double>> _data;

  Array2D(this.width, this.height) : _data = List.generate(height, (x) => List.generate(width, (y) => 0));

  double get(int x, int y) {
    if (x < 0 || x >= width || y < 0 || y >= height) return 0;
    return _data[y][x];
  }

  void set(int x, int y, double value) {
    if (x < 0 || x >= width || y < 0 || y >= height) return;
    _data[y][x] = value;
  }

  Array2D translateRight() {
    final newArray = Array2D(width, height);
    for (var y = 0; y < height; y++) {
      for (var x = 1; x < width; x++) {
        if (get(x, y) == 1) {
          newArray.set(x, y, 0);
          newArray.set(x + 1, y, 1);
        }
      }
    }
    return newArray;
  }
}
