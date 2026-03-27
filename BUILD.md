# Dali — Procedural Graphics Engine for Flutter
**Version:** 1.0
**Status:** Planning
**Date:** 2026-03-28
**Repo:** github.com/bobbotboe/dali

---

## What Is Dali?

Dali is a standalone Flutter package that generates images, characters, scenes, and visual assets **entirely in code** — no PNG files, no external APIs, no runtime costs.

Any Flutter app that needs visual content (characters, backgrounds, icons, avatars, illustrations) imports Dali and calls a painter or generator instead of loading an image asset.

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
    dali.dart                  ← barrel export (public API)

    src/
      painters/                ← raw CustomPainter implementations
        base/
          avatar_painter.dart
          hair_painter.dart
          body_painter.dart
          face_painter.dart
          clothing_painter.dart

        environment/
          background_painter.dart
          ground_painter.dart
          sky_painter.dart

        objects/
          animal_painter.dart
          vehicle_painter.dart
          food_painter.dart
          icon_painter.dart

        effects/
          particle_painter.dart
          glow_painter.dart
          shadow_painter.dart

      generators/              ← high-level composition helpers
        avatar_generator.dart  ← full character from parts
        scene_generator.dart   ← background + foreground composition
        icon_generator.dart    ← dynamic app-style icons
        badge_generator.dart   ← achievement/reward badges

      widgets/                 ← drop-in Flutter widgets
        dali_avatar.dart       ← Avatar widget with all options
        dali_scene.dart        ← Full scene widget
        dali_icon.dart         ← Icon widget
        dali_badge.dart        ← Badge/achievement widget
        dali_canvas.dart       ← Raw canvas widget for custom use

      models/                  ← typed parameter models
        avatar_config.dart
        hair_config.dart
        clothing_config.dart
        scene_config.dart
        color_palette.dart

      palettes/                ← predefined colour palettes
        skin_tones.dart        ← 12 inclusive skin tones
        hair_colors.dart       ← natural + fantasy colors
        material_colors.dart   ← UI-safe color sets

  test/
    painters/
    generators/
    widgets/

  example/
    lib/
      main.dart               ← showcase app demonstrating all components
```

---

## Phase 1 — Foundation (MVP)

**Goal:** Core character system. Enough for a hair salon, dress-up, or avatar app.

### Deliverables

| Component | Description |
|---|---|
| `AvatarPainter` | Base human figure — head, body, proportions. Skin tone parameter. |
| `HairPainter` | 12 hair styles drawn as `Path` objects. Color + highlight parameters. |
| `FacePainter` | Eyes (6 shapes), eyebrows, nose, mouth (6 expressions), blush |
| `ClothingPainter` | 8 clothing items — tops, dresses. Color + pattern parameters. |
| `DaliAvatar` widget | Composes all painters. Single widget, full character. |
| `AvatarConfig` model | Typed config object passed to the widget |
| `SkinTones` palette | 12 inclusive skin tones |
| `HairColors` palette | 20 natural + fantasy colors |
| Example app | Interactive demo — tap to change styles |

### Hair Styles (Phase 1)
`short_straight`, `short_curly`, `medium_straight`, `medium_wavy`, `long_straight`, `long_curly`, `bob`, `ponytail`, `bun`, `braids`, `afro`, `pixie`

### Expressions (Phase 1)
`neutral`, `happy`, `excited`, `sad`, `surprised`, `thinking`

---

## Phase 2 — Environments

**Goal:** Scene backgrounds and environments for games and story apps.

### Deliverables

| Component | Description |
|---|---|
| `BackgroundPainter` | Gradient sky, horizon, ground — time-of-day parameter |
| `SkyPainter` | Sun, moon, stars, clouds — all drawn in code |
| `GroundPainter` | Grass, sand, snow, water, city floor |
| `DaliScene` widget | Composes background layers |
| `SceneConfig` model | Time of day, weather, environment type |

### Scene Types (Phase 2)
`bedroom`, `kitchen`, `park`, `beach`, `city`, `forest`, `classroom`, `salon`, `space`, `underwater`

---

## Phase 3 — Objects & Props

**Goal:** Objects that appear in scenes and games.

### Deliverables

| Component | Description |
|---|---|
| `AnimalPainter` | 10 animals — cat, dog, rabbit, bird, fish, bear, fox, penguin, elephant, lion |
| `VehiclePainter` | 6 vehicles — car, bus, bike, plane, boat, rocket |
| `FoodPainter` | 12 food items — fruit, cake, pizza, ice cream etc |
| `FurniturePainter` | 8 items — chair, table, bed, sofa, lamp, mirror, shelf, door |
| `DaliIcon` widget | Dynamic app-style icon from any painter |

---

## Phase 4 — Effects & Polish

**Goal:** Visual effects that make apps feel alive.

### Deliverables

| Component | Description |
|---|---|
| `ParticlePainter` | Confetti, sparkles, bubbles, snow, rain, stars |
| `GlowPainter` | Soft glow/aura around any element |
| `ShadowPainter` | Drop shadow for any painted element |
| `BadgeGenerator` | Achievement badges — stars, ribbons, seals |
| `DaliBadge` widget | Animated badge reveal widget |
| Animation helpers | `DaliAnimated` — wraps any painter with animation |

---

## Phase 5 — tateru Integration

**Goal:** Make tateru automatically use Dali for visual apps.

### Changes to tateru

| Change | File | Detail |
|---|---|---|
| Add Dali to monorepo | `packages/dali/` | Symlink or copy as local package |
| DocTor injection | `DocTorAgent.ts` | When app is visual/game type, add Dali usage instructions to build spec |
| Bob awareness | `BobTheBuilderAgent.ts` | Import Dali in pubspec.yaml, use painters instead of Image.asset() |
| Golden references | `agents/bob-the-builder/references/` | 10-15 example apps built with Dali |
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
    CustomPaint(painter: BackgroundPainter(config.scene)),
    CustomPaint(painter: BodyPainter(config.avatar)),
    CustomPaint(painter: ClothingPainter(config.clothing)),
    CustomPaint(painter: HairPainter(config.hair)),
    CustomPaint(painter: FacePainter(config.face)),
    CustomPaint(painter: EffectPainter(config.effects)),
  ],
)
```

