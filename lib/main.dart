import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TelaInicial(),
      debugShowCheckedModeBanner: false,
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
          Column(
            children: [
              SizedBox(height: 100), // Espaço do topo
              Center(  // Centralizando o título
                child: Text(
                  'Missão Solidária',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 8.0,
                        color: Colors.black87,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(), // Empurra os botões para baixo
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    botaoCustomizado('Jogar', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SegundaTela()),
                      );
                    }),
                    SizedBox(height: 14),
                    botaoCustomizado('Como Jogar', () {
                      // ação do botão Como jogar
                    }),
                    SizedBox(height: 14),
                    botaoCustomizado('Configurações', () {
                      // ação do botão Configurações
                    }),
                    SizedBox(height: 14),
                    botaoCustomizado('Créditos', () {
                      // ação do botão Créditos
                    }),
                  ],
                ),
              ),
              SizedBox(height: 50), // Espaço da base
            ],
          ),
        ],
      ),
    );
  }

  // Função para criar os botões personalizados
  Widget botaoCustomizado(String texto, VoidCallback onPressed) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFF5782F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: Color(0xFFF773A26),
              width: 5,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          texto,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,  // Aumenta o tamanho do texto do botão
            fontWeight: FontWeight.bold,  // Deixa o texto mais forte
          ),
        ),
      ),
    );
  }
}

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
