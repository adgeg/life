// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter_test/flutter_test.dart';
import 'package:life/array_2d.dart';
import 'package:life/game.dart';

void main() {
  test('no living cell', () {
    // Given
    final Array2D input = Array2D.fromData([
      '000',
      '111',
      '000',
    ]);

    // When
    final output = process(input);

    // Then
    expect(output, Array2D.fromData([
      '010',
      '010',
      '010',
    ]));
  });
}
