import 'package:flutter/material.dart';
import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/models/body_part.dart';
import 'package:my_fit_journey/models/exercise_photo.dart';
import 'package:my_fit_journey/models/program.dart';

enum ExerciseType {
  machineWeight,
  freeWeight,
  bodyWeight,
  cardioMachine,
  swimming,
  other
}

extension ExerciseTypeExtension on ExerciseType {
  ProgramExerciseType? get programExerciseType {
    switch (this) {
      case ExerciseType.machineWeight:
        return ProgramExerciseType.machineWeight;
      case ExerciseType.freeWeight:
        return ProgramExerciseType.freeWeight;
      case ExerciseType.bodyWeight:
        return ProgramExerciseType.bodyWeight;
      case ExerciseType.cardioMachine:
        return ProgramExerciseType.cardioMachine;
      case ExerciseType.swimming:
        return ProgramExerciseType.swimming;
      case ExerciseType.other:
        return ProgramExerciseType.other;
    }
  }

  Color get color {
    switch (this) {
      case ExerciseType.machineWeight:
        return Colors.indigo;
      case ExerciseType.freeWeight:
        return Colors.teal;
      case ExerciseType.bodyWeight:
        return Colors.amber;
      case ExerciseType.cardioMachine:
        return Colors.deepOrange;
      case ExerciseType.swimming:
        return Colors.lightBlue;
      case ExerciseType.other:
        return Colors.deepPurple;
    }
  }
}

abstract class WeightExercise extends Exercise {
  WeightUnit weightUnit = WeightUnit.kg;
  int minWeight = 0;
  int maxWeight = 0;
  int weightStep = 0;

  WeightExercise({
    required super.title,
    required super.description,
    required super.bodyParts,
    required super.photos,
    required this.weightUnit,
    required this.minWeight,
    required this.maxWeight,
    required this.weightStep,
    super.type = ExerciseType.machineWeight,
    super.id,
  });

  WeightExercise.empty(super.type) : super.empty();

  WeightExercise.fromJson(super.json)
      : weightUnit =
            WeightUnit.values[json['weightUnit'] ?? WeightUnit.kg.index],
        minWeight = json['minWeight']?.toInt() ?? 0,
        maxWeight = json['maxWeight']?.toInt() ?? 0,
        weightStep = json['weightStep']?.toInt() ?? 0,
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

abstract class Exercise {
  late final String id;
  String title = '';
  String description = '';
  List<BodyPart> bodyParts = [];
  late final ExerciseType type;
  List<ExercisePhoto> photos = [];

  Exercise({
    required this.title,
    required this.description,
    required this.bodyParts,
    required this.type,
    required this.photos,
    String? id,
  }) {
    this.id = id ?? uuid.v4();
  }

  Exercise.empty(this.type) {
    id = uuid.v4();
  }

  Exercise.fromJson(Map json) {
    id = json['id'] ?? uuid.v4();
    title = json['title'] ?? '';
    description = json['description'] ?? '';
    bodyParts = ((json['bodyParts'] ?? []) as List<dynamic>)
        .map((e) => BodyPart.fromJson(e))
        .toList();
    type = ExerciseType.values[json['type'] ?? 0];
    photos = ((json['photos'] ?? []) as List<dynamic>)
        .map((e) => ExercisePhoto.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'bodyParts': bodyParts.map((e) => e.toJson()).toList(),
      'type': type.index,
      'photos': photos.map((e) => e.toJson()).toList(),
    };
  }
}
