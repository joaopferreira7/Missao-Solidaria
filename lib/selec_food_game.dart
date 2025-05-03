import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'main.dart'; // Certifique-se de importar sua tela de seleção

class GameSelectFoodScreen extends StatefulWidget {
  final int tempoInicial;
  final int quantidadeItens;
  const GameSelectFoodScreen({Key? key, required this.tempoInicial, required this.quantidadeItens}) : super(key: key);

  @override
  _GameSelectFoodScreenState createState() => _GameSelectFoodScreenState();
}

class _GameSelectFoodScreenState extends State<GameSelectFoodScreen> {
  int pontos = 0;
  int tempoRestante = 30;
  Timer? _timer;
  bool _telaFinalMostrada = false;

  final List<String> todosOsItens = [
    'pão', 'feijao', 'macarrao', 'leite',
    'cenoura', 'maçã', 'banana', 'café'
  ];

  late List<String> itensCorretos;
  late List<String> itensVisiveis;
  late int quantidadeParaSelecionar;
  Set<String> itensNaCesta = {};

  @override
  void initState() {
    super.initState();
    tempoRestante = widget.tempoInicial;
    quantidadeParaSelecionar = widget.quantidadeItens;
    selecionarItensAleatorios();
    embaralharItensVisiveis();
    iniciarTemporizador();
  }

  void selecionarItensAleatorios() {
    todosOsItens.shuffle();
    itensCorretos = todosOsItens.take(quantidadeParaSelecionar).toList();
  }

  void embaralharItensVisiveis() {
    itensVisiveis = List.from(todosOsItens)..shuffle();
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

  void _pauseGame() {
    _timer?.cancel();
  }

  void _resumeGame() {
    iniciarTemporizador();
  }

  void mostrarTelaFinal({String mensagem = "Tempo esgotado!"}) {
    if (_telaFinalMostrada) return;
    _telaFinalMostrada = true;
    _pauseGame();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(mensagem),
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
      _telaFinalMostrada = false;
      itensNaCesta.clear();
      selecionarItensAleatorios();
      embaralharItensVisiveis();
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
                image: AssetImage('assets/images/jogoComidas/Jogo 1 - Referência final (11).png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Itens corretos
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Wrap(
                  spacing: 10,
                  children: itensCorretos
                      .map((item) => Image.asset(_getImagePath(item), width: 90, height: 90))
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

                  if (itensCorretos.contains(item)) {
                    pontos++;
                  }

                  if (itensNaCesta.length == quantidadeParaSelecionar) {
                    final bool todosCorretos =
                    itensNaCesta.every((item) => itensCorretos.contains(item));

                    if (todosCorretos) {
                      mostrarTelaFinal(mensagem: "Parabéns! Você acertou todos os itens!");
                    }
                  }
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
                        const Text(
                          'Solte aqui!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
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

          // Itens visíveis
          Positioned(
            bottom: 145,
            left: 0,
            right: 0,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: itensVisiveis
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
                      children: itensVisiveis
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

          // HUD
          Positioned(
            top: -20,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Tempo: $tempoRestante',
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Botão de sair
          Positioned(
            top: 35,
            right: -10,
            child: ElevatedButton(
              onPressed: () {
                _pauseGame();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Sair do Jogo'),
                      content: const Text('Você deseja voltar ao menu anterior?'),
                      actions: [
                        TextButton(
                          child: const Text('Não'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _resumeGame();
                          },
                        ),
                        TextButton(
                          child: const Text('Sim'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => TelaEscolherJogo()),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE4C7A3),
                shape: const CircleBorder(
                  side: BorderSide(color: Color(0xFF4F2E0D), width: 3),
                ),
              ),
              child: const Icon(Icons.close, color: Color(0xFF333333), size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
