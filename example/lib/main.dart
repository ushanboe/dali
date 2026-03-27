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
    _tabs = TabController(length: 4, vsync: this);
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
            Tab(icon: Icon(Icons.category), text: 'Objects'),
            Tab(icon: Icon(Icons.auto_awesome), text: 'Effects'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [
          AvatarCustomiserPage(),
          SceneShowcasePage(),
          ObjectsShowcasePage(),
          EffectsShowcasePage(),
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
        // Scene preview — constrained to 16:9 so elements don't stretch
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRect(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    DaliScene(config: _config),
                    Positioned(
                      bottom: 0, left: 0, right: 0,
                      child: Center(
                        child: DaliAvatar(config: _avatar, size: 140),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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

// ── Objects Tab ───────────────────────────────────────────────────────────────

class ObjectsShowcasePage extends StatefulWidget {
  const ObjectsShowcasePage({super.key});

  @override
  State<ObjectsShowcasePage> createState() => _ObjectsShowcasePageState();
}

class _ObjectsShowcasePageState extends State<ObjectsShowcasePage> {
  // Selected items
  AnimalType _animal = AnimalType.cat;
  Color _animalColor = const Color(0xFFFF9800);
  VehicleType _vehicle = VehicleType.car;
  Color _vehicleColor = const Color(0xFF1565C0);
  FoodType _food = FoodType.pizza;
  FurnitureType _furniture = FurnitureType.sofa;
  Color _furnitureColor = const Color(0xFF795548);

  static const _objectColors = [
    Color(0xFFE53935), Color(0xFFE91E63), Color(0xFF9C27B0), Color(0xFF1565C0),
    Color(0xFF00897B), Color(0xFF43A047), Color(0xFFF57F17), Color(0xFFFF6F00),
    Color(0xFF795548), Color(0xFF546E7A), Color(0xFF212121), Color(0xFFFFFFFF),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Animals ──────────────────────────────────────────────────────────
        _section('Animals'),
        _colorRow(_objectColors, _animalColor, (c) => setState(() => _animalColor = c)),
        const SizedBox(height: 12),
        _objectGrid(
          AnimalType.values,
          _animal,
          (v) => setState(() => _animal = v),
          builder: (v, sel) => DaliObject.animal(v, size: 80, color: _animalColor),
          label: _animalLabel,
        ),
        const SizedBox(height: 8),
        _bigPreview(DaliObject.animal(_animal, size: 160, color: _animalColor)),

        // ── Vehicles ─────────────────────────────────────────────────────────
        _section('Vehicles'),
        _colorRow(_objectColors, _vehicleColor, (c) => setState(() => _vehicleColor = c)),
        const SizedBox(height: 12),
        _objectGrid(
          VehicleType.values,
          _vehicle,
          (v) => setState(() => _vehicle = v),
          builder: (v, sel) => DaliObject.vehicle(v, size: 80, color: _vehicleColor),
          label: _vehicleLabel,
        ),
        const SizedBox(height: 8),
        _bigPreview(DaliObject.vehicle(_vehicle, size: 160, color: _vehicleColor)),

        // ── Food ─────────────────────────────────────────────────────────────
        _section('Food'),
        _objectGrid(
          FoodType.values,
          _food,
          (v) => setState(() => _food = v),
          builder: (v, sel) => DaliObject.food(v, size: 80),
          label: _foodLabel,
        ),
        const SizedBox(height: 8),
        _bigPreview(DaliObject.food(_food, size: 160)),

        // ── Furniture ────────────────────────────────────────────────────────
        _section('Furniture'),
        _colorRow(_objectColors, _furnitureColor, (c) => setState(() => _furnitureColor = c)),
        const SizedBox(height: 12),
        _objectGrid(
          FurnitureType.values,
          _furniture,
          (v) => setState(() => _furniture = v),
          builder: (v, sel) => DaliObject.furniture(v, size: 80, color: _furnitureColor),
          label: _furnitureLabel,
        ),
        const SizedBox(height: 8),
        _bigPreview(DaliObject.furniture(_furniture, size: 160, color: _furnitureColor)),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _section(String t) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Text(t, style: const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 15,
      color: Color(0xFF6B3A8A), letterSpacing: 0.5,
    )),
  );

  Widget _bigPreview(Widget child) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF0E8FF),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: child,
      ),
    );
  }

  Widget _objectGrid<T>(
    List<T> values,
    T selected,
    ValueChanged<T> onTap, {
    required Widget Function(T, bool) builder,
    required String Function(T) label,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: values.map((v) {
        final sel = v == selected;
        return GestureDetector(
          onTap: () => onTap(v),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: sel ? const Color(0xFFF0E8FF) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: sel ? const Color(0xFF9B59B6) : Colors.grey.shade300,
                    width: sel ? 2.5 : 1.5,
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: builder(v, sel),
              ),
              const SizedBox(height: 4),
              Text(
                label(v),
                style: TextStyle(
                  fontSize: 10,
                  color: sel ? const Color(0xFF6B3A8A) : Colors.black54,
                  fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }).toList(),
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
          final sel = c.value == selected.value;
          return GestureDetector(
            onTap: () => onTap(c),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: c, shape: BoxShape.circle,
                border: Border.all(
                  color: sel ? const Color(0xFF9B59B6) : Colors.white,
                  width: sel ? 3 : 2,
                ),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4)],
              ),
              child: sel ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
          );
        },
      ),
    );
  }

  String _animalLabel(AnimalType t) => switch (t) {
    AnimalType.cat => 'Cat', AnimalType.dog => 'Dog',
    AnimalType.rabbit => 'Rabbit', AnimalType.bird => 'Bird',
    AnimalType.fish => 'Fish', AnimalType.bear => 'Bear',
    AnimalType.fox => 'Fox', AnimalType.penguin => 'Penguin',
    AnimalType.elephant => 'Elephant', AnimalType.lion => 'Lion',
  };

  String _vehicleLabel(VehicleType t) => switch (t) {
    VehicleType.car => 'Car', VehicleType.bus => 'Bus',
    VehicleType.bike => 'Bike', VehicleType.plane => 'Plane',
    VehicleType.boat => 'Boat', VehicleType.rocket => 'Rocket',
  };

  String _foodLabel(FoodType t) => switch (t) {
    FoodType.apple => 'Apple', FoodType.banana => 'Banana',
    FoodType.pizza => 'Pizza', FoodType.cake => 'Cake',
    FoodType.iceCream => 'Ice Cream', FoodType.burger => 'Burger',
    FoodType.donut => 'Donut', FoodType.watermelon => 'Melon',
    FoodType.cupcake => 'Cupcake', FoodType.strawberry => 'Berry',
    FoodType.lollipop => 'Lollipop', FoodType.star => 'Star',
  };

  String _furnitureLabel(FurnitureType t) => switch (t) {
    FurnitureType.chair => 'Chair', FurnitureType.table => 'Table',
    FurnitureType.bed => 'Bed', FurnitureType.sofa => 'Sofa',
    FurnitureType.lamp => 'Lamp', FurnitureType.mirror => 'Mirror',
    FurnitureType.shelf => 'Shelf', FurnitureType.door => 'Door',
  };
}

