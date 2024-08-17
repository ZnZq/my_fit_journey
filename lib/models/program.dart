import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/factories/program_exercise_factory.dart';
import 'package:my_fit_journey/models/body_part.dart';
import 'package:my_fit_journey/models/exercise.dart';
import 'package:my_fit_journey/storage/storage.dart';

class Program {
  late final String id;

  String name = '';
  String description = '';
  List<ProgramExercise> exercises = [];

  Program({
    required this.name,
    required this.description,
    required this.exercises,
    String? id,
  }) {
    this.id = id ?? uuid.v4();
  }

  Program.empty() {
    id = uuid.v4();
  }

  Program.fromJson(Map json) {
    id = json['id'] ?? uuid.v4();
    name = json['name'] ?? '';
    description = json['description'] ?? '';
    exercises = ((json['exercises'] ?? []) as List<Map>)
        .map((e) => ProgramExerciseFactory.fromJson(e))
        .where((e) => e != null)
        .toList()
        .cast();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }

  Set<BodyPart> getBodyParts() {
    final bodyParts = <BodyPart>{};

    for (final exercise in exercises) {
      bodyParts.addAll(exercise.getBodyParts());
    }

    return bodyParts;
  }
}

enum ProgramExerciseType<int> {
  complex,
  machineWeight,
  freeWeight,
  bodyWeight,
  cardioMachine,
  swimming,
  other
}

extension ProgramExerciseTypeExtension on ProgramExerciseType {
  ExerciseType? get exerciseType {
    switch (this) {
      case ProgramExerciseType.machineWeight:
        return ExerciseType.machineWeight;
      case ProgramExerciseType.freeWeight:
        return ExerciseType.freeWeight;
      case ProgramExerciseType.bodyWeight:
        return ExerciseType.bodyWeight;
      case ProgramExerciseType.cardioMachine:
        return ExerciseType.cardioMachine;
      case ProgramExerciseType.swimming:
        return ExerciseType.swimming;
      case ProgramExerciseType.other:
        return ExerciseType.other;
      default:
        return null;
    }
  }
}

abstract class ProgramExercise {
  final ProgramExerciseType type;

  ProgramExercise({
    required this.type,
  });

  ProgramExercise.fromJson(Map json)
      : type = ProgramExerciseType.values[json['type'] ?? 0];

  Map<String, dynamic> toJson() {
    return {
      'type': type.index,
    };
  }

  Set<BodyPart> getBodyParts();
}

class ProgramOtherExercise extends ProgramExercise {
  final String exerciseId;

  ProgramOtherExercise({
    required this.exerciseId,
  }) : super(type: ProgramExerciseType.other);

  ProgramOtherExercise.fromJson(super.json)
      : exerciseId = json['exerciseId'] ?? '',
        super.fromJson();

  @override
  Set<BodyPart> getBodyParts() {
    final exercise = Storage.exerciseStorage.getByKey(exerciseId);
    return exercise?.bodyParts.toSet() ?? {};
  }
}

class ProgramSwimmingExercise extends ProgramExercise {
  final String exerciseId;

  ProgramSwimmingExercise({
    required this.exerciseId,
  }) : super(type: ProgramExerciseType.swimming);

  ProgramSwimmingExercise.fromJson(super.json)
      : exerciseId = json['exerciseId'] ?? '',
        super.fromJson();

  @override
  Set<BodyPart> getBodyParts() {
    final exercise = Storage.exerciseStorage.getByKey(exerciseId);
    return exercise?.bodyParts.toSet() ?? {};
  }
}

class ProgramCardioMachineExercise extends ProgramExercise {
  final String exerciseId;
  final double speed;
  final int intensity;

  ProgramCardioMachineExercise({
    required this.exerciseId,
    required this.speed,
    required this.intensity,
  }) : super(type: ProgramExerciseType.cardioMachine);

  ProgramCardioMachineExercise.fromJson(super.json)
      : exerciseId = json['exerciseId'] ?? '',
        speed = json['speed'] ?? 0.0,
        intensity = json['intensity'] ?? 0,
        super.fromJson();

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'exerciseId': exerciseId,
      'speed': speed,
      'intensity': intensity,
    };
  }

  @override
  Set<BodyPart> getBodyParts() {
    final exercise = Storage.exerciseStorage.getByKey(exerciseId);
    return exercise?.bodyParts.toSet() ?? {};
  }
}

