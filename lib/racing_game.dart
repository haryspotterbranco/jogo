import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'dart:math';
import 'carros.dart';

enum Dificuldade{
  facil(velocidadeObstaculo: 150.0, tempoSpawn: 2.0),
  medio(velocidadeObstaculo: 250.0, tempoSpawn: 1.5),
  dificil(velocidadeObstaculo: 400.0, tempoSpawn: 0.8);

  final double velocidadeObstaculo;
  final double tempoSpawn;

  const Dificuldade({
    required this.velocidadeObstaculo,
    required this.tempoSpawn,
  });
}
Dificuldade dificuldadeAtual = Dificuldade.facil;

class RacingGame extends FlameGame {
  late PositionComponent carro; 
  List<RectangleComponent> obstaculos = [];
  bool gameOver = false;
  double limiteEsquerda = 0;
  double limiteDireita = 0;
  int pontos = 0;
  late TextComponent textoPontos;
  bool movendoEsquerda = false;
  bool movendoDireita = false;
  final int tipoCarro;
  final Random random = Random();

  RacingGame({required this.tipoCarro});

  @override
  Future<void> onLoad() async {
    limiteEsquerda = size.x * 0.2;
    limiteDireita = size.x * 0.8;
    
    switch(tipoCarro) {
      case 0:
        carro  = CarroAzul(position: Vector2(size.x / 2 - 25, size.y - 100));
        break;
      case 1:
        carro = CarroVermelho(position: Vector2(size.x / 2 - 22.5, size.y - 100));
        break;
      case 2:
        carro = CarroAmarelo(position: Vector2(size.x / 2 - 25, size.y - 100));
        break;
      default:
    }
    add(carro);
    
    textoPontos = TextComponent(
      text: 'Pontos: 0',
      position: Vector2(10, 10),
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
    add(textoPontos);
    
    gerarObstaculos();
  }
  
  void gerarObstaculos() {
    final millisegundos = (dificuldadeAtual.tempoSpawn * 1000).toInt();
    Future.delayed(Duration(milliseconds: millisegundos), () {
      if (!gameOver) {
        double x = limiteEsquerda + (limiteDireita - limiteEsquerda - 40) * random.nextDouble();
        
        final obstaculo = RectangleComponent(
          position: Vector2(x, -50),
          size: Vector2(40, 60),
        );
        obstaculo.paint = Paint()..color = Colors.red;
        obstaculos.add(obstaculo);
        add(obstaculo);
        
        gerarObstaculos();
      }
    }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    if (!gameOver) {
      if (movendoEsquerda) {
        carro.position.x -= 400 * dt;
        if (carro.position.x < limiteEsquerda) {
          carro.position.x = limiteEsquerda;
        }
      }
      if (movendoDireita) {
        carro.position.x += 400 * dt;
        if (carro.position.x + carro.width > limiteDireita) {
          carro.position.x = limiteDireita - carro.width;
        }
      }
      
      for (int i = 0; i < obstaculos.length; i++) {
        final obstaculo = obstaculos[i];
        obstaculo.position.y += 300 * dt;
        
        if (obstaculo.position.y > size.y) {
          obstaculo.removeFromParent();
          obstaculos.removeAt(i);
          i--;
          continue;
        }
        
        if (carro.toRect().overlaps(obstaculo.toRect())) {
          gameOver = true;
          final textoGameOver = TextComponent(
            text: 'GAME OVER\n\nPontos: ${pontos ~/ 60}',
            position: Vector2(size.x / 2, size.y / 2),
            anchor: Anchor.center,
            textRenderer: TextPaint(
              style: const TextStyle(fontSize: 32, color: Colors.red, fontWeight: FontWeight.bold),
            ),
          );
          add(textoGameOver);
          break;
        }
      }
      
      pontos++;
      if (pontos % 60 == 0) {
        final pontosExibidos = pontos ~/60;
        textoPontos.text = 'Pontos: ${pontos ~/ 60}';
        _atualizarDificuldade(pontosExibidos);
      }
    }
  }
  
  void moverEsquerda() {
    if (!gameOver) movendoEsquerda = true;
  }
  
  void moverDireita() {
    if (!gameOver) movendoDireita = true;
  }
  
  void parar() {
    movendoEsquerda = false;
    movendoDireita = false;
  }
  
  void reiniciar() {
    for (var componente in children.toList()) {
      componente.removeFromParent();
    }
    obstaculos.clear();
    gameOver = false;
    pontos = 0;
    movendoEsquerda = false;
    movendoDireita = false;
    onLoad();
  }
}
  
  void _atualizarDificuldade(int pontosAtuais) {
    if (pontosAtuais >= 30) {
      if (dificuldadeAtual != Dificuldade.dificil) {
        dificuldadeAtual = Dificuldade.dificil;
      }
    } else if (pontosAtuais >= 10) {
      if (dificuldadeAtual != Dificuldade.medio) {
        dificuldadeAtual = Dificuldade.medio;
      }
    }
  }