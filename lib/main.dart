// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:life/array_2d.dart';
import 'package:life/game.dart';

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
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Life'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    const cellEdge = 2.0;
    return Scaffold(
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {}),
          child: const Icon(Icons.restart_alt),
        ));
  }
}

Stream<Array2D> counter(int width, int height) async* {
  Array2D array = Array2D.random(width, height);

  while(true) {
    await Future.delayed(const Duration(milliseconds: 16 *4));
    array = process(array);
    yield array;
  }
}

class _Array2DPaint extends CustomPainter {
  final Array2D data;

  _Array2DPaint(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height / data.height;
    final width = size.width / data.width;
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
