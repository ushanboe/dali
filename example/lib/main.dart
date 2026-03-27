import 'package:flutter/material.dart';
import 'package:dali/dali.dart';

void main() {
  runApp(const DaliShowcaseApp());
}

class DaliShowcaseApp extends StatelessWidget {
  const DaliShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dali Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF9B59B6)),
        useMaterial3: true,
      ),
      home: const AvatarCustomiserPage(),
    );
  }
}

class AvatarCustomiserPage extends StatefulWidget {
  const AvatarCustomiserPage({super.key});

  @override
  State<AvatarCustomiserPage> createState() => _AvatarCustomiserPageState();
}

class _AvatarCustomiserPageState extends State<AvatarCustomiserPage> {
  AvatarConfig _config = AvatarConfig(
    skinTone: SkinTones.cream,
    hair: const HairConfig(style: HairStyle.mediumWavy, color: Color(0xFF6B3A1F)),
    face: const FaceConfig(expression: FaceExpression.happy, eyeShape: EyeShape.round, blush: true),
    clothing: const ClothingConfig(item: ClothingItem.dress, primaryColor: Color(0xFFE91E8C)),
  );

  HairStyle _hairStyle = HairStyle.mediumWavy;
  Color _hairColor = HairColors.mediumBrown;
  Color _skinTone = SkinTones.cream;
  FaceExpression _expression = FaceExpression.happy;
  EyeShape _eyeShape = EyeShape.round;
  bool _blush = true;
  ClothingItem _clothing = ClothingItem.dress;
  Color _clothingColor = const Color(0xFFE91E8C);

  void _updateConfig() {
    setState(() {
      _config = AvatarConfig(
        skinTone: _skinTone,
        hair: HairConfig(style: _hairStyle, color: _hairColor, highlightColor: _lighten(_hairColor, 0.15)),
        face: FaceConfig(expression: _expression, eyeShape: _eyeShape, blush: _blush),
        clothing: ClothingConfig(item: _clothing, primaryColor: _clothingColor, secondaryColor: _darken(_clothingColor, 0.15)),
      );
    });
  }

  Color _lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F0FF),
      appBar: AppBar(
        title: const Text('Dali Avatar Builder'),
        backgroundColor: const Color(0xFF9B59B6),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Avatar preview
          Container(
            color: const Color(0xFF9B59B6),
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF0E8FF),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.20),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: DaliAvatar(config: _config, size: 180),
              ),
            ),
          ),

          // Controls
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _sectionHeader('Skin Tone'),
                _colorRow(SkinTones.all, _skinTone, (c) {
                  _skinTone = c;
                  _updateConfig();
                }),

                _sectionHeader('Hair Style'),
                _enumGrid<HairStyle>(
                  HairStyle.values,
                  _hairStyle,
                  (v) { _hairStyle = v; _updateConfig(); },
                  label: (v) => _hairStyleLabel(v),
                ),

                _sectionHeader('Hair Colour'),
                _colorRow(HairColors.all, _hairColor, (c) {
                  _hairColor = c;
                  _updateConfig();
                }),

                _sectionHeader('Expression'),
                _enumGrid<FaceExpression>(
                  FaceExpression.values,
                  _expression,
                  (v) { _expression = v; _updateConfig(); },
                  label: (v) => v.name,
                ),

                _sectionHeader('Eye Shape'),
                _enumGrid<EyeShape>(
                  EyeShape.values,
                  _eyeShape,
                  (v) { _eyeShape = v; _updateConfig(); },
                  label: (v) => v.name,
                ),

                _sectionHeader('Clothing'),
                _enumGrid<ClothingItem>(
                  ClothingItem.values,
                  _clothing,
                  (v) { _clothing = v; _updateConfig(); },
                  label: (v) => _clothingLabel(v),
                ),

                _sectionHeader('Clothing Colour'),
                _colorRow(_clothingColors, _clothingColor, (c) {
                  _clothingColor = c;
                  _updateConfig();
                }),

                _sectionHeader('Extras'),
                SwitchListTile(
                  title: const Text('Blush'),
                  value: _blush,
                  onChanged: (v) { _blush = v; _updateConfig(); },
                  activeColor: const Color(0xFF9B59B6),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Color(0xFF6B3A8A),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _colorRow(List<Color> colors, Color selected, ValueChanged<Color> onTap) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final c = colors[i];
          final isSelected = c.value == selected.value;
          return GestureDetector(
            onTap: () => onTap(c),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: c,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF9B59B6) : Colors.white,
                  width: isSelected ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _enumGrid<T>(List<T> values, T selected, ValueChanged<T> onTap,
      {required String Function(T) label}) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values.map((v) {
        final isSelected = v == selected;
        return GestureDetector(
          onTap: () => onTap(v),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF9B59B6) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? const Color(0xFF9B59B6) : Colors.grey.shade300,
              ),
              boxShadow: isSelected
                  ? [BoxShadow(color: const Color(0xFF9B59B6).withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 2))]
                  : [],
            ),
            child: Text(
              label(v),
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _hairStyleLabel(HairStyle s) => switch (s) {
    HairStyle.shortStraight => 'Short Straight',
    HairStyle.shortCurly => 'Short Curly',
    HairStyle.mediumStraight => 'Medium Straight',
    HairStyle.mediumWavy => 'Medium Wavy',
    HairStyle.longStraight => 'Long Straight',
    HairStyle.longCurly => 'Long Curly',
    HairStyle.bob => 'Bob',
    HairStyle.ponytail => 'Ponytail',
    HairStyle.bun => 'Bun',
    HairStyle.braids => 'Braids',
    HairStyle.afro => 'Afro',
    HairStyle.pixie => 'Pixie',
  };

  String _clothingLabel(ClothingItem i) => switch (i) {
    ClothingItem.tshirt => 'T-Shirt',
    ClothingItem.dress => 'Dress',
    ClothingItem.hoodie => 'Hoodie',
    ClothingItem.blouse => 'Blouse',
    ClothingItem.jacket => 'Jacket',
    ClothingItem.sweater => 'Sweater',
    ClothingItem.tanktop => 'Tank Top',
    ClothingItem.formalShirt => 'Formal',
  };

  static const List<Color> _clothingColors = [
    Color(0xFFE91E8C), Color(0xFF9B59B6), Color(0xFF3498DB), Color(0xFF1ABC9C),
    Color(0xFFF39C12), Color(0xFFE74C3C), Color(0xFF2C3E50), Color(0xFF95A5A6),
    Color(0xFF27AE60), Color(0xFFD35400), Color(0xFF8E44AD), Color(0xFFFFFFFF),
  ];
}
