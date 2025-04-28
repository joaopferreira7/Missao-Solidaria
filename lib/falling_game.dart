import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class FallingObject {
  final double left;
  final int id;

  FallingObject({required this.left, required this.id});
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<FallingObject> objects = [];
  final Random random = Random();
  int _objectId = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      _addFallingObject();
    });
  }

  void _addFallingObject() {
    setState(() {
      objects.add(FallingObject(
        left: random.nextDouble() * 300,
        id: _objectId++,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: objects.map((obj) {
          return FallingWidget(
            key: ValueKey(obj.id),
            left: obj.left,
            onEnd: () {
              setState(() {
                objects.removeWhere((o) => o.id == obj.id);
              });
            },
          );
        }).toList(),
      ),
    );
  }
}

class FallingWidget extends StatefulWidget {
  final double left;
  final VoidCallback onEnd;

  const FallingWidget({Key? key, required this.left, required this.onEnd}) : super(key: key);

  @override
  _FallingWidgetState createState() => _FallingWidgetState();
}

class _FallingWidgetState extends State<FallingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _topAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(seconds: 3), vsync: this);
    _topAnimation = Tween(begin: -50.0, end: 800.0).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onEnd();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _topAnimation,
      builder: (context, child) {
        return Positioned(
          top: _topAnimation.value,
          left: widget.left,
          child: Icon(Icons.star, size: 40, color: Colors.amber),
        );
      },
    );
  }
}
