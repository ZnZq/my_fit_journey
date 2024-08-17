import 'package:my_fit_journey/models/exercise.dart';

class SwimmingExercise extends Exercise {
  String handMethod = '';
  String legMethod = '';
  List<String> additionalEquipment = [];

  SwimmingExercise({
    required super.title,
    required super.description,
    required super.bodyParts,
    required super.photos,
    required this.handMethod,
    required this.legMethod,
    super.type = ExerciseType.swimming,
    super.id,
  });

  SwimmingExercise.empty() : super.empty(ExerciseType.swimming);

  SwimmingExercise.fromJson(super.json)
      : handMethod = json['handMethod'] ?? '',
        legMethod = json['legMethod'] ?? '',
        additionalEquipment =
            List<String>.from(json['additionalEquipment'] ?? []),
        super.fromJson();

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'handMethod': handMethod,
      'legMethod': legMethod,
      'additionalEquipment': additionalEquipment,
    };
  }
}
