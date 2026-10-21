import 'package:flutter/material.dart';
import '../services/dream_service.dart';
import '../models/dream_model.dart';
import 'package:intl/intl.dart';
import '../globals.dart';
import '../services/merchant_categorizer.dart';

class DreamMotivationCard extends StatefulWidget {
  const DreamMotivationCard({super.key});

  @override
  State<DreamMotivationCard> createState() => _DreamMotivationCardState();
}

class _DreamMotivationCardState extends State<DreamMotivationCard> {
  @override
  Widget build(BuildContext context) {
    final dreams = DreamService.getAllDreams();
    if (dreams.isEmpty) return const SizedBox();
    dreams.sort((a, b) => b.savedAmount.compareTo(a.savedAmount));
    final activeDream = dreams.first;

    final f = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final progress = activeDream.targetAmount > 0 
        ? (activeDream.savedAmount / activeDream.targetAmount).clamp(0.0, 1.0) 
        : 0.0;
        
    final remaining = activeDream.targetAmount - activeDream.savedAmount;

    // AI Tip Dynamic Calculation (Daily Save Goal)
    String aiTipText = "";
    if (progress < 1.0) {
      final daysLeft = activeDream.deadline.difference(DateTime.now()).inDays;
      if (daysLeft > 0) {
        final dailyAmount = remaining / daysLeft;
        aiTipText = "AI Tip: Save ₹${dailyAmount.toStringAsFixed(0)} daily for the next $daysLeft days to achieve this! 🎯";
      } else if (daysLeft == 0) {
        aiTipText = "AI Tip: Today is your deadline! You need ${f.format(remaining)} more to complete this! ⏳";
      } else {
        aiTipText = "AI Tip: Your deadline has passed. Consider editing your dream to extend the date! ⏰";
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E002B),
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/images/bd_whatsapp.jpeg'),
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E002B).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '⚡ Dream Engine',
                style: TextStyle(color: Color(0xFFE8B923), fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
              if (progress >= 1.0)
                const Icon(Icons.star, color: Color(0xFFE8B923), size: 20)
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    DateFormat('d MMM y').format(activeDream.deadline),
                    style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(activeDream.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, height: 1.1)),
          const SizedBox(height: 10),
          
          if (progress >= 1.0)
            const Text("🎉 Goal Achieved! You can buy it today!", style: TextStyle(color: Color(0xFF1CB5AF), fontWeight: FontWeight.bold, fontSize: 16))
          else
            Text("You are just ${f.format(remaining)} away!", style: const TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w500)),
            
          const SizedBox(height: 16),
          Stack(
            children: [
              Container(height: 10, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(5))),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8B923),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [BoxShadow(color: const Color(0xFFE8B923).withOpacity(0.8), blurRadius: 8)],
                  ),
                ),
              ),
            ],
          ),
          if (progress < 1.0) ...[
            const SizedBox(height: 12),
            Text(
              aiTipText,
              style: TextStyle(color: Colors.yellow[100], fontStyle: FontStyle.italic, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}
