import '../globals.dart';
import '../services/gamification_service.dart';
import '../services/merchant_categorizer.dart';

Future<Map<String, dynamic>> getUserFinanceData() async {
  double balance = totalCredit - totalDebit;
  double income = totalCredit;
  double expenses = totalDebit;
  double savings = income - expenses;

  // Get Top 5 Transactions (by amount)
  final sortedTransactions = allTransactions.toList()
    ..sort((a, b) => b.amount.compareTo(a.amount));
  
  final top5 = sortedTransactions.take(5).map((t) {
    String type = t.isCredit ? "Credit" : "Debit";
    return "₹${t.amount} ($type) - ${t.description}";
  }).join("\n");

  // Get Bank Accounts with Balance and Last 3 Transactions
  List<String> bankInfoLines = [];
  for (var entry in bankBalances.entries) {
    String bankName = entry.key;
    double currentBalance = entry.value;
    
    // Get last 3 transactions for this specific bank
    final bankTxns = allTransactions.where((t) => t.bank == bankName).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
      
    final last3 = bankTxns.take(3).map((t) {
      String tType = t.isCredit ? "Credit" : "Debit";
      return "  - ₹${t.amount} ($tType) on ${t.date.day}/${t.date.month}";
    }).join("\n");

    bankInfoLines.add("**$bankName**\n- Balance: ₹$currentBalance\n- Recent Activity:\n$last3");
  }

  return {
    "balance": balance,
    "income": income,
    "expenses": expenses,
    "savings": savings,
    "transactions": top5.isEmpty ? "No recent transactions found." : top5,
    "bank_details": bankInfoLines.isEmpty ? "No linked bank accounts." : bankInfoLines.join("\n\n"),
    "gamification_level": GamificationService.currentLevel,
    "gamification_xp": GamificationService.xp,
    "gamification_streak": GamificationService.currentStreak,
    "gamification_badges": GamificationService.unlockedBadges.join(", "),
  };
}
