// import 'package:flutter/material.dart';
// import '../../services/emi_payment_service.dart';
// import 'package:intl/intl.dart';

// class PaymentHistoryScreen extends StatelessWidget {
//   const PaymentHistoryScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Payment History"),
//       ),

//       body: emiPayments.isEmpty
//           ? const Center(
//               child: Text("No EMI payments yet"),
//             )
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: emiPayments.length,
//               itemBuilder: (context, index) {

//                 final payment = emiPayments[index];

//                 return Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),

//                   child: ListTile(

//                     leading: const Icon(
//                       Icons.payment,
//                       color: Colors.green,
//                     ),

//                     title: Text(payment.emiName),

//                     subtitle: Text(
//                       DateFormat('d MMM yyyy')
//                           .format(payment.date),
//                     ),

//                     trailing: Text(
//                       "₹${payment.amount}",
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:hive/hive.dart';

// class PaymentHistoryScreen extends StatelessWidget {
//   const PaymentHistoryScreen({super.key});

//   @override
//   Widget build(BuildContext context) {

//     var box = Hive.box('paymentHistory');
//     var payments = box.values.toList(); // ✅ ADD THIS

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Payment History"),
//       ),

//       body: payments.isEmpty   // ✅ BODY ADD KIYA
//           ? const Center(
//               child: Text("No EMI payments yet"),
//             )
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: payments.length,
//               itemBuilder: (context, index) {

//                 final payment = payments[index];

//                 return Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),

//                   child: ListTile(
//                     leading: const Icon(
//                       Icons.payment,
//                       color: Colors.green,
//                     ),

//                     title: Text(payment['name']),

//                     subtitle: Text(
//                       DateFormat('d MMM yyyy')
//                           .format(DateTime.parse(payment['date'])),
//                     ),

//                     trailing: Text(
//                       "₹${payment['amount']}",
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import '../chatbot_screen.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    var box = Hive.box('paymentHistory');
    var payments = box.values.toList(); 

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Payment History", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF0A3622),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bd_whatsapp.jpeg"),
                fit: BoxFit.cover,
                opacity: 0.12,
              ),
            ),
          ),
          SafeArea(
            child: payments.isEmpty
              ? const Center(child: Text("No EMI payments yet", style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  itemCount: payments.length,
                  itemBuilder: (context, index) {
                    final payment = payments[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('MMM d').format(DateTime.parse(payment['date'])),
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF1A1A1A)),
                                ),
                                Text(
                                  "₹${payment['amount']}",
                                  style: const TextStyle(color: Color(0xFF0A3622), fontWeight: FontWeight.w900, fontSize: 16),
                                )
                              ],
                            ),
                          ),
                          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(payment['name'], style: const TextStyle(fontSize: 15, color: Color(0xFF5A5A5A))),
                                const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatbotScreen()));
        },
        backgroundColor: Colors.white,
        elevation: 6,
        shape: const CircleBorder(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.asset('assets/icons/chatbot.png', fit: BoxFit.cover, width: 44, height: 44),
        ),
      ),
    );
  }
}
