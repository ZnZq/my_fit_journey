import 'package:flutter/foundation.dart';
import 'package:my_fit_journey/models/program.dart';

class ProgramExerciseFactory {
  static ProgramExercise? fromJson(Map json) {
    switch (ProgramExerciseType.values[json['type'] ?? -1]) {
      case ProgramExerciseType.machineWeight:
        return ProgramMachineWeightExercise.fromJson(json);
      case ProgramExerciseType.freeWeight:
        return ProgramFreeWeightExercise.fromJson(json);
      case ProgramExerciseType.bodyWeight:
        return ProgramBodyWeightExercise.fromJson(json);
      case ProgramExerciseType.cardioMachine:
        return ProgramCardioMachineExercise.fromJson(json);
      case ProgramExerciseType.swimming:
        return ProgramSwimmingExercise.fromJson(json);
      case ProgramExerciseType.other:
        return ProgramOtherExercise.fromJson(json);
      case ProgramExerciseType.complex:
        return ProgramComplexExercise.fromJson(json);
      default:
        if (kDebugMode) {
          print('Unknown exercise type ${json['type']}');
        }
        return null;
    }
  }
}
