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
    return const Scaffold(
      body: _Array2D(),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: StreamBuilder<Array2D>(
        stream: counter(),
        builder: (BuildContext context, AsyncSnapshot<Array2D> snapshot) {
          final data = snapshot.data;
          if (data == null) return const SizedBox();
          return _Array2D();
        },
      ),
    );
  }
}

Stream<Array2D> counter() async* {
  Array2D array = Array2D(10, 10)
    ..set(0, 0, 1)
    ..set(1, 1, 1)
    ..set(2, 2, 1)
    ..set(3, 3, 1)
    ..set(4, 4, 1)
    ..set(5, 5, 1);

  for (var i = 0; i < 10; i++) {
    await Future.delayed(const Duration(seconds: 1));
    array = array.translateRight();
    yield array;
  }
}

class _Array2D extends StatelessWidget {
  //final Array2D data;

  const _Array2D();

  @override
  Widget build(BuildContext context) {
    const double edge = double.infinity;
    return  Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(color: Colors.blue, width: edge, height: edge),
              ),
              Expanded(
                child: Container(color: Colors.red, width: edge, height: edge),
              ),
              Expanded(
                child: Container(color: Colors.green, width: edge, height: edge),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(color: Colors.red, width: edge, height: edge),
              ),
              Expanded(
                child: Container(color: Colors.green, width: edge, height: edge),
              ),
              Expanded(
                child: Container(color: Colors.blue, width: edge, height: edge),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(color: Colors.green, width: edge, height: edge),
              ),
              Expanded(
                child: Container(color: Colors.blue, width: edge, height: edge),
              ),
              Expanded(
                child: Container(color: Colors.red, width: edge, height: edge),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
