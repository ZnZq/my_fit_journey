import 'package:my_fit_journey/models/exercise.dart';

class BodyWeightExercise extends Exercise {
  BodyWeightExercise({
    required super.title,
    required super.description,
    required super.bodyParts,
    required super.photos,
    super.type = ExerciseType.other,
    super.id,
  });

  BodyWeightExercise.empty() : super.empty();

  BodyWeightExercise.fromJson(super.json) : super.fromJson();
}
