import 'package:my_fit_journey/models/exercise.dart';

class MachineWeightExercise extends WeightExercise {
  MachineWeightExercise({
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

  MachineWeightExercise.empty() : super.empty(ExerciseType.machineWeight);

  MachineWeightExercise.fromJson(super.json) : super.fromJson();
}
