import 'package:my_fit_journey/models/exercise.dart';

class FreeWeightExercise extends WeightExercise {
  FreeWeightExercise({
    required super.title,
    required super.description,
    required super.bodyParts,
    required super.photos,
    required super.weightUnit,
    required super.minWeight,
    required super.maxWeight,
    required super.weightStep,
    super.type = ExerciseType.machineWeight,
    super.id,
  });

  FreeWeightExercise.empty() : super.empty(ExerciseType.freeWeight);

  FreeWeightExercise.fromJson(super.json) : super.fromJson();
}
