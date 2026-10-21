// import 'package:flutter/material.dart';
// import 'add_transaction_screen.dart';
// import 'history_screen.dart';

// class CustomTransactionsScreen extends StatelessWidget {
//   const CustomTransactionsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFBFD8C3), // light green bg

//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0A3622),
//         title: const Text("Custom Transactions"),
//       ),

//       body: Center(
//         child: Container(
//           margin: const EdgeInsets.all(20),
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2),
//                 blurRadius: 12,
//               ),
//             ],
//           ),

//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [

//               /// TITLE
//               const Text(
//                 "Custom Features",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),

//               const Divider(height: 20),

//               /// ADD TRANSACTION BUTTON
//               Container(
//                 width: double.infinity,
//                 margin: const EdgeInsets.symmetric(vertical: 6),
//                 child: ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue.shade200,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   icon: const Icon(Icons.add, color: Colors.white),
//                   label: const Text(
//                     "Add Transaction",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const AddTransactionScreen(),
//                       ),
//                     );
//                   },
//                 ),
//               ),

//               /// HISTORY BUTTON
//               Container(
//                 width: double.infinity,
//                 margin: const EdgeInsets.symmetric(vertical: 6),
//                 child: ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green.shade300,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   icon: const Icon(Icons.bar_chart, color: Colors.white),
//                   label: const Text(
//                     "View History & Analytics",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const HistoryScreen(),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'add_transaction_screen.dart';
import 'history_screen.dart';

class CustomTransactionsScreen extends StatelessWidget {
  const CustomTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F5E9), // lighter pastel green

      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3622),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Custom Transactions",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// TITLE
              const Text(
                "Custom Features",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 16),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
              const SizedBox(height: 20),

              /// ADD TRANSACTION BUTTON
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddTransactionScreen(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE6F2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF5080B8), // darker blue
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        "Add Transaction",
                        style: TextStyle(
                          color: Color(0xFF334A66),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// HISTORY BUTTON
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryScreen(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD5EAD2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF5BA56B), // dark green round icon
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.bar_chart, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        "View History & Analytics",
                        style: TextStyle(
                          color: Color(0xFF2B5C3A),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
