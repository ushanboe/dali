# Dali Showcase App

Interactive demo for the [Dali](https://github.com/ushanboe/dali) Flutter package.
Demonstrates all four component categories across four tabs — no image assets used anywhere.

## Tabs

| Tab | What It Shows |
|---|---|
| **Avatar** | Live avatar customiser — skin tone, 12 hair styles, hair colour, 6 expressions, 6 eye shapes, 8 clothing items, blush toggle |
| **Scenes** | 10 scene types × 4 times of day × 4 weather conditions — 16:9 constrained preview with avatar overlay |
| **Objects** | 36 objects across animals, vehicles, food, and furniture — grid pickers with colour customisation |
| **Effects** | 6 animated particle overlays + 8 achievement badges with bounce-in animation |

## Running

```bash
flutter pub get
flutter run -d chrome   # web
flutter run             # connected Android/iOS device
```

## Usage Examples From This App

```dart
// Avatar
DaliAvatar(config: AvatarConfig(
  skinTone: SkinTones.tan,
  hair: HairConfig(style: HairStyle.longCurly, color: HairColors.auburn),
  face: FaceConfig(expression: FaceExpression.happy, blush: true),
  clothing: ClothingConfig(item: ClothingItem.dress, primaryColor: Color(0xFFE91E8C)),
), size: 180)

// Scene with avatar overlay
Stack(children: [
  DaliScene(config: SceneConfig(type: SceneType.beach, timeOfDay: DayTime.dusk)),
  Positioned(bottom: 0, child: DaliAvatar(config: avatarConfig, size: 140)),
])

// Object
DaliObject.animal(AnimalType.cat, size: 120, color: Colors.orange)

// Particles over a scene
Stack(children: [
  DaliScene(config: sceneConfig),
  DaliEffects(type: ParticleType.confetti),
])

// Badge with animation
DaliBadge(type: BadgeType.star, size: 120, color: Color(0xFFFFD600))
```
