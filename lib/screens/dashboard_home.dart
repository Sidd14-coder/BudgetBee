import 'package:flutter/material.dart';
import '../widgets/scanning_overlay_screen.dart';
import '../widgets/wealth_predictor_card.dart';
import '../globals.dart';
import '../widgets/debit_credit_chart.dart';
import 'analytics_screen.dart';
import '../data/refresh_totals.dart';
import 'monthly_report_screen.dart'; // ADDED
import 'category_analytics_screen.dart'; // ADDED
import 'custom/custom_transactions_screen.dart';
import 'chatbot_screen.dart';
import '../widgets/fin_health_card.dart';
import '../widgets/safe_to_spend_card.dart'; // ADDED 'SAFE TO SPEND' PREDICTOR
import 'credit_card_screen.dart'; // ADDED CREDIT CARD MANAGER
import 'health_doctor_screen.dart'; // ADDED AI HEALTH DOCTOR
import 'tax_assistant_screen.dart'; // ADDED AI TAX ASSISTANT
import '../widgets/dream_motivation_card.dart'; // ADDED DREAM WIDGET
import 'dream_engine_screen.dart'; // ADDED DREAM MANAGER
import 'subscription_manager_screen.dart'; // ADDED SMART SUBSCRIPTIONS
import '../widgets/app_drawer.dart'; // ADDED UNIVERSAL DRAWER

