import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Obstaculo extends RectangleComponent with CollisionCallbacks {
  Obstaculo({required Vector2 position, required Vector2 size})
      : super(position: position, size: size) {
    paint = Paint()..color = Colors.red;
  }

  @override
  void onLoad() {
    super.onLoad();
    // OBRIGATÓRIO: Dá corpo físico ao bloco para o carro e o tiro baterem nele
    add(RectangleHitbox()); 
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += 200 * dt; // Ajuste a velocidade se necessário

    if (position.y > 1000) {
      removeFromParent();
    }
  }
}
