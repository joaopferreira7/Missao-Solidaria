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

  @override
  void initState() {
    super.initState();
    _generateTrashPositions();
    _startTimer();
  }

  void _generateTrashPositions() {
    final rand = Random();
    for (int i = 0; i < trashCount; i++) {
      _trashPositions.add(Offset(
        50.0 + rand.nextDouble() * 250,
        100.0 + rand.nextDouble() * 400,
      ));
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
              'assets/images/JogoColetarLixo/TelaFundoPark.jpeg',
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
                    'assets/images/trash.png',
                    width: 40,
                    height: 40,
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.0,
                    child: Image.asset(
                      'assets/images/trash.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/trash.png',
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
          // Área da cesta de lixo
          Positioned(
            bottom: 20,
            right: 20,
            child: DragTarget<int>(
              key: _binKey,
              builder: (context, candidateData, rejectedData) {
                return Image.asset(
                  'assets/images/bin.png',
                  width: 80,
                  height: 80,
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
