import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// Modelo do objeto que cai
class FallingObject {
  final double left;
  final int id;
  final String imagePath;

  FallingObject({required this.left, required this.id, required this.imagePath});
}

// Tela principal do mini game
class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<FallingObject> objects = [];
  final Random random = Random();
  int _objectId = 0;

  // Lista de imagens possíveis
  final List<String> objectImages = [
    'assets/images/jogoRoupas/Calça_marrom_boa_transparente.png',
    'assets/images/jogoRoupas/Calça_azulClaro_boa.png',
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _addFallingObject();
    });
  }

  void _addFallingObject() {
    setState(() {
      objects.add(FallingObject(
        left: random.nextDouble() * 300, // posição horizontal aleatória
        id: _objectId++,
        imagePath: objectImages[random.nextInt(objectImages.length)], // imagem aleatória
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/jogoRoupas/fundo_jogoRoupas.jpeg'), // Fundo do jogo
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: objects.map((obj) {
            return FallingWidget(
              key: ValueKey(obj.id),
              left: obj.left,
              imagePath: obj.imagePath,
              onEnd: () {
                setState(() {
                  objects.removeWhere((o) => o.id == obj.id);
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

// Widget da imagem caindo
class FallingWidget extends StatefulWidget {
  final double left;
  final String imagePath;
  final VoidCallback onEnd;

  const FallingWidget({
    Key? key,
    required this.left,
    required this.imagePath,
    required this.onEnd,
  }) : super(key: key);

  @override
  _FallingWidgetState createState() => _FallingWidgetState();
}

class _FallingWidgetState extends State<FallingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _topAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
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
          child: Image.asset(
            widget.imagePath,
            width: 50,
            height: 50,
          ),
        );
      },
    );
  }
}
