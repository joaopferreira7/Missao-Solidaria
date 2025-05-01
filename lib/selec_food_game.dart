import 'dart:async';
import 'package:flutter/material.dart';

class GameSelectFoodScreen extends StatefulWidget {
  const GameSelectFoodScreen({Key? key}) : super(key: key);

  @override
  _GameSelectFoodScreenState createState() => _GameSelectFoodScreenState();
}

class _GameSelectFoodScreenState extends State<GameSelectFoodScreen> {
  int pontos = 0;
  int tempoRestante = 900;
  Timer? _timer;

  List<String> itensCorretos = ['pão', 'feijao', 'macarrao', 'leite'];
  Set<String> itensArrastados = {};
  List<String> itensNaCesta = [];

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
      tempoRestante = 900;
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
      case 'cenoura':
        return 'assets/images/jogoComidas/alimentos/Cenoura.png';
      case 'maçã':
        return 'assets/images/jogoComidas/alimentos/Maçã.png';
      case 'banana':
        return 'assets/images/jogoComidas/alimentos/Banana.png';
      case 'café':
        return 'assets/images/jogoComidas/alimentos/Café.png';
      default:
        return '';
    }
  }

  Widget _buildItem(String nome, String caminho) {
    if (itensArrastados.contains(nome)) {
      return const SizedBox();
    }

    return Draggable<String>(
      data: nome,
      feedback: Image.asset(caminho, width: 90, height: 90),
      childWhenDragging:
      Opacity(opacity: 0.5, child: Image.asset(caminho, width: 90, height: 90)),
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
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/jogoComidas/fundo_jogoComida.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: DragTarget<String>(
              onAccept: (item) {
                setState(() {
                  if (!itensNaCesta.contains(item)) {
                    itensNaCesta.add(item);
                    itensArrastados.add(item);
                    if (itensCorretos.contains(item)) {
                      pontos++;
                    }
                  }
                });
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 25),
                  width: 360,
                  height: 130,
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
                        children: itensNaCesta.map((item) {
                          return GestureDetector(
                            onDoubleTap: () {
                              setState(() {
                                itensNaCesta.remove(item);
                                itensArrastados.remove(item);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(
                                _getImagePath(item),
                                width: 80,
                                height: 80,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Positioned(
            bottom: 150,
            left: 25,
            right: 0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      _buildItem('pão', _getImagePath('pão')),
                      const SizedBox(height: 12),
                      _buildItem('feijao', _getImagePath('feijao')),
                      const SizedBox(height: 12),
                      _buildItem('macarrao', _getImagePath('macarrao')),
                      const SizedBox(height: 12),
                      _buildItem('leite', _getImagePath('leite')),
                    ],
                  ),
                  const SizedBox(width: 40),
                  Row(
                    children: [
                      _buildItem('cenoura', _getImagePath('cenoura')),
                      const SizedBox(height: 12),
                      _buildItem('maçã', _getImagePath('maçã')),
                      const SizedBox(height: 12),
                      _buildItem('banana', _getImagePath('banana')),
                      const SizedBox(height: 12),
                      _buildItem('café', _getImagePath('café')),
                    ],
                  )
                ],
              ),
            ),
          ),

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
