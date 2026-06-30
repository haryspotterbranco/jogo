import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:meu_jogo_corrida/racing_game.dart';

class Obstaculo extends RectangleComponent with HasGameRef<RacingGame> {
  final double velocidade;
  static final Paint _paintCor = Paint()..color = const Color(0xFFE65100);

  Obstaculo({required Vector2 position, required this.velocidade}) 
    : super(position: position, size: Vector2(54, 44)) {
    paint = _paintCor;
  }

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += velocidade * dt;
    if (position.y > gameRef.size.y + 40) {
      removeFromParent();
    }
  }
}
