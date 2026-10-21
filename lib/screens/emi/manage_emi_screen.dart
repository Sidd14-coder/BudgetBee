// import 'package:flutter/material.dart';
// import '../../services/emi_service.dart';
// import 'add_emi_screen.dart';
// import 'emi_calculator_screen.dart';
// import 'payment_history_screen.dart';
// import 'reminder_settings_screen.dart';
// import 'package:hive/hive.dart';

// class ManageEmiScreen extends StatefulWidget {
//   const ManageEmiScreen({super.key});

//   @override
//   State<ManageEmiScreen> createState() => _ManageEmiScreenState();
// }

// class _ManageEmiScreen extends State<ManageEmiScreen> {

//   @override
//   Widget build(BuildContext context) {

//     var box = Hive.box('emiBox');
//     var emiData = box.values.toList();

//     return Scaffold(
//       appBar: AppBar(
        
//         title: const Text("Manage EMI"),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [

//           ElevatedButton.icon(
//             icon: const Icon(Icons.add),
//             label: const Text("Add New EMI"),
//             onPressed: () async {
//               await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => const AddEmiScreen(),
//                 ),
//               );
//               setState(() {}); // 🔥 UI refresh
//             },
//           ),

//           const SizedBox(height: 20),

//           const Text(
//             "Active EMIs",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),

//           const SizedBox(height: 10),

//           ...emiData.map((e) {

//   double progress =
//       ((e['tenure'] - e['remainingMonths']) / e['tenure']);

//   return Card(
//     margin: const EdgeInsets.symmetric(vertical: 8),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(16),
//     ),

//     child: Padding(
//       padding: const EdgeInsets.all(16),

//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [

//           Text(
//             e['name'],
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),

//           const SizedBox(height: 4),

//           Text(
//             "₹${e['emi']}/month",
//             style: const TextStyle(color: Colors.grey),
//           ),

//           const SizedBox(height: 10),

//           LinearProgressIndicator(
//             value: progress,
//             minHeight: 8,
//             borderRadius: BorderRadius.circular(10),
//           ),

//           const SizedBox(height: 10),

//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [

//               Text(
//                 "${e['remainingMonths']} months left",
//                 style: const TextStyle(fontSize: 13),
//               ),

//               Text(
//                 "${(progress * 100).toStringAsFixed(0)}% paid",
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );

// }).toList(),

//           ),

//           const SizedBox(height: 20),

//           _navCard(
//             context,
//             "EMI Calculator",
//             "Calculate your EMI before taking a loan",
//             EmiCalculatorScreen(),
//           ),

//           _navCard(
//             context,
//             "Payment History",
//             "View past EMI payments",
//             PaymentHistoryScreen(),
//           ),

//           _navCard(
//             context,
//             "Reminder Settings",
//             "Set reminders for upcoming EMI payments",
//             ReminderSettingsScreen(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _navCard(
//       BuildContext context,
//       String title,
//       String subtitle,
//       Widget page,
//       ) {
//     return Card(
//       child: ListTile(
//         title: Text(title),
//         subtitle: Text(subtitle),
//         trailing: const Icon(Icons.arrow_forward_ios),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => page),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';

// import 'add_emi_screen.dart';
// import 'emi_calculator_screen.dart';
// import 'payment_history_screen.dart';
// import 'reminder_settings_screen.dart';

// class ManageEmiScreen extends StatefulWidget {
//   const ManageEmiScreen({super.key});

//   @override
//   State<ManageEmiScreen> createState() => _ManageEmiScreenState();
// }

// class _ManageEmiScreenState extends State<ManageEmiScreen> {

//   @override
//   Widget build(BuildContext context) {

//     var box = Hive.box('emiBox');
//     var emiData = box.values.toList();

//     return Scaffold(
//       appBar: AppBar(
        
//         title: const Text("Manage EMI"),
//       ),

//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [

