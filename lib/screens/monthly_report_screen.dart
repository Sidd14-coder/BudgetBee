import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;
import '../widgets/chatbot_fab.dart';
import '../globals.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/app_drawer.dart';
class MonthlyData {
  final DateTime date;
  final String label;
  final double income;
  final double expense;
  MonthlyData(this.date, this.label, this.income, this.expense);
  double get saving => income - expense;
  int get healthScore {
    if (income == 0) return expense == 0 ? 100 : 0;
    double per = (expense / income) * 100;
    int score = (100 - per).round();
    return score.clamp(0, 100);
  }
}
class MonthlyReportScreen extends StatefulWidget {
  const MonthlyReportScreen({super.key});

  @override
  State<MonthlyReportScreen> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  bool compareMode = false;
  int? selectedMonth;
  int? selectedYear;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    int activeMonth = selectedMonth ?? now.month;
    int activeYear = selectedYear ?? now.year;

    // Current selected month calculations
    double tmIncome = 0;
    double tmExpense = 0;
    for (var tx in allTransactions) {
      if (tx.date.year == activeYear && tx.date.month == activeMonth) {
        if (tx.isCredit) {
          tmIncome += tx.amount;
        } else {
          tmExpense += tx.amount;
        }
      }
    }
    double tmSaving = tmIncome - tmExpense;

    // 3 Months Calculations
    List<MonthlyData> mDataList = [];
    
    for (int i = 2; i >= 0; i--) {
      int targetMonth = now.month - i;
      int targetYear = now.year;
      if (targetMonth <= 0) {
        targetMonth += 12;
        targetYear -= 1;
      }
      
      double mIncome = 0;
      double mExpense = 0;

      for (var tx in allTransactions) {
        if (tx.date.year == targetYear && tx.date.month == targetMonth) {
          if (tx.isCredit) {
            mIncome += tx.amount;
          } else {
            mExpense += tx.amount;
          }
        }
      }

      final months = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
      String label = "${months[targetMonth]}";
      
      mDataList.add(MonthlyData(DateTime(targetYear, targetMonth, 1), label, mIncome, mExpense));
    }

    double compIncome = mDataList.fold(0, (sum, item) => sum + item.income);
    double compExpense = mDataList.fold(0, (sum, item) => sum + item.expense);
    double compSaving = compIncome - compExpense;

