import 'package:hive/hive.dart';
import '../models/credit_card_model.dart';

class CreditCardService {
  static const String boxName = 'creditCardBox';

  static Box get _box => Hive.box(boxName);

  // Add or Update a Credit Card statement based on the card's last 4 digits
  static void updateStatement(CreditCardModel statement) {
    final Map<dynamic, dynamic> currentData = _box.toMap();
    int? existingKey;

    // Search if this card already exists to update it, rather than duplicate
    currentData.forEach((key, value) {
      final cd = CreditCardModel.fromMap(value as Map);
      if (cd.last4Digits == statement.last4Digits || cd.cardName == statement.cardName) {
        existingKey = key;
      }
    });

    if (existingKey != null) {
      _box.put(existingKey, statement.toMap());
    } else {
      _box.add(statement.toMap());
    }
  }

  // Get all active credit cards statements
  static List<CreditCardModel> getAllCards() {
    return _box.values.map((e) => CreditCardModel.fromMap(e as Map)).toList();
  }

  static void clearSpecificCard(String last4Digits) {
    final Map<dynamic, dynamic> currentData = _box.toMap();
    currentData.forEach((key, value) {
      final cd = CreditCardModel.fromMap(value as Map);
      if (cd.last4Digits == last4Digits) {
        _box.delete(key);
      }
    });
  }

  // Analyze SMS to detect if it's a Credit Card Statement
  static void processSmsForCreditCard(String body, DateTime date, String bankName) {
    final b = body.toLowerCase();
    
    // Check if this is a credit card bill/statement message
    if (!b.contains('credit card') && !b.contains(' cc ')) return;
    if (!b.contains('statement') && !b.contains('total due')) return;

    // Last 4 digits
    final cardRegex = RegExp(r'(?:card|cc).*?(?:ending with|xx|x)[^\d]*(\d{4})');
    final cardMatch = cardRegex.firstMatch(b);
    final last4 = cardMatch != null ? cardMatch.group(1)! : 'Unknown';

    // Total Due
    final totalRegex = RegExp(r'total\s*(?:amount|amt)?\s*due\s*(?:is|:)?[^\d]*rs\.?\s*([\d,]+(\.\d+)?)');
    final totalMatch = totalRegex.firstMatch(b);
    if (totalMatch == null) return;
    final totalDue = double.tryParse(totalMatch.group(1)?.replaceAll(',', '') ?? '0.0') ?? 0.0;

    // Minimum Due
    final minRegex = RegExp(r'min(?:imum)?\s*(?:amount|amt)?\s*due\s*(?:is|:)?[^\d]*rs\.?\s*([\d,]+(\.\d+)?)');
    final minMatch = minRegex.firstMatch(b);
    final minDue = minMatch != null ? (double.tryParse(minMatch.group(1)?.replaceAll(',', '') ?? '0.0') ?? 0.0) : 0.0;

    // Due Date (Extremely simplified parser for Indian SMS)
    // Assuming format like 15-Jun, 15/06, 15 Jun
    final dateRegex = RegExp(r'due\s*date\s*(?:is|:)?\s*([\d]{1,2}[-\/\s]+[a-zA-Z]{3,4}[-\/\s]*[\d]{2,4})');
    final dateMatch = dateRegex.firstMatch(b);
    DateTime dueDate;
    if (dateMatch != null) {
      // Just fallback to +20 days from statement if parse fails
      dueDate = date.add(const Duration(days: 20)); 
    } else {
      dueDate = date.add(const Duration(days: 20)); // typical grace period from statement creation
    }

    final statement = CreditCardModel(
      cardName: '$bankName Credit Card',
      last4Digits: last4,
      totalDue: totalDue,
      minDue: minDue,
      dueDate: dueDate,
    );

    updateStatement(statement);
  }
}
