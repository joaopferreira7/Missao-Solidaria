import 'package:flutter/material.dart';

class GameCollectGarbageScreen extends StatefulWidget {
  @override
  _GameCollectGarbageState createState() => _GameCollectGarbageState();
}

class _GameCollectGarbageState extends State<GameCollectGarbageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Separação Consciente'),
      ),
      body: Center(
        child: Text('Tela do jogo aqui'),
      ),
    );
  }
}
