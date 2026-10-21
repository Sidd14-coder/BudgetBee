// import 'package:telephony/telephony.dart';
// import '../../globals.dart';

// class BankData {
//   final String bankName;
//   final double balance;
//   final String accountNumber;
//   final int date;

//   BankData({
//     required this.bankName,
//     required this.balance,
//     required this.accountNumber,
//     required this.date,
//   });
// }

// /// Recalculate debit, credit and total spent
// /// whenever filter (weekly / monthly) changes
// Future<void> refreshTotals() async {
//   final telephony = Telephony.instance;

//   // We fetch a larger batch to ensure we don't miss transactions 
//   // at the start of the month if the user is very active.
//   final sms = await telephony.getInboxSms(
//     columns: [SmsColumn.BODY, SmsColumn.DATE],
//     sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
//   );

//   double debitSum = 0;
//   double creditSum = 0;

//   final now = DateTime.now();
  
//   // ✅ 1st Day of current month at 00:00:00
//   final startOfMonth = DateTime(now.year, now.month, 1);
  
//   // ✅ Exactly 7 days ago from this exact second
//   final sevenDaysAgo = now.subtract(const Duration(days: 7));

//   // Clear daily maps for fresh calculation
//   dailyDebitMap.clear();
//   dailyCreditMap.clear();

//   bankBalances.clear();
//   bankAccounts.clear();
//   bankLastSmsTime.clear();

// //   for (var msg in sms.take(500)) { 
// //     final body = msg.body ?? '';
// //     final ts = msg.date;
// //     if (ts == null) continue;

// //     final d = DateTime.fromMillisecondsSinceEpoch(ts);

// //     // ✅ REFINED RANGE LOGIC
// //     bool inRange;
// //     if (currentFilter == FilterType.weekly) {
// //       // Is the message timestamp after 7 days ago?
// //       inRange = d.isAfter(sevenDaysAgo);
// //     } else {
// //       // Is the message timestamp on or after the 1st of this month?
// //       // isAfter(1st - 1 second) covers the very start of the day
// //       inRange = d.isAfter(startOfMonth.subtract(const Duration(seconds: 1)));
// //     }

// //     if (!inRange) continue;

// //     final debit = _isDebit(body);
// //     final credit = _isCredit(body);

// //     if (!debit && !credit) continue;

// //     final amt = _extractAmount(body);
// //     if (amt == 0) continue;

// //     // 🔵 BANK DETECTION
// //     // 🔵 BANK DETECTION – NO DATE FILTER
// // final bankName = extractBankNameFromSMS(body);

// // if (bankName != 'Unknown Bank') {
// //   // BALANCE – only latest per bank
// //   final balStr = extractAvailableBalance(body);
// //   if (balStr != null && !bankBalances.containsKey(bankName)) {
// //     final bal = double.tryParse(balStr);
// //     if (bal != null) {
// //       bankBalances[bankName] = bal;
// //     }
// //   }

// //   // ACCOUNT – only latest per bank
// //   final acc = extractAccountNumber(body);
// //   if (acc != null && !bankAccounts.containsKey(bankName)) {
// //     bankAccounts[bankName] = acc;
// //   }
// // }

// // // 🔽 AMOUNT CALCULATION – WITH DATE FILTER
// // if (!inRange) continue;

// // final debit = _isDebit(body);
// // final credit = _isCredit(body);

// // if (!debit && !credit) continue;

// // final amt = _extractAmount(body);
// // if (amt == 0) continue;

// //     final day = DateTime(d.year, d.month, d.day);

// //     if (debit) {
// //       debitSum += amt;
// //       dailyDebitMap[day] = (dailyDebitMap[day] ?? 0) + amt;
// //     } else if (credit) {
// //       creditSum += amt;
// //       dailyCreditMap[day] = (dailyCreditMap[day] ?? 0) + amt;
// //     }
// //   }

//   for (var msg in sms.take(1500)) {
//   final body = msg.body ?? '';
//   final ts = msg.date;
//   if (ts == null) continue;

//   final d = DateTime.fromMillisecondsSinceEpoch(ts);

//   // 🔵 BANK DETECTION – NO DATE FILTER
//   final bankName = extractBankNameFromSMS(body);

