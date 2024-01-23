// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:math';

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
  static const int _framesSkippedForCalculation = -10;

  int _minLivingCells = double.maxFinite.toInt();
  int _maxLivingCells = _framesSkippedForCalculation;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    const cellEdge = 2.0;
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<Array2D>(
          stream: counter(width ~/ cellEdge, height ~/ cellEdge),
          builder: (BuildContext context, AsyncSnapshot<Array2D> snapshot) {
            final data = snapshot.data;
            if (data == null) return const SizedBox();
            final count = data.count;
            // Skip the first frames (with random data)
            if (_maxLivingCells < 0) {
              _maxLivingCells++;
            } else {
              _minLivingCells = min(_minLivingCells, count);
              _maxLivingCells = max(_maxLivingCells, count);
            }
            return Stack(
              children: [
                SizedBox(
                  width: width,
                  height: height,
                  child: CustomPaint(painter: _Array2DPaint(data)),
                ),
                InformationLayer(
                  count: count,
                  minLivingCells: _minLivingCells,
                  maxLivingCells: _maxLivingCells,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                      onPressed: () => setState(() {
                        _minLivingCells = double.maxFinite.toInt();
                        _maxLivingCells = _framesSkippedForCalculation;
                      }),
                      child: const Text('Restart'),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

Stream<Array2D> counter(int width, int height) async* {
  Array2D array = Array2D.random(width, height);

  while (true) {
    await Future.delayed(const Duration(milliseconds: 16));
    array = process(array);
    yield array;
  }
}

class _Array2DPaint extends CustomPainter {
  static final blue = Paint()
    ..color = const Color(0xFF0D47A1)
    ..style = PaintingStyle.fill;

  final Array2D data;

  _Array2DPaint(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height / data.height;
    final width = size.width / data.width;

    for (var y = 0; y < data.height; y++) {
      for (var x = 0; x < data.width; x++) {
        if (data.get(x, y) == 1) {
          canvas.drawRect(Rect.fromLTWH(x * width, y * height, width, height), blue);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class InformationLayer extends StatefulWidget {
  final int count;
  final int minLivingCells;
  final int maxLivingCells;

  const InformationLayer({
    super.key,
    required this.count,
    required this.minLivingCells,
    required this.maxLivingCells,
  });

  @override
  State<InformationLayer> createState() => _InformationLayerState();
}

class _InformationLayerState extends State<InformationLayer> {
  double _opacity = 0.2;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _opacity = _opacity == 0.2 ? 0.0 : 0.2),
      child: Container(
        color: Colors.black.withOpacity(_opacity),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Living cells: ${widget.count}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
              ),
              Visibility(
                visible: widget.maxLivingCells > 0,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Text(
                  'Min: ${widget.minLivingCells}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ),
              Visibility(
                visible: widget.maxLivingCells > 0,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Text(
                  'Max: ${widget.maxLivingCells}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
