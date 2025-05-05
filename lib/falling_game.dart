// Importações necessárias
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'main.dart';

// Modelo de Objeto que Cai
class FallingObject {
  final double left;
  final int id;
  final String imagePath;
  final bool isGood;
  late AnimationController controller;

  FallingObject({
    required this.left,
    required this.id,
    required this.imagePath,
    required this.isGood,
  });
}

// Fase do jogo com roupas específicas
class Phase {
  final int duration;
  final int maxErrors;
  final double fallSpeed;
  final List<String> goodClothes;
  final List<String> badClothes;

  Phase({
    required this.duration,
    required this.maxErrors,
    required this.fallSpeed,
    required this.goodClothes,
    required this.badClothes,
  });
}

class GameFallingScreen extends StatefulWidget {
  const GameFallingScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameFallingScreen> with TickerProviderStateMixin {
  List<FallingObject> objects = [];
  final Random random = Random();
  int _objectId = 0;
  int score = 0;
  int badPassed = 0;
  int remainingTime = 60;
  Timer? spawnTimer;
  Timer? gameTimer;
  bool gameOver = false;
  bool isPaused = false;
  int currentPhase = 0;

  late List<Phase> phases;

  @override
  void initState() {
    super.initState();

    // Define as fases com roupas específicas
    phases = [
      Phase(
        duration: 60,
        maxErrors: 5,
        fallSpeed: 0.9,
        goodClothes: [
          'assets/images/jogoRoupas/Calça_marrom_boa.png',
          'assets/images/jogoRoupas/Calça_azulClaro_boa.png',
          'assets/images/jogoRoupas/Calça_azulEscuro_boa.png',
          'assets/images/jogoRoupas/Calça_cinzaClaro_boa.png',
          'assets/images/jogoRoupas/Calça_cinzaEscuro_boa.png',
          'assets/images/jogoRoupas/Calça_preta_boa.png',
          'assets/images/jogoRoupas/Camisa_azul_boa.png',
          'assets/images/jogoRoupas/Camisa_branca_boa.png',
          'assets/images/jogoRoupas/Camisa_laranja_boa.png',
          'assets/images/jogoRoupas/Camisa_marromListrada_boa.png',
          'assets/images/jogoRoupas/Camisa_preta_boa.png',
          'assets/images/jogoRoupas/Camisa_verdeListrada_boa.png',
        ],
        badClothes: [
          'assets/images/jogoRoupas/Camisa_laranja_ruim.png',
          'assets/images/jogoRoupas/Camisa_marromListrada_ruim.png',
          'assets/images/jogoRoupas/Camisa_preta_ruim.png',
          'assets/images/jogoRoupas/Camisa_verdeListrada_ruim.png',
          'assets/images/jogoRoupas/Camisa_branca_ruim.png',
          'assets/images/jogoRoupas/Camisa_azul_ruim.png',
          'assets/images/jogoRoupas/Shorts_azul_ruim.png',
          'assets/images/jogoRoupas/Shorts_bege_ruim.png',
          'assets/images/jogoRoupas/Shorts_branco_ruim.png',
          'assets/images/jogoRoupas/Shorts_cinza_ruim.png',
          'assets/images/jogoRoupas/Shorts_marrom_ruim.png',
          'assets/images/jogoRoupas/Shorts_preto_ruim.png',
        ],
      ),
      Phase(
        duration: 50,
        maxErrors: 3,
        fallSpeed: 0.6,
        goodClothes: [
          'assets/images/jogoRoupas/Calca_jeans_boa.png',
          'assets/images/jogoRoupas/Camisa_social_boa.png',
        ],
        badClothes: [
          'assets/images/jogoRoupas/Calca_jeans_ruim.png',
          'assets/images/jogoRoupas/Camisa_social_ruim.png',
        ],
      ),
      Phase(
        duration: 30,
        maxErrors: 2,
        fallSpeed: 0.3,
        goodClothes: [
          'assets/images/jogoRoupas/Blusa_lan_boa.png',
        ],
        badClothes: [
          'assets/images/jogoRoupas/Blusa_lan_ruim.png',
        ],
      ),
    ];

    _startPhase();
  }

  void _startPhase() {
    Phase current = phases[currentPhase];
    remainingTime = current.duration;

    spawnTimer = Timer.periodic(
      Duration(milliseconds: (current.fallSpeed * 1000).toInt()),
          (_) {
        if (!isPaused) _addFallingObject();
      },
    );

    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused) {
        setState(() {
          remainingTime--;
          if (remainingTime <= 0) {
            _endPhase(lost: false);
          }
        });
      }
    });
  }

  void _pauseGame() {
    setState(() => isPaused = true);
    for (var obj in objects) {
      obj.controller.stop();
    }
  }

  void _resumeGame() {
    setState(() => isPaused = false);
    for (var obj in objects) {
      obj.controller.forward();
    }
  }

  void _endPhase({required bool lost}) {
    _pauseGame();
    spawnTimer?.cancel();
    gameTimer?.cancel();

    if (lost) {
      _showGameOverDialog();
    } else if (currentPhase < phases.length - 1) {
      _showVictoryDialog();
    } else {
      _showGameOverDialog();
    }
  }

  void _showVictoryDialog() {
    _pauseGame();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Parabéns!'),
        content: Text('Você completou a fase ${currentPhase + 1}!Pontuação: $score'),
            actions: [
            TextButton(
            onPressed: () {
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
      currentPhase++;
      score = 0;
      badPassed = 0;
      objects.clear();
      });
      _resumeGame();
      _startPhase();
      });
      },
        child: const Text('Próxima Fase'),
      ),
      ],
    ),
    );
  }

  void _showGameOverDialog() {
    _pauseGame();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Fim de Jogo!'),
        content: Text('Pontuação final: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 100), () {
                setState(() {
                  score = 0;
                  badPassed = 0;
                  objects.clear();
                  _startPhase();
                });
              });
            },
            child: const Text('Reiniciar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TelaEscolherJogo()),
              );
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  void _addFallingObject() {
    Phase current = phases[currentPhase];
    bool isGood = random.nextBool();
    String imagePath = isGood
        ? current.goodClothes[random.nextInt(current.goodClothes.length)]
        : current.badClothes[random.nextInt(current.badClothes.length)];

    AnimationController controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    final obj = FallingObject(
      left: random.nextDouble() * MediaQuery.of(context).size.width * 0.5,
      id: _objectId++,
      imagePath: imagePath,
      isGood: isGood,
    )..controller = controller;

    controller.forward().whenComplete(() {
      _handleObjectEnd(obj);
    });

    setState(() => objects.add(obj));
  }

  void _handleTapObject(FallingObject obj) {
    setState(() {
      obj.controller.dispose();
      objects.removeWhere((o) => o.id == obj.id);
      if (obj.isGood) {
        score -= 1;
        badPassed++;
      } else {
        score += 2;
      }
      if (badPassed >= phases[currentPhase].maxErrors) {
        _endPhase(lost: true);
      }
    });
  }

  void _handleObjectEnd(FallingObject obj) {
    setState(() {
      obj.controller.dispose();
      objects.removeWhere((o) => o.id == obj.id);
      if (obj.isGood) {
        score += 1;
      } else {
        score -= 2;
        badPassed++;
      }
      if (badPassed >= phases[currentPhase].maxErrors) {
        _endPhase(lost: true);
      }
    });
  }

  @override
  void dispose() {
    spawnTimer?.cancel();
    gameTimer?.cancel();
    for (var obj in objects) {
      obj.controller.dispose();
    }
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
            ...objects.map((obj) => FallingWidget(
              key: ValueKey(obj.id),
              left: obj.left,
              imagePath: obj.imagePath,
              controller: obj.controller,
              onTap: () => _handleTapObject(obj),
            )),
            Positioned(
              top: 50,
              left: 10,
              child: Row(
                children: [
                  _buildStatText('⏱ $remainingTime s'),
                  const SizedBox(width: 16),
                  _buildStatText('⭐ Pontos: $score'),
                  const SizedBox(width: 16),
                  _buildStatText('❌ Erros: $badPassed/${phases[currentPhase].maxErrors}'),
                ],
              ),
            ),
            Positioned(
              top: 40,
              right: -5,
              child: ElevatedButton(
                onPressed: () {
                  _pauseGame();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Sair do Jogo'),
                        content: const Text('Você deseja voltar ao menu anterior?'),
                        actions: [
                          TextButton(
                            child: const Text('Não'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _resumeGame();
                            },
                          ),
                          TextButton(
                            child: const Text('Sim'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => TelaEscolherJogo()),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE4C7A3),
                  shape: const CircleBorder(
                    side: BorderSide(color: Color(0xFF4F2E0D), width: 3),
                  ),
                ),
                child: const Icon(Icons.close, color: Color(0xFF333333), size: 22),
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

class FallingWidget extends StatelessWidget {
  final double left;
  final String imagePath;
  final AnimationController controller;
  final VoidCallback onTap;

  const FallingWidget({
    Key? key,
    required this.left,
    required this.imagePath,
    required this.controller,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animation = Tween<double>(begin: -50.0, end: 800.0).animate(controller);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Positioned(
          top: animation.value,
          left: left,
          child: GestureDetector(
            onTap: onTap,
            child: Image.asset(
              imagePath,
              width: 180,
              height: 180,
            ),
          ),
        );
      },
    );
  }
}
