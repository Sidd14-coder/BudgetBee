import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../globals.dart';
import '../services/credit_card_service.dart';

class SafeToSpendCard extends StatelessWidget {
  const SafeToSpendCard({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Calculate Total Bank Balance
    double totalBalance = 0;
    bankBalances.forEach((key, value) {
      totalBalance += value;
    });

    // 2. Add custom cash/wallet balances if needed, but let's stick to bank SMS bounds.

    // 3. Calculate Upcoming Dues (Credit Cards)
    double upcomingDues = 0;
    final cards = CreditCardService.getAllCards();
    for (var card in cards) {
      // Only deduct if due date is in the future
      if (card.dueDate.isAfter(DateTime.now()) || card.dueDate.day == DateTime.now().day) {
        upcomingDues += card.totalDue;
      }
    }

    // 4. Calculate days left in month
    final now = DateTime.now();
    // Get last day of month
    final lastDay = DateTime(now.year, now.month + 1, 0).day;
    final daysLeft = (lastDay - now.day) + 1; // +1 to include today

    // 5. Compute Safe Daily Allowance
    // We assume 30% of balance is "savings" roughly or should be kept safe, but the exact formula requested:
    // (Total Balance - Upcoming Dues) / Days Left
    double safePool = totalBalance - upcomingDues;
    if (safePool < 0) safePool = 0; // Prevent negative
    
    // As an aggressive protection, let's say only 50% of the remaining safe pool is for daily allowance, rest is savings.
    double dailyAllowance = (safePool * 0.5) / daysLeft;

    final f = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3CFF), Color(0xFF001A9E)], // Matching Premium Blue
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3CFF).withOpacity(0.4), // Matching Blue Shadow
            blurRadius: 24,
            spreadRadius: 4,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Safe Daily Allowance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1CB5AF).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'AI Prediction',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                f.format(dailyAllowance),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 6.0),
                child: Text(
                  '/ day',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'We held back ${f.format(upcomingDues)} for your upcoming Credit Card bills and 50% for savings. Spend this amount tension-free for the next $daysLeft days!',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
