import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'falling_game.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TelaInicial(), debugShowCheckedModeBanner: false);
  }
}

// Tela Inicial
class TelaInicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/TelaInicial.png', fit: BoxFit.cover),
          Column(
            children: [
              SizedBox(height: 100),
              Center(
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
              Spacer(),
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
                        MaterialPageRoute(
                          builder: (context) => TelaComoJogar(),
                        ),
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
              SizedBox(height: 50),
            ],
          ),
          Positioned(
            top: 50,
            right: 15,
            child: SizedBox(
              width: 45,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
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
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("Sim"),
                            onPressed: () {
                              SystemNavigator.pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF5782F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(color: Color(0xFFF773A26), width: 4),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Center(
                  child: Text(
                    'X',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget botaoCustomizado(String texto, VoidCallback onPressed) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFF5782F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Color(0xFFF773A26), width: 5),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          texto,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Widget para os botões superiores reutilizáveis
class TopBarBotoes extends StatelessWidget {
  final VoidCallback onVoltar;
  final VoidCallback onProximo;

  TopBarBotoes({required this.onVoltar, required this.onProximo});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 70.0, left: 5.0, right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                botaoJogarCustomizado('Voltar', onVoltar),
                SizedBox(width: 10),
                botaoJogarCustomizado('Próximo', onProximo),
              ],
            ),
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
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("Sim"),
                        onPressed: () {
                          SystemNavigator.pop();
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
    );
  }

  Widget botaoJogarCustomizado(String texto, VoidCallback onPressed) {
    bool isBotaoX = texto == 'X';

    return SizedBox(
      width: isBotaoX ? 45 : 100,
      height: isBotaoX ? 45 : 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFE4C7A3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isBotaoX ? 100 : 5),
            side: BorderSide(color: Color(0xFF4F2E0D), width: 4),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: Text(
            texto,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isBotaoX ? 22 : 20,
              color: Color(0xFF333333),
            ),
          ),
        ),
      ),
    );
  }
}

// Telas da história
class TelaJogar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/HistoriaTela_1.png', fit: BoxFit.cover),
          TopBarBotoes(
            onVoltar: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaInicial()),
              );
            },
            onProximo: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaHistoria_2()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Tela 2 História
class TelaHistoria_2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/HistoriaTela_2.png', fit: BoxFit.cover),
          TopBarBotoes(
            onVoltar: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaJogar()),
              );
            },
            onProximo: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaHistoria_3()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Tela 3 História
class TelaHistoria_3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/HistoriaTela_3.png', fit: BoxFit.cover),
          TopBarBotoes(
            onVoltar: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaHistoria_2()),
              );
            },
            onProximo: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaHistoria_4()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Tela 4 História
class TelaHistoria_4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/HistoriaTela_4.png', fit: BoxFit.cover),
          TopBarBotoes(
            onVoltar: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaHistoria_3()),
              );
            },
            onProximo: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaHistoria_5()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Tela 5 História
class TelaHistoria_5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/HistoriaTela_5.png', fit: BoxFit.cover),
          TopBarBotoes(
            onVoltar: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaHistoria_4()),
              );
            },
            onProximo: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaHistoria_6()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Tela 6 História
class TelaHistoria_6 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/HistoriaTela_6.png', fit: BoxFit.cover),
          TopBarBotoes(
            onVoltar: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaHistoria_5()),
              );
            },
            onProximo: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaHistoria_7()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Tela 7 História
class TelaHistoria_7 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/HistoriaTela_7.png', fit: BoxFit.cover),
          TopBarBotoes(
            onVoltar: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaHistoria_6()),
              );
            },
            onProximo: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaEscolherJogo()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class TelaEscolherJogo extends StatefulWidget {
  @override
  _TelaEscolherJogoState createState() => _TelaEscolherJogoState();
}

class _TelaEscolherJogoState extends State<TelaEscolherJogo> {
  int? jogoSelecionado;

