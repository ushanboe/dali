# Dali — Procedural Graphics Engine for Flutter
**Version:** 1.0
**Status:** Phases 1–4 complete. Phase 5 (tateru integration) next.
**Repo:** github.com/ushanboe/dali

---

## What Is Dali?

Dali is a standalone Flutter package that generates images, characters, scenes, and visual assets **entirely in code** — no PNG files, no external APIs, no runtime costs.

Any Flutter app that needs visual content (characters, backgrounds, icons, avatars, illustrations) imports Dali and calls a painter or widget instead of loading an image asset.

Named after Salvador Dalí — art created from imagination, not photographs.

---

## The Problem It Solves

AI app builders (like tateru) can generate code but cannot generate image files. This blocks an entire category of apps:

- Kids games (characters, animals, environments)
- Dress-up / customisation apps
- Avatar creators
- Illustrated education apps
- Visual health/fitness apps
- Creative tools

Dali eliminates this blocker entirely. Every visual element is a `CustomPainter` or `Widget` — drawn at runtime from parameters, infinite resolution, zero asset files.

---

## Key Principles

1. **Zero assets** — no PNG, SVG, or font files required
2. **Parameter-driven** — every visual is controlled by typed parameters (color, style, size, expression)
3. **Composable** — painters layer on top of each other like Photoshop layers
4. **Animatable** — any parameter can be driven by an `AnimationController`
5. **Standalone** — no dependency on tateru, works in any Flutter project
6. **Pub.dev ready** — structured to be publishable as an open-source package

---

## Architecture

```
dali/
  lib/
    dali.dart                      ← barrel export (public API)

    src/
      painters/
        body_painter.dart          ← head, neck, torso, arms, legs, skin tone
        hair_painter.dart          ← 12 hair styles as Path objects
        face_painter.dart          ← eyes (6 shapes), brows, nose, mouth (6 expressions), blush
        clothing_painter.dart      ← 8 clothing items with shading & details
        sky_painter.dart           ← sky gradient, sun/moon, clouds, stars, rain, snow
        scene_painter.dart         ← 10 full scene types
        animal_painter.dart        ← 10 cartoon animals
        vehicle_painter.dart       ← 6 cartoon vehicles
        food_painter.dart          ← 12 food items
        furniture_painter.dart     ← 8 furniture/room items
        particle_painter.dart      ← 6 animated particle effects
        badge_painter.dart         ← 8 achievement badge designs

      widgets/
        dali_avatar.dart           ← DaliAvatar (two-pass hair compositing)
        dali_scene.dart            ← DaliScene
        dali_object.dart           ← DaliObject (.animal / .vehicle / .food / .furniture)
        dali_effects.dart          ← DaliEffects (AnimationController-driven particles)
        dali_badge.dart            ← DaliBadge (bounce-in reveal animation)

      models/
        avatar_config.dart         ← AvatarConfig, HairConfig, FaceConfig, ClothingConfig
        scene_config.dart          ← SceneConfig, SceneType, DayTime, Weather
        object_config.dart         ← AnimalType, VehicleType, FoodType, FurnitureType
        effects_config.dart        ← ParticleType, BadgeType

      palettes/
        skin_tones.dart            ← 12 inclusive skin tones
        hair_colors.dart           ← 12 natural + 8 fantasy colours

  example/
    lib/main.dart                  ← 4-tab showcase app (Avatar, Scenes, Objects, Effects)
```

---

## Phase 1 — Foundation ✅ COMPLETE

**Goal:** Core character system.

| Component | Status | Detail |
|---|---|---|
| `BodyPainter` | ✅ | Head, neck, torso, arms, legs with gradients |
| `HairPainter` | ✅ | 12 styles as Path objects, two-pass clip compositing |
| `FacePainter` | ✅ | 6 eye shapes, 6 expressions, blush |
| `ClothingPainter` | ✅ | 8 items with shading, buttons, details |
| `DaliAvatar` widget | ✅ | Two-pass clipRect hair layering |
| `AvatarConfig` model | ✅ | Typed config — skinTone, HairConfig, FaceConfig, ClothingConfig |
| `SkinTones` palette | ✅ | 12 inclusive skin tones |
| `HairColors` palette | ✅ | 20 natural + fantasy colours |
| Example app — Avatar tab | ✅ | Live customiser with colour pickers |