    double activeIncome = compareMode ? compIncome : tmIncome;
    double activeExpense = compareMode ? compExpense : tmExpense;
    double activeSaving = compareMode ? compSaving : tmSaving;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF0A3622),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Monthly Report",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              "Generated on ${now.day} ${_currentMonth(activeMonth, activeYear)}",
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: const Color(0xFF0A3622),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  value: "$activeMonth-$activeYear",
                  items: mDataList.map((mData) {
                    return DropdownMenuItem<String>(
                      value: "${mData.date.month}-${mData.date.year}",
                      child: Text(
                        "${mData.label} ${mData.date.year}",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      final parts = val.split('-');
                      setState(() {
                        selectedMonth = int.parse(parts[0]);
                        selectedYear = int.parse(parts[1]);
                      });
                    }
                  },
                ),
              ),
            ),
          ),
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
            ),
          ),
        ],
      ),
      floatingActionButton: const ChatbotFab(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bd_whatsapp.jpeg"),
                fit: BoxFit.cover,
                opacity: 0.6,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  
                  // TOGGLE BUTTONS
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => compareMode = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: compareMode ? Colors.transparent : const Color(0xFF0A3622),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  "This Month (${_currentMonth(activeMonth, activeYear).split(' ')[0]})",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: compareMode ? Colors.black87 : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => compareMode = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: compareMode ? const Color(0xFF0A3622) : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  "Compare 3 Months",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: compareMode ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // TOP 3 STATS
                  Row(
                    children: [
                      Expanded(
                        child: _modernCard("Total Income", activeIncome, const Color(0xFFCBEBFF), const Color(0xFF0033B9)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _modernCard("Total Expense", activeExpense, const Color(0xFFFFCCCC), const Color(0xFF990000)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _modernCard("Total Saving", activeSaving, const Color(0xFFCCFFCC), const Color(0xFF006600)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  if (!compareMode) ...[
                    // THIS MONTH VIEW
                    _sectionCard(
                      title: "Top Transactions",
                      child: Column(
                        children: _topTransactionsUI(activeMonth, activeYear),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _sectionCard(
                      title: "Spending Trend",
                      child: SizedBox(
                        height: 220,
                        child: _buildWeeklyChart(activeMonth, activeYear),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _warningBox(tmExpense, tmIncome),
                    
                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007BFF),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.share, color: Colors.white),
                        label: const Text("Share Report", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        onPressed: () async {
                          await _sharePdf(activeMonth, activeYear);
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                  ] else ...[
                    // COMPARE 3 MONTHS VIEW
                    _sectionCard(
                      title: "Compare 3 Months",
                      child: SizedBox(
                        height: 250,
                        child: _buildGroupedBarChart(mDataList),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _dataTableCard(mDataList),
                    const SizedBox(height: 20),
                    _sectionCard(
                      title: "Last 3 Months Expense Breakdown",
                      child: SizedBox(
                        height: 280,
                        child: _buildDetailedPieChart(mDataList),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _modernCard(String title, double amount, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
        ]
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87), textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(
            "₹${amount.toInt()}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  // --- THIS MONTH METHODS ---
  List<Widget> _topTransactionsUI(int month, int year) {
    final sorted = allTransactions.where((tx) => tx.date.month == month && tx.date.year == year).toList();
    sorted.sort((a,b)=>b.amount.compareTo(a.amount));
    
    if (sorted.isEmpty) return [const Text("No transactions this month.")];

    return sorted.take(3).map((tx){
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFFFE0E0),
              radius: 18,
              child: const Icon(Icons.arrow_upward, color: Colors.red, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx.description.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text("${tx.isCredit ? 'Credit' : 'Debit'} • ${tx.date.day}/${tx.date.month}/${tx.date.year}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            Text(
              "${tx.isCredit ? '+' : '-'} ₹${tx.amount.toInt()}",
              style: TextStyle(color: tx.isCredit ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _warningBox(double expense, double income) {
    double per = income == 0 ? 0 : (expense / income) * 100;
    
    if (per > 75) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4F4),
          border: Border.all(color: const Color(0xFFFFCCCC)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black87),
            children: [
              const TextSpan(text: "⚠️ Warning: ", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              TextSpan(text: "You used ${per.toStringAsFixed(0)}% of your monthly budget! Consider reducing your shopping expenses."),
            ]
          ),
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF4FFF4),
          border: Border.all(color: const Color(0xFFCCFFCC)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black87),
            children: [
              const TextSpan(text: "✅ Great Job: ", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              TextSpan(text: "You only used ${per.toStringAsFixed(0)}% of your monthly budget! Keep saving."),
            ]
          ),
        ),
      );
    }
  }

  Widget _buildWeeklyChart(int month, int year) {
    List<double> weeks = [0,0,0,0,0];

    for(final tx in allTransactions){
      if(!tx.isCredit && tx.date.month == month && tx.date.year == year){
        int week = ((tx.date.day-1)/7).floor();
        if(week < 5){
          weeks[week] += tx.amount;
        }
      }
    }

    double maxVal = weeks.reduce((a, b) => a > b ? a : b);
    maxVal = maxVal == 0 ? 1000 : maxVal * 1.5;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxVal,
        barTouchData: BarTouchData(
          enabled: false,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => Colors.transparent,
            tooltipPadding: EdgeInsets.zero,
            tooltipMargin: 4,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              if (rod.toY == 0) return null;
              return BarTooltipItem(
                "₹${rod.toY.toInt()}",
                const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text("Week ${value.toInt() + 1}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(
          5,
          (i) => BarChartGroupData(
            x: i,
            showingTooltipIndicators: [0],
            barRods: [
              BarChartRodData(
                toY: weeks[i],
                width: 28,
                color: const Color(0xFF4B8BFF),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- COMPARE 3 MONTHS METHODS ---
  Widget _buildGroupedBarChart(List<MonthlyData> mDataList) {
    double maxVal = 0;
    for (var d in mDataList) {
      if (d.income > maxVal) maxVal = d.income;
      if (d.expense > maxVal) maxVal = d.expense;
    }
    maxVal = maxVal == 0 ? 1000 : maxVal * 1.3;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 10, height: 10, color: const Color(0xFF007BFF)),
            const SizedBox(width: 4),
            const Text("Income", style: TextStyle(fontSize: 12)),
            const SizedBox(width: 16),
            Container(width: 10, height: 10, color: const Color(0xFFFF4B4B)),
            const SizedBox(width: 4),
            const Text("Expense", style: TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: BarChart(
            BarChartData(
              maxY: maxVal,
              alignment: BarChartAlignment.spaceAround,
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(mDataList[value.toInt()].label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const Text("0");
                      if (value % 5000 != 0 && value % 10000 != 0) return const SizedBox.shrink();
                      return Text("${(value).toInt()}", style: const TextStyle(fontSize: 10));
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(bottom: BorderSide(color: Colors.black12), left: BorderSide(color: Colors.black12)),
              ),
              gridData: const FlGridData(show: false),
              barTouchData: BarTouchData(
                enabled: false,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => Colors.transparent,
                  tooltipPadding: EdgeInsets.zero,
                  tooltipMargin: 6,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    if (rod.toY == 0) return null;
                    return BarTooltipItem(
                      "₹${rod.toY.toInt()}",
                      const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 9),
                    );
                  },
                ),
              ),
              barGroups: List.generate(
                mDataList.length,
                (i) => BarChartGroupData(
                  x: i,
                  barsSpace: 4,
                  showingTooltipIndicators: [0, 1],
                  barRods: [
                    BarChartRodData(
                      toY: mDataList[i].income,
                      width: 24,
                      color: const Color(0xFF007BFF),
                      borderRadius: BorderRadius.zero,
                    ),
                    BarChartRodData(
                      toY: mDataList[i].expense,
                      width: 24,
                      color: const Color(0xFFFF4B4B),
                      borderRadius: BorderRadius.zero,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dataTableCard(List<MonthlyData> mDataList) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: DataTable(
          horizontalMargin: 12,
          columnSpacing: 10,
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
          columns: const [
            DataColumn(label: Text("Month", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
            DataColumn(label: Text("Income", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
            DataColumn(label: Text("Expense", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
            DataColumn(label: Text("Savings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
            DataColumn(label: Text("Health", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          ],
          rows: mDataList.map((m) {
            return DataRow(
              cells: [
                DataCell(Text("${m.label} ${m.date.year}", style: const TextStyle(fontSize: 11))),
                DataCell(Text("₹${m.income.toInt()}", style: const TextStyle(fontSize: 11))),
                DataCell(Text("₹${m.expense.toInt()}", style: const TextStyle(fontSize: 11))),
                DataCell(Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("₹${m.saving.toInt()}", style: const TextStyle(fontSize: 11)),
                    Icon(m.saving >= 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: m.saving >= 0 ? Colors.green : Colors.red, size: 16),
                  ],
                )),
                DataCell(Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("${m.healthScore}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                    const SizedBox(width: 4),
                    Text(m.healthScore >= 70 ? "Good" : "Poor", style: TextStyle(color: m.healthScore >= 70 ? Colors.green : Colors.red, fontSize: 10)),
                  ],
                )),
              ]
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDetailedPieChart(List<MonthlyData> mDataList) {
    final colors = [const Color(0xFF0033B9), const Color(0xFFFF9900), const Color(0xFF00AACC)];
    
    double totalAll = mDataList.fold(0, (s, e) => s + e.expense);
    if (totalAll == 0) return const Center(child: Text("No expenses to chart."));

    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 0,
                  sections: List.generate(mDataList.length, (i) {
                    final d = mDataList[i];
                    double per = (d.expense / totalAll) * 100;
                    return PieChartSectionData(
                      value: per,
                      color: colors[i % colors.length],
                      title: "${per.toStringAsFixed(0)}%",
                      radius: 90,
                      titlePositionPercentageOffset: 1.3,
                      titleStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
                    );
                  }),
                )
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(mDataList.length, (i) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: colors[i % colors.length], shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Text(mDataList[i].label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(width: 16),
              ],
            );
          }),
        ),
      ],
    );
  }

  // --- UTILS ---
  Future<File> _generatePdf(int activeMonth, int activeYear) async {
    final pdf = pw.Document();
    final now = DateTime.now();

    double tmIncome = 0;
    double tmExpense = 0;
    for (var tx in allTransactions) {
      if (tx.date.year == activeYear && tx.date.month == activeMonth) {
        if (tx.isCredit) tmIncome += tx.amount;
        else tmExpense += tx.amount;
      }
    }
    double tmSaving = tmIncome - tmExpense;
    double expensePercent = tmIncome == 0 ? 0 : (tmExpense / tmIncome) * 100;

    final sortedTxs = allTransactions.where((tx) => tx.date.month == activeMonth && tx.date.year == activeYear).toList();
    sortedTxs.sort((a,b)=>b.amount.compareTo(a.amount));
    final topTxs = sortedTxs.take(3).toList();

    List<double> weeks = [0,0,0,0,0];
    for(final tx in allTransactions){
      if(!tx.isCredit && tx.date.month == activeMonth && tx.date.year == activeYear){
        int week = ((tx.date.day-1)/7).floor();
        if(week < 5){
          weeks[week] += tx.amount;
        }
      }
    }
    double maxWeekly = 0;
    if (weeks.isNotEmpty) {
      maxWeekly = weeks.reduce((a, b) => a > b ? a : b);
    }
    if(maxWeekly == 0) maxWeekly = 1000;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: const PdfColor.fromInt(0xFF0A3622),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Monthly Report", style: pw.TextStyle(color: PdfColors.white, fontSize: 24, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 4),
                        pw.Text("Generated on ${now.day} ${_currentMonth(now.month, now.year)}", style: const pw.TextStyle(color: PdfColors.white, fontSize: 12)),
                      ]
                    ),
                    pw.Text(_currentMonth(activeMonth, activeYear), style: pw.TextStyle(color: PdfColors.white, fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  ]
                )
              ),
              pw.SizedBox(height: 20),

              // Summary Cards
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _pdfSummaryCard("Total Income", tmIncome, const PdfColor.fromInt(0xFF0033B9), const PdfColor.fromInt(0xFFCBEBFF)),
                  _pdfSummaryCard("Total Expense", tmExpense, const PdfColor.fromInt(0xFF990000), const PdfColor.fromInt(0xFFFFCCCC)),
                  _pdfSummaryCard("Total Saving", tmSaving, const PdfColor.fromInt(0xFF006600), const PdfColor.fromInt(0xFFCCFFCC)),
                ]
              ),
              pw.SizedBox(height: 20),

              // Warning Box
              if (expensePercent > 75) ...[
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: const PdfColor.fromInt(0xFFFFF4F4),
                    border: pw.Border.all(color: const PdfColor.fromInt(0xFFFFCCCC)),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Text(
                    "Warning: You used ${expensePercent.toStringAsFixed(0)}% of your monthly budget! Consider reducing unnecessary expenses.",
                    style: pw.TextStyle(color: const PdfColor.fromInt(0xFF990000), fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(height: 20),
              ],

              // Top Transactions
              pw.Text("Top Transactions", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              if (topTxs.isEmpty)
                pw.Text("No transactions this month.")
              else
                pw.Column(
                  children: topTxs.map((tx) {
                    return pw.Container(
                      margin: const pw.EdgeInsets.only(bottom: 8),
                      padding: const pw.EdgeInsets.all(10),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey300),
                        borderRadius: pw.BorderRadius.circular(6),
                      ),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(tx.description.toUpperCase(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                                pw.SizedBox(height: 4),
                                pw.Text("${tx.isCredit ? 'Credit' : 'Debit'} * ${tx.date.day}/${tx.date.month}/${tx.date.year}", style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
                              ],
                            ),
                          ),
                          pw.SizedBox(width: 8),
                          pw.Text(
                            "${tx.isCredit ? '+' : '-'} Rs.${tx.amount.toInt()}",
                            style: pw.TextStyle(
                              color: tx.isCredit ? const PdfColor.fromInt(0xFF006600) : const PdfColor.fromInt(0xFF990000),
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ]
                      )
                    );
                  }).toList(),
                ),
              pw.SizedBox(height: 20),

              // Spending Trend (Weekly Chart)
              pw.Text("Spending Trend", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Container(
                height: 180,
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (i) {
                    double barHeight = (weeks[i] / maxWeekly) * 80;
                    if (barHeight < 2 && weeks[i] > 0) barHeight = 2;
                    return pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        if (weeks[i] > 0)
                          pw.Text("Rs.${weeks[i].toInt()}", style: pw.TextStyle(fontSize: 9, color: PdfColors.black, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 4),
                        pw.Container(
                          width: 28,
                          height: barHeight == 0 ? 1 : barHeight,
                          color: weeks[i] > 0 ? const PdfColor.fromInt(0xFF4B8BFF) : null,
                        ),
                        pw.SizedBox(height: 6),
                        pw.Text("Week ${i + 1}", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                      ]
                    );
                  }),
                )
              ),
            ]
          );
        }
      ),
    );
    final directory = Directory("/storage/emulated/0/Download");
    if (!await directory.exists()) await directory.create(recursive: true);
    final file = File("${directory.path}/BudgetBee_${DateTime.now().millisecondsSinceEpoch}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  pw.Widget _pdfSummaryCard(String title, double amount, PdfColor textColor, PdfColor bgColor) {
    return pw.Container(
      width: 155,
      padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: pw.BoxDecoration(
        color: bgColor,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
          pw.SizedBox(height: 6),
          pw.Text("Rs.${amount.toInt()}", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: textColor)),
        ]
      )
    );
  }

  Future<void> _sharePdf(int activeMonth, int activeYear) async {
    try {
      final file = await _generatePdf(activeMonth, activeYear);
      await Share.shareXFiles([XFile(file.path)], text: "My BudgetBee Monthly Report");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error sharing PDF")));
    }
  }

  String _currentMonth(int m, int y) {
    const months=["", "January","February","March","April","May","June","July","August","September","October","November","December"];
    return "${months[m]} $y";
  }
}
