import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/models/body_part.dart';
import 'package:my_fit_journey/models/exercise_photo.dart';

enum ExerciseType {
  machineWeight,
  freeWeight,
  bodyWeight,
  cardioMachine,
  swimming,
  other
}

class Exercise {
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
