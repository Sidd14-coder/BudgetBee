// import 'package:flutter/material.dart';
// import '../globals.dart';
// import '../widgets/debit_credit_pie.dart';
// import '../widgets/debit_credit_line.dart';
// import '../data/refresh_totals.dart';

// class AnalyticsScreen extends StatefulWidget {
//   const AnalyticsScreen({super.key});

//   @override
//   State<AnalyticsScreen> createState() => _AnalyticsScreenState();
// }

// class _AnalyticsScreenState extends State<AnalyticsScreen> {
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadAnalytics();
//   }

//   // ✅ LOAD DATA WHEN ANALYTICS OPENS
//   Future<void> _loadAnalytics() async {
//     if (!mounted) return;
//     setState(() {
//       _isLoading = true;
//     });

//     await refreshTotals();

//     if (mounted) {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _onFilterChange(FilterType v) async {
//     if (!mounted) return;
    
//     setState(() {
//       currentFilter = v;
//       _isLoading = true;
//     });

//     // Recalculate global variables and daily maps
//     await refreshTotals();

//     if (mounted) {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFCFFBFF),
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(76),
//         child: AppBar(
//           elevation: 0,
//           // Changed to true so user can go back to Dashboard
//           automaticallyImplyLeading: true, 
//           iconTheme: const IconThemeData(color: Colors.white),
//           backgroundColor: Colors.transparent,
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [Color(0xFF1E3CFF), Color(0xFF4B6CFF)],
//               ),
//             ),
//           ),
//           title: const Text(
//             'Analytics Dashboard',
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/bd_whatsapp.jpeg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SafeArea(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     '📌 See your recent spends, inflows and trends',
//                     style: TextStyle(
//                       color: Color.fromARGB(255, 9, 1, 255),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // -------- FILTER CARD --------
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(14),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 8,
//                         ),
//                       ],
//                     ),
//                     child: DropdownButton<FilterType>(
//                       value: currentFilter,
//                       isExpanded: true,
//                       underline: const SizedBox(),
//                       icon: const Icon(Icons.keyboard_arrow_down),
//                       items: const [
//                         DropdownMenuItem(
//                           value: FilterType.weekly,
//                           child: Text('🗓 Last 7 Days'),
//                         ),
//                         DropdownMenuItem(
//                           value: FilterType.monthly,
//                           child: Text('📆 This Month'),
//                         ),
//                       ],
//                       onChanged: (v) {
//                         if (v != null) _onFilterChange(v);
//                       },
//                     ),
//                   ),

//                   const SizedBox(height: 30),

//                   // -------- PIE CHART CARD --------
//                   const Text(
//                     '💸 Spent vs Received',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF0A33FF),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   _chartContainer(
//                     child: _isLoading
//                         ? _loadingIndicator()
//                         : DebitCreditPieChart(
//                             debit: totalDebit,
//                             credit: totalCredit,
//                           ),
//                   ),

//                   const SizedBox(height: 30),

//                   // -------- LINE CHART CARD (TREND) --------
//                   const Text(
//                     '📈 Transaction Trend',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF0A33FF),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   _chartContainer(
//                     child: _isLoading
//                         ? _loadingIndicator()
//                         // Pass maps explicitly if your widget supports it, 
//                         // or ensure the widget listens to global variables.
//                         : const DebitCreditLineChart(), 
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper to keep code clean
//   Widget _chartContainer({required Widget child}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }

//   Widget _loadingIndicator() {
//     return const Center(
//       child: Padding(
//         padding: EdgeInsets.all(40.0),
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../globals.dart';
import '../widgets/debit_credit_pie.dart';
import '../widgets/debit_credit_line.dart';
import '../data/refresh_totals.dart';
import 'chatbot_screen.dart';
import '../widgets/chatbot_fab.dart';
import 'custom/custom_transactions_screen.dart';
import '../widgets/app_drawer.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  // ✅ LOAD DATA WHEN ANALYTICS OPENS
  Future<void> _loadAnalytics() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    await refreshTotals();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onFilterChange(FilterType v) async {
    if (!mounted) return;
    
    setState(() {
      currentFilter = v;
      _isLoading = true;
    });

    // Recalculate global variables and daily maps
    await refreshTotals();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      endDrawer: const AppDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: AppBar(
          elevation: 0,
          // Changed to true so user can go back to Dashboard
          automaticallyImplyLeading: true, 
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xFF0A3622),
          flexibleSpace: Container(
            color: const Color(0xFF0A3622),
          ),
          title: const Text(
            'Analytics Dashboard',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () => Scaffold.of(ctx).openEndDrawer(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const ChatbotFab(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bd_whatsapp.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'See your recent spends',
                    style: TextStyle(
                      color: Color(0xFF114F2E),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // -------- FILTER CARD --------
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: DropdownButton<FilterType>(
                      value: currentFilter,
                      isExpanded: true,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: const [
                        DropdownMenuItem(
                          value: FilterType.weekly,
                          child: Text('Last 7 Days', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        DropdownMenuItem(
                          value: FilterType.monthly,
                          child: Text('This Month', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ],
                      onChanged: (v) {
                        if (v != null) _onFilterChange(v);
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // -------- PIE CHART CARD --------
                  const Text(
                    'Spent vs Recieved',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF114F2E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _chartContainer(
                    child: _isLoading
                        ? _loadingIndicator()
                        : DebitCreditPieChart(
                            debit: totalDebit,
                            credit: totalCredit,
                          ),
                  ),

                  const SizedBox(height: 30),

                  // -------- LINE CHART CARD (TREND) --------
                  const Text(
                    'Transaction Trend',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF114F2E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _chartContainer(
                    child: _isLoading
                        ? _loadingIndicator()
                        // Pass maps explicitly if your widget supports it, 
                        // or ensure the widget listens to global variables.
                        : const DebitCreditLineChart(), 
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to keep code clean
  Widget _chartContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _loadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
