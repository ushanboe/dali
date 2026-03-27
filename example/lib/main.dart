import 'package:flutter/material.dart';
import 'package:dali/dali.dart';

void main() => runApp(const DaliShowcaseApp());

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
      home: const ShowcaseHome(),
    );
  }
}

class ShowcaseHome extends StatefulWidget {
  const ShowcaseHome({super.key});

  @override
  State<ShowcaseHome> createState() => _ShowcaseHomeState();
}

class _ShowcaseHomeState extends State<ShowcaseHome>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dali Showcase'),
        backgroundColor: const Color(0xFF9B59B6),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: 'Avatar'),
            Tab(icon: Icon(Icons.landscape), text: 'Scenes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [
          AvatarCustomiserPage(),
          SceneShowcasePage(),
        ],
      ),
    );
  }
}

// ── Avatar Tab ───────────────────────────────────────────────────────────────

class AvatarCustomiserPage extends StatefulWidget {
  const AvatarCustomiserPage({super.key});

  @override
  State<AvatarCustomiserPage> createState() => _AvatarCustomiserPageState();
}

class _AvatarCustomiserPageState extends State<AvatarCustomiserPage> {
  HairStyle _hairStyle = HairStyle.mediumWavy;
  Color _hairColor = HairColors.mediumBrown;
  Color _skinTone = SkinTones.cream;
  FaceExpression _expression = FaceExpression.happy;
  EyeShape _eyeShape = EyeShape.round;
  bool _blush = true;
  ClothingItem _clothing = ClothingItem.dress;
  Color _clothingColor = const Color(0xFFE91E8C);

  AvatarConfig get _config => AvatarConfig(
    skinTone: _skinTone,
    hair: HairConfig(
      style: _hairStyle,
      color: _hairColor,
      highlightColor: _lighten(_hairColor, 0.15),
    ),
    face: FaceConfig(expression: _expression, eyeShape: _eyeShape, blush: _blush),
    clothing: ClothingConfig(
      item: _clothing,
      primaryColor: _clothingColor,
      secondaryColor: _darken(_clothingColor, 0.15),
    ),
  );

  Color _lighten(Color c, double amt) {
    final h = HSLColor.fromColor(c);
    return h.withLightness((h.lightness + amt).clamp(0.0, 1.0)).toColor();
  }

  Color _darken(Color c, double amt) {
    final h = HSLColor.fromColor(c);
    return h.withLightness((h.lightness - amt).clamp(0.0, 1.0)).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: const Color(0xFF9B59B6),
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF0E8FF),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              padding: const EdgeInsets.all(16),
              child: DaliAvatar(config: _config, size: 180),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _section('Skin Tone'),
              _colorRow(SkinTones.all, _skinTone, (c) => setState(() => _skinTone = c)),
              _section('Hair Style'),
              _chips(HairStyle.values, _hairStyle, (v) => setState(() => _hairStyle = v),
                  label: _hairLabel),
              _section('Hair Colour'),
              _colorRow(HairColors.all, _hairColor, (c) => setState(() => _hairColor = c)),
              _section('Expression'),
              _chips(FaceExpression.values, _expression, (v) => setState(() => _expression = v),
                  label: (v) => v.name),
              _section('Eye Shape'),
              _chips(EyeShape.values, _eyeShape, (v) => setState(() => _eyeShape = v),
                  label: (v) => v.name),
              _section('Clothing'),
              _chips(ClothingItem.values, _clothing, (v) => setState(() => _clothing = v),
                  label: _clothingLabel),
              _section('Clothing Colour'),
              _colorRow(_clothingColors, _clothingColor, (c) => setState(() => _clothingColor = c)),
              _section('Extras'),
              SwitchListTile(
                title: const Text('Blush'),
                value: _blush,
                onChanged: (v) => setState(() => _blush = v),
                activeColor: const Color(0xFF9B59B6),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  Widget _section(String t) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13,
        color: Color(0xFF6B3A8A), letterSpacing: 0.5)),
  );

  Widget _colorRow(List<Color> colors, Color selected, ValueChanged<Color> onTap) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final c = colors[i];
          final sel = c.value == selected.value;
          return GestureDetector(
            onTap: () => onTap(c),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: c, shape: BoxShape.circle,
                border: Border.all(color: sel ? const Color(0xFF9B59B6) : Colors.white, width: sel ? 3 : 2),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: sel ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
          );
        },
      ),
    );
  }

  Widget _chips<T>(List<T> values, T selected, ValueChanged<T> onTap,
      {required String Function(T) label}) {
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: values.map((v) {
        final sel = v == selected;
        return GestureDetector(
          onTap: () => onTap(v),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: sel ? const Color(0xFF9B59B6) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: sel ? const Color(0xFF9B59B6) : Colors.grey.shade300),
              boxShadow: sel ? [BoxShadow(color: const Color(0xFF9B59B6).withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 2))] : [],
            ),
            child: Text(label(v), style: TextStyle(fontSize: 12,
                fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                color: sel ? Colors.white : Colors.black87)),
          ),
        );
      }).toList(),
    );
  }

  String _hairLabel(HairStyle s) => switch (s) {
    HairStyle.shortStraight => 'Short Straight', HairStyle.shortCurly => 'Short Curly',
    HairStyle.mediumStraight => 'Medium Straight', HairStyle.mediumWavy => 'Medium Wavy',
    HairStyle.longStraight => 'Long Straight', HairStyle.longCurly => 'Long Curly',
    HairStyle.bob => 'Bob', HairStyle.ponytail => 'Ponytail', HairStyle.bun => 'Bun',
    HairStyle.braids => 'Braids', HairStyle.afro => 'Afro', HairStyle.pixie => 'Pixie',
  };

  String _clothingLabel(ClothingItem i) => switch (i) {
    ClothingItem.tshirt => 'T-Shirt', ClothingItem.dress => 'Dress',
    ClothingItem.hoodie => 'Hoodie', ClothingItem.blouse => 'Blouse',
    ClothingItem.jacket => 'Jacket', ClothingItem.sweater => 'Sweater',
    ClothingItem.tanktop => 'Tank Top', ClothingItem.formalShirt => 'Formal',
  };

  static const List<Color> _clothingColors = [
    Color(0xFFE91E8C), Color(0xFF9B59B6), Color(0xFF3498DB), Color(0xFF1ABC9C),
    Color(0xFFF39C12), Color(0xFFE74C3C), Color(0xFF2C3E50), Color(0xFF95A5A6),
    Color(0xFF27AE60), Color(0xFFD35400), Color(0xFF8E44AD), Color(0xFFFFFFFF),
  ];
}

