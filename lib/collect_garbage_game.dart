import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class GameCollectGarbageScreen extends StatefulWidget {
  @override
  _GameCollectGarbageState createState() => _GameCollectGarbageState();
}

class _GameCollectGarbageState extends State<GameCollectGarbageScreen> {
  final List<Offset> _trashPositions = [];
  final List<bool> _collected = [];
  final int trashCount = 5;
  final GlobalKey _binKey = GlobalKey();
  int collectedCount = 0;

  int _timeLeft = 60;
  Timer? _timer;
  bool _gameOver = false;

  // Posições fixas onde os lixos podem aparecer
  final List<Offset> _presetPositions = [
    Offset(60, 150),
    Offset(120, 300),
    Offset(200, 450),
    Offset(100, 200),
    Offset(250, 350),
    Offset(180, 100),
    Offset(300, 400),
    Offset(80, 380),
  ];

  @override
  void initState() {
    super.initState();
    _generateTrashPositions();
    _startTimer();
  }

  void _generateTrashPositions() {
    _trashPositions.clear();
    _collected.clear();

    final rand = Random();
    final shuffled = List<Offset>.from(_presetPositions)..shuffle(rand);

    for (int i = 0; i < trashCount; i++) {
      _trashPositions.add(shuffled[i]);
      _collected.add(false);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _endGame(false);
      }
    });
  }

  void _endGame(bool victory) {
    _timer?.cancel();
    _gameOver = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(victory ? 'Parabéns!' : 'Tempo esgotado!'),
        content: Text(victory
            ? 'Você limpou todo o parque!'
            : 'Você não conseguiu limpar tudo a tempo.'),
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

  void _restartGame() {
    setState(() {
      _trashPositions.clear();
      _collected.clear();
      collectedCount = 0;
      _timeLeft = 60;
      _gameOver = false;
      _generateTrashPositions();
      _startTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo do parque
          Positioned.fill(
            child: Image.asset(
              'assets/images/JogoColetarLixo/imagemParque_2.png',
              fit: BoxFit.cover,
            ),
          ),
          // Lixos
          for (int i = 0; i < trashCount; i++)
            if (!_collected[i])
              Positioned(
                left: _trashPositions[i].dx,
                top: _trashPositions[i].dy,
                child: Draggable<int>(
                  data: i,
                  feedback: Image.asset(
                    'assets/images/JogoColetarLixo/lixos/latasRefrigerante.png',
                    width: 90,
                    height: 90,
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.0,
                    child: Image.asset(
                      'assets/images/JogoColetarLixo/lixos/papelao.png',
                      width: 90,
                      height: 90,
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/JogoColetarLixo/lixos/restosDeComida.png',
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
          // Área da cesta de lixo
          Positioned(
            bottom: 0,
            right: 30,
            child: DragTarget<int>(
              key: _binKey,
              builder: (context, candidateData, rejectedData) {
                return Image.asset(
                  'assets/images/JogoColetarLixo/cestoDeLixo.png',
                  width: 340,
                  height: 340,
                );
              },
              onAccept: (index) {
                if (!_collected[index]) {
                  setState(() {
                    _collected[index] = true;
                    collectedCount++;
                    if (collectedCount == trashCount) {
                      _endGame(true);
                    }
                  });
                }
              },
            ),
          ),
          // UI superior
          Positioned(
            top: 40,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lixos coletados: $collectedCount / $trashCount',
                  style: TextStyle(fontSize: 20, color: Colors.white, shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black,
                      offset: Offset(2, 2),
                    )
                  ]),
                ),
                SizedBox(height: 10),
                Text(
                  'Tempo restante: $_timeLeft s',
                  style: TextStyle(fontSize: 20, color: Colors.white, shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black,
                      offset: Offset(2, 2),
                    )
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
