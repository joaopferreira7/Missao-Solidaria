import 'dart:async';
import 'package:flutter/material.dart';

class GameSelectFoodScreen extends StatefulWidget {
  const GameSelectFoodScreen({Key? key}) : super(key: key);

  @override
  _GameSelectFoodScreenState createState() => _GameSelectFoodScreenState();
}

class _GameSelectFoodScreenState extends State<GameSelectFoodScreen> {
  int pontos = 0;
  int tempoRestante = 30;
  Timer? _timer;

  List<String> itensCorretos = ['pão', 'feijao', 'macarrao', 'leite'];
  Set<String> itensArrastados = {};
  List<Widget> itensNaCesta = [];

  @override
  void initState() {
    super.initState();
    iniciarTemporizador();
  }

  void iniciarTemporizador() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        tempoRestante--;
      });

      if (tempoRestante == 0) {
        _timer?.cancel();
        mostrarTelaFinal();
      }
    });
  }

  void mostrarTelaFinal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Tempo esgotado!"),
        content: Text("Sua pontuação: $pontos"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              reiniciarJogo();
            },
            child: const Text("Jogar novamente"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text("Sair"),
          ),
        ],
      ),
    );
  }

  void reiniciarJogo() {
    setState(() {
      pontos = 0;
      tempoRestante = 30;
      itensArrastados.clear();
      itensNaCesta.clear();
      iniciarTemporizador();
    });
  }

  String _getImagePath(String nome) {
    switch (nome) {
      case 'pão':
        return 'assets/images/jogoComidas/alimentos/Pão.png';
      case 'feijao':
        return 'assets/images/jogoComidas/alimentos/Feijão_enlatado.png';
      case 'macarrao':
        return 'assets/images/jogoComidas/alimentos/Macarrão.png';
      case 'leite':
        return 'assets/images/jogoComidas/alimentos/Leite.png';
      default:
        return '';
    }
  }

  Widget _buildItem(String nome, String caminho) {
    if (itensArrastados.contains(nome)) {
      return const SizedBox(); // Não mostra mais na posição original
    }

    return Draggable<String>(
      data: nome,
      feedback: Image.asset(caminho, width: 60, height: 60),
      childWhenDragging:
      Opacity(opacity: 0.5, child: Image.asset(caminho, width: 60, height: 60)),
      child: Image.asset(caminho, width: 90, height: 90),
    );
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
          // Fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/jogoComidas/fundo_jogoComida.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Cesta
          Align(
            alignment: Alignment.bottomCenter,
            child: DragTarget<String>(
              onAccept: (item) {
                if (itensCorretos.contains(item)) {
                  setState(() {
                    pontos++;
                    itensArrastados.add(item);
                    itensNaCesta.add(
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          _getImagePath(item),
                          width: 60,
                          height: 60,
                        ),
                      ),
                    );
                  });
                }
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.brown.withOpacity(0.7),
                    border: Border.all(color: Colors.white, width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Solte aqui!',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: itensNaCesta,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Itens para arrastar
          Positioned(left: 20, bottom: 220, child: _buildItem('pão', _getImagePath('pão'))),
          Positioned(left: 110, bottom: 220, child: _buildItem('feijao', _getImagePath('feijao'))),
          Positioned(left: 200, bottom: 220, child: _buildItem('macarrao', _getImagePath('macarrao'))),
          Positioned(left: 290, bottom: 220, child: _buildItem('leite', _getImagePath('leite'))),

          // HUD
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pontos: $pontos',
                    style: const TextStyle(
                        fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Tempo: $tempoRestante',
                    style: const TextStyle(
                        fontSize: 24, color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