// if (bankName != 'Unknown Bank') {
//   final msgTime = ts!;

//   final balStr = extractAvailableBalance(body);

//   if (balStr != null) {
//     final bal = double.tryParse(balStr);
//     if (bal != null) {
//       if (!bankLastSmsTime.containsKey(bankName) ||
//           msgTime > bankLastSmsTime[bankName]!) {
//         bankLastSmsTime[bankName] = msgTime;
//         bankBalances[bankName] = bal;
//       }
//     }
//   }

//   final acc = extractAccountNumber(body);
//   if (acc != null && !bankAccounts.containsKey(bankName)) {
//     bankAccounts[bankName] = acc;
//   }
// }

//   // 🔽 DATE FILTER ONLY FOR TOTALS
//   bool inRange;
//   if (currentFilter == FilterType.weekly) {
//     inRange = d.isAfter(sevenDaysAgo);
//   } else {
//     inRange =
//         d.isAfter(startOfMonth.subtract(const Duration(seconds: 1)));
//   }

//   if (!inRange) continue;

//   // 🔽 AMOUNT CALCULATION (DECLARE ONLY ONCE)
//   final debit = _isDebit(body);
//   final credit = _isCredit(body);

//   if (!debit && !credit) continue;

//   final amt = _extractAmount(body);
//   if (amt == 0) continue;

//   final day = DateTime(d.year, d.month, d.day);

//   if (debit) {
//     debitSum += amt;
//     dailyDebitMap[day] = (dailyDebitMap[day] ?? 0) + amt;
//   } else if (credit) {
//     creditSum += amt;
//     dailyCreditMap[day] = (dailyCreditMap[day] ?? 0) + amt;
//   }
// }

//   totalDebit = debitSum;
//   totalCredit = creditSum;
//   globalTotalSpent = debitSum;
// }

// /* ---------------- HELPER FUNCTIONS ---------------- */

// double _extractAmount(String body) {
//   // Removes commas from amounts like "1,250.00" before parsing
//   final regex = RegExp(
//     r'(rs\.?|inr|₹)\s?([\d,]+(\.\d+)?)',
//     caseSensitive: false,
//   );

//   final match = regex.firstMatch(body.replaceAll(',', ''));
//   if (match != null) {
//     return double.tryParse(match.group(2)!) ?? 0;
//   }
//   return 0;
// }

// bool _isDebit(String body) {
//   final b = body.toLowerCase();
//   final explicitDebit = RegExp(r'\b(debit(?:ed)?|withdrawn|spent|purchase|paid|payment|card payment|atm withdrawal|sent)\b', caseSensitive: false);
//   if (explicitDebit.hasMatch(b)) return true;

//   final explicitCredit = RegExp(r'\b(credit(?:ed)?|deposited|received|refund|cashback|reversal)\b', caseSensitive: false);
//   if (explicitCredit.hasMatch(b)) return false;

//   final abbrev = RegExp(r'\bdr\b', caseSensitive: false);
//   return abbrev.hasMatch(b);
// }

// bool _isCredit(String body) {
//   final b = body.toLowerCase();
//   final explicitCredit = RegExp(r'\b(credit(?:ed)?|deposited|received|refund|cashback|reversal)\b', caseSensitive: false);
//   if (explicitCredit.hasMatch(b)) return true;

//   final explicitDebit = RegExp(r'\b(debit(?:ed)?|withdrawn|spent|purchase|paid|payment|card payment|atm withdrawal|sent)\b', caseSensitive: false);
//   if (explicitDebit.hasMatch(b)) return false;

//   final abbrev = RegExp(r'\bcr\b', caseSensitive: false);
//   return abbrev.hasMatch(b);
// }

// String? extractAvailableBalance(String body) {
//   final cleaned = body.replaceAll(',', '').toLowerCase();

