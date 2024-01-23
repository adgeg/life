import 'package:flutter/material.dart';
import 'package:life/array_2d.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    const cellEdge = 4.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: StreamBuilder<Array2D>(
        stream: counter(width ~/ cellEdge, height ~/ cellEdge),
        builder: (BuildContext context, AsyncSnapshot<Array2D> snapshot) {
          final data = snapshot.data;
          if (data == null) return const SizedBox();

          return SizedBox(
            width: width,
            height: height,
            child: CustomPaint(painter: _Array2DPaint(data)),
          );
        },
      ),
    );
  }
}

Stream<Array2D> counter(int width, int height) async* {
  Array2D array = Array2D(width, height)
    ..set(0, 0, 1)
    ..set(1, 1, 1)
    ..set(2, 2, 1)
    ..set(3, 3, 1)
    ..set(4, 4, 1)
    ..set(5, 5, 1);

  for (var i = 0; i < 1000; i++) {
    await Future.delayed(const Duration(milliseconds: 16));
    array = array.translateRight();
    yield array;
  }
}

class _Array2DPaint extends CustomPainter {
  final Array2D data;

  _Array2DPaint(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height/data.height;
    final width = size.width/data.width;
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    for (var y = 0; y < data.height; y++) {
      for (var x = 0; x < data.width; x++) {
        if (data.get(x, y) == 1) {
          canvas.drawRect(Rect.fromLTWH(x * width, y * height, width, height), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
