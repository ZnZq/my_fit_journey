import 'package:my_fit_journey/models/exercise.dart';
import 'package:my_fit_journey/storage/json_storage_notifier.dart';

class ExerciseStorage extends JsonStorageNotifier<Exercise, String> {
  ExerciseStorage(super.items);

  @override
  bool equalByKey(Exercise item, String key) {
    return item.id == key;
  }

  @override
  bool isEqual(Exercise item1, Exercise item2) {
    return item1.id == item2.id;
  }
}
