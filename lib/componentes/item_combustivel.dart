import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:meu_jogo_corrida/racing_game.dart';

class ItemCombustivel extends RectangleComponent with HasGameRef<RacingGame> {
  static final Paint _paint = Paint()..color = Colors.orangeAccent;

  ItemCombustivel({required Vector2 posicao})
      : super(position: posicao, size: Vector2(24, 32), anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += 190 * dt;
    if (position.y > gameRef.size.y + 30) removeFromParent();
  }
}