//   final patterns = [
//     RegExp(r'avl\s*bal(?:ance)?[:\s]*rs\.?\s?([\d]+(\.\d+)?)'),
//     RegExp(r'avl\s*bal(?:ance)?[:\s]*([\d]+(\.\d+)?)'), // ✅ BOI FIX
//     RegExp(r'available\s*bal(?:ance)?[:\s]*rs\.?\s?([\d]+(\.\d+)?)'),
//     RegExp(r'\bbal(?:ance)?[:\s]*rs\.?\s?([\d]+(\.\d+)?)'),
//     RegExp(r'bal(?:ance)?[:\s]*inr\s?([\d]+(\.\d+)?)'),
//     RegExp(r'inr\s?([\d]+(\.\d+)?)\s*(?:is\s*)?your\s*bal'),
//     RegExp(r'bal[:\s]*([\d]+(\.\d+)?)'),
//   ];

//   for (final regex in patterns) {
//     final match = regex.firstMatch(cleaned);
//     if (match != null) {
//       return match.group(1);
//     }
//   }

//   return null;
// }

// String? extractAccountNumber(String body) {
//   body = body.toLowerCase();

//   // 1️⃣ format: a/c xx1234
//   final acRegex = RegExp(r'a/c\s*[xX*]*([0-9]{3,4})');
//   final acMatch = acRegex.firstMatch(body);
//   if (acMatch != null) {
//     return 'A/c xx${acMatch.group(1)}';
//   }

//   // 2️⃣ format: account xxxx1234 (BOI, many banks)
//   final accRegex = RegExp(r'account\s*[xX*]*([0-9]{4})');
//   final accMatch = accRegex.firstMatch(body);
//   if (accMatch != null) {
//     return 'A/c xx${accMatch.group(1)}';
//   }

//   // 3️⃣ format: ending with XXXX1234
//   final last4Regex = RegExp(r'[xX]{2,}([0-9]{4})');
//   final last4Match = last4Regex.firstMatch(body);
//   if (last4Match != null) {
//     return 'A/c xx${last4Match.group(1)}';
//   }

//   return null;
// }

// String extractBankNameFromSMS(String body) {
//   final b = body.toUpperCase();

//   if (b.contains('IPPB') || b.contains('INDIA POST')) {
//     return 'India Post Payments Bank';
//   }

//   if (b.contains('BANK OF INDIA') || b.contains('BOI') || b.contains('BOIIND')) {
//     return 'Bank of India';
//   }

//   if (b.contains('SLICE') || b.contains('SLCEIT')) {
//     return 'Slice';
//   }

//   if (b.contains('HDFC')) return 'HDFC Bank';
//   if (b.contains('SBI') || b.contains('STATE BANK')) return 'State Bank of India';
//   if (b.contains('ICICI')) return 'ICICI Bank';
//   if (b.contains('AXIS')) return 'Axis Bank';
//   if (b.contains('KOTAK')) return 'Kotak Mahindra Bank';
//   if (b.contains('PNB') || b.contains('PUNJAB NATIONAL')) return 'Punjab National Bank';
//   if (b.contains('CANARA')) return 'Canara Bank';
//   if (b.contains('UNION BANK')) return 'Union Bank of India';
//   if (b.contains('INDUSIND')) return 'IndusInd Bank';
//   if (b.contains('YES BANK')) return 'Yes Bank';
//   if (b.contains('IDFC')) return 'IDFC First Bank';
//   if (b.contains('UCO')) return 'UCO Bank';
//   if (b.contains('PAYTM')) return 'Paytm Payments Bank';
//   if (b.contains('NSDL')) return 'NSDL Payments Bank';
//   if (b.contains('JANA')) return 'Jana Small Finance Bank';
//   if (b.contains('EQUITAS')) return 'Equitas Small Finance Bank';
//   if (b.contains('UJJIVAN')) return 'Ujjivan Small Finance Bank';
//   if (b.contains('ESAF')) return 'ESAF Small Finance Bank';
//   if (b.contains('SURYODAY')) return 'Suryoday Small Finance Bank';
//   if (b.contains('AU SMALL')) return 'AU Small Finance Bank';
//   if (b.contains('KARNATAKA')) return 'Karnataka Bank';
//   if (b.contains('KARUR VYSYA')) return 'Karur Vysya Bank';
//   if (b.contains('CENTRAL BANK')) return 'Central Bank of India';
//   if (b.contains('BANK OF BARODA') || b.contains('BOB')) return 'Bank of Baroda';
//   if (b.contains('INDIAN BANK')) return 'Indian Bank';
//   if (b.contains('INDIAN OVERSEAS')) return 'Indian Overseas Bank';
//   if (b.contains('CITY UNION')) return 'City Union Bank';
//   if (b.contains('FEDERAL BANK')) return 'Federal Bank';
//   if (b.contains('TAMILNAD MERCANTILE')) return 'Tamilnad Mercantile Bank';
//   if (b.contains('SOUTH INDIAN')) return 'South Indian Bank';
//   if (b.contains('RBL')) return 'RBL Bank';
//   if (b.contains('HSBC')) return 'HSBC Bank';
//   if (b.contains('DEUTSCHE')) return 'Deutsche Bank';
//   if (b.contains('BARCLAYS')) return 'Barclays Bank';
//   if (b.contains('BNP')) return 'BNP Paribas';

