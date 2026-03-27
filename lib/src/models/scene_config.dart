enum SceneType {
  bedroom,
  kitchen,
  park,
  beach,
  city,
  forest,
  classroom,
  salon,
  space,
  underwater,
}

enum DayTime { dawn, day, dusk, night }

enum Weather { clear, cloudy, rainy, snowy }

class SceneConfig {
  final SceneType type;
  final DayTime timeOfDay;
  final Weather weather;

  const SceneConfig({
    this.type = SceneType.park,
    this.timeOfDay = DayTime.day,
    this.weather = Weather.clear,
  });

  SceneConfig copyWith({SceneType? type, DayTime? timeOfDay, Weather? weather}) {
    return SceneConfig(
      type: type ?? this.type,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      weather: weather ?? this.weather,
    );
  }

  bool get isOutdoor => const {
    SceneType.park, SceneType.beach, SceneType.city, SceneType.forest,
  }.contains(type);

  bool get isIndoor => const {
    SceneType.bedroom, SceneType.kitchen, SceneType.classroom, SceneType.salon,
  }.contains(type);
}
