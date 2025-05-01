import 'package:flutter/material.dart';

class GameSelectFoodScreen extends StatefulWidget {
  const GameSelectFoodScreen({Key? key}) : super(key: key);

  @override
  _GameSelectFoodScreenState createState() => _GameSelectFoodScreenState();
}

class _GameSelectFoodScreenState extends State<GameSelectFoodScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/jogoComidas/fundo_jogoComida.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}