import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'componentes/obstaculo.dart';
// Imports oficiais usando o padrão do seu projeto (Resolve erros de tipo)
import 'package:meu_jogo_corrida/racing_game.dart'; 
import 'package:meu_jogo_corrida/componentes/projetil.dart';

class CarroJogador extends RectangleComponent with CollisionCallbacks, HasGameRef<RacingGame> {
  bool temArma = false;
  double tempoDoUltimoTiro = 0;
  final double intervaloEntreTiros = 0.5;

  // Recebe a posição e a cor dinamicamente
  CarroJogador({required Vector2 position, required Color cor}) : super(
    position: position,
    size: Vector2(50, 80),
  ) {
    paint = Paint()..color = cor;
  }

  @override
  void onLoad() {
    super.onLoad();
    // Ativa o corpo físico do carro (Resolve o problema de passar por dentro)
    add(RectangleHitbox()); 
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Gerencia o tiro automático se tiver a arma
    if (temArma) {
      tempoDoUltimoTiro += dt;
      if (tempoDoUltimoTiro >= intervaloEntreTiros) {
        atirar();
        tempoDoUltimoTiro = 0;
      }
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    // Se colidir com o item da arma (que está no racing_game.dart)
    if (other is ItemArma) {
      temArma = true;
      other.removeFromParent();
    }

    // Se colidir com o obstáculo vermelho
    if (other is Obstaculo) {
      gameRef.gameOver = true; // Ativa o Game Over no jogo principal
    }
  }

  void atirar() {
    final tiro = Projetil(
      posicao: Vector2(position.x + size.x / 2, position.y - 10),
    );
    gameRef.add(tiro); 
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Declarado apenas uma vez (Resolve erro de duplicidade)
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(10, 10, size.x - 20, 25), whitePaint);
  }
}