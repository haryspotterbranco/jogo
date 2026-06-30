import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'racing_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retro Racer Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
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
  int _carroSelecionado = 0;

  final List<Map<String, dynamic>> _listaCarrosExemplo = const [
    {'nome': 'Spectre', 'icone': '🚗', 'cor': Colors.blue, 'status': 'Equilibrado'},
    {'nome': 'Bumblebee', 'icone': '🚙', 'cor': Colors.yellow, 'status': 'Agilidade +'},
    {'nome': 'Diablo', 'icone': '🏎️', 'cor': Colors.red, 'status': 'Velocidade +'},
  ];

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
  '⚡ RETRO RACER PRO ⚡',
  style: TextStyle(
    fontSize: 38, 
    fontWeight: FontWeight.w900, // Correção aqui de .black para .w900
    color: Colors.white,
    letterSpacing: 2,
  ),
),

              const SizedBox(height: 10),
              const Text(
                'Selecione sua Máquina',
                style: TextStyle(fontSize: 18, color: Colors.cyanAccent),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_listaCarrosExemplo.length, (index) {
                  final carro = _listaCarrosExemplo[index];
                  final isSelected = _carroSelecionado == index;

                  return GestureDetector(
                    onTap: () => setState(() => _carroSelecionado = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 110,
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.cyan.withOpacity(0.3) : Colors.black45,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? Colors.cyanAccent : Colors.grey.shade800, 
                          width: 2,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(color: Colors.cyan.withOpacity(0.5), blurRadius: 10)
                        ] : [],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(carro['icone'] as String, style: const TextStyle(fontSize: 44)),
                          const SizedBox(height: 8),
                          Text(carro['nome'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(
                            carro['status'] as String, 
                            style: TextStyle(fontSize: 10, color: isSelected ? Colors.white : Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Container(width: 40, height: 6, color: carro['cor'] as Color),
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
                      builder: (context) => TelaJogo(tipoCarro: _carroSelecionado),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  'PILOTAR',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  }


// ========== TELA DO JOGO ==========
class TelaJogo extends StatefulWidget {
  final int tipoCarro;
  const TelaJogo({super.key, required this.tipoCarro});

  @override
  State<TelaJogo> createState() => _TelaJogoState();
}

class _TelaJogoState extends State<TelaJogo> {
  late final RacingGame _game;

  @override
  void initState() {
    super.initState();
    _game = RacingGame(tipoCarro: widget.tipoCarro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Painel Superior de HUD Nativo do Flutter
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.grey.shade900,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: _game.scoreNotifier,
                    builder: (context, score, _) {
                      return Text('SCORE: $score', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.yellow));
                    },
                  ),
                  ValueListenableBuilder<double>(
                    valueListenable: _game.fuelNotifier,
                    builder: (context, fuel, _) {
                      return Row(
                        children: [
                          const Icon(Icons.local_gas_station, color: Colors.orangeAccent, size: 18),
                          const SizedBox(width: 4),
                          SizedBox(
                            width: 80,
                            child: LinearProgressIndicator(
                              value: fuel,
                              backgroundColor: Colors.grey.shade800,
                              color: fuel < 0.25 ? Colors.red : Colors.orangeAccent,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: GameWidget(
                game: _game,
                overlayBuilderMap: {
                  'GameOver': (context, RacingGame game) => Center(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.redAccent, width: 2),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('💥 GAME OVER 💥', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.red)),
                          const SizedBox(height: 16),
                          Text('Sua Pontuação: ${game.scoreNotifier.value}', style: const TextStyle(fontSize: 20)),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => game.reiniciar(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('TENTAR NOVAMENTE'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                },
              ),
            ),
            // Controles de Toque Otimizados
            Container(
              height: 110,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              color: Colors.black87,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTapDown: (_) => _game.moverEsquerda(),
                      onTapUp: (_) => _game.parar(),
                      onTapCancel: () => _game.parar(),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade800,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Icon(Icons.arrow_back_ios_new, size: 36, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTapDown: (_) => _game.moverDireita(),
                      onTapUp: (_) => _game.parar(),
                      onTapCancel: () => _game.parar(),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.red.shade800,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Icon(Icons.arrow_forward_ios, size: 36, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
