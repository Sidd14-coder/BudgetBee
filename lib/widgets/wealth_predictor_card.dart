import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../globals.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

class WealthPredictorCard extends StatefulWidget {
  const WealthPredictorCard({super.key});

  @override
  State<WealthPredictorCard> createState() => _WealthPredictorCardState();
}

class _WealthPredictorCardState extends State<WealthPredictorCard> {
  double _years = 1.0;
  final double _annualReturnRate = 0.12; // Modest 12% mutual fund assumption

  double _calculateProjection() {
    double monthlySavings = totalCredit - totalDebit;
    // If not saving, fallback to projecting a modest 1000 rupees/month to show capability
    if (monthlySavings < 1000) {
      monthlySavings = 1000;
    }
    
    // Future Value of a Series formula (Compound Interest on SIP)
    double r = _annualReturnRate / 12; // Monthly rate
    double n = _years * 12; // Total months
    double futureValue = monthlySavings * ((math.pow(1 + r, n) - 1) / r) * (1 + r);
    return futureValue;
  }

  @override
  Widget build(BuildContext context) {
    double projectedWealth = _calculateProjection();
    final f = NumberFormat.compactCurrency(locale: 'en_IN', symbol: '₹');

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      // 💎 Premium Glassmorphic Deep Space Gradient
      decoration: BoxDecoration(
        color: const Color(0xff0f2027),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF203A43).withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                   const Icon(Icons.rocket_launch, color: Color(0xFF00FF87), size: 20),
                   const SizedBox(width: 8),
                   const Text(
                    'Time-Travel Wealth',
                    style: TextStyle(
                        color: Color(0xFF00FF87),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_years.toInt()} Years',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Your Projected Net Worth:',
            style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          // Animated Number Counter
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCirc,
            tween: Tween<double>(begin: 0, end: projectedWealth),
            builder: (context, value, child) {
              return Text(
                f.format(value).replaceAll('T', 'K'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  letterSpacing: -1,
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF00FF87),
              inactiveTrackColor: Colors.white.withOpacity(0.2),
              thumbColor: Colors.white,
              overlayColor: const Color(0xFF00FF87).withOpacity(0.2),
              trackHeight: 6,
            ),
            child: Slider(
              value: _years,
              min: 1,
              max: 20,
              divisions: 19,
              onChanged: (val) {
                setState(() => _years = val);
              },
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              "Slide to see your future wealth based on your current savings! 💸",
              style: TextStyle(color: Colors.yellow[100], fontStyle: FontStyle.italic, fontSize: 11),
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 800.ms).scale(begin: const Offset(0.95, 0.95));
  }
}
