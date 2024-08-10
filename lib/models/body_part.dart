import 'package:equatable/equatable.dart';

enum BodyPartPosition {
  front,
  back,
}

class BodyPart with EquatableMixin {
  String title = '';
  String path = '';
  BodyPartPosition position = BodyPartPosition.front;

  BodyPart({
    required this.title,
    required this.path,
    required this.position,
  });

  @override
  List<Object?> get props => [title, path, position];

  BodyPart.fromJson(Map<String, dynamic> json)
      : title = json['title'] ?? '',
        path = json['path'] ?? '',
        position = BodyPartPosition.values[json['position'] ?? 0];

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'path': path,
      'position': BodyPartPosition.front.index,
    };
  }
}
