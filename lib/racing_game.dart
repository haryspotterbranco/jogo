

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'componentes/obstaculo.dart';
import 'componentes/item_arma.dart';
import 'componentes/item_combustivel.dart';
import 'carros.dart'; 

enum Dificuldade {
  facil(velocidadeObstaculo: 250.0, tempoSpawn: 1.4),
  medio(velocidadeObstaculo: 420.0, tempoSpawn: 0.8),
  dificil(velocidadeObstaculo: 700.0, tempoSpawn: 0.4);

  final double velocidadeObstaculo;
  final double tempoSpawn;
  const Dificuldade({required this.velocidadeObstaculo, required this.tempoSpawn});
}

class RacingGame extends FlameGame with HasCollisionDetection {
  final int tipoCarro;
  late CarroJogador _jogador;
  
  double _direcaoMovimento = 0.0;
  final double _velocidadeJogador = 380.0;

  bool gameOver = false;
  Dificuldade dificuldadeAtual = Dificuldade.facil;
  double _tempoProximoSpawn = 0.0;
  final Random _random = Random();

  double _limiteEsquerda = 0.0;
  double _limiteDireita = 0.0;

  // Notifiers Reativos para a UI do Flutter
  final ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);
  final ValueNotifier<double> fuelNotifier = ValueNotifier<double>(1.0);
  double _acumuladorScore = 0.0;

  RacingGame({required this.tipoCarro});

  @override
  Color backgroundColor() => const Color(0xFF232526);

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    _configurarLimitesPista();
    _inicializarJogadorAtivo();
  }

  void _configurarLimitesPista() {
    _limiteEsquerda = 24.0;
    _limiteDireita = size.x - 74.0;
  }

  void _inicializarJogadorAtivo() {
    final posicaoInicial = Vector2(size.x / 2 - 25, size.y - 130);
    final cor = tipoCarro == 0 ? Colors.blue : (tipoCarro == 1 ? Colors.yellow : Colors.red);
    _jogador = CarroJogador(cor: cor, position: posicaoInicial);
    add(_jogador);
  }

  @override
  void update(double dt) {
    if (gameOver) return;
    super.update(dt);

    _atualizarMovimentoJogador(dt);
    _gerenciarGeracaoDeObstaculos(dt);
    _processarCicloDeSustentabilidade(dt);
  }

  void _atualizarMovimentoJogador(double dt) {
    if (_direcaoMovimento == 0.0) return;
    _jogador.position.x += _direcaoMovimento * _velocidadeJogador * dt;
    _jogador.position.x = _jogador.position.x.clamp(_limiteEsquerda, _limiteDireita);
  }

  void _processarCicloDeSustentabilidade(double dt) {
    // Consumo constante de combustível
    fuelNotifier.value = (fuelNotifier.value - (0.04 * dt)).clamp(0.0, 1.0);
    if (fuelNotifier.value <= 0.0) {
      dispararGameOver();
    }

    // Ganho passivo de pontuação por sobrevivência
    _acumuladorScore += dt * 10;
    scoreNotifier.value = _acumuladorScore.toInt();

    // Evolução reativa de dificuldade baseado no Score
    if (scoreNotifier.value > 500 && dificuldadeAtual == Dificuldade.facil) {
      dificuldadeAtual = Dificuldade.medio;
    } else if (scoreNotifier.value > 1500 && dificuldadeAtual == Dificuldade.medio) {
      dificuldadeAtual = Dificuldade.dificil;
    }
  }

  void _gerenciarGeracaoDeObstaculos(double dt) {
    _tempoProximoSpawn += dt;
    if (_tempoProximoSpawn >= dificuldadeAtual.tempoSpawn) {
      _tempoProximoSpawn = 0.0;
      _gerarConteudoProcedural();
    }
  }

  void _gerarConteudoProcedural() {
    final x = _limiteEsquerda + _random.nextDouble() * (_limiteDireita - _limiteEsquerda);
    final gatilho = _random.nextDouble();

    if (gatilho < 0.12) {
      add(ItemArma(posicao: Vector2(x, -40)));
    } else if (gatilho < 0.26) {
      add(ItemCombustivel(posicao: Vector2(x, -40)));
    } else {
      add(Obstaculo(position: Vector2(x, -80), velocidade: dificuldadeAtual.velocidadeObstaculo));
    }
  }

  void moverEsquerda() => _direcaoMovimento = -1.0;
  void moverDireita() => _direcaoMovimento = 1.0;
  void parar() => _direcaoMovimento = 0.0;

  void abastecer() {
    fuelNotifier.value = (fuelNotifier.value + 0.35).clamp(0.0, 1.0);
  }

  void dispararGameOver() {
    if (gameOver) return;
    gameOver = true;
    pauseEngine();
    overlays.add('GameOver');
  }

  void reiniciar() {
    children.whereType<Obstaculo>().forEach((o) => o.removeFromParent());
    children.whereType<ItemArma>().forEach((i) => i.removeFromParent());
    children.whereType<ItemCombustivel>().forEach((c) => c.removeFromParent());

    gameOver = false;
    _tempoProximoSpawn = 0.0;
    _acumuladorScore = 0.0;
    scoreNotifier.value = 0;
    fuelNotifier.value = 1.0;
    dificuldadeAtual = Dificuldade.facil;
    
    _jogador.position = Vector2(size.x / 2 - 25, size.y - 130);
    _jogador.temArma = false;
    _direcaoMovimento = 0.0;

    overlays.remove('GameOver');
    resumeEngine();
  }
}