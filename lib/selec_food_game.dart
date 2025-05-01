import 'dart:async';
import 'dart:math';
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

  final List<String> todosOsItens = [
    'pão', 'feijao', 'macarrao', 'leite',
    'cenoura', 'maçã', 'banana', 'café'
  ];

  late List<String> itensCorretos;
  Set<String> itensNaCesta = {};

  @override
  void initState() {
    super.initState();
    selecionarItensAleatorios();
    iniciarTemporizador();
  }

  void selecionarItensAleatorios() {
    todosOsItens.shuffle();
    itensCorretos = todosOsItens.take(4).toList();
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
      itensNaCesta.clear();
      selecionarItensAleatorios();
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

  Widget _buildItem(String nome) {
    String caminho = _getImagePath(nome);

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
          // Fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/jogoComidas/fundo_jogoComida.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Itens corretos
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  'Itens corretos:',
                  style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 10,
                  children: itensCorretos
                      .map((item) => Image.asset(_getImagePath(item), width: 70, height: 70))
                      .toList(),
                ),
              ],
            ),
          ),

          // Cesta
          Align(
            alignment: Alignment.bottomCenter,
            child: DragTarget<String>(
              onAccept: (item) {
                setState(() {
                  if (itensNaCesta.contains(item)) return;
                  itensNaCesta.add(item);
                  if (itensCorretos.contains(item)) pontos++;
                });
              },
              onWillAccept: (item) => itensNaCesta.length < 4,
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
                      if (itensNaCesta.isEmpty)
                        const Text('Solte aqui!',
                            style: TextStyle(color: Colors.white, fontSize: 24)),
                      Wrap(
                        children: itensNaCesta
                            .map((item) => GestureDetector(
                          onTap: () {
                            setState(() => itensNaCesta.remove(item));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset(
                              _getImagePath(item),
                              width: 70,
                              height: 70,
                            ),
                          ),
                        ))
                            .toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Itens para arrastar (filtrando os que já estão na cesta)
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: todosOsItens
                          .where((item) => !itensNaCesta.contains(item))
                          .take(4)
                          .map((item) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: _buildItem(item),
                      ))
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: todosOsItens
                          .where((item) => !itensNaCesta.contains(item))
                          .skip(4)
                          .take(4)
                          .map((item) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: _buildItem(item),
                      ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // HUD com pontos e tempo
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
