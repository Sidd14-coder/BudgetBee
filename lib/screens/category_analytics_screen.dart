import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/merchant_categorizer.dart';
import '../screens/transactions_screen.dart'; // To get parseTransactionSMS
import '../widgets/app_drawer.dart';
class CategoryAnalyticsScreen extends StatefulWidget {
  const CategoryAnalyticsScreen({super.key});

  @override
  State<CategoryAnalyticsScreen> createState() => _CategoryAnalyticsScreenState();
}

class _CategoryAnalyticsScreenState extends State<CategoryAnalyticsScreen> {
  final Telephony telephony = Telephony.instance;
  bool isLoading = true;
  int touchedIndex = -1;

  Map<String, double> categorySpends = {};
  double totalSpend = 0;
  String topCategory = "None";

  @override
  void initState() {
    super.initState();
    _analyzeData();
  }

  Future<void> _analyzeData() async {
    final ok = await telephony.requestSmsPermissions;
    if (ok != true) {
      setState(() => isLoading = false);
      return;
    }

    final smsList = await telephony.getInboxSms(
      columns: [SmsColumn.BODY, SmsColumn.DATE],
      sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
    );

    Map<String, double> tempSpends = {};
    double tSpend = 0;

    // We only analyze current month
    final now = DateTime.now();

    for (var msg in smsList) {
      if (msg.date == null || msg.body == null) continue;
      
      final date = DateTime.fromMillisecondsSinceEpoch(msg.date!);
      if (date.month != now.month || date.year != now.year) continue; // Only this month

      final parsed = parseTransactionSMS(msg.body!);
      if (parsed != null && parsed.isDebit) {
        final catData = MerchantCategorizer.getCategoryAndIcon(msg.body!);
        final categoryName = catData['category'] as String;

        tempSpends[categoryName] = (tempSpends[categoryName] ?? 0) + parsed.amount;
        tSpend += parsed.amount;
      }
    }

    // Sort categories by spend (highest first)
    final sortedEntries = tempSpends.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final sortedSpends = Map.fromEntries(sortedEntries);

    setState(() {
      categorySpends = sortedSpends;
      totalSpend = tSpend;
      if (sortedSpends.isNotEmpty) {
        topCategory = sortedSpends.keys.first;
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        
        title: const Text('Spending DNA', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0A3622),
        elevation: 0,
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    if (categorySpends.isEmpty) {
      return const Center(child: Text('No spending data found this month.', style: TextStyle(color: Colors.grey)));
    }

    final sections = _createPieSections();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Spend Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF0A3622), Color(0xFF114F2E)]),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: const Color(0xFF0A3622).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('This Month\'s Spend', style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 8),
                Text('₹${totalSpend.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 16),
                      const SizedBox(width: 8),
                      Text('High Spend Alert: $topCategory', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30),

          // Detailed Breakdown
          const Text('Category Analytics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 20),

          // The BEAUTIFUL PIE CHART
          Container(
            height: 250,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]
            ),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: -270, end: -90),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return PieChart(
                  PieChartData(
                    startDegreeOffset: value,
                    sectionsSpace: 0,
                    centerSpaceRadius: 50,
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    sections: _createPieSections(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 30),

          // Category List Items
          ...categorySpends.entries.map((e) {
            final catName = e.key;
            final spend = e.value;
            final percentage = ((spend / totalSpend) * 100).toStringAsFixed(1);
            
            final catData = MerchantCategorizer.predefinedCategories[catName] ?? {'icon': Icons.payment, 'color': Colors.grey};
            final IconData catIcon = catData['icon'];
            final Color catColor = catData['color'];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))]
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: catColor.withOpacity(0.15),
                    radius: 24,
                    child: Icon(catIcon, color: catColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(catName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text('$percentage% of total', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  Text('₹${spend.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black87)),
                ],
              ),
            );
          }).toList(),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  List<PieChartSectionData> _createPieSections() {
    List<PieChartSectionData> sections = [];
    int index = 0;
    for (var entry in categorySpends.entries) {
      final isLarge = index < 3; 
      final val = entry.value;
      final percentage = (val / totalSpend) * 100;
      
      final catData = MerchantCategorizer.predefinedCategories[entry.key] ?? {'color': Colors.grey};
      final Color catColor = catData['color'];

      final isTouched = index == touchedIndex;
      final double radius = isTouched ? 75.0 : (isLarge ? 60.0 : 50.0);
      
      String titleText = '';
      if (isTouched) {
        titleText = '${entry.key}\n${percentage.toStringAsFixed(0)}%';
      } else if (isLarge) {
        titleText = '${percentage.toStringAsFixed(0)}%';
      }

      sections.add(
        PieChartSectionData(
          color: catColor,
          value: val,
          title: titleText,
          radius: radius,
          titleStyle: TextStyle(
            fontSize: isTouched ? 14 : 12, 
            fontWeight: FontWeight.bold, 
            color: Colors.white,
            shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 2)],
          ),
          badgeWidget: null,
          badgePositionPercentageOffset: .98,
        ),
      );
      index++;
    }
    return sections;
  }
}
