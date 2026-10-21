import 'package:flutter/material.dart';
import '../../services/emi_service.dart';
import 'manage_emi_screen.dart';

class EmiTrackerCard extends StatelessWidget {
  final double income;

  const EmiTrackerCard({super.key, required this.income});

  @override
  Widget build(BuildContext context) {
    double emi = totalEmi;
    double remaining = income - emi;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.08),
                )
              ],
            ),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Monthly EMI Payments",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),

                _row("Monthly Income", income),
                _row("Total EMI", emi),
                _row("Remaining Balance After EMI", remaining),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF1E3CFF), Color(0xFF001A9E)]),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: const Color(0xFF1E3CFF).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
              ]
            ),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.trending_up, color: Colors.white),
              label: const Text("Manage EMI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ManageEmiScreen(),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _row(String title, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text("₹${value.toStringAsFixed(0)}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
