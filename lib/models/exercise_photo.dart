enum ExercisePhotoSource {
  network,
  local,
}

class ExercisePhoto {
  String path = '';
  ExercisePhotoSource source = ExercisePhotoSource.local;

  ExercisePhoto({
    required this.path,
    required this.source,
  });

  ExercisePhoto.fromJson(Map<String, dynamic> json)
      : path = json['path'] ?? '',
        source = ExercisePhotoSource.values[json['source'] ?? 0];

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'source': source.index,
    };
  }
}
