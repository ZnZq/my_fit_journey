import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:my_fit_journey/factories/exercise_factory.dart';
import 'package:my_fit_journey/models/exercise.dart';
import 'package:path_provider/path_provider.dart';

import 'package:my_fit_journey/storage/exercise_storage.dart';

class Storage {
  static late final ExerciseStorage exerciseStorage;

  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<String> get exercisePath async {
    final path = await localPath;
    return '$path/exercises.json';
  }

  static Future<void> initialize() async {
    final exercises = await readExercises();
    exerciseStorage = ExerciseStorage(exercises)..addListener(_onSaveExercises);
  }

  static void _onSaveExercises() async {
    final exercises = exerciseStorage.exercises;
    final path = await exercisePath;

    writeJson(path, exercises);
  }

  static Future<List<Exercise>> readExercises() async {
    final path = await exercisePath;
    final rawExercises = await readJson<List<dynamic>>(path, []);

    final exercises =
        rawExercises.map((e) => ExerciseFactory.fromJson(e)).toList();

    return exercises;
  }

  static Future<T> readJson<T>(String path, T defaultValue) async {
    try {
      final utf8 = Encoding.getByName("utf-8")!;
      final json = await File(path).readAsString(encoding: utf8);
      final data = jsonDecode(json);

      return data as T;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return defaultValue;
    }
  }

  static Future<void> writeJson(String path, dynamic data) async {
    try {
      final utf8 = Encoding.getByName("utf-8")!;
      final json = jsonEncode(data);

      await File(path).writeAsString(json, encoding: utf8);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
