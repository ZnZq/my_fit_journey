import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/models/exercise.dart';

class FreeWeightExercise extends Exercise {
  WeightUnit weightUnit = WeightUnit.kg;
  double minWeight = 0;
  double maxWeight = 0;
  double weightStep = 0.0;

  FreeWeightExercise({
    required super.title,
    required super.description,
    required super.bodyParts,
    required super.photos,
    required this.weightUnit,
    super.type = ExerciseType.freeWeight,
    super.id,
  });

  FreeWeightExercise.empty() : super.empty(ExerciseType.freeWeight);

  FreeWeightExercise.fromJson(super.json)
      : weightUnit = WeightUnit.values[json['weightUnit'] ?? 0],
        minWeight = json['minWeight'] ?? 0.0,
        maxWeight = json['maxWeight'] ?? 0.0,
        weightStep = json['weightStep'] ?? 0.0,
        super.fromJson();

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'weightUnit': weightUnit.index,
      'minWeight': minWeight,
      'maxWeight': maxWeight,
      'weightStep': weightStep,
    };
  }
}
