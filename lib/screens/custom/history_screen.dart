// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:fl_chart/fl_chart.dart';

// class HistoryScreen extends StatefulWidget {
//   const HistoryScreen({super.key});

//   @override
//   State<HistoryScreen> createState() => _HistoryScreenState();
// }

// class _HistoryScreenState extends State<HistoryScreen>
//     with SingleTickerProviderStateMixin {

//   String filter = "weekly";
//   String selectedCategory = "All";

//   /// ANIMATION
//   late AnimationController _controller;

//   /// CATEGORY ICONS
//   Map<String, IconData> categoryIcons = {
//     "Food": Icons.fastfood,
//     "Health": Icons.health_and_safety,
//     "Grocery": Icons.shopping_cart,
//     "Bills": Icons.receipt,
//     "Dining": Icons.restaurant,
//     "Education": Icons.school,
//     "Fuel": Icons.local_gas_station,
//     "Gadgets": Icons.devices,
//     "Shopping": Icons.shopping_bag,
//     "Travel": Icons.flight,
//     "Misc": Icons.category,
//     "Others": Icons.more_horiz,
//   };

//   /// COLORS
//   List<Color> chartColors = [
//     Colors.blue,
//     Colors.red,
//     Colors.orange,
//     Colors.purple,
//     Colors.green,
//     Colors.teal,
//     Colors.pink,
//     Colors.brown,
//   ];

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   List getFilteredData() {
//     var box = Hive.box('customTransactions');

//     List data = box.keys.map((key) {
//       final item = box.get(key);
//       return {...item, "key": key};
//     }).toList();

//     DateTime now = DateTime.now();

//     var filtered = data.where((e) {
//       if (e['date'] == null) return false;
//       DateTime d = DateTime.parse(e['date']);
//       return d.isAfter(now.subtract(const Duration(days: 30)));
//     }).toList();

//     filtered.sort((a, b) {
//       DateTime dA = DateTime.parse(a['date']);
//       DateTime dB = DateTime.parse(b['date']);
//       return dB.compareTo(dA);
//     });

//     return filtered;
//   }

//   void deleteTransaction(dynamic key) {
//     var box = Hive.box('customTransactions');
//     box.delete(key);
//     setState(() {});
//   }

//   void editTransaction(Map e) {
//     TextEditingController amountController =
//         TextEditingController(text: e['amount'].toString());
//     TextEditingController noteController =
//         TextEditingController(text: e['note']);

//     showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           title: const Text("Edit Transaction"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: amountController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(labelText: "Amount"),
//               ),
//               TextField(
//                 controller: noteController,
//                 decoration: const InputDecoration(labelText: "Description"),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 var box = Hive.box('customTransactions');
//                 box.put(e['key'], {
//                   "type": e['type'],
//                   "account": e['account'],
//                   "category": e['category'],
//                   "amount": double.tryParse(amountController.text),
//                   "note": noteController.text,
//                   "date": e['date'],
//                 });
//                 Navigator.pop(context);
//                 setState(() {});
//               },
//               child: const Text("Save"),
//             )
//           ],
//         );
//       },
//     );
//   }

//   Map<String, double> getCategoryData(List data) {
//     Map<String, double> map = {};
//     for (var e in data) {
//       map[e['category']] = (map[e['category']] ?? 0) + (e['amount'] ?? 0);
//     }
//     return map;
//   }

//   Map<String, Color> getCategoryColorMap(List data) {
//     Map<String, Color> map = {};
//     int index = 0;
//     for (var e in data) {
//       String cat = e['category'] ?? "Unknown";
//       if (!map.containsKey(cat)) {
//         map[cat] = chartColors[index % chartColors.length];
//         index++;
//       }
//     }
//     return map;
//   }

//   String formatCustomDate(String isoDate) {
//     DateTime d = DateTime.parse(isoDate);
//     List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
//     List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
//     String day = days[d.weekday - 1];
//     String month = months[d.month - 1];
    
//     int h = d.hour;
//     int m = d.minute;
//     String ampm = h >= 12 ? 'pm' : 'am';
//     h = h % 12;
//     if (h == 0) h = 12;
//     String mStr = m < 10 ? '0$m' : '$m';

//     bool isToday = d.day == DateTime.now().day && d.month == DateTime.now().month && d.year == DateTime.now().year;

//     if (isToday) return "Today, $h:$mStr $ampm";
//     return "$day, ${d.day}-$month";
//   }

//   @override
//   Widget build(BuildContext context) {
//     List data = getFilteredData();
//     var categoryData = getCategoryData(data);
//     var colorMap = getCategoryColorMap(data);

//     return Scaffold(
//       backgroundColor: const Color(0xFFE8F5E9),
//       appBar: AppBar(
        
//         backgroundColor: const Color(0xFF0A3622),
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text(
//           "History & Analytics",
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//       ),
//       body: data.isEmpty
//           ? const Center(child: Text("No transactions in the last 30 days.", style: TextStyle(fontSize: 16)))
//           : FadeTransition(
//               opacity: _controller,
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
                    
//                     /// RECENT TRANSACTIONS CARD
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.05),
//                             blurRadius: 10,
//                             offset: const Offset(0, 4),
//                           )
//                         ]
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Padding(
//                             padding: EdgeInsets.all(16),
//                             child: Text(
//                               "Recent Transactions",
//                               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           const Divider(height: 1, thickness: 1),
//                           ListView.separated(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemCount: data.length,
//                             separatorBuilder: (context, index) => const Divider(height: 1, thickness: 1),
//                             itemBuilder: (context, index) {
//                               var e = data[index];
//                               Color iconColor = colorMap[e['category']] ?? Colors.grey;
//                               return ListTile(
//                                 leading: Icon(
//                                   categoryIcons[e['category']] ?? Icons.category,
//                                   color: iconColor,
//                                   size: 30,
//                                 ),
//                                 title: Text(e['category'], style: const TextStyle(fontWeight: FontWeight.bold)),
//                                 subtitle: Text(formatCustomDate(e['date']), style: const TextStyle(fontSize: 12, color: Colors.grey)),
//                                 trailing: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       "${e['amount'] ?? 0}",
//                                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                                     ),
//                                     Text(
//                                       e['account'] ?? "UPI",
//                                       style: const TextStyle(fontSize: 11, color: Colors.grey),
//                                     ),
//                                   ],
//                                 ),
//                                 onTap: () => editTransaction(e),
//                                 onLongPress: () => deleteTransaction(e['key']),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     /// SPENDING BREAKDOWN CARD
//                     Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.05),
//                             blurRadius: 10,
//                             offset: const Offset(0, 4),
//                           )
//                         ]
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Padding(
//                             padding: EdgeInsets.all(16),
//                             child: Text(
//                               "Spending Breakdown",
//                               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           const Divider(height: 1, thickness: 1),
//                           const SizedBox(height: 20),
                          
//                           // PIE CHART
//                           SizedBox(
//                             height: 200,
//                             child: PieChart(
//                               PieChartData(
//                                 sectionsSpace: 2,
//                                 centerSpaceRadius: 50,
//                                 sections: categoryData.entries.map((entry) {
//                                   return PieChartSectionData(
//                                     value: entry.value,
//                                     title: "",
//                                     color: colorMap[entry.key],
//                                     radius: 40,
//                                   );
//                                 }).toList(),
//                               ),
//                             ),
//                           ),
                          
                          
//                           const SizedBox(height: 30),

//                           // LEGEND (Dynamic Row/Wrap)
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                             child: Wrap(
//                               spacing: 16,
//                               runSpacing: 8,
//                               alignment: WrapAlignment.center,
//                               children: colorMap.entries.map((entry) {
//                                 return Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     CircleAvatar(radius: 5, backgroundColor: entry.value),
//                                     const SizedBox(width: 6),
//                                     Text(
//                                       entry.key,
//                                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
//                                     ),
//                                   ],
//                                 );
//                               }).toList(),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animations/animations.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {

  String filter = "weekly";
  String selectedCategory = "All";

  /// ANIMATION
  late AnimationController _controller;
  int touchedIndex = -1;

  /// CATEGORY ICONS
  Map<String, IconData> categoryIcons = {
    "Food": Icons.fastfood,
    "Health": Icons.health_and_safety,
    "Grocery": Icons.shopping_cart,
    "Bills": Icons.receipt,
    "Dining": Icons.restaurant,
    "Education": Icons.school,
    "Fuel": Icons.local_gas_station,
    "Gadgets": Icons.devices,
    "Shopping": Icons.shopping_bag,
    "Travel": Icons.flight,
    "Misc": Icons.category,
    "Others": Icons.more_horiz,
  };

  /// COLORS
  List<Color> chartColors = [
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.green,
    Colors.teal,
    Colors.pink,
    Colors.brown,
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List getFilteredData() {
    var box = Hive.box('customTransactions');

    List data = box.keys.map((key) {
      final item = box.get(key);
      return {...item, "key": key};
    }).toList();

    DateTime now = DateTime.now();

    var filtered = data.where((e) {
      if (e['date'] == null) return false;
      DateTime d = DateTime.parse(e['date']);
      return d.isAfter(now.subtract(const Duration(days: 30)));
    }).toList();

    filtered.sort((a, b) {
      DateTime dA = DateTime.parse(a['date']);
      DateTime dB = DateTime.parse(b['date']);
      return dB.compareTo(dA);
    });

    return filtered;
  }

  void deleteTransaction(dynamic key) {
    var box = Hive.box('customTransactions');
    box.delete(key);
    setState(() {});
  }

  void editTransaction(Map e) {
    TextEditingController amountController =
        TextEditingController(text: e['amount'].toString());
    TextEditingController noteController =
        TextEditingController(text: e['note']);

    showModal(
      context: context,
      configuration: const FadeScaleTransitionConfiguration(),
      builder: (_) {
        return AlertDialog(
          title: const Text("Edit Transaction"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Amount"),
              ),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                var box = Hive.box('customTransactions');
                box.put(e['key'], {
                  "type": e['type'],
                  "account": e['account'],
                  "category": e['category'],
                  "amount": double.tryParse(amountController.text),
                  "note": noteController.text,
                  "date": e['date'],
                });
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text("Save"),
            )
          ],
        );
      },
    );
  }

  Map<String, double> getCategoryData(List data) {
    Map<String, double> map = {};
    for (var e in data) {
      map[e['category']] = (map[e['category']] ?? 0) + (e['amount'] ?? 0);
    }
    return map;
  }

  Map<String, Color> getCategoryColorMap(List data) {
    Map<String, Color> map = {};
    int index = 0;
    for (var e in data) {
      String cat = e['category'] ?? "Unknown";
      if (!map.containsKey(cat)) {
        map[cat] = chartColors[index % chartColors.length];
        index++;
      }
    }
    return map;
  }

  String formatCustomDate(String isoDate) {
    DateTime d = DateTime.parse(isoDate);
    List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    String day = days[d.weekday - 1];
    String month = months[d.month - 1];
    
    int h = d.hour;
    int m = d.minute;
    String ampm = h >= 12 ? 'pm' : 'am';
    h = h % 12;
    if (h == 0) h = 12;
    String mStr = m < 10 ? '0$m' : '$m';

    bool isToday = d.day == DateTime.now().day && d.month == DateTime.now().month && d.year == DateTime.now().year;

    if (isToday) return "Today, $h:$mStr $ampm";
    return "$day, ${d.day}-$month";
  }

  @override
  Widget build(BuildContext context) {
    List data = getFilteredData();
    var categoryData = getCategoryData(data);
    var colorMap = getCategoryColorMap(data);

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        
        backgroundColor: const Color(0xFF0A3622),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "History & Analytics",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: data.isEmpty
          ? const Center(child: Text("No transactions in the last 30 days.", style: TextStyle(fontSize: 16)))
          : FadeTransition(
              opacity: _controller,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    /// RECENT TRANSACTIONS CARD
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              "Recent Transactions",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Divider(height: 1, thickness: 1),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            separatorBuilder: (context, index) => const Divider(height: 1, thickness: 1),
                            itemBuilder: (context, index) {
                              var e = data[index];
                              Color iconColor = colorMap[e['category']] ?? Colors.grey;
                              return ListTile(
                                leading: Icon(
                                  categoryIcons[e['category']] ?? Icons.category,
                                  color: iconColor,
                                  size: 30,
                                ),
                                title: Text(e['category'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(formatCustomDate(e['date']), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "₹${(e['amount'] ?? 0).toInt()}",
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    Text(
                                      e['account'] ?? "UPI",
                                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                onTap: () => editTransaction(e),
                                onLongPress: () => deleteTransaction(e['key']),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// SPENDING BREAKDOWN CARD
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              "Spending Breakdown",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Divider(height: 1, thickness: 1),
                          const SizedBox(height: 20),
                          
                          // PIE CHART
                          SizedBox(
                            height: 200,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: -270, end: -90),
                              duration: const Duration(milliseconds: 1500),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return PieChart(
                                  PieChartData(
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
                                    startDegreeOffset: value,
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 50,
                                    sections: categoryData.entries.toList().asMap().entries.map((mappedEntry) {
                                      int index = mappedEntry.key;
                                      var entry = mappedEntry.value;
                                      
                                      double total = categoryData.values.fold(0.0, (s, v) => s + v);
                                      double percentage = total > 0 ? (entry.value / total) * 100 : 0;
                                      
                                      final isTouched = index == touchedIndex;
                                      final double radius = isTouched ? 70.0 : 60.0;
                                      final String titleText = isTouched 
                                        ? '${entry.key}\n${percentage.toStringAsFixed(0)}%' 
                                        : '${percentage.toStringAsFixed(0)}%';

                                      return PieChartSectionData(
                                        value: entry.value,
                                        title: titleText,
                                        titleStyle: TextStyle(
                                          fontSize: isTouched ? 14 : 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 2)],
                                        ),
                                        color: colorMap[entry.key],
                                        radius: radius,
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                            ),
                          ),
                          
                          
                          const SizedBox(height: 30),

                          // LEGEND (Dynamic Row/Wrap)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            child: Wrap(
                              spacing: 16,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: colorMap.entries.map((entry) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(radius: 5, backgroundColor: entry.value),
                                    const SizedBox(width: 6),
                                    Text(
                                      entry.key,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }
}
