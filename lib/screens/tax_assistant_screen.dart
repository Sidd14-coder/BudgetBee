import 'dart:convert';
import 'package:flutter/material.dart';
import '../../globals.dart';
import '../../services/gemini_service.dart';
import 'package:intl/intl.dart';
import '../widgets/app_drawer.dart';
class TaxAssistantScreen extends StatefulWidget {
  const TaxAssistantScreen({super.key});

  @override
  State<TaxAssistantScreen> createState() => _TaxAssistantScreenState();
}

class _TaxAssistantScreenState extends State<TaxAssistantScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _taxData;

  @override
  void initState() {
    super.initState();
    _analyzeTax();
  }

  Future<void> _analyzeTax() async {
    // Send a larger batch of expenses to find tax-deductible items (e.g., life insurance, medical, education)
    final recentDebits = allTransactions.where((t) => t.isCredit == false).take(100).toList();
    
    if (recentDebits.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "No transactions found to review for taxes.";
        });
      }
      return;
    }

    final txListJson = recentDebits.map((e) => {
      "desc": e.description.replaceAll(RegExp(r'\n+'), ' '),
      "amount": e.amount,
      "date": e.date.toIso8601String().substring(0, 10),
    }).toList();

    String jsonStr = jsonEncode(txListJson);

    final result = await GeminiService.analyzeTransactionsForTax(jsonStr);

    if (mounted) {
      if (result != null) {
        setState(() {
          _taxData = result;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Failed to analyze taxes via AI. Please try again.";
          _isLoading = false;
        });
      }
    }
  }

  final _currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Soft background
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('AI Tax Assistant', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0A3622),
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
      body: _isLoading 
        ? Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFF0A3622)),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text("BudgetBee is acting as your CA...\nScanning bank texts for 80C and 80D eligible deductions...", textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
              ),
            ],
          ))
        : _errorMessage != null 
          ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // TAX ADVICE CARD
                  if (_taxData?['tax_advice'] != null)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF0A3622), Color(0xFF114F2E)]),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 5)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.account_balance, color: Colors.white, size: 28),
                              SizedBox(width: 10),
                              Text("CA's Summary Report", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(_taxData!['tax_advice'], style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5)),
                        ],
                      ),
                    ),

                  // DEDUCTION METRICS
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard("Sec 80C Eligible", _taxData?['total_80c_eligible'] ?? 0, const Color(0xFF0A3622)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildMetricCard("Sec 80D Eligible", _taxData?['total_80d_eligible'] ?? 0, const Color(0xFF2C3E78)),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 30),

                  // ELIGIBLE TRANSACTIONS
                  const Text('Deductible Transactions Found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 12),
                  
                  if (_taxData?['eligible_transactions'] != null && (_taxData!['eligible_transactions'] as List).isNotEmpty)
                    Column(
                      children: (_taxData!['eligible_transactions'] as List).map((tx) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.withOpacity(0.2)),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(tx['merchant'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                                    const SizedBox(height: 4),
                                    Text(tx['date'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(_currencyFormatter.format(tx['amount']), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0A3622).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text("Sec ${tx['section'] ?? 'N/A'}", style: const TextStyle(color: Color(0xFF0A3622), fontSize: 11, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text("No tax-deductible transactions found in recent history. Provide receipts of your LIC/Medical premium for OCR analysis.", style: TextStyle(color: Colors.grey, height: 1.4)),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildMetricCard(String title, num amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[700], fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(_currencyFormatter.format(amount), style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w900, height: 1.1)),
        ],
      ),
    );
  }
}