### Hair Styles
`shortStraight`, `shortCurly`, `mediumStraight`, `mediumWavy`, `longStraight`, `longCurly`, `bob`, `ponytail`, `bun`, `braids`, `afro`, `pixie`

### Expressions
`neutral`, `happy`, `excited`, `sad`, `surprised`, `thinking`

### Key Technical Decision — Two-Pass Hair Rendering
Hair layering solved with canvas clip regions:
1. Pass 1 — clip to `y > 15%` → draws hair sides/back behind body
2. Body + clothing drawn over
3. Pass 2 — clip to `y < 28%` → draws hair crown cap on top
4. Face drawn last (always on top)

---

## Phase 2 — Environments ✅ COMPLETE

**Goal:** Scene backgrounds for games and story apps.

| Component | Status | Detail |
|---|---|---|
| `SkyPainter` | ✅ | 4 sky gradients, sun/moon, clouds, stars, rain, snow |
| `ScenePainter` | ✅ | 10 scene types, height-based `u()` sizing unit |
| `DaliScene` widget | ✅ | Drop-in background widget |
| `SceneConfig` model | ✅ | SceneType, DayTime, Weather |
| Example app — Scenes tab | ✅ | 16:9 constrained preview with avatar overlay |

### Scene Types
`park`, `beach`, `city`, `forest`, `bedroom`, `kitchen`, `classroom`, `salon`, `space`, `underwater`

### Key Technical Decision — Height-Based Sizing
All detail element sizes use `sz.height * scale` (not `sz.width * scale`). This prevents giant trees/fish/flowers at wide aspect ratios (e.g. full-browser-width on web).

---

## Phase 3 — Objects & Props ✅ COMPLETE

**Goal:** Objects that appear in scenes and games.

| Component | Status | Detail |
|---|---|---|
| `AnimalPainter` | ✅ | 10 animals, colour-customisable |
| `VehiclePainter` | ✅ | 6 vehicles, colour-customisable |
| `FoodPainter` | ✅ | 12 food items |
| `FurniturePainter` | ✅ | 8 furniture items, colour-customisable |
| `DaliObject` widget | ✅ | Factory constructors: `.animal`, `.vehicle`, `.food`, `.furniture` |
| Example app — Objects tab | ✅ | Grid pickers + colour pickers + large preview |

### Animals
`cat`, `dog`, `rabbit`, `bird`, `fish`, `bear`, `fox`, `penguin`, `elephant`, `lion`

### Vehicles
`car`, `bus`, `bike`, `plane`, `boat`, `rocket`

### Food
`apple`, `banana`, `pizza`, `cake`, `iceCream`, `burger`, `donut`, `watermelon`, `cupcake`, `strawberry`, `lollipop`, `star`

### Furniture
`chair`, `table`, `bed`, `sofa`, `lamp`, `mirror`, `shelf`, `door`

---

## Phase 4 — Effects & Polish ✅ COMPLETE

**Goal:** Visual effects that make apps feel alive.

| Component | Status | Detail |
|---|---|---|
| `ParticlePainter` | ✅ | 6 particle types driven by `time` (0.0–1.0) |
| `DaliEffects` widget | ✅ | `AnimationController`-driven looping overlay |
| `BadgePainter` | ✅ | 8 achievement badge designs with glow |
| `DaliBadge` widget | ✅ | Bounce-in scale/fade reveal animation |
| Hair style fixes | ✅ | Bob and Ponytail paths rebuilt with correct proportions |
| Example app — Effects tab | ✅ | Live particles, scene overlay, badge gallery with replay |

### Particle Types
`confetti`, `sparkles`, `bubbles`, `stars`, `hearts`, `snow`

### Badge Types
`star`, `trophy`, `ribbon`, `medal`, `shield`, `crown`, `heart`, `diamond`

