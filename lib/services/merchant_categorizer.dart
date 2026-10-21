import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MerchantCategorizer {
  // Pre-defined rich categories allowed in the app
  static const Map<String, Map<String, dynamic>> predefinedCategories = {
    'Food & Dining': {'icon': Icons.fastfood, 'color': Colors.orangeAccent},
    'Medical & Health': {'icon': Icons.local_hospital, 'color': Colors.redAccent},
    'Groceries': {'icon': Icons.shopping_basket, 'color': Colors.green},
    'Education': {'icon': Icons.menu_book, 'color': Colors.blueGrey},
    'Shopping': {'icon': Icons.shopping_bag, 'color': Colors.purpleAccent},
    'Fuel': {'icon': Icons.local_gas_station, 'color': Colors.amber},
    'Travel': {'icon': Icons.directions_car, 'color': Colors.lightBlue},
    'Entertainment': {'icon': Icons.movie, 'color': Colors.deepPurple},
    'Bills & Utils': {'icon': Icons.wifi, 'color': Colors.teal},
    'Tech & Gadgets': {'icon': Icons.computer, 'color': Colors.cyan},
    'General Expense': {'icon': Icons.payment, 'color': Colors.red}, // Fixed to red for better visibility instead of red[300]
    'General Money': {'icon': Icons.account_balance_wallet, 'color': Colors.green}, // Fixed to green for better visibility instead of green[300]
  };

  // Cleans the raw SMS string to a beautiful Merchant/Person Name
  static String getCleanName(String rawSms) {
    String text = rawSms.toUpperCase();
    
    // Pattern 1: Explicit "UPI TO X" or "PAID TO X" or "TRANSFER TO X"
    final paidToPattern = RegExp(r'(?:UPI TO|PAID TO|SENT TO|TRANSFER TO|VPA)\s+([A-Z0-9&\.\s]+?)(?:\sON\b|\sREF\b|\sA/C\b|\.|\s$|$)');
    final paidToMatch = paidToPattern.firstMatch(text);
    if (paidToMatch != null) {
      String merchant = paidToMatch.group(1)!.trim();
      // Remove any trailing junk like ' ON ' that might have slipped through
      merchant = merchant.split(' ON ')[0].split(' REF ')[0].trim();
      if (merchant.isNotEmpty && merchant.length > 2) {
        return _truncate(_titleCase(merchant), 30);
      }
    }

    // Pattern 2: Explicit "RECEIVED FROM X", "FROM X", or "BY X"
    final recFromPattern = RegExp(r'(?:RECEIVED FROM|FROM|BY)\s+([A-Z0-9&\.\s]+?)(?:\.\s|\sON\b|\sREF\b|\sTHRU\b|$)');
    final recFromMatch = recFromPattern.firstMatch(text);
    if (recFromMatch != null) {
      String merchant = recFromMatch.group(1)!.trim();
      merchant = merchant.split(' ON ')[0].split(' REF ')[0].split(' THRU ')[0].trim();
      // Remove any trailing numbers or time like "2026 15:41" from the START of the name
      merchant = merchant.replaceAll(RegExp(r'^\d{4}\s\d{2}:\d{2}\s*'), '');
      if (merchant.isNotEmpty && merchant.length > 2) {
        return _truncate(_titleCase(merchant), 30);
      }
    }

    // Pattern 3: Standard UPI Format (UPI/DR/ID/MERCHANT)
    if (text.contains('UPI/DR') || text.contains('UPI/CR')) {
      final parts = text.split('/');
      if (parts.length > 3) {
        String merchant = parts[3].trim();
        for (int i = 2; i < parts.length; i++) {
          final part = parts[i].trim();
           // Find the first part that is strictly NOT entirely numeric (like an ID) and NOT 'DR'/'CR'
          if (!RegExp(r'^\d+$').hasMatch(part) && part.length > 3 && part != 'DR' && part != 'CR') {
             merchant = part;
             return _truncate(_titleCase(merchant), 30);
          }
        }
      }
    }
    
    // Fallback: Remove bank pre-fixes, typical keywords, and grab the first 3 valid words
    text = text.replaceAll(RegExp(r'\b(RS\.?|INR|CREDIT|DEBIT|DEBITED|WITHDRAWN|SPENT|AVAILABLE|BAL|BALANCE|A/C|AC|XX\d+|THRU|FOR)\b'), ' ');
    // Remove numbers and single characters
    text = text.replaceAll(RegExp(r'\b\d{4}\s\d{2}:\d{2}\b'), ''); // Strip dates like 2026 15:41
    final words = text.split(RegExp(r'\s+')).where((w) => w.length > 2 && !RegExp(r'\d').hasMatch(w)).toList();
    
    if (words.isNotEmpty) {
      String merchant = words.take(3).join(' '); // Take up to 3 descriptive words
      return _truncate(_titleCase(merchant), 30);
    }

    return "Unknown Merchant";
  }

  // Internal helper to prevent overflow from insanely long extraction
  static String _truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Gives a category and perfectly matched icon based on ML History -> fallback to NLP -> fallback to default
  static Map<String, dynamic> getCategoryAndIcon(String rawSms, {bool isDebit = true}) {
    final cleanName = getCleanName(rawSms);

    // If it's a CREDIT (Income), we skip ML Expense categories entirely!
    if (!isDebit) {
       return {'category': 'Income / Received', 'icon': Icons.account_balance_wallet, 'color': Colors.green};
    }

    // 1. [TRANSACTION-LEVEL LAYER - HIGHEST PRIORITY] CHECK IF USER OVERRODE THIS EXACT TRANSACTION
    final tBox = Hive.box('transactionCategoryBox');
    if (tBox.containsKey(rawSms)) {
      final overrideCategory = tBox.get(rawSms) as String;
      if (predefinedCategories.containsKey(overrideCategory)) {
        return {
          'category': overrideCategory,
          'icon': predefinedCategories[overrideCategory]!['icon'],
          'color': predefinedCategories[overrideCategory]!['color'],
        };
      }
    }

    // 2. [MERCHANT-LEVEL ML LAYER - LEGACY] GLOBAL OVERRIDES
    final box = Hive.box('merchantCategoryBox');
    if (box.containsKey(cleanName)) {
      final learnedCategory = box.get(cleanName) as String;
      if (predefinedCategories.containsKey(learnedCategory)) {
        return {
          'category': learnedCategory,
          'icon': predefinedCategories[learnedCategory]!['icon'],
          'color': predefinedCategories[learnedCategory]!['color'],
        };
      }
    }

    // 2. [NLP LAYER] FALLBACK TO KEYWORD SMART ANALYSIS
    final t = rawSms.toLowerCase();

    if (t.contains('swiggy') || t.contains('zomato') || t.contains('mcdonald') || t.contains('restaurant') || t.contains('cafe') || t.contains('pizza')) {
      return {'category': 'Food & Dining', 'icon': predefinedCategories['Food & Dining']!['icon'], 'color': predefinedCategories['Food & Dining']!['color']};
    }
    if (t.contains('chemist') || t.contains('pharma') || t.contains('hospital') || t.contains('clinic') || t.contains('apollo') || t.contains('med')) {
      return {'category': 'Medical & Health', 'icon': predefinedCategories['Medical & Health']!['icon'], 'color': predefinedCategories['Medical & Health']!['color']};
    }
    if (t.contains('blinkit') || t.contains('instamart') || t.contains('zepto') || t.contains('grocery') || t.contains('dmart') || t.contains('supermarket')) {
      return {'category': 'Groceries', 'icon': predefinedCategories['Groceries']!['icon'], 'color': predefinedCategories['Groceries']!['color']};
    }
    if (t.contains('stationery') || t.contains('book') || t.contains('school') || t.contains('college') || t.contains('tuition') || t.contains('print')) {
      return {'category': 'Education', 'icon': predefinedCategories['Education']!['icon'], 'color': predefinedCategories['Education']!['color']};
    }
    if (t.contains('amazon') || t.contains('flipkart') || t.contains('myntra') || t.contains('shopping') || t.contains('store')) {
      return {'category': 'Shopping', 'icon': predefinedCategories['Shopping']!['icon'], 'color': predefinedCategories['Shopping']!['color']};
    }
    if (t.contains('petrol') || t.contains('fuel') || t.contains('bharat petroleum') || t.contains('indian oil') || t.contains('hpcl') || t.contains('reliance')) {
      return {'category': 'Fuel', 'icon': predefinedCategories['Fuel']!['icon'], 'color': predefinedCategories['Fuel']!['color']};
    }
    if (t.contains('uber') || t.contains('ola') || t.contains('rapido') || t.contains('irctc') || t.contains('metro') || t.contains('flight')) {
      return {'category': 'Travel', 'icon': predefinedCategories['Travel']!['icon'], 'color': predefinedCategories['Travel']!['color']};
    }
    if (t.contains('netflix') || t.contains('prime') || t.contains('spotify') || t.contains('hotstar') || t.contains('subscription')) {
      return {'category': 'Entertainment', 'icon': predefinedCategories['Entertainment']!['icon'], 'color': predefinedCategories['Entertainment']!['color']};
    }
    if (t.contains('jio') || t.contains('airtel') || t.contains('vi') || t.contains('recharge') || t.contains('wifi') || t.contains('broadband')) {
      return {'category': 'Bills & Utils', 'icon': predefinedCategories['Bills & Utils']!['icon'], 'color': predefinedCategories['Bills & Utils']!['color']};
    }

    // 3. [DEFAULT LAYER] IF EVERYTHING FAILS
    if (t.contains('dr') || t.contains('debit') || t.contains('paid')) {
      return {'category': 'General Expense', 'icon': predefinedCategories['General Expense']!['icon'], 'color': predefinedCategories['General Expense']!['color']};
    }
    return {'category': 'General Money', 'icon': predefinedCategories['General Money']!['icon'], 'color': predefinedCategories['General Money']!['color']};
  }

  // Method to teach the ML Engine a new merchant-to-category mapping (LEGACY GLOBAL)
  static Future<void> learnMerchantCategory(String cleanName, String newCategory) async {
    final box = Hive.box('merchantCategoryBox');
    await box.put(cleanName, newCategory);
  }

  // Method to teach the Engine a TRANSACTION-SPECIFIC mapping
  static Future<void> learnTransactionCategory(String rawSms, String newCategory) async {
    final box = Hive.box('transactionCategoryBox');
    await box.put(rawSms, newCategory);
  }

  static String _titleCase(String text) {
    if (text.length <= 1) return text.toUpperCase();
    final words = text.toLowerCase().split(' ');
    final capitalized = words.map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    });
    return capitalized.join(' ').trim();
  }
}
