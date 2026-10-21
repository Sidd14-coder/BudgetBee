import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../globals.dart';

class DebitCreditLineChart extends StatelessWidget {
  const DebitCreditLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    if (dailyDebitMap.isEmpty && dailyCreditMap.isEmpty) {
      return const Center(
        child: Text(
          'No transaction data available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // ===== 1. DETERMINE START DATE (1st of month for Monthly) =====
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    DateTime startDate;
    int daysCount;

    if (currentFilter == FilterType.weekly) {
      daysCount = 7;
      startDate = today.subtract(const Duration(days: 6));
    } else {
      // "This Month" means from the 1st date of the month
      startDate = DateTime(now.year, now.month, 1);
      daysCount = today.difference(startDate).inDays + 1;
    }

    // ===== 2. BUILD CONTINUOUS SPOTS (Filling missing days with 0) =====
    final List<DateTime> allDays = [];
    final List<FlSpot> debitSpots = [];
    final List<FlSpot> creditSpots = [];

    for (int i = 0; i < daysCount; i++) {
      final date = startDate.add(Duration(days: i));
      final dayKey = DateTime(date.year, date.month, date.day);
      
      allDays.add(dayKey);
      debitSpots.add(FlSpot(i.toDouble(), dailyDebitMap[dayKey] ?? 0.0));
      creditSpots.add(FlSpot(i.toDouble(), dailyCreditMap[dayKey] ?? 0.0));
    }

    // ===== 3. CALCULATE 75% LINE & MAX Y SCALE =====
    final double spendingThreshold = totalCredit * 0.75;

    double highestValue = spendingThreshold;
    for (var spot in [...debitSpots, ...creditSpots]) {
      if (spot.y > highestValue) highestValue = spot.y;
    }
    
    // Add padding so chart isn't cramped at the top
    final double maxY = highestValue == 0 ? 1000 : highestValue * 1.25;

    return Column(
      children: [
        SizedBox(
          height: 260,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (daysCount - 1).toDouble(),
              minY: 0,
              maxY: maxY,

              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: _yInterval(maxY),
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.withOpacity(0.1),
                  strokeWidth: 1,
                ),
              ),

              borderData: FlBorderData(show: false),

              // ===== 75% SPENDING LIMIT LINE =====
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  if (spendingThreshold > 0)
                    HorizontalLine(
                      y: spendingThreshold,
                      color: Colors.deepOrange,
                      strokeWidth: 3,
                      dashArray: [5, 5],
                      label: HorizontalLineLabel(
                        show: true,
                        alignment: Alignment.topRight,
                        padding: const EdgeInsets.only(right: 8, bottom: 6),
                        style: const TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.white,
                        ),
                        labelResolver: (_) => '75% Limit (₹${spendingThreshold.toInt()})',
                      ),
                    ),
                ],
              ),

              titlesData: FlTitlesData(
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                
                // DATE AXIS
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    // If monthly, show labels every 5 days to prevent overlapping
                    interval: currentFilter == FilterType.weekly ? 1 : 5,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index < 0 || index >= allDays.length) return const SizedBox.shrink();
                      final d = allDays[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${d.day}/${d.month}',
                          style: const TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),

                // AMOUNT AXIS
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    getTitlesWidget: (value, _) {
                      if (value == 0) return const SizedBox.shrink();
                      return Text(
                        '₹${(value / 1000).toStringAsFixed(1)}k',
                        style: const TextStyle(fontSize: 9, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),

              lineBarsData: [
                // Debit Line (Spent)
                LineChartBarData(
                  spots: debitSpots,
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 3,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.red.withOpacity(0.08),
                  ),
                ),
                // Credit Line (Received)
                LineChartBarData(
                  spots: creditSpots,
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 3,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.green.withOpacity(0.08),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ===== LEGEND =====
        const Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 8,
          children: [
            _LegendItem(color: Colors.red, text: 'Debit'),
            _LegendItem(color: Colors.green, text: 'Credit'),
            _LegendItem(color: Colors.deepOrange, text: '75% Limit'),
          ],
        ),
      ],
    );
  }

  double _yInterval(double maxY) {
    if (maxY <= 5000) return 1000;
    if (maxY <= 20000) return 5000;
    return 10000;
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12, height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