//   return 'Unknown Bank';
// }




import 'package:telephony/telephony.dart';
import 'package:hive/hive.dart';

import '../../globals.dart';
import '../../models/transaction_model.dart';
import '../services/credit_card_service.dart';

import '../../models/transaction_model.dart';
import '../services/credit_card_service.dart';
import '../services/notification_service.dart';

class BankData {
  final String bankName;
  final double balance;
  final String accountNumber;
  final int date;

  BankData({
    required this.bankName,
    required this.balance,
    required this.accountNumber,
    required this.date,
  });
}

/// Scans the device's SMS inbox, parses raw text to extract financial data (amount, type, bank, balance),
/// and structures it into [TransactionModel] objects. Uses sequential calculations to deduce missing
/// balances dynamically. Finally, saves data persistently using Hive local storage.
Future<void> refreshTotals() async {
  final telephony = Telephony.instance;
  
  // Create / Get the persistent Box
  // We use this to save SMS messages so if deleted from the phone, they aren't lost here.
  final Box smsBox = Hive.box('smsTransactionsBox');

  // Fetch from Phone Inbox
  final sms = await telephony.getInboxSms(
    columns: [SmsColumn.BODY, SmsColumn.DATE],
    sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
  );

  // Sync any newly found SMS into Hive.
  // Using the Date (Timestamp) as the Unique ID.
  for (var msg in sms) {
    if (msg.date == null || msg.body == null) continue;
    final id = msg.date.toString();
    if (!smsBox.containsKey(id)) {
      smsBox.put(id, msg.body);
    }
  }

  // Retrieve ALL messages ever processed and saved in Hive
  final List<Map<String, dynamic>> persistedSms = [];
  for (var key in smsBox.keys) {
    persistedSms.add({
      'date': int.tryParse(key.toString()) ?? 0,
      'body': smsBox.get(key),
    });
  }

  // =======================
  // PROCESS CHRONOLOGICALLY
  // =======================
  // By processing from Oldest to Newest, we can accurately deduce 
  // Bank Balances by progressively deducting/adding amounts 
  // if an explicit balance is missing in the SMS string!
  persistedSms.sort((a, b) => (a['date'] as int).compareTo(b['date'] as int));

  allTransactions.clear();
  dailyDebitMap.clear();
  dailyCreditMap.clear();
  bankBalances.clear();
  bankAccounts.clear();

  double debitSum = 0;
  double creditSum = 0;

  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final sevenDaysAgo = now.subtract(const Duration(days: 7));

  for (var msg in persistedSms) {
    final int ts = msg['date'];
    final String body = msg['body'];
    
    // Skip if invalid timestamp
    if (ts == 0) continue;

    final bankName = extractBankNameFromSMS(body);
    if (_isSpam(body, bankName)) continue;

    final date = DateTime.fromMillisecondsSinceEpoch(ts);

    bool isDebit = _isDebit(body);
    bool isCredit = _isCredit(body);

    // If it's neither debit nor credit, it might still just be an account balance update msg
    if (!isDebit && !isCredit) {
      if (bankName != 'Unknown Bank') {
        final balStr = extractAvailableBalance(body);
        if (balStr != null) {
          final bal = double.tryParse(balStr);
          if (bal != null) bankBalances[bankName] = bal; 
        }
        final acc = extractAccountNumber(body);
        if (acc != null && !bankAccounts.containsKey(bankName)) bankAccounts[bankName] = acc;
      }
      continue;
    }

    final amount = _extractAmount(body);
    if (amount == 0) continue;

    // Is there a strictly parsed balance available in this specific SMS?
    final balStr = extractAvailableBalance(body);
    double? balance = balStr != null ? double.tryParse(balStr) : null;

    if (bankName != 'Unknown Bank') {
      if (balance != null) {
        // EXACT RULE: If SMS explicitly has a balance, ALWAYS override & update to it.
        // This ensures maximum accuracy when the bank provides explicit data.
        bankBalances[bankName] = balance;
      } else {
        // DYNAMIC MATH: The SMS didn't have an explicit balance stated. 
        // We dynamically compute it by extrapolating from the last known balance.
        if (bankBalances.containsKey(bankName)) {
          if (isDebit) {
            bankBalances[bankName] = bankBalances[bankName]! - amount;
          } else if (isCredit) {
            bankBalances[bankName] = bankBalances[bankName]! + amount;
          }
          // Attach this deduced balance to the transaction so reports can display it!
          balance = bankBalances[bankName];
        }
      }

      final acc = extractAccountNumber(body);
      if (acc != null) bankAccounts[bankName] = acc;
      
      // Pass the original body string to further analytics
      CreditCardService.processSmsForCreditCard(body, date, bankName);
    }

    // Add to our list 
    allTransactions.add(
      TransactionModel(
        amount: amount,
        date: date,
        isCredit: isCredit,
        description: body,
        bank: bankName,
        balance: balance,
        reference: null,
      ),
    );

    // Total calculations (Filtering for the Dashboard Graph Ranges)
    bool inRange;
    if (currentFilter == FilterType.weekly) {
      inRange = date.isAfter(sevenDaysAgo);
    } else {
      inRange = date.isAfter(startOfMonth.subtract(const Duration(seconds: 1)));
    }

    if (inRange) {
      final day = DateTime(date.year, date.month, date.day);
      if (isDebit) {
        debitSum += amount;
        dailyDebitMap[day] = (dailyDebitMap[day] ?? 0) + amount;
      } else if (isCredit) {
        creditSum += amount;
        dailyCreditMap[day] = (dailyCreditMap[day] ?? 0) + amount;
      }
    }
  }

  // Reverse all transactions so the Newest show up sequentially FIRST in UI Data
  allTransactions = allTransactions.reversed.toList();

  totalDebit = debitSum;
  totalCredit = creditSum;
  globalTotalSpent = debitSum;

  // Refresh Smart Reminders based on updated data
  NotificationService().scheduleSmartReminders();
}

