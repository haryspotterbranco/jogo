import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:meu_jogo_corrida/racing_game.dart'; 
import 'componentes/obstaculo.dart';
import 'componentes/item_arma.dart';
import 'componentes/item_combustivel.dart';
import 'componentes/projetil.dart';

class CarroJogador extends RectangleComponent with CollisionCallbacks, HasGameRef<RacingGame> {
  bool temArma = false;
  double _tempoDoUltimoTiro = 0.0;
  final double _intervaloEntreTiros = 0.35;

  final Paint _windowPaint = Paint()..color = Colors.white70;

  CarroJogador({required Vector2 position, required Color cor}) 
    : super(position: position, size: Vector2(46, 76)) {
    paint = Paint()..color = cor;
  }

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    add(RectangleHitbox()); 
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (temArma) {
      _tempoDoUltimoTiro += dt;
      if (_tempoDoUltimoTiro >= _intervaloEntreTiros) {
        _dispararMeteoro();
        _tempoDoUltimoTiro = 0.0;
      }
    }
  }

  void _dispararMeteoro() {
    gameRef.add(Projetil(posicao: Vector2(position.x + (size.x / 2), position.y)));
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is ItemArma) {
      temArma = true;
      other.removeFromParent();
    } else if (other is ItemCombustivel) {
      gameRef.abastecer();
      other.removeFromParent();
    } else if (other is Obstaculo) {
      gameRef.dispararGameOver();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Renderiza cockpit estético sênior
    canvas.drawRect(Rect.fromLTWH(8, 12, size.x - 16, 18), _windowPaint);
  }
}
