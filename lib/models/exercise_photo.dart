import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 2)
enum ExercisePhotoSource {
  @HiveField(0)
  network,
  @HiveField(1)
  local,
}

@HiveType(typeId: 3)
class ExercisePhoto extends HiveObject {
  @HiveField(1)
  final String path;

  @HiveField(2)
  final ExercisePhotoSource source;

  ExercisePhoto({required this.path, required this.source});
}

class ExercisePhotoAdapter extends TypeAdapter<ExercisePhoto> {
  @override
  final int typeId = 3;

  @override
  ExercisePhoto read(BinaryReader reader) {
    return ExercisePhoto(
      path: reader.readString(),
      source: ExercisePhotoSource.values[reader.readInt()],
    );
  }

  @override
  void write(BinaryWriter writer, ExercisePhoto obj) {
    writer.writeString(obj.path);
    writer.writeInt(obj.source.index);
  }
}