/* ---------------- HELPER FUNCTIONS ---------------- */

/// Extracts numeric transaction amounts using Regular Expressions.
/// Supports multiple currency formats (Rs, INR, ₹) and handles commas.
double _extractAmount(String body) {
  final regex = RegExp(
    r'(rs\.?|inr|₹)\s?([\d,]+(\.\d+)?)',
    caseSensitive: false,
  );

  final match = regex.firstMatch(body.replaceAll(',', ''));
  if (match != null) {
    return double.tryParse(match.group(2)!) ?? 0;
  }
  return 0;
}

/// Determines if a transaction is a Debit based on standard financial keywords present in the SMS.
bool _isDebit(String body) {
  final b = body.toLowerCase().replaceAll('credit card', '').replaceAll('credit limit', '');

  final explicitCredit = RegExp(
      r'\b(credit(?:ed)?|deposited|received|refund|cashback|reversal|credited)\b',
      caseSensitive: false);
  if (explicitCredit.hasMatch(b)) return false;

  final explicitDebit = RegExp(
      r'\b(debit(?:ed)?|withdrawn|spent|purchase|paid|card payment|atm withdrawal|sent)\b',
      caseSensitive: false);
  if (explicitDebit.hasMatch(b)) return true;

  final abbrev = RegExp(r'\bdr\b', caseSensitive: false);
  return abbrev.hasMatch(b);
}

