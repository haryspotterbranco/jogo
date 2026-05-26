import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:meu_jogo_corrida/componentes/obstaculo.dart';

class Projetil extends RectangleComponent {
  final double velocidade = 400;

  Projetil({required Vector2 posicao})
      : super(
          position: posicao,
          size: Vector2(8, 20),
          anchor: Anchor.center,
        ) {
    paint = Paint()..color = Colors.yellow;
  }

  @override
  void onLoad() {
    super.onLoad();
    
    final hitbox = RectangleHitbox();
    
    // Lógica interna de colisão (Evita erros de mixin)
    hitbox.onCollisionStartCallback = (intersectionPoints, other) {
      if (other is Obstaculo) {
        other.removeFromParent(); // Destrói o obstáculo
        removeFromParent();        // Destrói o tiro
      }
    };

    add(hitbox); 
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y -= velocidade * dt; 

    if (position.y < -50) {
      removeFromParent(); 
    }
  }
}
