import 'package:my_fit_journey/models/exercise.dart';

class OtherExercise extends Exercise {
  String details = '';

  OtherExercise({
    required super.title,
    required super.description,
    required super.bodyParts,
    required super.photos,
    required this.details,
    super.type = ExerciseType.other,
    super.id,
  });

  OtherExercise.empty() : super.empty();

  OtherExercise.fromJson(super.json) : super.fromJson();
}
