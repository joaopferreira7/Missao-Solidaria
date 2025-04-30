import 'package:flutter/material.dart';

class SelectingFoodGame extends StatefulWidget {
  const SelectingFoodGame({Key? key}) : super(key: key);

  @override
  State<SelectingFoodGame> createState() => _SelectingFoodGameState();
}

class _SelectingFoodGameState extends State<SelectingFoodGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecionar Alimentos')),
      body: const Center(child: Text('Conteúdo do mini game de comida')),
    );
  }
}
