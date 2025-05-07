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
    {"name": "Restos", "image": "assets/images/JogoColetarLixo/lixos/restosDeComida.png"},
    {"name": "Garrafa", "image": "assets/images/JogoColetarLixo/lixos/garrafasPlasticas.png"},
    {"name": "Entulho", "image": "assets/images/JogoColetarLixo/lixos/entulho.png"},
  ];

  late List<Offset> _positions;
  int currentIndex = 0;
  int timeLeft = 5;
  Timer? _timer;
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _shuffleTrash();
    _generatePositions();
    _startTimer();
  }

  void _shuffleTrash() {
    trashItems.shuffle(Random());
  }

  void _generatePositions() {
    final List<Offset> basePositions = [
      Offset(50, 150), Offset(120, 300), Offset(200, 450),
      Offset(100, 200), Offset(250, 350), Offset(180, 100),
      Offset(300, 400), Offset(80, 380),
    ];
    basePositions.shuffle(Random());
    _positions = basePositions.take(5).toList();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        _nextTrashOrEnd();
      }
    });
  }

  void _nextTrashOrEnd() {
    if (currentIndex < trashItems.length - 1) {
      setState(() {
        currentIndex++;
        timeLeft = 5;
      });
    } else {
      _endGame(true);
    }
  }

  void _endGame(bool success) {
    _timer?.cancel();
    _gameOver = true;
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

  void _restartGame() {
    setState(() {
      currentIndex = 0;
      timeLeft = 5;
      _shuffleTrash();
      _generatePositions();
      _gameOver = false;
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
          Positioned.fill(
            child: Image.asset(
              'assets/images/JogoColetarLixo/imagemParque_2.png',
              fit: BoxFit.cover,
            ),
          ),
          // Exibir todos os lixos
          for (int i = 0; i < trashItems.length; i++)
            Positioned(
              left: _positions[i].dx,
              top: _positions[i].dy,
              child: Draggable<String>(
                data: trashItems[i]['name']!,
                feedback: Image.asset(trashItems[i]['image']!, width: 140, height: 140),
                childWhenDragging: Opacity(
                  opacity: 0.5,
                  child: Image.asset(trashItems[i]['image']!, width: 140, height: 140),
                ),
                child: Image.asset(trashItems[i]['image']!, width: 140, height: 140),
              ),
            ),
          // Cesta de lixo
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
                if (data == trashItems[currentIndex]['name']) {
                  _nextTrashOrEnd();
                } else {
                  _endGame(false);
                }
              },
            ),
          ),
          // UI com tempo e nome
          Positioned(
            top: 60,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Encontre: ${trashItems[currentIndex]['name']}',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white, shadows: [
                    Shadow(blurRadius: 4, color: Colors.black, offset: Offset(2, 1))
                  ]),
                ),
                SizedBox(height: 10),
                Text(
                  'Tempo: $timeLeft s',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white, shadows: [
                    Shadow(blurRadius: 4, color: Colors.black, offset: Offset(2, 1))
                  ]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
