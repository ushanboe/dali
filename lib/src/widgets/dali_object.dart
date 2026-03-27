import 'package:flutter/material.dart';
import '../models/object_config.dart';
import '../painters/animal_painter.dart';
import '../painters/vehicle_painter.dart';
import '../painters/food_painter.dart';
import '../painters/furniture_painter.dart';

/// Renders a single animal, vehicle, food item, or furniture piece.
///
/// ```dart
/// DaliObject.animal(AnimalType.cat, size: 120, color: Colors.orange)
/// DaliObject.vehicle(VehicleType.rocket, size: 100, color: Colors.red)
/// DaliObject.food(FoodType.pizza, size: 100)
/// DaliObject.furniture(FurnitureType.sofa, size: 140, color: Colors.teal)
/// ```
class DaliObject extends StatelessWidget {
  final CustomPainter _painter;
  final double size;

  const DaliObject._({
    required CustomPainter painter,
    required this.size,
    super.key,
  }) : _painter = painter;

  factory DaliObject.animal(
    AnimalType type, {
    double size = 100,
    Color color = const Color(0xFFFF9800),
    Color? secondaryColor,
    Key? key,
  }) {
    return DaliObject._(
      painter: AnimalPainter(
        type: type,
        primaryColor: color,
        secondaryColor: secondaryColor,
      ),
      size: size,
      key: key,
    );
  }

  factory DaliObject.vehicle(
    VehicleType type, {
    double size = 100,
    Color color = const Color(0xFF1565C0),
    Color? secondaryColor,
    Key? key,
  }) {
    return DaliObject._(
      painter: VehiclePainter(
        type: type,
        primaryColor: color,
        secondaryColor: secondaryColor,
      ),
      size: size,
      key: key,
    );
  }

  factory DaliObject.food(
    FoodType type, {
    double size = 100,
    Color? color,
    Key? key,
  }) {
    return DaliObject._(
      painter: FoodPainter(type: type, primaryColor: color),
      size: size,
      key: key,
    );
  }

  factory DaliObject.furniture(
    FurnitureType type, {
    double size = 100,
    Color color = const Color(0xFF795548),
    Color? secondaryColor,
    Key? key,
  }) {
    return DaliObject._(
      painter: FurniturePainter(
        type: type,
        primaryColor: color,
        secondaryColor: secondaryColor,
      ),
      size: size,
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _painter, size: Size(size, size)),
    );
  }
}
