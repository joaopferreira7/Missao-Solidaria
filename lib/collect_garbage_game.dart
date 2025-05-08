import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'main.dart';

class GameCollectGarbageScreen extends StatefulWidget {
  @override
  _GameCollectGarbageState createState() => _GameCollectGarbageState();
}

class _GameCollectGarbageState extends State<GameCollectGarbageScreen> {
  final List<Map<String, String>> trashItems = [
    {"name": "Lata", "image": "assets/images/JogoColetarLixo/lixos/latasRefrigerante.png"},
    {"name": "Papelão", "image": "assets/images/JogoColetarLixo/lixos/papelao.png"},
    {"name": "Restos de Comida", "image": "assets/images/JogoColetarLixo/lixos/restosDeComida.png"},
    {"name": "Garrafa", "image": "assets/images/JogoColetarLixo/lixos/garrafa.png"},
    {"name": "Entulho", "image": "assets/images/JogoColetarLixo/lixos/entulho.png"},
  ];

  final List<List<Map<String, dynamic>>> allPhases = [
    // Fase 1
    [
      {"offset": Offset(60, 100), "allowed": ["Lata", "Garrafa", "Papelão"]},
      {"offset": Offset(20, 530), "allowed": ["Entulho", "Restos de Comida", "Papelão"]},
      {"offset": Offset(250, 560), "allowed": ["Garrafa", "Lata"]},
      {"offset": Offset(150, 500), "allowed": ["Restos de Comida", "Entulho", "Papelão", "Lata", "Garrafa"]},
      {"offset": Offset(0, 600), "allowed": ["Lata", "Garrafa"]},
    ],
    // Fase 2
    [
      {"offset": Offset(10, 200), "allowed": ["Lata", "Papelão"]},
      {"offset": Offset(240, 530), "allowed": ["Entulho", "Garrafa"]},
      {"offset": Offset(30, 420), "allowed": ["Restos de Comida", "Entulho"]},
      {"offset": Offset(230, 320), "allowed": ["Garrafa", "Papelão"]},
      {"offset": Offset(20, 300), "allowed": ["Lata", "Restos de Comida"]},
      {"offset": Offset(300, 240), "allowed": ["Garrafa", "Entulho"]},


    ],
    // Fase 3
    [
      {"offset": Offset(100, 150), "allowed": ["Papelão", "Entulho"]},
      {"offset": Offset(30, 550), "allowed": ["Garrafa", "Lata"]},
      {"offset": Offset(270, 450), "allowed": ["Restos de Comida", "Papelão"]},
      {"offset": Offset(120, 500), "allowed": ["Entulho", "Lata"]},
      {"offset": Offset(180, 320), "allowed": ["Garrafa", "Lata"]},
      {"offset": Offset(50, 400), "allowed": ["Restos de Comida", "Papelão"]},
      {"offset": Offset(250, 300), "allowed": ["Lata", "Papelão", "Garrafa"]},
    ],
  ];

  final List<String> backgroundImages = [
    'assets/images/JogoColetarLixo/imagemParque_2.png',
    'assets/images/JogoColetarLixo/imagemParque_1.png',
    'assets/images/JogoColetarLixo/TelaFundoPark.jpeg',
  ];

