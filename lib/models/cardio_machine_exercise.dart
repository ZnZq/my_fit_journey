import 'package:my_fit_journey/models/exercise.dart';

class CardioMachineExercise extends Exercise {
  double minSpeed = 0;
  double maxSpeed = 0;
  double speedStep = 0.0;
  int minIntensity = 0;
  int maxIntensity = 0;
  int intensityStep = 0;

  CardioMachineExercise({
    required super.title,
    required super.description,
    required super.bodyParts,
    required super.photos,
    required this.minSpeed,
    required this.maxSpeed,
    required this.speedStep,
    required this.minIntensity,
    required this.maxIntensity,
    required this.intensityStep,
    super.type = ExerciseType.cardioMachine,
    super.id,
  });

  CardioMachineExercise.empty() : super.empty(ExerciseType.cardioMachine);

  CardioMachineExercise.fromJson(super.json)
      : minSpeed = json['minSpeed'] ?? 0.0,
        maxSpeed = json['maxSpeed'] ?? 0.0,
        speedStep = json['speedStep'] ?? 0.0,
        minIntensity = json['minIntensity'] ?? 0,
        maxIntensity = json['maxIntensity'] ?? 0,
        intensityStep = json['intensityStep'] ?? 0,
        super.fromJson();

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'minSpeed': minSpeed,
      'maxSpeed': maxSpeed,
      'speedStep': speedStep,
      'minIntensity': minIntensity,
      'maxIntensity': maxIntensity,
      'intensityStep': intensityStep,
    };
  }
}