import 'dart:io'; 

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/ocr_service.dart';
import 'custom/add_transaction_screen.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _scanReceipt() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Select Image Source", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF0A3622)),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF0A3622)),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission is required.')),
        );
        return;
      }
    }

    try {
      final picker = ImagePicker();
      XFile? pickedFile;
      
      if (source == ImageSource.camera) {
        // Balanced quality to prevent SIG 9 crashes while maintaining OCR readability
        pickedFile = await picker.pickImage(source: source, imageQuality: 85, maxWidth: 1600);
      } else {
        // High quality for Gallery to ensure small fonts (like D-Mart bills) are captured perfectly by Vision AI
        pickedFile = await picker.pickImage(source: source, imageQuality: 100);
      }
      
      if (pickedFile == null) return;
      if (!mounted) return;
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ScanningOverlayScreen(imageFile: File(pickedFile!.path)), 
        ),
      ).then((_) => _loadData());
    } catch (e) {
      debugPrint("Image picker error: $e");
    }
  }

  /// Initial data load and RefreshIndicator logic
  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    // Ensure refreshTotals() uses the 'currentFilter' internally to filter SMS
    await refreshTotals();

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  /// Triggered when the Weekly/Monthly dropdown changes
  Future<void> _onFilterChange(FilterType v) async {
    setState(() {
      currentFilter = v;
      _isLoading = true;
    });

    // We call refreshTotals again so it can re-scan the SMS with the new date range
    await refreshTotals();

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildBleedWarning() {
    if (currentFilter == FilterType.weekly) return const SizedBox.shrink(); // Only accurate for monthly
    if (totalCredit <= 0 || globalTotalSpent <= 0) return const SizedBox.shrink();
    
    int currentDay = DateTime.now().day;
    // Prevent day 1 overreactions
    if (currentDay < 3) return const SizedBox.shrink(); 
    
    double dailyVelocity = globalTotalSpent / currentDay;
    double projectedMonthSpend = dailyVelocity * 30;
    
    // If projected spend exceeds 90% of income, trigger alert
    if (projectedMonthSpend > totalCredit * 0.9) {
      int daysToRuin = 0;
      if (dailyVelocity > 0) {
         daysToRuin = ((totalCredit - globalTotalSpent) / dailyVelocity).floor();
      }
      if (daysToRuin < 0) daysToRuin = 0;
      
      return Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0F0),
          border: Border.all(color: Colors.redAccent.withOpacity(0.5), width: 2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("⚠️ AI Bleed Warning", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text("Your spending velocity is ₹${dailyVelocity.toStringAsFixed(0)}/day. At this rate, you will exhaust your income in $daysToRuin days and severely delay your Dream targets!", style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.4, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        )
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),

      floatingActionButton: Stack(
        children: [
          // 🤖 CHATBOT BUTTON (UPPER)
          Positioned(
            bottom: 90,
            right: 16,
            child: FloatingActionButton(
              heroTag: "chatbot",
              backgroundColor: const Color(0xFF1E002B),
              shape: const CircleBorder(
                side: BorderSide(color: Colors.white, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset('assets/icons/chatbot.png'),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChatbotScreen(),
                  ),
                );
              },
            ),
          ),

          // ➕ EXISTING PLUS BUTTON
          Positioned(
            bottom: 20,
            right: 16,
            child: FloatingActionButton(
              heroTag: "add",
              backgroundColor: const Color(0xFF0A3622),
              shape: const CircleBorder(
                side: BorderSide(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CustomTransactionsScreen(),
                  ),
                ).then((_) => _loadData());
              },
            ),
          ),
        ],
      ),

      endDrawer: const AppDrawer(), // Hooked Universal App Drawer

      // ===== HEADER =====
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF0A3622),
          flexibleSpace: Container(
            color: const Color(0xFF0A3622),
          ),
          title: const Padding(
            padding: EdgeInsets.only(left: 4, top: 16),
            child: Text(
              'Overview',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: IconButton(
                icon: const Icon(Icons.document_scanner, color: Colors.white, size: 26),
                onPressed: _scanReceipt,
                tooltip: "Scan Receipt",
              ),
            ),
            Builder(
              builder: (ctx) => Padding(
                padding: const EdgeInsets.only(top: 16, right: 8),
                child: IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white, size: 26),
                  onPressed: () => Scaffold.of(ctx).openEndDrawer(),
                  tooltip: "Menu",
                ),
              ),
            ),
          ],
        ),
      ),

      // ===== BODY =====
      body: Stack(
        children: [
          // Background image with overlay
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bd_whatsapp.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          RefreshIndicator(
            onRefresh: _loadData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== PREDICTIVE BLEED WARNING (AI) =====
                  _buildBleedWarning(),

                  // ===== DREAM MOTIVATION CARD (NEW) =====
                  const DreamMotivationCard(),
                  
                  // ===== TIME-TRAVEL WEALTH PREDICTOR (SHOCK FEATURE) =====
                  WealthPredictorCard(),
                  
                  // ===== FIN HEALTH CARD (NEW) =====
                  const FinHealthCard(),

                  // ===== SAFE TO SPEND PREDICTOR (NEW) =====
                  const SafeToSpendCard(),


                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
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
                              'Total Spent',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFBBE5BE),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButton<FilterType>(
                                value: currentFilter,
                                dropdownColor: const Color(0xFFBBE5BE),
                                underline: const SizedBox(),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black87,
                                  size: 20,
                                ),
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: FilterType.weekly,
                                    child: Text('Weekly'),
                                  ),
                                  DropdownMenuItem(
                                    value: FilterType.monthly,
                                    child: Text('Monthly'),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v != null) _onFilterChange(v);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        _isLoading
                            ? const SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  color: Colors.black87,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                '₹${globalTotalSpent.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ===== DEBIT & CREDIT SUMMARY =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => _showTransactionsPopup(true),
                        child: _summaryCard(
                          title: 'Debit',
                          amount: totalDebit,
                          color: const Color(0xFFF1655F),
                          icon: Icons.arrow_upward,
                          isDebit: true,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showTransactionsPopup(false),
                        child: _summaryCard(
                          title: 'Credit',
                          amount: totalCredit,
                          color: const Color(0xFF7DDF73),
                          icon: Icons.arrow_downward,
                          isDebit: false,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ===== CHART =====

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: DebitCreditBarChart(
                      totalDebit: totalDebit,
                      totalCredit: totalCredit,
                    ),
                  ),



                ],
              ),
            ),


          ),
        ],
      ),
    );
  }

  // ===== SUMMARY CARD =====
  Widget _summaryCard({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
    required bool isDebit,
  }) {
    final gradient = isDebit 
        ? const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFC92A2A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFF69DB7C), Color(0xFF2B8A3E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -15,
            bottom: -5,
            child: Icon(
              icon,
              size: 80,
              color: Colors.white.withOpacity(0.15),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '₹${amount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isDebit ? 'Money Spent' : 'Money Received',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===== TRANSACTIONS POPUP =====
  void _showTransactionsPopup(bool isDebit) {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    final filtered = allTransactions.where((t) {
      if (t.isCredit == isDebit) return false;
      return t.date.isAfter(thirtyDaysAgo);
    }).toList();

    filtered.sort((a, b) => b.date.compareTo(a.date));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Color(0xFFF9FAFB),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 20),
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Text(
                isDebit ? 'Recent Debit Transactions' : 'Recent Credit Transactions',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E002B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Last 30 Days Activity',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          'No transactions found.',
                          style: TextStyle(color: Colors.grey[500], fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final tx = filtered[index];
                          final amtStr = '₹${tx.amount.toStringAsFixed(0)}';
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isDebit
                                        ? const Color(0xFFFF6B6B).withOpacity(0.15)
                                        : const Color(0xFF69DB7C).withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isDebit ? Icons.arrow_upward : Icons.arrow_downward,
                                    color: isDebit ? const Color(0xFFC92A2A) : const Color(0xFF2B8A3E),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tx.description.isEmpty ? 'Unknown' : tx.description,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${tx.date.day}/${tx.date.month}/${tx.date.year}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  (isDebit ? '- ' : '+ ') + amtStr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: isDebit ? const Color(0xFFC92A2A) : const Color(0xFF2B8A3E),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
