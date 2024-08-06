import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/models/body_part.dart';
import 'package:my_fit_journey/models/exercise_photo.dart';
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
enum ExerciseType {
  @HiveField(0)
  machineWeight,
  @HiveField(1)
  freeWeight,
  @HiveField(2)
  bodyWeight,
  @HiveField(3)
  cardioMachine,
  @HiveField(4)
  stretching,
  @HiveField(5)
  swimming,
  @HiveField(6)
  other
}

@HiveType(typeId: 1)
class Exercise extends HiveObject {
  @HiveField(0)
  late final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  final List<BodyPart> bodyParts;

  @HiveField(4)
  ExerciseType type;

  @HiveField(5)
  final List<ExercisePhoto> photos;

  @HiveField(6)
  final Map<String, dynamic> specifications;

  Exercise({
    required this.title,
    required this.description,
    required this.bodyParts,
    required this.type,
    required this.photos,
    required this.specifications,
    String? id,
  }) {
    this.id = id ?? uuid.v1();
  }

  Exercise.empty()
      : title = '',
        description = '',
        bodyParts = [],
        type = ExerciseType.other,
        photos = [],
        specifications = {},
        id = uuid.v1();
}

class ExerciseAdapter extends TypeAdapter<Exercise> {
  @override
  final int typeId = 1;

  @override
  Exercise read(BinaryReader reader) {
    var exercise = Exercise(
      title: reader.readString(),
      description: reader.readString(),
      bodyParts: reader.readList().cast<BodyPart>(),
      type: ExerciseType.values[reader.readInt()],
      photos: reader.readList().cast<ExercisePhoto>(),
      specifications: reader.readMap().cast(),
      id: reader.readString(),
    );

    return exercise;
  }

  @override
  void write(BinaryWriter writer, Exercise obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.description);
    writer.writeList(obj.bodyParts);
    writer.writeInt(obj.type.index);
    writer.writeList(obj.photos);
    writer.writeMap(obj.specifications);
    writer.writeString(obj.id);
  }
}