//           /// ADD EMI BUTTON
//           ElevatedButton.icon(
//             icon: const Icon(Icons.add),
//             label: const Text("Add New EMI"),
//             onPressed: () async {
//               await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => const AddEmiScreen(),
//                 ),
//               );

//               setState(() {}); // 🔥 refresh
//             },
//           ),

//           const SizedBox(height: 20),

//           const Text(
//             "Active EMIs",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),

//           const SizedBox(height: 10),

//           /// EMI LIST FROM HIVE
//           ...emiData.asMap().entries.map((entry) {

//             int index = entry.key;
//             var e = entry.value;

//             double progress =
//                 ((e['tenure'] - e['remainingMonths']) / e['tenure']);

//             return Card(
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),

//               child: Padding(
//                 padding: const EdgeInsets.all(16),

//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [

//                     Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [

//     Text(
//       e['name'],
//       style: const TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.bold,
//       ),
//     ),

//     IconButton(
//   icon: const Icon(Icons.delete, color: Colors.red),

//   onPressed: () async {

//     bool? confirm = await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Delete EMI"),
//           content: const Text("Are you sure you want to delete this EMI?"),

//           actions: [

//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, false); // cancel
//               },
//               child: const Text("Cancel"),
//             ),

//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, true); // confirm
//               },
//               child: const Text("Delete"),
//             ),
//           ],
//         );
//       },
//     );

//     // 🔥 agar user ne YES click kiya
//     if (confirm == true) {

//       var box = Hive.box('emiBox');

//       var deletedItem = e; // backup for undo

//       box.deleteAt(index);

//       setState(() {}); // refresh UI

//       // 🎯 STEP 2 — UNDO SNACKBAR
//       ScaffoldMessenger.of(context).showSnackBar(

//         SnackBar(
//           content: const Text("EMI deleted"),

//           action: SnackBarAction(
//             label: "UNDO",

//             onPressed: () {
//               box.add(deletedItem); // restore
//               setState(() {});
//             },
//           ),
//         ),
//       );
//     }
//   },
// ),
//   ],
// ),

//                     const SizedBox(height: 4),

//                     Text(
//                       "₹${e['emi']}/month",
//                       style: const TextStyle(color: Colors.grey),
//                     ),

//                     const SizedBox(height: 10),

//                     LinearProgressIndicator(
//                       value: progress,
//                       minHeight: 8,
//                       borderRadius: BorderRadius.circular(10),
//                     ),

//                     const SizedBox(height: 10),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [

//                         Text(
//                           "${e['remainingMonths']} months left",
//                           style: const TextStyle(fontSize: 13),
//                         ),

//                         Text(
//                           "${(progress * 100).toStringAsFixed(0)}% paid",
//                           style: const TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );

//           }).toList(),

//           const SizedBox(height: 20),

//           _navCard(
//             context,
//             "EMI Calculator",
//             "Calculate your EMI before taking a loan",
//             const EmiCalculatorScreen(),
//           ),

//           _navCard(
//             context,
//             "Payment History",
//             "View past EMI payments",
//             const PaymentHistoryScreen(),
//           ),

//           _navCard(
//             context,
//             "Reminder Settings",
//             "Set reminders for upcoming EMI payments",
//             const ReminderSettingsScreen(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _navCard(
//     BuildContext context,
//     String title,
//     String subtitle,
//     Widget page,
//   ) {
//     return Card(
//       child: ListTile(
//         title: Text(title),
//         subtitle: Text(subtitle),
//         trailing: const Icon(Icons.arrow_forward_ios),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => page),
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../widgets/chatbot_fab.dart';
import '../chatbot_screen.dart';
import 'package:animations/animations.dart';

import 'add_emi_screen.dart';
import 'emi_calculator_screen.dart';
import 'payment_history_screen.dart';
import 'reminder_settings_screen.dart';

class ManageEmiScreen extends StatefulWidget {
  const ManageEmiScreen({super.key});

  @override
  State<ManageEmiScreen> createState() => _ManageEmiScreenState();
}

