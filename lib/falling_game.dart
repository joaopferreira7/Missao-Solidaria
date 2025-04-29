import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class FallingObject {
  final double left;
  final int id;
  final String imagePath;
  final bool isGood;

  FallingObject({
    required this.left,
    required this.id,
    required this.imagePath,
    required this.isGood,
  });
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
  int score = 0;

  final List<String> objectImages = [
    // Roupas boas
    'assets/images/jogoRoupas/Calça_marrom_boa.png',
    'assets/images/jogoRoupas/Calça_azulClaro_boa.png',
    'assets/images/jogoRoupas/Calça_azulEscuro_boa.png',
    'assets/images/jogoRoupas/Calça_cinzaClaro_boa.png',
    'assets/images/jogoRoupas/Calça_cinzaEscuro_boa.png',
    'assets/images/jogoRoupas/Calça_preta_boa.png',
    // Roupas ruins
    'assets/images/jogoRoupas/Camisa_laranja_ruim.png',
    'assets/images/jogoRoupas/Camisa_marromListrada_ruim.png',
    'assets/images/jogoRoupas/Camisa_preta_ruim.png',
    'assets/images/jogoRoupas/Camisa_verdeListrada_ruim.png',
    'assets/images/jogoRoupas/Camisa_branca_ruim.png',
    'assets/images/jogoRoupas/Camisa_azul_ruim.png',
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
    final String path = objectImages[random.nextInt(objectImages.length)];
    final bool isGood = path.contains('_boa');

    setState(() {
      objects.add(FallingObject(
        left: random.nextDouble() * MediaQuery.of(context).size.width * 0.8,
        id: _objectId++,
        imagePath: path,
        isGood: isGood,
      ));
    });
  }

  void _incrementScore(int id) {
    final tapped = objects.firstWhere((o) => o.id == id);

    setState(() {
      if (tapped.isGood) {
        score++;
      } else {
        score = max(0, score - 1); // perde ponto se clicar em roupa ruim
      }

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
            // Objetos caindo
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

            // Pontuação e botão
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
              width: 180,
              height: 180,
            ),
          ),
        );
      },
    );
  }
}
