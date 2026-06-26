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
  super.onLoad(); // Garante a inicialização correta da Flame

  // 1. Inicializa os objetos dos três carros
  // 1. Inicializa os objetos definindo a posição de cada um
  // 1. Inicializa os objetos definindo a posição e a cor de cada um
  // 1. Inicializa os objetos definindo a posição e a cor correta do Flutter
  carroAzul = CarroJogador(cor: Colors.blue, position: Vector2(100, 500));
  carroAmarelo = CarroJogador(cor: Colors.yellow, position: Vector2(200, 500));
  carroVermelho = CarroJogador(cor: Colors.red, position: Vector2(300, 500));

  // 2. Adiciona os carros na tela para eles aparecerem
  await add(carroAzul);
  await add(carroAmarelo);
  await add(carroVermelho);

  // Aqui embaixo você pode colocar o código para adicionar seus obstáculos
  // Exemplo: await add(Obstaculo());
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
