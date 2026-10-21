import 'package:hive/hive.dart';
import '../models/dream_model.dart';
import '../globals.dart';

class DreamService {
  static const String boxName = 'dreamBox';

  static Box get _box => Hive.box(boxName);

  static void addDream(DreamModel dream) {
    _box.put(dream.id, dream.toMap());
  }

  static void updateSavedAmount(String id, double newAmount) {
    final existingData = _box.get(id);
    if (existingData != null) {
      final dream = DreamModel.fromMap(existingData as Map);
      dream.savedAmount = newAmount;
      _box.put(id, dream.toMap());
    }
  }

  static List<DreamModel> getAllDreams() {
    return _box.values.map((e) => DreamModel.fromMap(e as Map)).toList();
  }

  static void deleteDream(String id) {
    _box.delete(id);
  }

  // Calculate roughly how many days are added to your dream if you spend unnecessary money
  static int calculatePenaltyDays(DreamModel dream, double unnecessaryAmountSpent) {
    // If the user's average saving rate isn't perfectly known, let's estimate 1000 rupees daily saving goal.
    // So spending 500 rupees unnecessarily pushes the goal by 0.5 days.
    double dailySavingCapacity = (totalCredit > 0 ? (totalCredit - totalDebit) / 30 : 500);
    if (dailySavingCapacity <= 100) dailySavingCapacity = 200; // fallback capacity

    final penaltyDays = unnecessaryAmountSpent / dailySavingCapacity;
    return penaltyDays.ceil();
  }
}
