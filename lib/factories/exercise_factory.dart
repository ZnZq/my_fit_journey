import 'package:flutter/foundation.dart';
import 'package:my_fit_journey/models/body_weight_exercise.dart';
import 'package:my_fit_journey/models/cardio_machine_exercise.dart';
import 'package:my_fit_journey/models/exercise.dart';
import 'package:my_fit_journey/models/free_weight_exercise.dart';
import 'package:my_fit_journey/models/machine_weight_exercise.dart';
import 'package:my_fit_journey/models/other_exercise.dart';
import 'package:my_fit_journey/models/swimming_exercise.dart';

class ExerciseFactory {
  static Exercise? fromJson(Map json) {
    switch (ExerciseType.values[json['type'] ?? -1]) {
      case ExerciseType.machineWeight:
        return MachineWeightExercise.fromJson(json);
      case ExerciseType.freeWeight:
        return FreeWeightExercise.fromJson(json);
      case ExerciseType.bodyWeight:
        return BodyWeightExercise.fromJson(json);
      case ExerciseType.cardioMachine:
        return CardioMachineExercise.fromJson(json);
      case ExerciseType.swimming:
        return SwimmingExercise.fromJson(json);
      case ExerciseType.other:
        return OtherExercise.fromJson(json);
      default:
        if (kDebugMode) {
          print('Unknown exercise type ${json['type']}');
        }
        return null;
    }
  }
}
