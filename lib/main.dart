import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                        MaterialPageRoute(builder: (context) => TelaJogar()),
                      );
                    }),
                    SizedBox(height: 14),
                    botaoCustomizado('Como Jogar', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TelaComoJogar()),
                      );
                    }),
                    SizedBox(height: 14),
                    botaoCustomizado('Configurações', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TelaConfig()),
                      );
                    }),
                    SizedBox(height: 14),
                    botaoCustomizado('Créditos', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TelaCreditos()),
                      );
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

class TelaJogar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/HistoriaTela_1.png',
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 70.0, left: 5.0, right: 10.0), // margem da tela
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botões no canto esquerdo
                  Row(
                    children: [
                      botaoJogarCustomizado('Voltar', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TelaInicial()),
                        );
                      }),
                      SizedBox(width: 10),
                      botaoJogarCustomizado('Próximo', () {

                      }),
                    ],
                  ),

                  // Botão no canto direito
                  botaoJogarCustomizado('X', () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Sair do Jogo"),
                          content: Text("Você deseja sair do jogo?"),
                          actions: [
                            TextButton(
                              child: Text("Não"),
                              onPressed: () {
                                Navigator.of(context).pop(); // Fecha o diálogo
                              },
                            ),
                            TextButton(
                              child: Text("Sim"),
                              onPressed: () {
                                SystemNavigator.pop(); // Fecha o app
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Botão com estilo personalizado
  Widget botaoJogarCustomizado(String texto, VoidCallback onPressed) {
    return SizedBox(
      width: 100,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFE4C7A3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: Color(0xFF4F2E0D), width: 4),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: Text(
            texto,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF333333),
            ),
          ),
        ),
      ),
    );
  }
}




class TelaComoJogar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Como Jogar'),
      ),
      body: Center(
        child: Text('Você está na tela COMO JOGAR!'),
      ),
    );
  }
}

class TelaConfig extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela de Configurações'),
      ),
      body: Center(
        child: Text('Você está na tela de CONFIGURAÇÕES!'),
      ),
    );
  }
}

class TelaCreditos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela de Créditos'),
      ),
      body: Center(
        child: Text('Você está na tela de CRÉDITOS!'),
      ),
    );
  }
}
