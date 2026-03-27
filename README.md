# Dali

**Procedural graphics engine for Flutter — zero image files, infinite resolution.**

Named after Salvador Dalí: art created from imagination, not photographs.

---

## What Is Dali?

Dali is a standalone Flutter package that generates avatars, characters, scenes, objects, and visual effects **entirely in code** using Flutter's `CustomPainter` / Canvas API.

No PNG files. No external APIs. No runtime costs. Every visual element is drawn at paint time from typed parameters, scales perfectly at any resolution, and updates instantly when parameters change.

---

## What It Unlocks

| App Category | Without Dali | With Dali |
|---|---|---|
| Kids hair/dress-up games | Blocked (no assets) | Buildable |
| Avatar creators | Blocked | Buildable |
| Character-based education | Blocked | Buildable |
| Animal/pet games | Blocked | Buildable |
| Scene-based story apps | Blocked | Buildable |
| Visual reward/badge systems | Partial | Full |
| Any app needing illustrations | Blocked | Buildable |

---

## Installation

```yaml
dependencies:
  dali:
    path: path/to/dali   # local
    # or once published:
    # dali: ^1.0.0
```

```dart
import 'package:dali/dali.dart';
```

---

## Components

### DaliAvatar

A fully customisable human character — skin tone, hair (12 styles, any colour), face (6 expressions, 6 eye shapes), and clothing (8 items, any colour).

```dart
DaliAvatar(
  config: AvatarConfig(
    skinTone: SkinTones.tan,
    hair: HairConfig(
      style: HairStyle.longCurly,
      color: HairColors.auburn,
      highlightColor: HairColors.lightBrown,
    ),
    face: FaceConfig(
      expression: FaceExpression.happy,
      eyeShape: EyeShape.almond,
      blush: true,
    ),
    clothing: ClothingConfig(
      item: ClothingItem.dress,
      primaryColor: Color(0xFFE91E8C),
    ),
  ),
  size: 200,
)
```

**Hair styles:** shortStraight, shortCurly, mediumStraight, mediumWavy, longStraight, longCurly, bob, ponytail, bun, braids, afro, pixie

**Expressions:** neutral, happy, excited, sad, surprised, thinking

**Eye shapes:** round, almond, wide, narrow, bright, sleepy

**Clothing:** tshirt, dress, hoodie, blouse, jacket, sweater, tanktop, formalShirt

---

### DaliScene

A full background scene. Drop it behind a `DaliAvatar` in a `Stack`.

```dart
Stack(
  children: [
    DaliScene(
      config: SceneConfig(
        type: SceneType.beach,
        timeOfDay: DayTime.dusk,
        weather: Weather.clear,
      ),
    ),
    Positioned(
      bottom: 0,
      child: DaliAvatar(config: avatarConfig, size: 200),
    ),
  ],
)
```

**Scene types:** park, beach, city, forest, bedroom, kitchen, classroom, salon, space, underwater

**Times of day:** dawn, day, dusk, night

**Weather:** clear, cloudy, rainy, snowy

---

### DaliObject

Standalone objects — animals, vehicles, food, and furniture.

```dart
// Animal (colour-customisable)
DaliObject.animal(AnimalType.cat, size: 120, color: Colors.orange)

// Vehicle (colour-customisable)
DaliObject.vehicle(VehicleType.rocket, size: 100, color: Colors.red)

// Food
DaliObject.food(FoodType.pizza, size: 100)

// Furniture (colour-customisable)
DaliObject.furniture(FurnitureType.sofa, size: 140, color: Colors.teal)
```

**Animals (10):** cat, dog, rabbit, bird, fish, bear, fox, penguin, elephant, lion

**Vehicles (6):** car, bus, bike, plane, boat, rocket

**Food (12):** apple, banana, pizza, cake, iceCream, burger, donut, watermelon, cupcake, strawberry, lollipop, star

**Furniture (8):** chair, table, bed, sofa, lamp, mirror, shelf, door

---

### DaliEffects

Animated particle overlay. Place in a `Stack` over any content.

```dart
Stack(
  children: [
    DaliScene(config: sceneConfig),
    DaliAvatar(config: avatarConfig, size: 200),
    const DaliEffects(type: ParticleType.confetti),
  ],
)
```

