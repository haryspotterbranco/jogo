import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'obstaculo.dart';

class Projetil extends RectangleComponent {
  final double _speed = 650.0;
  static final Paint _laserPaint = Paint()..color = Colors.cyanAccent;

  Projetil({required Vector2 posicao})
      : super(position: posicao, size: Vector2(6, 18), anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    final hitbox = RectangleHitbox();
    hitbox.onCollisionStartCallback = (pts, other) {
      if (other is Obstaculo) {
        other.removeFromParent();
        removeFromParent();
      }
    };
    add(hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y -= _speed * dt;
    if (position.y < -30) removeFromParent();
  }
}