### Key Technical Decision — Sin-Hash RNG
Particles use `(sin(seed * 127.1 + 311.7) * 43758.5453).abs() % 1.0` for deterministic pseudo-random positions. This provides well-distributed spread across the canvas — an LCG (linear congruential generator) was initially used but produced values clustered near 0.5 for small sequential seeds.

---

## Phase 5 — tateru Integration ⏳ NEXT

**Goal:** Make tateru automatically use Dali for visual apps.

| Change | File | Detail |
|---|---|---|
| Add Dali to monorepo | `packages/dali/` | Symlink or copy as local package |
| DocTor injection | `DocTorAgent.ts` | When app is visual/game type, add Dali usage instructions to build spec |
| Bob awareness | `BobTheBuilderAgent.ts` | Import Dali in pubspec.yaml, use painters instead of `Image.asset()` |
| Golden references | `agents/bob-the-builder/references/` | 10–15 example apps built with Dali |
| Agent Orange | `AgentOrangeAgent.ts` | Loosen `image_asset_crash` check when Dali is imported |
| App type detection | `DocTorAgent.ts` | Detect keywords: avatar, character, dress-up, salon, game, kids, creative |

### Integration pubspec.yaml (tateru projects)
```yaml
dependencies:
  dali:
    path: ../../../../packages/dali
```

---

## Technical Approach

### CustomPainter Layering
```dart
Stack(
  children: [
    DaliScene(config: sceneConfig),
    DaliAvatar(config: avatarConfig, size: 200),
    DaliEffects(type: ParticleType.confetti),
  ],
)
```

### Object Placement
```dart
DaliObject.animal(AnimalType.cat, size: 120, color: Colors.orange)
DaliObject.food(FoodType.pizza, size: 100)
```

### Badge Reveal
```dart
DaliBadge(
  key: ValueKey(replayCount),
  type: BadgeType.star,
  size: 120,
  color: Color(0xFFFFD600),
)
```

### Path-Based Shapes
All hair, clothing, animals, vehicles, and badges are defined as `Path` objects:
- Infinite resolution (no pixelation at any size)
- Dynamic colour fill
- Gradient support
- Clip masks for complex overlapping shapes

### Coordinate System
All painters use normalised 0.0–1.0 space, scaled to actual `Size` at paint time. Detail element sizing uses `sz.height * scale` (height-based units) to prevent distortion at wide aspect ratios.

---

## Success Criteria

### Phase 1–4 Done ✅
- [x] `DaliAvatar` renders a recognisable human character
- [x] All 12 hair styles visually distinct and correct
- [x] All 6 expressions clear and readable at 200×200px
- [x] 10 scene types with time-of-day and weather variation
- [x] 36 objects across 4 categories (animals, vehicles, food, furniture)
- [x] 6 animated particle effects running at 60fps
- [x] 8 achievement badges with animated reveal
- [x] No image asset files anywhere in the package
- [x] Example app runs on web and mobile

### Full v1.0 Done When:
- [ ] Phase 5 (tateru integration) complete
- [ ] tateru automatically uses Dali for visual apps
- [ ] 5+ different app types buildable that previously failed due to asset requirements
- [ ] Package passes `flutter analyze` with zero issues
- [ ] Published to pub.dev

---

## What Dali Unlocks for tateru

| App Category | Previously | With Dali |
|---|---|---|
| Kids hair/dress-up games | Blocked | ✅ Buildable |
| Avatar creators | Blocked | ✅ Buildable |
| Character-based education | Blocked | ✅ Buildable |
| Animal/pet games | Blocked | ✅ Buildable |
| Scene-based story apps | Blocked | ✅ Buildable |
| Visual reward/badge systems | Partial | ✅ Full |
| Any app needing illustrations | Blocked | ✅ Buildable |

---

## Open Source Potential

Dali is independently useful to any Flutter developer who wants:
- Procedural character generation
- No-asset illustration system
- Parameterised visual components

Could be published to **pub.dev** as `dali` or `flutter_dali` — with the tateru integration as a bonus feature.