### Animation
```dart
DaliAnimated(
  painter: HairPainter(config),
  animation: controller,    // AnimationController
  tweens: { 'color': ColorTween(begin: Colors.brown, end: Colors.red) },
)
```

### Path-based Shapes
All hair styles, clothing, and characters are defined as `Path` objects — meaning:
- Infinite resolution (no pixelation at any size)
- Dynamic color fill
- Gradient support
- Clip masks for complex overlapping shapes

---

## Success Criteria

### Phase 1 Done When:
- [ ] `DaliAvatar` renders a recognisable human character
- [ ] All 12 hair styles visually distinct and correct
- [ ] All 6 expressions clear and readable at 200x200px
- [ ] Color changes apply in real-time (no rebuild)
- [ ] Example app runs on Android without any image assets
- [ ] A hair salon demo app can be built using only Dali + Flutter widgets

### Full v1.0 Done When:
- [ ] All 4 phases complete
- [ ] tateru automatically uses Dali for visual apps
- [ ] 5+ different app types buildable that previously failed due to asset requirements
- [ ] Package passes `flutter analyze` with zero issues
- [ ] Published to pub.dev

---

## What Dali Unlocks for tateru

| App Category | Previously | With Dali |
|---|---|---|
| Kids hair/dress-up games | Blocked | Buildable |
| Avatar creators | Blocked | Buildable |
| Character-based education | Blocked | Buildable |
| Animal/pet games | Blocked | Buildable |
| Scene-based story apps | Blocked | Buildable |
| Visual reward/badge systems | Partial | Full |
| Any app needing illustrations | Blocked | Buildable |

---

## Open Source Potential

Dali is independently useful to any Flutter developer who wants:
- Procedural character generation
- No-asset illustration system
- Parameterised visual components

Could be published to **pub.dev** as `dali` or `flutter_dali` — with the tateru integration as a bonus feature. This would also serve as marketing for the tateru platform.

---

## Notes & Decisions

- Flutter `Canvas` API is the foundation — no third-party rendering dependencies
- All paths hand-authored or traced from reference silhouettes
- `shouldRepaint` optimised per painter — only repaints on relevant config change
- Coordinate system normalised to 1.0x1.0 space, scaled to actual size at paint time (makes path reuse trivial)
- Phase 1 targets Android; web/iOS compatibility validated in Phase 4