// ── Effects Tab ───────────────────────────────────────────────────────────────

class EffectsShowcasePage extends StatefulWidget {
  const EffectsShowcasePage({super.key});

  @override
  State<EffectsShowcasePage> createState() => _EffectsShowcasePageState();
}

class _EffectsShowcasePageState extends State<EffectsShowcasePage> {
  ParticleType _particle = ParticleType.confetti;
  BadgeType _badge = BadgeType.star;
  bool _animateBadge = true;
  int _badgeKey = 0;

  static const _badgeColors = [
    Color(0xFFFFD600), Color(0xFFE53935), Color(0xFF9C27B0),
    Color(0xFF1565C0), Color(0xFF00897B), Color(0xFF4CAF50),
  ];
  int _badgeColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Particles ────────────────────────────────────────────────────────
        _section('Particle Effects'),
        _chips(ParticleType.values, _particle,
            (v) => setState(() => _particle = v),
            label: _particleLabel),
        const SizedBox(height: 12),
        // Live particle preview
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                DaliEffects(type: _particle),
                Center(
                  child: Text(
                    _particleLabel(_particle),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Particle over avatar demo
        _section('Particles Over Scene'),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 180,
            child: Stack(
              fit: StackFit.expand,
              children: [
                DaliScene(config: const SceneConfig(
                  type: SceneType.park, timeOfDay: DayTime.day,
                )),
                DaliEffects(type: _particle),
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Center(
                    child: DaliAvatar(
                      config: const AvatarConfig(
                        skinTone: Color(0xFFF5C5A3),
                        hair: HairConfig(style: HairStyle.longCurly, color: Color(0xFF6B3A1F)),
                        face: FaceConfig(expression: FaceExpression.excited, blush: true),
                        clothing: ClothingConfig(item: ClothingItem.dress, primaryColor: Color(0xFFE91E8C)),
                      ),
                      size: 110,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Badges ───────────────────────────────────────────────────────────
        _section('Achievement Badges'),
        _chips(BadgeType.values, _badge,
            (v) => setState(() => _badge = v),
            label: _badgeLabel),
        const SizedBox(height: 8),
        // Badge color row
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _badgeColors.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final sel = i == _badgeColorIndex;
              return GestureDetector(
                onTap: () => setState(() => _badgeColorIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: _badgeColors[i], shape: BoxShape.circle,
                    border: Border.all(
                      color: sel ? const Color(0xFF9B59B6) : Colors.white,
                      width: sel ? 3 : 2,
                    ),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4)],
                  ),
                  child: sel ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Badge preview with re-animate button
        Center(
          child: Column(
            children: [
              DaliBadge(
                key: ValueKey(_badgeKey),
                type: _badge,
                size: 160,
                color: _badgeColors[_badgeColorIndex],
                animate: _animateBadge,
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => setState(() {
                  _animateBadge = true;
                  _badgeKey++;
                }),
                icon: const Icon(Icons.replay),
                label: const Text('Replay Animation'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9B59B6),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),

        // Badge grid
        const SizedBox(height: 16),
        Wrap(
          spacing: 12, runSpacing: 12,
          children: BadgeType.values.map((b) {
            final sel = b == _badge;
            return GestureDetector(
              onTap: () => setState(() { _badge = b; _badgeKey++; }),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: sel ? const Color(0xFF9B59B6) : Colors.grey.shade200,
                        width: sel ? 2.5 : 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: DaliBadge(type: b, size: 72,
                        color: _badgeColors[_badgeColorIndex], animate: false),
                  ),
                  const SizedBox(height: 4),
                  Text(_badgeLabel(b), style: TextStyle(
                    fontSize: 10,
                    color: sel ? const Color(0xFF6B3A8A) : Colors.black54,
                    fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                  )),
                ],
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _section(String t) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Text(t, style: const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 15,
      color: Color(0xFF6B3A8A), letterSpacing: 0.5,
    )),
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

  String _particleLabel(ParticleType t) => switch (t) {
    ParticleType.confetti => 'Confetti',
    ParticleType.sparkles => 'Sparkles',
    ParticleType.bubbles  => 'Bubbles',
    ParticleType.stars    => 'Stars',
    ParticleType.hearts   => 'Hearts',
    ParticleType.snow     => 'Snow',
  };

  String _badgeLabel(BadgeType t) => switch (t) {
    BadgeType.star    => 'Star',
    BadgeType.trophy  => 'Trophy',
    BadgeType.ribbon  => 'Ribbon',
    BadgeType.medal   => 'Medal',
    BadgeType.shield  => 'Shield',
    BadgeType.crown   => 'Crown',
    BadgeType.heart   => 'Heart',
    BadgeType.diamond => 'Diamond',
  };
}