  int currentPhase = 0;
  List<Map<String, dynamic>> activeTrash = [];
  int currentIndex = 0;
  int timeLeft = 5;
  Timer? _timer;
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _setupGame();
  }

  void _setupGame() {
    _generateTrashItems();
    _startTimer();
  }

  void _restartGame() {
    setState(() {
      currentPhase = 0;
      currentIndex = 0;
      timeLeft = 5;
      _gameOver = false;
      _setupGame();
    });
  }

  void _generateTrashItems() {
    activeTrash.clear();
    final random = Random();
    final List<Map<String, dynamic>> positionConfigs = allPhases[currentPhase];
    final List<Map<String, dynamic>> shuffledPositions = List.from(positionConfigs)..shuffle();

    for (var config in shuffledPositions.take(5)) {
      final allowed = config["allowed"];
      final possible = trashItems.where((item) => allowed.contains(item["name"])).toList();
      final selected = possible[random.nextInt(possible.length)];

      activeTrash.add({
        "name": selected["name"],
        "image": selected["image"],
        "position": config["offset"]
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_gameOver && timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        _endGame(false);
      }
    });
  }

  void _endGame(bool success) {
    _timer?.cancel();
    setState(() {
      _gameOver = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(success ? 'Parabéns!' : 'Tempo esgotado!'),
        content: Text(success ? 'Você limpou todo o parque!' : 'Você não conseguiu completar o desafio.'),
        actions: [
          TextButton(
            child: Text('Jogar Novamente'),
            onPressed: () {
              Navigator.of(context).pop();
              _restartGame();
            },
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

  void _pauseGame() {
    _timer?.cancel();
  }

  void _resumeGame() {
    _startTimer();
  }

  void _advanceToNextPhase() {
    setState(() {
      currentPhase++;
      currentIndex = 0;
      timeLeft = 5;
      _gameOver = false;
      _generateTrashItems();
      _startTimer();
    });
  }

  void _nextTrashOrEnd() {
    if (_gameOver) return;

    if (currentIndex < activeTrash.length - 1) {
      setState(() {
        currentIndex++;
        timeLeft = 5;
      });
    } else {
      if (currentPhase < allPhases.length - 1) {
        _timer?.cancel();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: Text('Fase Completa!'),
            content: Text('Você limpou o parque com sucesso!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _advanceToNextPhase();
                },
                child: Text('Próxima Fase'),
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
      } else {
        _endGame(true);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasTrashToShow = !_gameOver && currentIndex < activeTrash.length;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              backgroundImages[currentPhase],
              fit: BoxFit.cover,
            ),
          ),

          for (int i = 0; i < activeTrash.length; i++)
            if (i >= currentIndex && !_gameOver)
              Positioned(
                left: activeTrash[i]['position'].dx,
                top: activeTrash[i]['position'].dy,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapDown: (_) {
                    debugPrint('Item tocado: ${activeTrash[i]['name']}');
                  },
                  child: Container(
                    // Ajuste esses valores para mudar a hitbox
                    width: 130,  // Largura da hitbox
                    height: 130, // Altura da hitbox
                    color: Colors.transparent, // Mantém transparente
                    child: Center(
                      child: SizedBox(
                        width: 130,  // Largura visual do item
                        height: 130, // Altura visual do item
                        child: Draggable<String>(
                          data: activeTrash[i]['name'],
                          feedback: Image.asset(
                            activeTrash[i]['image'],
                            width: 130,
                            height: 130,
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.5,
                            child: Image.asset(
                              activeTrash[i]['image'],
                              width: 130,
                              height: 130,
                            ),
                          ),
                          child: Image.asset(
                            activeTrash[i]['image'],
                            width: 130,
                            height: 130,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),


          Positioned(
            bottom: 0,
            right: 30,
            child: DragTarget<String>(
              builder: (context, candidateData, rejectedData) {
                return Image.asset(
                  'assets/images/JogoColetarLixo/cestoDeLixo.png',
                  width: 340,
                  height: 340,
                );
              },
              onAccept: (data) {
                if (_gameOver || currentIndex >= activeTrash.length) return;

                if (data == activeTrash[currentIndex]['name']) {
                  _nextTrashOrEnd();
                } else {
                  _endGame(false);
                }
              },
            ),
          ),

          if (hasTrashToShow)
            Positioned(
              top: 60,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Encontre: ${activeTrash[currentIndex]['name']}',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black, offset: Offset(2, 1))],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Tempo: $timeLeft s',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black, offset: Offset(2, 1))],
                    ),
                  ),
                ],
              ),
            ),

          // Botão de sair
          Positioned(
            top: 55,
            right: -10,
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
    );
  }
}
