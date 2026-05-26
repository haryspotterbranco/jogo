import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'dart:math';
import 'package:flutter/material.dart';
// IMPORTS CORRIGIDOS (Ajustado para ler diretamente os seus arquivos)
import 'componentes/obstaculo.dart';
import 'carros.dart'; // CORRIGIDO: Removido o 'componentes/' se ele estiver na raiz

enum Dificuldade {
  facil(velocidadeObstaculo: 200.0, tempoSpawn: 1.5),
  medio(velocidadeObstaculo: 300.0, tempoSpawn: 1.0),
  dificil(velocidadeObstaculo: 700.0, tempoSpawn: 0.1);

  final double velocidadeObstaculo;
  final double tempoSpawn;

  const Dificuldade({
    required this.velocidadeObstaculo,
    required this.tempoSpawn,
  });
}

// RECUPERADO: Trazendo de volta a variável global que controla a dificuldade
Dificuldade dificuldadeAtual = Dificuldade.facil;

class RacingGame extends FlameGame with HasCollisionDetection {
  late CarroJogador carroAzul;
  late CarroJogador carroAmarelo;
  late CarroJogador carroVermelho;
}
  // RECOLOCADO: Variáveis da pista e jogo que o método gerarObstaculos precisa
  bool gameOver = false;
  double limiteEsquerda = 0;   // Se você já tiver um valor inicial para eles, pode colocar aqui (ex: 50)
  double limiteDireita = 400;  // Se você tiver um valor inicial, coloque aqui (ex: 400)
  final random = Random();

// A PARTIR DAQUI, O ITEM ARMA FICA TOTALMENTE FORA DA CLASSE ACIMA
class ItemArma extends RectangleComponent {
  ItemArma({required Vector2 posicao})
      : super(
          position: posicao,
          size: Vector2(30, 30),
          anchor: Anchor.center,
        ) {
    paint = Paint()..color = Colors.blue;
  }

  @override
  void onLoad() {
    super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += 200 * dt; 
    if (position.y > 1000) {
      removeFromParent();
    }
  }
}
