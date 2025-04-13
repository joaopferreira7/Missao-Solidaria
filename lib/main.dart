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
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF5782F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Color(0xFFF773A26),
                            width: 5
                          ),
                        ),
                    ),
                      onPressed:(){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SegundaTela()),
                        );
                      },
                      child: Text('Jogar'),
                  ),
                ),
                SizedBox(height: 14),
                SizedBox(
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
                      onPressed: (){
                        //ação do botão Como jogar
                      },
                    child: Text('Como Jogar'),
                  ),
                ),
                SizedBox(height: 14),
                SizedBox(
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
                        )
                      ),
                    ),
                      onPressed:() {
                        //ação do botão Configurações
                      },
                      child: Text("Configurações"),
                  ),
                ),
                SizedBox(height: 14),
                SizedBox(
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
                      onPressed: (){
                        //ação do botão Créditos
                      },
                      child: Text('Créditos'),
                  ),
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
