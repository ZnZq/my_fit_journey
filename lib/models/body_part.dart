import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 4)
enum BodyPartPosition {
  @HiveField(0)
  front,
  @HiveField(1)
  back,
}

@HiveType(typeId: 5)
class BodyPart extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String path;

  @HiveField(2)
  final BodyPartPosition position;

  BodyPart({
    required this.title,
    required this.path,
    required this.position,
  });

  @override
  List<Object?> get props => [title, path, position];
}

class BodyPartAdapter extends TypeAdapter<BodyPart> {
  @override
  final int typeId = 5;

  @override
  BodyPart read(BinaryReader reader) {
    return BodyPart(
      title: reader.readString(),
      path: reader.readString(),
      position: BodyPartPosition.values[reader.readInt()],
    );
  }

  @override
  void write(BinaryWriter writer, BodyPart obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.path);
    writer.writeInt(obj.position.index);
  }
}
