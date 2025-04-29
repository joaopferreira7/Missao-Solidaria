import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class FallingObject {
  final double left;
  final int id;
  final String imagePath;
  final bool isGood; // Define se é roupa boa ou ruim

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
  int badPassed = 0;
  int remainingTime = 60;
  Timer? spawnTimer;
  Timer? gameTimer;
  bool gameOver = false;

  // Roupas boas
  final List<String> goodClothes = [
    'assets/images/jogoRoupas/Calça_marrom_boa.png',
    'assets/images/jogoRoupas/Calça_azulClaro_boa.png',
    'assets/images/jogoRoupas/Calça_azulEscuro_boa.png',
    'assets/images/jogoRoupas/Calça_cinzaClaro_boa.png',
    'assets/images/jogoRoupas/Calça_cinzaEscuro_boa.png',
    'assets/images/jogoRoupas/Calça_preta_boa.png',
  ];

  // Roupas ruins
  final List<String> badClothes = [
    'assets/images/jogoRoupas/Camisa_laranja_ruim.png',
    'assets/images/jogoRoupas/Camisa_marromListrada_ruim.png',
    'assets/images/jogoRoupas/Camisa_preta_ruim.png',
    'assets/images/jogoRoupas/Camisa_verdeListrada_ruim.png',
    'assets/images/jogoRoupas/Camisa_branca_ruim.png',
    'assets/images/jogoRoupas/Camisa_azul_ruim.png',
  ];

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    spawnTimer = Timer.periodic(const Duration(milliseconds: 900), (_) {
      _addFallingObject();
    });

    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime--;
        if (remainingTime <= 0 || badPassed >= 5) {
          _endGame();
        }
      });
    });
  }

  void _endGame() {
    spawnTimer?.cancel();
    gameTimer?.cancel();
    setState(() {
      gameOver = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(badPassed >= 5 ? 'Você perdeu!' : 'Fim de jogo!'),
          content: Text('Pontuação final: $score'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );
    });
  }

  void _addFallingObject() {
    bool isGood = random.nextBool();
    String imagePath = isGood
        ? goodClothes[random.nextInt(goodClothes.length)]
        : badClothes[random.nextInt(badClothes.length)];

    setState(() {
      objects.add(FallingObject(
        left: random.nextDouble() * MediaQuery.of(context).size.width * 0.8,
        id: _objectId++,
        imagePath: imagePath,
        isGood: isGood,
      ));
    });
  }

  void _removeBadByTap(int id) {
    setState(() {
      objects.removeWhere((o) => o.id == id);
      score += 2;
    });
  }

  void _handleObjectEnd(FallingObject obj) {
    setState(() {
      objects.removeWhere((o) => o.id == obj.id);
      if (obj.isGood) {
        score += 1;
      } else {
        score -= 2;
        badPassed++;
      }

      if (badPassed >= 5) {
        _endGame();
      }
    });
  }

  @override
  void dispose() {
    spawnTimer?.cancel();
    gameTimer?.cancel();
    super.dispose();
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
                onTap: obj.isGood
                    ? null
                    : () => _removeBadByTap(obj.id), // só clica em roupas ruins
                onEnd: () => _handleObjectEnd(obj),
              );
            }).toList(),

            // HUD de pontuação
            Positioned(
              top: 50,
              left: 10,
              child: Row(
                children: [
                  _buildStatText('⏱ $remainingTime s'),
                  const SizedBox(width: 16),
                  _buildStatText('⭐ Pontos: $score'),
                  const SizedBox(width: 16),
                  _buildStatText('❌ Erros: $badPassed/5'),
                ],
              ),
            ),
            // Botão sair
            Positioned(
              top: 40,
              right: -5,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE4C7A3),
                  shape: const CircleBorder(
                    side: BorderSide(color: Color(0xFF4F2E0D), width: 3),
                  ),
                ),
                child: const Icon(Icons.close, color: Color(0xFF333333)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [Shadow(offset: Offset(1, 1), blurRadius: 2, color: Colors.black)],
      ),
    );
  }
}

class FallingWidget extends StatefulWidget {
  final double left;
  final String imagePath;
  final VoidCallback? onTap;
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

class _FallingWidgetState extends State<FallingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _topAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _topAnimation = Tween(begin: -80.0, end: 800.0).animate(_controller)
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
