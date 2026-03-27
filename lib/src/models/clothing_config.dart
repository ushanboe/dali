import 'package:flutter/material.dart';

enum ClothingItem {
  tshirt,
  dress,
  hoodie,
  blouse,
  jacket,
  sweater,
  tanktop,
  formalShirt,
}

class ClothingConfig {
  final ClothingItem item;
  final Color primaryColor;
  final Color secondaryColor;

  const ClothingConfig({
    this.item = ClothingItem.tshirt,
    this.primaryColor = const Color(0xFF4A90D9),
    this.secondaryColor = const Color(0xFF2C5F8A),
  });

  ClothingConfig copyWith({
    ClothingItem? item,
    Color? primaryColor,
    Color? secondaryColor,
  }) {
    return ClothingConfig(
      item: item ?? this.item,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
    );
  }
}
