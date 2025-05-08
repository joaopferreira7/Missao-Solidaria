  import 'dart:async';
  import 'dart:math';
  import 'package:flutter/material.dart';

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
        {"offset": Offset(80, 120), "allowed": ["Lata", "Papelão"]},
        {"offset": Offset(240, 530), "allowed": ["Entulho", "Garrafa"]},
        {"offset": Offset(100, 460), "allowed": ["Restos de Comida", "Entulho"]},
        {"offset": Offset(280, 620), "allowed": ["Garrafa", "Papelão"]},
        {"offset": Offset(20, 300), "allowed": ["Lata", "Restos de Comida"]},
        {"offset": Offset(310, 220), "allowed": ["Garrafa", "Entulho"]},
      ],
      // Fase 3
      [
        {"offset": Offset(100, 150), "allowed": ["Papelão", "Entulho"]},
        {"offset": Offset(30, 550), "allowed": ["Garrafa", "Lata"]},
        {"offset": Offset(270, 450), "allowed": ["Restos de Comida", "Papelão"]},
        {"offset": Offset(120, 600), "allowed": ["Entulho", "Lata"]},
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
          _nextTrashOrEnd();
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
            )
          ],
        ),
      );
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
          setState(() {
            currentPhase++;
            currentIndex = 0;
            timeLeft = 5;
            _generateTrashItems();
          });
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

            // Mostrar apenas os lixos atuais e seguintes, se o jogo ainda estiver em andamento
            for (int i = 0; i < activeTrash.length; i++)
              if (i >= currentIndex && !_gameOver)
                Positioned(
                  left: activeTrash[i]['position'].dx,
                  top: activeTrash[i]['position'].dy,
                  child: Draggable<String>(
                    data: activeTrash[i]['name'],
                    feedback: Image.asset(activeTrash[i]['image'], width: 140, height: 140),
                    childWhenDragging: Opacity(
                      opacity: 0.5,
                      child: Image.asset(activeTrash[i]['image'], width: 140, height: 140),
                    ),
                    child: Image.asset(activeTrash[i]['image'], width: 140, height: 140),
                  ),
                ),

            // Área da cesta de lixo
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
                    setState(() {
                      currentIndex++;
                      timeLeft = 5;
                    });
                    if (currentIndex >= activeTrash.length) {
                      _endGame(true);
                    }
                  } else {
                    _endGame(false);
                  }
                },
              ),
            ),

            // Exibição de nome do lixo atual e tempo restante
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
              )
          ],
        ),
      );
    }
  }
