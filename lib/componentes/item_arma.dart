import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

// O "extends RectangleComponent" faz desta classe um Component válido para o add()
class ItemArma extends RectangleComponent {
  ItemArma({required Vector2 posicao})
      : super(
          position: posicao,
          size: Vector2(30, 30),
          anchor: Anchor.center,
        ) {
    paint = Paint()..color = Colors.blue; // Cor do item no mapa
  }

  @override
  void onLoad() {
    super.onLoad();
    // Cria a caixa de colisão diretamente
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Move o item para baixo na pista
    position.y += 200 * dt; 

    // Remove se sair da tela
    if (position.y > 1000) {
      removeFromParent();
    }
  }
}
