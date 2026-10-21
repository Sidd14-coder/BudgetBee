import 'package:flutter/material.dart';
import '../../services/credit_card_service.dart';
import '../../models/credit_card_model.dart';
import 'package:intl/intl.dart';
import '../widgets/app_drawer.dart';
class CreditCardScreen extends StatefulWidget {
  const CreditCardScreen({super.key});

  @override
  State<CreditCardScreen> createState() => _CreditCardScreenState();
}

class _CreditCardScreenState extends State<CreditCardScreen> {
  List<CreditCardModel> cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  void _loadCards() {
    setState(() {
      cards = CreditCardService.getAllCards();
    });
  }

  int _daysLeft(DateTime dueDate) {
    return dueDate.difference(DateTime.now()).inDays;
  }

  // Gemini calculation logic for paying minimum due
  String _calculateTrap(CreditCardModel card) {
    if (card.minDue <= 0 || card.totalDue <= 0) return '';
    // Rough trap calculation assuming 3.5% monthly interest on remaining balance if only min is paid
    int months = 0;
    double balance = card.totalDue;
    double totalPaid = 0;
    
    // Safety check to avoid infinite loops
    while (balance > 0 && months < 360) {
      double interest = balance * 0.035; // 3.5% p.m. typical CC interest
      balance += interest;
      if (balance <= card.minDue) {
        totalPaid += balance;
        balance = 0;
      } else {
        balance -= card.minDue;
        totalPaid += card.minDue;
      }
      months++;
    }

    int years = months ~/ 12;
    int remainingMonths = months % 12;
    
    double extraInterest = totalPaid - card.totalDue;
    
    String timeStr = years > 0 ? '$years years and $remainingMonths months' : '$months months';
    final f = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    
    return "⚠️ AI Warning: If you only pay minimum due, it will take $timeStr to clear this debt and cost you ${f.format(extraInterest)} in extra interest!";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        
        title: const Text('💳 Credit Card Manager', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: cards.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No pending Credit Card bills detected.", style: TextStyle(color: Colors.black54, fontSize: 16)),
                  const Text("We automatically scan SMS for statements.", style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                final daysLeft = _daysLeft(card.dueDate);
                final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                    gradient: LinearGradient(
                      colors: [const Color(0xFF1CB5AF), const Color(0xFF2C3E78)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(card.cardName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text('**** **** **** ${card.last4Digits}', style: const TextStyle(color: Colors.white70, fontSize: 20, letterSpacing: 2)),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Total Due', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                Text(currencyFormatter.format(card.totalDue), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('Due Date', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                Text(DateFormat('dd MMM').format(card.dueDate), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // Smart AI Warning for Minimum Due Trap
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Minimum Due:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                  Text(currencyFormatter.format(card.minDue), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(_calculateTrap(card), style: const TextStyle(color: Color(0xFFFFCCCC), fontSize: 11, fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Days Left Indicator
                        Row(
                          children: [
                            Icon(daysLeft < 3 ? Icons.warning_amber_rounded : Icons.check_circle_outline, color: daysLeft < 3 ? Colors.orangeAccent : Colors.tealAccent, size: 20),
                            const SizedBox(width: 8),
                            Text(daysLeft < 0 ? 'OVERDUE by ${daysLeft.abs()} days!' : 'Pay in $daysLeft days to avoid late fees', style: TextStyle(color: daysLeft < 0 ? Colors.redAccent : Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
