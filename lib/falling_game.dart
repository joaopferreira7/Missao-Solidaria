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
  int score = 0; // Nova variável de pontuação

  // Lista de imagens possíveis
  final List<String> objectImages = [
    'assets/images/jogoRoupas/Calça_marrom_boa.png',
    'assets/images/jogoRoupas/Calça_azulClaro_boa.png',
    'assets/images/jogoRoupas/Calça_azulEscuro_boa.png',
    'assets/images/jogoRoupas/Calça_cinzaClaro_boa.png',
    'assets/images/jogoRoupas/Calça_cinzaEscuro_boa.png',
    'assets/images/jogoRoupas/Calça_preta_boa.png',
  ];

  Timer? spawnTimer;

  @override
  void initState() {
    super.initState();
    spawnTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _addFallingObject();
    });
  }

  @override
  void dispose() {
    spawnTimer?.cancel();
    super.dispose();
  }

  void _addFallingObject() {
    setState(() {
      objects.add(FallingObject(
        left: random.nextDouble() * MediaQuery.of(context).size.width * 0.8, // posição horizontal
        id: _objectId++,
        imagePath: objectImages[random.nextInt(objectImages.length)], // imagem aleatória
      ));
    });
  }

  void _incrementScore(int id) {
    setState(() {
      score++;
      objects.removeWhere((o) => o.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/jogoRoupas/fundo_jogoRoupas.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Itens caindo
            ...objects.map((obj) {
              return FallingWidget(
                key: ValueKey(obj.id),
                left: obj.left,
                imagePath: obj.imagePath,
                onTap: () => _incrementScore(obj.id),
                onEnd: () {
                  setState(() {
                    objects.removeWhere((o) => o.id == obj.id);
                  });
                },
              );
            }).toList(),

            // HUD de Pontuação e Botão
            Positioned(
              top: 40,
              left: 20,
              child: Row(
                children: [
                  Text(
                    'Pontos: $score',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 3,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 180),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE4C7A3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Color(0xFF4F2E0D), width: 4),
                      ),
                    ),
                    child: const Text('X'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget da imagem caindo
class FallingWidget extends StatefulWidget {
  final double left;
  final String imagePath;
  final VoidCallback onTap;
  final VoidCallback onEnd;

  const FallingWidget({
    Key? key,
    required this.left,
    required this.imagePath,
    required this.onTap,
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
      duration: const Duration(seconds: 2),
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
          child: GestureDetector(
            onTap: widget.onTap,
            child: Image.asset(
              widget.imagePath,
              width: 160,
              height: 160,
            ),
          ),
        );
      },
    );
  }
}
