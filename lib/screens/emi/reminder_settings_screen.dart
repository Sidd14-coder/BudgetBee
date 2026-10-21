// import 'package:flutter/material.dart';
// import '../../services/notification_service.dart';
// import '../../services/emi_service.dart';
// import 'package:hive/hive.dart';

// class ReminderSettingsScreen extends StatefulWidget {
//   const ReminderSettingsScreen({super.key});

//   @override
//   State<ReminderSettingsScreen> createState() => _ReminderSettingsScreenState();
// }

// class _ReminderSettingsScreenState extends State<ReminderSettingsScreen> {

//   bool reminderEnabled = true;
//   String selectedOption = "1 day before due date";

//   final List<String> reminderOptions = [
//     "On due date",
//     "1 day before due date",
//     "2 days before due date",
//     "Custom date",
//   ];

//   @override
//   Widget build(BuildContext context) {

//     var box = Hive.box('emiBox');
//     var emiData = box.values.toList();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F6F7),

//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         elevation: 0,
//         title: const Text("Reminder Settings"),
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [

//             /// EMI CARD
//             ...emiData.map((e) {

//   return Container(
//     margin: const EdgeInsets.only(bottom: 12),
//     padding: const EdgeInsets.all(16),

//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(14),
//       boxShadow: const [
//         BoxShadow(
//           blurRadius: 8,
//           color: Colors.black12,
//         )
//       ],
//     ),

//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [

//         Text(
//           e['name'],
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),

//         const SizedBox(height: 10),

//         Text("₹${e['emi']}/month"),

//         Text("${e['remainingMonths']} months left"),

//       ],
//     ),
//   );

// }).toList(),

//             const SizedBox(height: 20),

//             /// REMINDER SETTINGS CARD
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//                 boxShadow: const [
//                   BoxShadow(
//                     blurRadius: 8,
//                     color: Colors.black12,
//                   )
//                 ],
//               ),

//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [

//                   /// Enable reminder switch
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [

//                       const Text(
//                         "Enable Reminder",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),

//                       Switch(
//                         value: reminderEnabled,
//                         activeColor: Colors.green,
//                         onChanged: (value) {
//                           setState(() {
//                             reminderEnabled = value;
//                           });
//                         },
//                       )

//                     ],
//                   ),

//                   const SizedBox(height: 10),

//                   const Text(
//                     "Remind Me",
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   /// Reminder options
//                   Column(
//                     children: reminderOptions.map((option) {

//                       return ListTile(

//                         contentPadding: EdgeInsets.zero,

//                         title: Text(option),

//                         trailing: selectedOption == option
//                             ? const Icon(Icons.check, color: Colors.green)
//                             : null,

//                         onTap: () {

//                           setState(() {
//                             selectedOption = option;
//                           });

//                         },
//                       );

//                     }).toList(),
//                   )

//                 ],
//               ),
//             ),

//             const Spacer(),

//             /// SAVE BUTTON
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(

//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),

//                 onPressed: () {

//   DateTime dueDate = DateTime(2026, 5, 10); // example EMI due date

//   DateTime reminderDate = dueDate;

//   if (selectedOption == "1 day before due date") {
//     reminderDate = dueDate.subtract(const Duration(days: 1));
//   }

//   if (selectedOption == "2 days before due date") {
//     reminderDate = dueDate.subtract(const Duration(days: 2));
//   }

//   NotificationService.scheduleNotification(
//     id: 1,
//     title: "EMI Reminder",
//     body: "Your EMI is due soon",
//     scheduledDate: reminderDate,
//   );

//   ScaffoldMessenger.of(context).showSnackBar(
//     const SnackBar(
//       content: Text("Reminder Scheduled"),
//     ),
//   );

// },

//                 child: const Text(
//                   "Save Changes",
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//             )

//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/notification_service.dart';
import '../../services/emi_service.dart';
import '../chatbot_screen.dart';
import 'package:hive/hive.dart';

class ReminderSettingsScreen extends StatefulWidget {
  const ReminderSettingsScreen({super.key});

  @override
  State<ReminderSettingsScreen> createState() => _ReminderSettingsScreenState();
}

class _ReminderSettingsScreenState extends State<ReminderSettingsScreen> {

  bool reminderEnabled = true;
  String selectedOption = "1 day before due date";
  DateTime? customReminderDate;

  final List<String> reminderOptions = [
    "On due date",
    "1 day before due date",
    "2 days before due date",
    "Custom date",
  ];

  @override
  Widget build(BuildContext context) {

    var box = Hive.box('emiBox');
    var emiData = box.values.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Reminder Settings", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    children: [
                      /// EMI CARD(s)
                      ...emiData.map((e) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F7F1),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A))),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("₹${e['emi']}", style: const TextStyle(color: Color(0xFF0A3622), fontSize: 18, fontWeight: FontWeight.w900)),
                                      const Text("/month", style: TextStyle(color: Colors.grey, fontSize: 14)),
                                    ],
                                  ),
                                  Text("${e['remainingMonths']} months left", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text("Remaining: 5th of month (Est.)", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)), // Preserving logic placeholder
                            ],
                          ),
                        );
                      }).toList(),

                      /// REMINDER SETTINGS CARD
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F7F1),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Enable reminder switch
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Enable Reminder", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A))),
                                Switch(
                                  value: reminderEnabled,
                                  activeColor: Colors.white,
                                  activeTrackColor: const Color(0xFF4A8462),
                                  onChanged: (value) {
                                    setState(() {
                                      reminderEnabled = value;
                                    });
                                  },
                                )
                              ],
                            ),
                            const Divider(height: 32, color: Color(0xFFE2E2E2)),
                            const Text("Remind Me", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF5A5A5A))),
                            const SizedBox(height: 12),

                            /// Reminder options
                            Column(
                              children: reminderOptions.map((option) {
                                bool isSelected = selectedOption == option;
                                String displayOption = option;
                                if (option == "Custom date" && isSelected && customReminderDate != null) {
                                  displayOption = "Custom: ${DateFormat('MMM d, yyyy').format(customReminderDate!)}";
                                }
                                return GestureDetector(
                                  onTap: () async {
                                    if (option == "Custom date") {
                                      DateTime? picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2100),
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          selectedOption = option;
                                          customReminderDate = picked;
                                        });
                                      }
                                    } else {
                                      setState(() => selectedOption = option);
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFF6B9378) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(displayOption, style: TextStyle(fontSize: 15, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.white : const Color(0xFF1A1A1A))),
                                        if (isSelected) const Icon(Icons.check, color: Colors.white, size: 20)
                                        else if (option == "Custom date") const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                            
                            /// SAVE BUTTON
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF326B4A),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  DateTime dueDate = DateTime(2026, 5, 10); // example EMI due date
                                  DateTime reminderDate = dueDate;
                                  if (selectedOption == "1 day before due date") reminderDate = dueDate.subtract(const Duration(days: 1));
                                  if (selectedOption == "2 days before due date") reminderDate = dueDate.subtract(const Duration(days: 2));
                                  if (selectedOption == "Custom date" && customReminderDate != null) reminderDate = customReminderDate!;

                                  NotificationService.scheduleNotification(
                                    id: 1,
                                    title: "EMI Reminder",
                                    body: "Your EMI is due soon",
                                    scheduledDate: reminderDate,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reminder Scheduled")));
                                },
                                child: const Text("Save Changes", style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
