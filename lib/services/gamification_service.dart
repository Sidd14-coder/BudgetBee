import 'package:hive_flutter/hive_flutter.dart';
import '../globals.dart';

class GamificationService {
  static const String boxName = 'gamificationBox';

  // XP Required per level (Linear 500 XP per level for simplicity, or curve)
  static const int xpPerLevel = 500;

  // ====================== CORE XP & LEVEL ======================

  static int get xp {
    var box = Hive.box(boxName);
    return box.get('xp', defaultValue: 0) as int;
  }

  static int get currentLevel {
    // Level 1 starts at 0 XP. Level 2 at 500. Level 3 at 1000.
    return (xp / xpPerLevel).floor() + 1;
  }

  static int get xpForNextLevel {
    return currentLevel * xpPerLevel;
  }

  static double get levelProgress {
    int currentLevelBaseXp = (currentLevel - 1) * xpPerLevel;
    int xpInCurrentLevel = xp - currentLevelBaseXp;
    return xpInCurrentLevel / xpPerLevel;
  }

  static Future<void> addXp(int amount) async {
    var box = Hive.box(boxName);
    int currentXp = box.get('xp', defaultValue: 0) as int;
    await box.put('xp', currentXp + amount);
    
    // Automatically check for level-based badges here if needed
  }

  // ====================== STREAK SYSTEM ======================

  static int get currentStreak {
    var box = Hive.box(boxName);
    return box.get('streak', defaultValue: 0) as int;
  }

  /// Called every time the app opens or dashboard loads
  static Future<void> checkDailyLogin() async {
    var box = Hive.box(boxName);
    
    String? lastLoginStr = box.get('lastLoginDate');
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    if (lastLoginStr == null) {
      // First time ever
      await box.put('lastLoginDate', today.toIso8601String());
      await box.put('streak', 1);
      await addXp(50); // Welcome XP
      return;
    }

    DateTime lastLogin = DateTime.parse(lastLoginStr);
    
    // If already logged in today, do nothing
    if (lastLogin.isAtSameMomentAs(today)) {
      return;
    }

    // If logged in exactly yesterday, increment streak
    DateTime yesterday = today.subtract(const Duration(days: 1));
    if (lastLogin.isAtSameMomentAs(yesterday)) {
      int newStreak = currentStreak + 1;
      await box.put('streak', newStreak);
      await box.put('lastLoginDate', today.toIso8601String());
      
      // Bonus XP for maintaining streak
      int bonusXp = 50 + (newStreak * 10); // Escalating bonus!
      if (bonusXp > 300) bonusXp = 300; // Cap bonus
      await addXp(bonusXp);

      // Check Streak Badges
      if (newStreak == 7) await unlockBadge('7_day_streak');
      if (newStreak == 30) await unlockBadge('30_day_streak');
    } else {
      // Streak broken (missed a day)
      await box.put('streak', 1);
      await box.put('lastLoginDate', today.toIso8601String());
      await addXp(50); // Just base daily XP
    }
  }

  // ====================== BADGES SYSTEM ======================

  static List<String> get unlockedBadges {
    var box = Hive.box(boxName);
    List<dynamic> badgesDynamic = box.get('unlockedBadges', defaultValue: []);
    return badgesDynamic.cast<String>();
  }

  static Future<void> unlockBadge(String badgeId) async {
    var box = Hive.box(boxName);
    List<String> badges = unlockedBadges;
    
    if (!badges.contains(badgeId)) {
      badges.add(badgeId);
      await box.put('unlockedBadges', badges);
      
      // Massive XP bonus for unlocking a badge!
      await addXp(500); 
    }
  }

  // Check financial health badges
  static Future<void> evaluateFinancialBadges() async {
    if (totalCredit > 0 && totalDebit == 0) {
      // Wow, zero spending!
      await unlockBadge('zero_spender');
    }

    if (totalCredit > 0 && totalDebit < (totalCredit * 0.5)) {
      // Spending less than 50%
      await unlockBadge('super_saver');
    }
  }

  // ====================== LEGACY FIN-HEALTH (MIGRATED) ======================

  static String getStatusEmoji() {
    double ratio = totalCredit > 0 ? (totalCredit - totalDebit) / totalCredit : 0.0;
    if (ratio >= 0.5) return 'Excellent 🏆';
    if (ratio >= 0.2) return 'Good 👍';
    if (ratio >= 0.0) return 'Fair ⚠️';
    return 'Critical 🚨';
  }

  static String getStatusMessage() {
    double ratio = totalCredit > 0 ? (totalCredit - totalDebit) / totalCredit : 0.0;
    if (ratio >= 0.5) return 'You are doing great with your budget!';
    if (ratio >= 0.2) return 'On track, but keep an eye on unnecessary expenses.';
    if (ratio >= 0.0) return 'You are nearing your limits. Try to save more.';
    return 'Your spending is critically high. Stop unnecessary expenses!';
  }
}