**Particle types:** confetti, sparkles, bubbles, stars, hearts, snow

```dart
DaliEffects(
  type: ParticleType.hearts,
  color: Colors.pink,
  speed: 1.5,   // animation speed multiplier
  loop: true,
)
```

---

### DaliBadge

Achievement badge with an animated bounce-in reveal.

```dart
DaliBadge(
  type: BadgeType.star,
  size: 120,
  color: Color(0xFFFFD600),
  animate: true,   // plays bounce-in on first display
)
```

**Badge types:** star, trophy, ribbon, medal, shield, crown, heart, diamond

Use a `ValueKey` to replay the animation:
```dart
DaliBadge(
  key: ValueKey(replayCount),
  type: BadgeType.trophy,
  size: 120,
  color: Colors.amber,
)
```

---

## Palettes

```dart
// Skin tones (12 inclusive shades)
SkinTones.all       // List<Color>
SkinTones.porcelain
SkinTones.cream
SkinTones.ivory
SkinTones.beige
SkinTones.sand
SkinTones.tan
SkinTones.caramel
SkinTones.bronze
SkinTones.chestnut
SkinTones.mocha
SkinTones.espresso
SkinTones.ebony

// Hair colours (20 — 12 natural + 8 fantasy)
HairColors.all
HairColors.jetBlack
HairColors.darkBrown
HairColors.mediumBrown
HairColors.lightBrown
HairColors.auburn
HairColors.copper
HairColors.golden
HairColors.strawberry
HairColors.platinum
HairColors.silver
HairColors.white
HairColors.grey
// Fantasy:
HairColors.rose
HairColors.lavender
HairColors.skyBlue
HairColors.mint
HairColors.coral
HairColors.violet
HairColors.electric
HairColors.rainbow
```

---

## Architecture

```
dali/
  lib/
    dali.dart                      ← public API barrel export

    src/
      painters/
        body_painter.dart          ← head, neck, torso, arms, legs
        hair_painter.dart          ← 12 hair styles as Path objects
        face_painter.dart          ← eyes, brows, nose, mouth, blush
        clothing_painter.dart      ← 8 clothing items with shading
        sky_painter.dart           ← gradient sky, sun/moon, clouds, stars, weather
        scene_painter.dart         ← 10 full scene types
        animal_painter.dart        ← 10 animals
        vehicle_painter.dart       ← 6 vehicles
        food_painter.dart          ← 12 food items
        furniture_painter.dart     ← 8 furniture items
        particle_painter.dart      ← 6 animated particle types
        badge_painter.dart         ← 8 achievement badge designs

      widgets/
        dali_avatar.dart           ← DaliAvatar widget
        dali_scene.dart            ← DaliScene widget
        dali_object.dart           ← DaliObject widget (animals/vehicles/food/furniture)
        dali_effects.dart          ← DaliEffects animated particle widget
        dali_badge.dart            ← DaliBadge animated badge widget

      models/
        avatar_config.dart         ← AvatarConfig, HairConfig, FaceConfig, ClothingConfig
        scene_config.dart          ← SceneConfig, SceneType, DayTime, Weather
        object_config.dart         ← AnimalType, VehicleType, FoodType, FurnitureType
        effects_config.dart        ← ParticleType, BadgeType

      palettes/
        skin_tones.dart
        hair_colors.dart

  example/
    lib/main.dart                  ← 4-tab showcase app
```

---

## Key Design Principles

1. **Zero assets** — no PNG, SVG, or font files
2. **Parameter-driven** — every visual controlled by typed config objects
3. **Composable** — painters layer like Photoshop layers inside a `Stack`
4. **Height-based sizing** — detail elements use `sz.height * scale` so proportions stay correct at any aspect ratio
5. **Animatable** — any parameter can be driven by an `AnimationController`
6. **Standalone** — no dependencies beyond Flutter itself

---

## Running the Example App

```bash
cd example
flutter pub get
flutter run -d chrome    # web
flutter run              # connected device
```

---

## Repo

[github.com/ushanboe/dali](https://github.com/ushanboe/dali)
