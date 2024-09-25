import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 3D Controller',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter 3D controller example'),
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
  double _rx = 0.0, _ry = 0.0, _rz = 0.0;
  bool _rotationEnabled = true;
  Timer? _rotationTimer;
  final double _rotationIncrement = 0.01; // Incremental rotation value
  double _targetRotation = 0.0;

  void _toggleRotation() {
    setState(() {
      _rotationEnabled = !_rotationEnabled;
      if (!_rotationEnabled && _rotationTimer != null) {
        _rotationTimer?.cancel();
      }
    });
  }

  void _rotateBy90Degrees() {
    // if (_rotationEnabled) {
    // Calculate the target angle (current + 90 degrees)
    _targetRotation = _rx + pi / 2;
    // _targetRotation %= pi * 2; // Keep within 0 to 2π range

    _rotationTimer?.cancel();
    _rotationTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        _rx += _rotationIncrement;
        if (_rx >= _targetRotation) {
          _rx = _targetRotation; // Snap to the exact target value
          _rotationTimer?.cancel(); // Stop the timer when 90 degrees is reached
        }
      });
    });
    // }
  }

  @override
  void dispose() {
    _rotationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (_rotationEnabled) {
          _rx += details.delta.dx * 0.01;
          _ry += details.delta.dy * 0.01;
          setState(() {
            _rx %= pi * 2;
            _ry %= pi * 2;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_ry)
                ..rotateY(_rx)
                ..rotateZ(_rz),
              alignment: Alignment.center,
              child: const Center(
                child: Cube(),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            // ElevatedButton(
            //   onPressed: _toggleRotation,
            //   child: Text(
            //       _rotationEnabled ? 'Disable Rotation' : 'Enable Rotation'),
            // ),
            ElevatedButton(
              onPressed: _rotateBy90Degrees,
              child: const Text('Rotate 90 Degrees Slowly'),
            ),
          ],
        ),
      ),
    );
  }
}

class Cube extends StatelessWidget {
  const Cube({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      // Transform(
      //   transform: Matrix4.identity()
      //     ..translate(0.0, -100.0, 0.0)
      //     ..rotateX(-pi / 2),
      //   alignment: Alignment.center,
      //   child: Image.asset(
      //     'assets/Ellipse.png',
      //     // height: 100,
      //     // width: 100,
      //     color: Colors.black,
      //   ),
      // ),
      Transform(
        //back
        // transform: Matrix4.identity()
        //   ..translate(0.0, 0.0, 0.0), //(0.0, 0.0, -112.5)
        // ..rotateY(pi / 2),
        // alignment: Alignment.center,
        alignment: Alignment.center,
        transform: Matrix4.identity()..translate(Vector3(0, 0, -220)),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              'assets/front.png',
              height: 200,
            ),
          ),
        ),
      ),
      Transform(
        // left side
        // transform: Matrix4.identity()
        //   ..translate(0.0, 0.0, 0.0) //(-110.0, 0.0, 0.0)
        //   ..rotateY(pi / 2),
        // alignment: Alignment.center,
        alignment: Alignment.centerLeft,
        transform: Matrix4.identity()..rotateY(pi / 2.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              'assets/back.png',
              height: 200,
            ),
          ),
        ),
      ),
      Transform(
        // right side
        // transform: Matrix4.identity()..translate(0.0, 0.0, 112.5),
        // alignment: Alignment.center,
        alignment: Alignment.centerRight,
        transform: Matrix4.identity()..rotateY(-pi / 2.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              'assets/right.png',
              height: 200,
            ),
          ),
        ),
      ),
      // Transform(
      //   transform: Matrix4.identity()
      //     ..translate(110.0, 0.0, 0.0)
      //     ..rotateY(-pi / 2),
      //   alignment: Alignment.center,
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.asset(
            'assets/left.png',
            height: 200,
          ),
        ),
      ),
      // ),
      // Transform(
      //   transform: Matrix4.identity()
      //     ..translate(0.0, 100.0, 0.0)
      //     ..rotateX(pi / 2),
      //   alignment: Alignment.center,
      //   child: Image.asset(
      //     'assets/Ellipse.png',
      //     // height: 100,
      //     // width: 100,
      //     color: Colors.black,
      //   ),
      // ),
    ]);
  }
}
