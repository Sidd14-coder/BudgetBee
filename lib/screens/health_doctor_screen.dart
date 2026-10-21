import 'dart:convert';
import 'package:flutter/material.dart';
import '../../globals.dart';
import '../../services/gemini_service.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_drawer.dart';

class HealthDoctorScreen extends StatefulWidget {
  const HealthDoctorScreen({super.key});

  @override
  State<HealthDoctorScreen> createState() => _HealthDoctorScreenState();
}

class _HealthDoctorScreenState extends State<HealthDoctorScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _healthData;

  @override
  void initState() {
    super.initState();
    _analyzeHealth();
  }

  Future<void> _analyzeHealth() async {
    // Analyze debit transactions from exactly the last 30 days
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    final recentDebits = allTransactions.where((t) => 
      t.isCredit == false && t.date.isAfter(thirtyDaysAgo)
    ).take(50).toList(); // Capped at 50 to save Gemini token limits
    
    if (recentDebits.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = "No recent expenses found to analyze.";
      });
      return;
    }

    final txListJson = recentDebits.map((e) => {
      "desc": e.description.replaceAll(RegExp(r'\n+'), ' '),
      "amount": e.amount,
      "date": e.date.toIso8601String().substring(0, 10),
      "bank": e.bank,
    }).toList();

    String jsonStr = jsonEncode(txListJson);

    final result = await GeminiService.analyzeTransactionsForHealth(jsonStr);

    if (mounted) {
      if (result != null) {
        setState(() {
          _healthData = result;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Failed to get AI diagnosis. Please try again later.";
          _isLoading = false;
        });
      }
    }
  }

  final _currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Light green theme
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        
        title: const Text('AI Health Doctor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
              const Text("AI is reviewing your last 30 days of expenses...", style: TextStyle(color: Colors.black54)),
            ],
          ))
        : _errorMessage != null 
          ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // ADVICE CARD
                  if (_healthData?['doctor_advice'] != null)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF2C3E78), Color(0xFF0A3622)]),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.monitor_heart, color: Colors.white, size: 28),
                              SizedBox(width: 10),
                              Text("Doctor's Verdict", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(_healthData!['doctor_advice'], style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5)),
                        ],
                      ),
                    ),

                  // TOP CATEGORIES
                  if (_healthData?['top_categories'] != null)
                    const Text('Top Auto-Categorization', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0A3622))),
                  if (_healthData?['top_categories'] != null)
                    const SizedBox(height: 12),
                  if (_healthData?['top_categories'] != null)
                    Column(
                      children: (_healthData!['top_categories'] as List).map((cat) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: const Color(0xFF0A3622).withOpacity(0.1),
                                      child: const Icon(Icons.category, color: Color(0xFF0A3622), size: 18),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        cat['name'], 
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(_currencyFormatter.format(cat['amount']), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  
                  const SizedBox(height: 24),

                  // HIDDEN SUBSCRIPTIONS
                  const Text('🚨 Hidden Subscriptions Detected', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                  const SizedBox(height: 12),
                  if (_healthData?['hidden_subscriptions'] != null && (_healthData!['hidden_subscriptions'] as List).isNotEmpty)
                    Column(
                      children: (_healthData!['hidden_subscriptions'] as List).map((sub) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(sub['merchant'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                                  Text(_currencyFormatter.format(sub['amount']), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.redAccent)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(sub['warning'] ?? '', style: const TextStyle(color: Colors.red, fontStyle: FontStyle.italic, fontSize: 13)),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () async {
                                    final merchant = sub['merchant'] ?? 'Unknown';
                                    final Uri emailLaunchUri = Uri(
                                      scheme: 'mailto',
                                      path: 'support@budgetbee.com', // Placeholder
                                      query: 'subject=URGENT: Cancel Subscription&body=Hello,\\n\\nPlease cancel my recurring subscription immediately for the account associated with this email address regarding $merchant.\\n\\nThank you.',
                                    );
                                    if (await canLaunchUrl(emailLaunchUri)) {
                                      await launchUrl(emailLaunchUri);
                                    } else {
                                      // Fallback to Google Search for the cancellation page
                                      final Uri searchUri = Uri.parse('https://www.google.com/search?q=how+to+cancel+$merchant+subscription');
                                      if (await canLaunchUrl(searchUri)) {
                                        await launchUrl(searchUri);
                                      }
                                    }
                                  },
                                  icon: const Icon(Icons.cancel, color: Colors.redAccent),
                                  label: const Text('Assassinate', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                  else
                    const Text("Great! No hidden subscriptions detected in recent SMS.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
    );
  }
}