  void selecionarJogo(int numeroDoJogo) {
    setState(() {
      jogoSelecionado = numeroDoJogo;
    });
  }

  void confirmarSelecao() {
    if (jogoSelecionado == null) {
      ScaffoldMessenger.of(context);
      return;
    }

    Widget tela;

    switch (jogoSelecionado) {
      case 1:
        tela = TelaJogo1();
        break;
      case 2:
        tela = TelaJogo2();
        break;
      case 3:
        tela = TelaJogo3();
        break;
      case 4:
        tela = TelaJogo4();
        break;
      default:
        return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => tela));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/TelaEscolherJogo.png', fit: BoxFit.cover),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 55.0, left: 10.0),
              child: SizedBox(
                width: 110,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE4C7A3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: Color(0xFF4F2E0D), width: 4),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Voltar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 55, right: 10),
              child: SizedBox(
                width: 45,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Sair do Jogo'),
                          content: Text('Você deseja sair do jogo?'),
                          actions: [
                            TextButton(
                              child: Text('Não'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Sim'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                SystemNavigator.pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE4C7A3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: Color(0xFF4F2E0D), width: 4),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'X',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 170),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildBotaoJogar('assets/images/Jogo1.png', 1),
                      SizedBox(width: 50),
                      _buildBotaoJogar('assets/images/Jogo2.png', 2),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildBotaoJogar('assets/images/Jogo3.png', 3),
                      SizedBox(width: 50),
                      _buildBotaoJogar('assets/images/Jogo4.png', 4),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: SizedBox(
                width: 160,
                height: 60,
                child: ElevatedButton(
                  onPressed: confirmarSelecao,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE4C7A3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Color(0xFF4F2E0D), width: 4),
                    ),
                  ),
                  child: Text(
                    'Confirmar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotaoJogar(String imagePath, int numeroDoJogo) {
    return SizedBox(
      width: 100,
      height: 110,
      child: ElevatedButton(
        onPressed: () => selecionarJogo(numeroDoJogo),
        style: ElevatedButton.styleFrom(
          backgroundColor: jogoSelecionado == numeroDoJogo
              ? Colors.green[300]
              : Color(0xFFE4C7A3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Color(0xFF4F2E0D), width: 4),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}


// Telas de exemplo (substitua com os jogos reais)
class TelaJogo1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Jogo 1')),
      body: Center(child: Text('Tela do Jogo 1')),
    );
  }
}

class TelaJogo2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/jogoRoupas/fundo_jogoRoupas.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Botão Fechar no topo direito
          Positioned(
            top: 40,
            right: -5,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE4C7A3),
                shape: const CircleBorder(
                  side: BorderSide(color: Color(0xFF4F2E0D), width: 3),
                ),
              ),
              child: const Icon(Icons.close, color: Color(0xFF333333), size: 22),
            ),
          ),

          // Botão iniciar no centro inferior
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GameFallingScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE4C7A3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(color: Color(0xFF4F2E0D), width: 4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text(
                  'Iniciar Mini Game',
                  style: TextStyle(
                    color: Color(0xFF333333), // Aqui você escolhe a cor desejada
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TelaJogo3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Jogo 3')),
      body: Center(child: Text('Tela do Jogo 3')),
    );
  }
}

class TelaJogo4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Jogo 4')),
      body: Center(child: Text('Tela do Jogo 4')),
    );
  }
}

// Outras Telas
class TelaComoJogar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tela Como Jogar')),
      body: Center(child: Text('Você está na tela COMO JOGAR!')),
    );
  }
}

class TelaConfig extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tela de Configurações')),
      body: Center(child: Text('Você está na tela de CONFIGURAÇÕES!')),
    );
  }
}

class TelaCreditos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tela de Créditos')),
      body: Center(child: Text('Você está na tela de CRÉDITOS!')),
    );
  }
}