class ProgramBodyWeightExercise extends ProgramExercise {
  final String exerciseId;

  ProgramBodyWeightExercise({
    required this.exerciseId,
  }) : super(type: ProgramExerciseType.bodyWeight);

  ProgramBodyWeightExercise.fromJson(super.json)
      : exerciseId = json['exerciseId'] ?? '',
        super.fromJson();

  @override
  Set<BodyPart> getBodyParts() {
    final exercise = Storage.exerciseStorage.getByKey(exerciseId);
    return exercise?.bodyParts.toSet() ?? {};
  }
}

class ProgramFreeWeightExercise extends ProgramExercise {
  final String exerciseId;
  final int sets;
  final int reps;
  final int rest;
  final double weight;
  final WeightUnit weightUnit;

  ProgramFreeWeightExercise({
    required this.exerciseId,
    required this.sets,
    required this.reps,
    required this.rest,
    required this.weight,
    required this.weightUnit,
  }) : super(type: ProgramExerciseType.freeWeight);

  ProgramFreeWeightExercise.fromJson(super.json)
      : exerciseId = json['exerciseId'] ?? '',
        sets = json['sets'] ?? 0,
        reps = json['reps'] ?? 0,
        rest = json['rest'] ?? 0,
        weight = json['weight'] ?? 0.0,
        weightUnit =
            WeightUnit.values[json['weightUnit'] ?? WeightUnit.kg.index],
        super.fromJson();

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'exerciseId': exerciseId,
      'sets': sets,
      'reps': reps,
      'rest': rest,
      'weight': weight,
      'weightUnit': weightUnit.index,
    };
  }

  @override
  Set<BodyPart> getBodyParts() {
    final exercise = Storage.exerciseStorage.getByKey(exerciseId);
    return exercise?.bodyParts.toSet() ?? {};
  }
}

class ProgramMachineWeightExercise extends ProgramExercise {
  final String exerciseId;
  final int sets;
  final int reps;
  final int rest;
  final double weight;
  final WeightUnit weightUnit;

  ProgramMachineWeightExercise({
    required this.exerciseId,
    required this.sets,
    required this.reps,
    required this.rest,
    required this.weight,
    required this.weightUnit,
  }) : super(type: ProgramExerciseType.machineWeight);

  ProgramMachineWeightExercise.fromJson(super.json)
      : exerciseId = json['exerciseId'] ?? '',
        sets = json['sets'] ?? 0,
        reps = json['reps'] ?? 0,
        rest = json['rest'] ?? 0,
        weight = json['weight'] ?? 0.0,
        weightUnit =
            WeightUnit.values[json['weightUnit'] ?? WeightUnit.kg.index],
        super.fromJson();

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'exerciseId': exerciseId,
      'sets': sets,
      'reps': reps,
      'rest': rest,
      'weight': weight,
      'weightUnit': weightUnit.index,
    };
  }

  @override
  Set<BodyPart> getBodyParts() {
    final exercise = Storage.exerciseStorage.getByKey(exerciseId);
    return exercise?.bodyParts.toSet() ?? {};
  }
}

class ProgramComplexExercise extends ProgramExercise {
  final int reps;
  final int rest;
  final List<ProgramExercise> exercises;

  ProgramComplexExercise({
    required this.reps,
    required this.rest,
    required this.exercises,
  }) : super(type: ProgramExerciseType.complex);

  ProgramComplexExercise.fromJson(super.json)
      : reps = json['reps'] ?? 0,
        rest = json['rest'] ?? 0,
        exercises = ((json['exercises'] ?? []) as List<Map>)
            .map((e) => ProgramExerciseFactory.fromJson(e))
            .where((e) => e != null)
            .toList()
            .cast(),
        super.fromJson();

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'reps': reps,
      'rest': rest,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }

  @override
  Set<BodyPart> getBodyParts() {
    final bodyParts = <BodyPart>{};

    for (final exercise in exercises) {
      bodyParts.addAll(exercise.getBodyParts());
    }

    return bodyParts;
  }
}
