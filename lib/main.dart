import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TelaInicial(),
    );
  }
}

class TelaInicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/TelaInicial.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // centraliza verticalmente
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SegundaTela()),
                    );
                  },
                  child: Text('Jogar'),
                ),
                SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () {
                    // ação do segundo botão
                  },
                  child: Text('Como Jogar'),
                ),
                SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () {
                    // ação do terceiro botão
                  },
                  child: Text('Configurações'),
                ),
                SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () {
                    // ação do quarto botão
                  },
                  child: Text('Créditos'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// Essa é uma estrutura básica para a SegundaTela
class SegundaTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Segunda Tela'),
      ),
      body: Center(
        child: Text('Você está na segunda tela!'),
      ),
    );
  }
}