/// Determines if a transaction is a Credit based on standard financial keywords.
bool _isCredit(String body) {
  final b = body.toLowerCase().replaceAll('credit card', '').replaceAll('credit limit', '');
  final explicitCredit = RegExp(
      r'\b(credit(?:ed)?|deposited|received|refund|cashback|reversal)\b',
      caseSensitive: false);
  if (explicitCredit.hasMatch(b)) return true;

  final explicitDebit = RegExp(
      r'\b(debit(?:ed)?|withdrawn|spent|purchase|paid|payment|card payment|atm withdrawal|sent)\b',
      caseSensitive: false);
  if (explicitDebit.hasMatch(b)) return false;

  final abbrev = RegExp(r'\bcr\b', caseSensitive: false);
  return abbrev.hasMatch(b);
}

String? extractAvailableBalance(String body) {
  final cleaned = body.replaceAll(',', '').toLowerCase();

  final patterns = [
    RegExp(r'avl\s*bal(?:ance)?[:\s]*rs\.?\s?([\d]+(\.\d+)?)'),
    RegExp(r'avl\s*bal(?:ance)?[:\s]*([\d]+(\.\d+)?)'),
    RegExp(r'available\s*bal(?:ance)?[:\s]*rs\.?\s?([\d]+(\.\d+)?)'),
    RegExp(r'\bbal(?:ance)?[:\s]*rs\.?\s?([\d]+(\.\d+)?)'),
    RegExp(r'bal(?:ance)?[:\s]*inr\s?([\d]+(\.\d+)?)'),
    RegExp(r'inr\s?([\d]+(\.\d+)?)\s*(?:is\s*)?your\s*bal'),
    RegExp(r'bal[:\s]*([\d]+(\.\d+)?)'),
  ];

  for (final regex in patterns) {
    final match = regex.firstMatch(cleaned);
    if (match != null) return match.group(1);
  }

  return null;
}

String? extractAccountNumber(String body) {
  body = body.toLowerCase();

  final acRegex = RegExp(r'a/c\s*[xX*]*([0-9]{3,4})');
  final acMatch = acRegex.firstMatch(body);
  if (acMatch != null) return 'A/c xx${acMatch.group(1)}';

  final accRegex = RegExp(r'account\s*[xX*]*([0-9]{4})');
  final accMatch = accRegex.firstMatch(body);
  if (accMatch != null) return 'A/c xx${accMatch.group(1)}';

  final last4Regex = RegExp(r'[xX]{2,}([0-9]{4})');
  final last4Match = last4Regex.firstMatch(body);
  if (last4Match != null) return 'A/c xx${last4Match.group(1)}';

  return null;
}

String extractBankNameFromSMS(String body) {
  final b = body.toUpperCase();

  if (b.contains('IPPB') || b.contains('INDIA POST')) return 'India Post Payments Bank';
  if (b.contains('BANK OF INDIA') || b.contains('BOI') || b.contains('BOIIND')) return 'Bank of India';
  if (b.contains('SLICE') || b.contains('SLCEIT')) return 'Slice';

  if (b.contains('HDFC')) return 'HDFC Bank';
  if (b.contains('SBI') || b.contains('STATE BANK')) return 'State Bank of India';
  if (b.contains('ICICI')) return 'ICICI Bank';
  if (b.contains('AXIS')) return 'Axis Bank';
  if (b.contains('KOTAK')) return 'Kotak Mahindra Bank';
  if (b.contains('PNB') || b.contains('PUNJAB NATIONAL')) return 'Punjab National Bank';
  if (b.contains('CANARA')) return 'Canara Bank';
  if (b.contains('UNION BANK')) return 'Union Bank of India';
  if (b.contains('INDUSIND')) return 'IndusInd Bank';
  if (b.contains('YES BANK')) return 'Yes Bank';
  if (b.contains('IDFC')) return 'IDFC First Bank';
  if (b.contains('UCO')) return 'UCO Bank';
  if (b.contains('PAYTM')) return 'Paytm Payments Bank';

  return 'Unknown Bank';
}

bool _isSpam(String body, [String? bankName]) {
  final b = body.toLowerCase();
  
  // Specific promotional/spam keywords that falsely trigger
  final spamKeywords = [
    'recharge now',
    'play rummy',
    'claim now',
    'lottery',
    'win cash',
    'data pack',
    'validity expires',
    'vip gift',
    'cutt.ly',
    'rummy',
  ];
  
  for (var word in spamKeywords) {
    if (b.contains(word)) return true;
  }

  return false;
}
