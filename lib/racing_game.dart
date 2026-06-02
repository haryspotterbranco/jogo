import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'componentes/obstaculo.dart';
import 'carros.dart'; 

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

// Controle de dificuldade global
Dificuldade dificuldadeAtual = Dificuldade.facil;

class RacingGame extends FlameGame with HasCollisionDetection {
  final int tipoCarro;

  // Construtor correto
  RacingGame({required this.tipoCarro});

  // Declaração dos carros
  late CarroJogador carroAzul;
  late CarroJogador carroAmarelo;
  late CarroJogador carroVermelho;

  // Variáveis de estado do jogo
  bool gameOver = false; 
  double limiteEsquerda = 0;

  @override
  Future<void> onLoad() async {
    // Adicione aqui o código de inicialização do seu jogo, se houver
    // Exemplo: add(carroAzul); etc.
  }

  // Método chamado pelos botões da interface do Flutter
  void moverEsquerda() {
    // Certifique-se de que a variável ou lógica de posição dos seus carros está correta aqui
    if (tipoCarro == 0) {
      carroAzul.position.x -= 20;
    } else if (tipoCarro == 1) {
      carroAmarelo.position.x -= 20;
    } else {
      carroVermelho.position.x -= 20;
    }
  }
  
  // 🔴 ADICIONE ESTA NOVA FUNÇÃO EXATAMENTE AQUI:
  void moverDireita() {
    if (tipoCarro == 0) {
      carroAzul.position.x += 20; // Soma (+) faz o carro ir para a direita
    } else if (tipoCarro == 1) {
      carroAmarelo.position.x += 20;
    } else {
      carroVermelho.position.x += 20;
    }
  }

  void parar() {
    // Insira aqui a lógica para fazer o carro parar se o botão for solto
  }

  void reiniciar() {
    gameOver = false;
    // Insira aqui a lógica para resetar a pista e os carros
  }
}
