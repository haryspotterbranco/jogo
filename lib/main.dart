import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'racing_game.dart';
import 'carros.dart';
import 'componentes/obstaculo.dart'; 


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo de Corrida',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const TelaInicio(),
    );
  }
}

// ========== TELA DE INÍCIO ==========
class TelaInicio extends StatefulWidget {
  const TelaInicio({super.key});

  @override
  State<TelaInicio> createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  int carroSelecionado = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.black],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🏎️ JOGO DE CORRIDA 🏎️',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text(
                'Escolha seu Carro',
                style: TextStyle(fontSize: 24, color: Colors.yellow),
              ),
             const SizedBox(height: 30),
            Row(
         mainAxisAlignment: MainAxisAlignment.center,
       children: List.generate(ListaCarros.carros.length, (index) {
     final carro = ListaCarros.carros[index];
    return GestureDetector(
      onTap: () {
        setState(() {
          carroSelecionado = index;
        });
      },// ... resto do seu design de cartões de carros
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: carroSelecionado == index ? Colors.green : Colors.black54,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Column(
                        children: [
                          Text(carro['icone'], style: const TextStyle(fontSize: 40)),
                          const SizedBox(height: 10),
                          Text(carro['nome'], style: const TextStyle(color: Colors.white)),
                          Container(
                            width: 30,
                            height: 15,
                            color: carro['cor'],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaJogo(
                        tipoCarro: carroSelecionado,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('INICIAR JOGO', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========== TElA DO JOGO ==========
class TelaJogo extends StatefulWidget {
  final int tipoCarro;
  const TelaJogo({super.key, required this.tipoCarro});

  @override
  State<TelaJogo> createState() => _TelaJogoState();
}

class _TelaJogoState extends State<TelaJogo> {
  late RacingGame game;

  @override
  void initState() {
    super.initState();
    game = RacingGame(tipoCarro: widget.tipoCarro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GameWidget(game: game),
          ),
          Container(
            height: 100,
            color: Colors.grey[900],
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTapDown: (_) => game.moverEsquerda(),
                    onTapUp: (_) => game.parar(),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text('←', style: TextStyle(color: Colors.white, fontSize: 40)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTapDown: (_) => game.moverDireita(),
                    onTapUp: (_) => game.parar(),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text('→', style: TextStyle(color: Colors.white, fontSize: 40)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      game.reiniciar();
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('REINICIAR'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text('VOLTAR'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}//mais alguma coisa