// ── Scenes Tab ───────────────────────────────────────────────────────────────

class SceneShowcasePage extends StatefulWidget {
  const SceneShowcasePage({super.key});

  @override
  State<SceneShowcasePage> createState() => _SceneShowcasePageState();
}

class _SceneShowcasePageState extends State<SceneShowcasePage> {
  SceneType _sceneType = SceneType.park;
  DayTime _timeOfDay = DayTime.day;
  Weather _weather = Weather.clear;

  SceneConfig get _config => SceneConfig(type: _sceneType, timeOfDay: _timeOfDay, weather: _weather);

  static const _avatar = AvatarConfig(
    skinTone: Color(0xFFF5C5A3),
    hair: HairConfig(style: HairStyle.longCurly, color: Color(0xFF6B3A1F)),
    face: FaceConfig(expression: FaceExpression.happy, blush: true),
    clothing: ClothingConfig(item: ClothingItem.dress, primaryColor: Color(0xFFE91E8C)),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Scene preview
        SizedBox(
          height: 280,
          child: Stack(
            fit: StackFit.expand,
            children: [
              DaliScene(config: _config),
              Positioned(
                bottom: 0,
                left: 0, right: 0,
                child: Center(
                  child: DaliAvatar(config: _avatar, size: 160),
                ),
              ),
            ],
          ),
        ),

        // Controls
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _section('Scene'),
              _chips(SceneType.values, _sceneType, (v) => setState(() => _sceneType = v),
                  label: _sceneLabel),
              _section('Time of Day'),
              _chips(DayTime.values, _timeOfDay, (v) => setState(() => _timeOfDay = v),
                  label: (v) => v.name),
              _section('Weather'),
              _chips(Weather.values, _weather, (v) => setState(() => _weather = v),
                  label: (v) => v.name),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  Widget _section(String t) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13,
        color: Color(0xFF6B3A8A), letterSpacing: 0.5)),
  );

  Widget _chips<T>(List<T> values, T selected, ValueChanged<T> onTap,
      {required String Function(T) label}) {
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: values.map((v) {
        final sel = v == selected;
        return GestureDetector(
          onTap: () => onTap(v),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: sel ? const Color(0xFF9B59B6) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: sel ? const Color(0xFF9B59B6) : Colors.grey.shade300),
            ),
            child: Text(label(v), style: TextStyle(fontSize: 12,
                fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                color: sel ? Colors.white : Colors.black87)),
          ),
        );
      }).toList(),
    );
  }

  String _sceneLabel(SceneType t) => switch (t) {
    SceneType.park => 'Park', SceneType.beach => 'Beach',
    SceneType.city => 'City', SceneType.forest => 'Forest',
    SceneType.bedroom => 'Bedroom', SceneType.kitchen => 'Kitchen',
    SceneType.classroom => 'Classroom', SceneType.salon => 'Salon',
    SceneType.space => 'Space', SceneType.underwater => 'Underwater',
  };
}
