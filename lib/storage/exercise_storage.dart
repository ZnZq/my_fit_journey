import 'package:flutter/material.dart';
import 'package:my_fit_journey/models/exercise.dart';

class ExerciseStorage extends ChangeNotifier {
  final List<Exercise> _exercises;
  List<Exercise> get exercises => _exercises;

  ExerciseStorage(this._exercises);

  void add(Exercise exercise) {
    _exercises.add(exercise);
    notifyListeners();
  }

  bool contains(String exerciseId) {
    return _exercises.any((e) => e.id == exerciseId);
  }

  void update(Exercise exercise) {
    final index = _exercises.indexWhere((e) => e.id == exercise.id);
    _exercises[index] = exercise;
    notifyListeners();
  }

  void remove(String exerciseId) {
    _exercises.removeWhere((e) => e.id == exerciseId);
    notifyListeners();
  }
}
