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
          return _Array2D(data);
        },
      ),
    );
  }
}

Stream<Array2D> counter() async* {
  const edge = 10;
  Array2D array = Array2D(edge, edge)
    ..set(0, 0, 1)
    ..set(1, 1, 1)
    ..set(2, 2, 1)
    ..set(3, 3, 1)
    ..set(4, 4, 1)
    ..set(5, 5, 1)
  ;

  for (var i = 0; i < 100; i++) {
    await Future.delayed(const Duration(milliseconds: 500));
    array = array.translateRight();
    yield array;
  }
}

class _Array2D extends StatelessWidget {
  final Array2D data;

  const _Array2D(this.data);

  @override
  Widget build(BuildContext context) {
    const double edge = double.infinity;
    final columnChildren = <Widget>[];
    for (var y = 0; y < data.height; y++) {
      final rowChildren = <Widget>[];
      for (var x = 0; x < data.width; x++) {
        rowChildren.add(
          Expanded(
            child: Container(
              color: data.get(x, y) == 1 ? Colors.blue : Colors.transparent,
              width: edge,
              height: edge,
            ),
          ),
        );
      }
      columnChildren.add(Expanded(child: Row(children: rowChildren)));
    }

    return Column(children: columnChildren);
  }
}