class _ManageEmiScreenState extends State<ManageEmiScreen> {

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('emiBox');
    var emiData = box.values.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
        backgroundColor: const Color(0xFF0A3622),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: const Text("Manage EMI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 18),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          // Background Doodle
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
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              children: [
                
                /// ADD EMI BUTTON
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddEmiScreen()),
                    );
                    setState(() {}); // refresh on return
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF7F0), // Off-white/beige
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2)),
                      ]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add, color: Color(0xFF153323), size: 22),
                        SizedBox(width: 8),
                        Text("Add New EMI", style: TextStyle(color: Color(0xFF153323), fontSize: 18, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                /// ACTIVE EMIS SECTION
                const Text("Active EMIs", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A3B29))),
                const SizedBox(height: 12),
                
                if (emiData.isEmpty)
                  const Text("No active EMIs right now.", style: TextStyle(color: Colors.grey))
                else
                  ...emiData.asMap().entries.map((entry) {
                    int index = entry.key;
                    var e = entry.value;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 0,
                      color: Colors.white,
                      shadowColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(e['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF2A2A2A))),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("${e['remainingMonths']} months left", style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500)),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                                    const SizedBox(width: 12), // Space before delete
                                    GestureDetector(
                                      onTap: () async {
                                        bool? confirm = await showModal(
                                          context: context,
                                          configuration: const FadeScaleTransitionConfiguration(),
                                          builder: (context) => AlertDialog(
                                            title: const Text("Delete EMI"),
                                            content: const Text("Are you sure you want to delete this EMI?"),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
                                            ],
                                          ),
                                        );
                                        if (confirm == true) {
                                          var box = Hive.box('emiBox');
                                          var deletedItem = e;
                                          box.deleteAt(index);
                                          setState(() {});
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: const Text("EMI deleted"),
                                              action: SnackBarAction(label: "UNDO", onPressed: () {
                                                box.add(deletedItem);
                                                setState(() {});
                                              }),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text("₹${e['emi']}/month", style: const TextStyle(color: Color(0xFF0A3622), fontWeight: FontWeight.w800, fontSize: 13)),
                            const SizedBox(height: 6),
                            Text("Next Due: 5th of every month", style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                const SizedBox(height: 28),

                /// EM CALCULATOR SECTION
                const Text("EMI Calculator", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A3B29))),
                const SizedBox(height: 12),
                _customNavCard(
                  context,
                  title: "EMI Calculator",
                  subtitle: "Calculate your EMI before taking a loan.",
                  icon: Icons.calculate,
                  iconBgColor: const Color(0xFF81A088),
                  page: const EmiCalculatorScreen(),
                ),

                const SizedBox(height: 28),

                /// PAYMENT HISTORY SECTION
                const Text("Payment History", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A3B29))),
                const SizedBox(height: 12),
                _customNavCard(
                  context,
                  title: "Payment History",
                  subtitle: "View past EMI payments.",
                  icon: Icons.receipt_long,
                  iconBgColor: const Color(0xFF81A088),
                  page: const PaymentHistoryScreen(),
                ),

                const SizedBox(height: 28),

                /// REMINDER SETTINGS SECTION
                const Text("Reminder Settings", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A3B29))),
                const SizedBox(height: 12),
                _customNavCard(
                  context,
                  title: "Reminder Settings",
                  subtitle: "Set reminders for upcoming EMI payments.",
                  icon: Icons.notifications,
                  iconBgColor: const Color(0xFF81A088),
                  iconColor: Colors.white,
                  page: const ReminderSettingsScreen(),
                ),
                
                const SizedBox(height: 100), // Padding to avoid FAB hiding content
              ],
            ),
          )
        ],
      ),
      floatingActionButton: const ChatbotFab(),
    );
  }

  Widget _customNavCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBgColor,
    required Widget page,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF2A2A2A))),
                  const SizedBox(height: 6),
                  Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF0A3622)),
          ],
        ),
      ),
    );
  }
}
