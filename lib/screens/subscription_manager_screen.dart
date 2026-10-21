import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/subscription_model.dart';
import '../models/transaction_model.dart';
import '../globals.dart';
import '../services/merchant_categorizer.dart';

class SubscriptionManagerScreen extends StatefulWidget {
  const SubscriptionManagerScreen({super.key});

  @override
  State<SubscriptionManagerScreen> createState() => _SubscriptionManagerScreenState();
}

class _SubscriptionManagerScreenState extends State<SubscriptionManagerScreen> {
  
  List<Subscription> _autoSubscriptions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _scanForSubscriptions();
  }

  void _scanForSubscriptions() {
    // Background keyword detection for subscriptions
    Map<String, Subscription> subsMap = {};

    final regex = RegExp(
      r'\b(autopay|mandate|e-mandate|si|standing instruction|subscription|recurring|auto-debit|auto debit|auto renewal)\b',
      caseSensitive: false,
    );

    for (var t in allTransactions) {
      if (t.description != null && regex.hasMatch(t.description!)) {
        // Found an auto-debit!
        // Extract a clean merchant name
        String merchantName = MerchantCategorizer.getCleanName(t.description!);
        if (merchantName == "Unknown Merchant") {
          merchantName = "Bank Auto-Debit";
        }

        // Use merchant + amount as a unique key so we don't duplicate
        String key = '${merchantName}_${t.amount}';

        if (!subsMap.containsKey(key)) {
          // Estimate next due date (assume Monthly for automatic ones initially)
          DateTime nextDue = DateTime(t.date.year, t.date.month + 1, t.date.day);
          
          // Fast-forward to the closest upcoming date if it's an old SMS
          while (nextDue.isBefore(DateTime.now().subtract(const Duration(days: 3)))) {
             nextDue = DateTime(nextDue.year, nextDue.month + 1, nextDue.day);
          }

          subsMap[key] = Subscription(
             id: key,
             name: merchantName,
             amount: t.amount,
             category: 'Subscriptions',
             billingCycle: 'Monthly', // Safest automated assumption
             nextDueDate: nextDue,
             isAutoDetected: true,
          );
        }
      }
    }

    setState(() {
      _autoSubscriptions = subsMap.values.toList();
      // Sort by due date
      _autoSubscriptions.sort((a, b) => a.nextDueDate.compareTo(b.nextDueDate));
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    double totalMonthly = 0;
    for (var s in _autoSubscriptions) {
        totalMonthly += s.amount;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3622),
        title: const Text('Smart Subscriptions', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _autoSubscriptions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text("No Subscriptions Found", style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "We scan your bank messages for autopay, mandates, and recurring instructions. None found yet!", 
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            )
          : Column(
            children: [
              // Monthly overview card
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF1E002B), Color(0xFF3B0054)]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.auto_awesome, color: Colors.white70, size: 16),
                              SizedBox(width: 8),
                              Text("Est. Auto-Detected Expenses", style: TextStyle(color: Colors.white70, fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text("₹${totalMonthly.toStringAsFixed(0)}", style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const Icon(Icons.loop, color: Colors.white, size: 48),
                  ],
                ),
              ),
              
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _autoSubscriptions.length,
                  itemBuilder: (context, index) {
                    final sub = _autoSubscriptions[index];
                    final isDueSoon = sub.nextDueDate.difference(DateTime.now()).inDays <= 3 && sub.nextDueDate.isAfter(DateTime.now().subtract(const Duration(days:1)));
                    final isOverdue = sub.nextDueDate.isBefore(DateTime.now());

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: isOverdue ? Colors.red.withOpacity(0.2) : isDueSoon ? Colors.orange.withOpacity(0.2) : const Color(0xFF0A3622).withOpacity(0.1),
                          child: Icon(
                            Icons.receipt_long,
                            color: isOverdue ? Colors.red : isDueSoon ? Colors.orange : const Color(0xFF0A3622),
                          ),
                        ),
                        title: Text(sub.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text("₹${sub.amount.toStringAsFixed(0)} • ${sub.billingCycle}"),
                            const SizedBox(height: 4),
                            Text(
                              isOverdue ? "Overdue: ${DateFormat('dd MMM').format(sub.nextDueDate)}" :
                              "Due: ${DateFormat('dd MMM').format(sub.nextDueDate)}",
                              style: TextStyle(
                                color: isOverdue ? Colors.red : isDueSoon ? Colors.orange : Colors.grey[700],
                                fontWeight: (isDueSoon || isOverdue) ? FontWeight.bold : FontWeight.normal,
                              ),
                            )
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text("AUTO", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
    );
  }
}
