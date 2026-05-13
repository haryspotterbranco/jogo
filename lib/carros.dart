// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

// ========== 1. CARRO AZUL PADRÃO ==========
class CarroAzul extends RectangleComponent {
  CarroAzul({required Vector2 position}) : super(
    position: position,
    size: Vector2(50, 80),
  ) {
    paint = Paint()..color = Colors.blue;
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Janela
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(10, 10, size.x - 20, 25), whitePaint);
    
    // Faróis
    final yellowPaint = Paint()..color = Colors.yellow;
    canvas.drawRect(Rect.fromLTWH(5, size.y - 15, 10, 10), yellowPaint);
    canvas.drawRect(Rect.fromLTWH(size.x - 15, size.y - 15, 10, 10), yellowPaint);
    
    // Rodas
    final blackPaint = Paint()..color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(5, size.y - 10, 12, 8), blackPaint);
    canvas.drawRect(Rect.fromLTWH(size.x - 17, size.y - 10, 12, 8), blackPaint);
  }
}

// ========== 2. CARRO VERMELHO ESPORTIVO ==========
class CarroVermelho extends RectangleComponent {
  CarroVermelho({required Vector2 position}) : super(
    position: position,
    size: Vector2(45, 75),
  ) {
    paint = Paint()..color = Colors.red;
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Listras esportivas
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(15, 5, 5, 30), whitePaint);
    canvas.drawRect(Rect.fromLTWH(25, 5, 5, 30), whitePaint);
    
    // Janela escura
    final darkPaint = Paint()..color = Colors.grey[800]!;
    canvas.drawRect(Rect.fromLTWH(10, 10, size.x - 20, 20), darkPaint);
    
    // Rodas
    final blackPaint = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(12, size.y - 10), 8, blackPaint);
    canvas.drawCircle(Offset(size.x - 12, size.y - 10), 8, blackPaint);
    
    // Faróis de LED
    final ledPaint = Paint()..color = const Color(0xFF00FF00);
    canvas.drawRect(Rect.fromLTWH(3, size.y - 12, 8, 6), ledPaint);
    canvas.drawRect(Rect.fromLTWH(size.x - 11, size.y - 12, 8, 6), ledPaint);
  }
}

// ========== 3. CARRO AMARELO ==========
class CarroAmarelo extends RectangleComponent {
  CarroAmarelo({required Vector2 position}) : super(
    position: position,
    size: Vector2(50, 80),
  ) {
    paint = Paint()..color = Colors.amber;
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Faixa preta
    final blackPaint = Paint()..color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(0, size.y / 2 - 10, size.x, 20), blackPaint);
    
    // Janela
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(10, 10, size.x - 20, 20), whitePaint);
    
    // Rodas
    final grayPaint = Paint()..color = Colors.grey;
    canvas.drawRect(Rect.fromLTWH(5, size.y - 12, 12, 8), grayPaint);
    canvas.drawRect(Rect.fromLTWH(size.x - 17, size.y - 12, 12, 8), grayPaint);
  }
}

// ========== LISTA DE CARROS ==========
class ListaCarros {
  static final List<Map<String, dynamic>> carros = [
    {'nome': 'Azul', 'icone': '🔵', 'cor': Colors.blue, 'classe': CarroAzul},
    {'nome': 'Vermelho', 'icone': '🔴', 'cor': Colors.red, 'classe': CarroVermelho},
    {'nome': 'Amarelo', 'icone': '🟡', 'cor': Colors.amber, 'classe': CarroAmarelo},
  ];
}