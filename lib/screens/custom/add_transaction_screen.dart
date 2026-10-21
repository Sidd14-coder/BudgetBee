// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';

// class AddTransactionScreen extends StatefulWidget {
//   const AddTransactionScreen({super.key});

//   @override
//   State<AddTransactionScreen> createState() => _AddTransactionScreenState();
// }

// class _AddTransactionScreenState extends State<AddTransactionScreen> {

//   String type = "Debit";
//   String account = "UPI";
//   String category = "Select Category";
//   String amount = "";
//   TextEditingController desc = TextEditingController();
//   TextEditingController amountController = TextEditingController();

//   List<String> categories = [
//     "Food","Health","Grocery","Bills","Dining","Education",
//     "Fuel","Gadgets","Shopping","Travel","Misc","Others"
//   ];

//   Map<String, IconData> categoryIcons = {
//   "Food": Icons.fastfood,
//   "Health": Icons.health_and_safety,
//   "Grocery": Icons.shopping_cart,
//   "Bills": Icons.receipt,
//   "Dining": Icons.restaurant,
//   "Education": Icons.school,
//   "Fuel": Icons.local_gas_station,
//   "Gadgets": Icons.devices,
//   "Shopping": Icons.shopping_bag,
//   "Travel": Icons.flight,
//   "Misc": Icons.category,
//   "Others": Icons.more_horiz,
// };

//   /// SAVE TO HIVE
//   void saveTransaction() {
//   var box = Hive.box('customTransactions');
//   print(box.values.toList());

//   double amt = double.tryParse(amountController.text) ?? 0;

//   if (amt <= 0) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Enter valid amount")),
//     );
//     return;
//   }

//   box.add({
//     "type": type,
//     "account": account,
//     "category": category,
//     "amount": amt,
//     "note": desc.text,
//     "date": DateTime.now().toString(),
//   });

//   print("Saved: $amt"); // debug

//   Navigator.pop(context);
// }

//   /// CATEGORY PICKER
//   void openCategoryPicker() {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) {
//         return GridView.count(
//           crossAxisCount: 3,
//           padding: const EdgeInsets.all(16),
//           children: categories.map((cat) {
//             return GestureDetector(
//               onTap: () {
//                 setState(() => category = cat);
//                 Navigator.pop(context);
//               },
//               child: Card(
//   child: Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Icon(categoryIcons[cat], size: 30, color: Colors.green),
//       const SizedBox(height: 5),
//       Text(cat),
//     ],
//   ),
// ),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }

//   /// KEYPAD BUTTON
  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFE8F5E9), // Light green background
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0A3622), // Dark green theme
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text(
//           "Custom Transactions",
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // --- TRANSACTION TYPE DROPDOWN ---
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(color: Colors.grey.shade300),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         value: type,
//                         isExpanded: true,
//                         items: ["Credit", "Debit"]
//                             .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                             .toList(),
//                         onChanged: (v) => setState(() => type = v!),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // --- ACCOUNT TYPE DROPDOWN ---
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(color: Colors.grey.shade300),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         value: account,
//                         isExpanded: true,
//                         items: ["UPI", "Cash"]
//                             .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                             .toList(),
//                         onChanged: (v) => setState(() => account = v!),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   // --- DESCRIPTION ---
//                   const Text(
//                     "Description",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF0A3622),
//                     ),
//                   ),
//                   TextField(
//                     controller: desc,
//                     decoration: const InputDecoration(
//                       hintText: "Name of shop, brand",
//                       hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
//                       enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(color: Colors.grey),
//                       ),
//                       focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(color: Color(0xFF0A3622), width: 2),
//                       ),
//                       isDense: true,
//                       contentPadding: EdgeInsets.symmetric(vertical: 8),
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   // --- CATEGORY ---
//                   const Text(
//                     "Category",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF0A3622),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: openCategoryPicker,
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       decoration: const BoxDecoration(
//                         border: Border(bottom: BorderSide(color: Colors.grey)),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             categoryIcons[category] ?? Icons.category,
//                             color: const Color(0xFF0A3622),
//                             size: 20,
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             category == "Select Category" ? "Choose Category" : category,
//                             style: const TextStyle(fontSize: 16, color: Colors.black87),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   // --- DATE AND AMOUNT ---
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       // Date
//                       Expanded(
//                         child: Row(
//                           children: [
//                             const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
//                             const SizedBox(width: 8),
//                             Text(
//                               "Today ${TimeOfDay.now().format(context)}",
//                               style: const TextStyle(
//                                 fontSize: 13,
//                                 color: Color(0xFF0A3622),
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Amount
//                       Expanded(
//                         child: TextField(
//                           controller: amountController,
//                           keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                           decoration: const InputDecoration(
//                             prefixText: "₹   ",
//                             prefixStyle: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black),
//                             enabledBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                             focusedBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(color: Color(0xFF0A3622), width: 2),
//                             ),
//                             isDense: true,
//                             contentPadding: EdgeInsets.symmetric(vertical: 8),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // --- STICKY SAVE BUTTON ---
//           SizedBox(
//             width: double.infinity,
//             height: 60,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF0A3622),
//                 shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//               ),
//               onPressed: saveTransaction,
//               child: const Text(
//                 "SAVE",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   letterSpacing: 1.2,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AddTransactionScreen extends StatefulWidget {
  final String? initialAmount;
  final String? initialDesc;
  final String? initialCategory;

  const AddTransactionScreen({
    super.key,
    this.initialAmount,
    this.initialDesc,
    this.initialCategory,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {

  String type = "Debit";
  String account = "UPI";
  String category = "Select Category";
  String amount = "";
  TextEditingController desc = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialAmount != null) amountController.text = widget.initialAmount!;
    if (widget.initialDesc != null) desc.text = widget.initialDesc!;
    if (widget.initialCategory != null) category = widget.initialCategory!;
  }

  List<String> categories = [
    "Food","Health","Grocery","Bills","Education",
    "Fuel","Gadgets","Shopping","Travel","Misc","Others"
  ];

  Map<String, IconData> categoryIcons = {
  "Food": Icons.fastfood,
  "Health": Icons.health_and_safety,
  "Grocery": Icons.shopping_cart,
  "Bills": Icons.receipt,
  "Education": Icons.school,
  "Fuel": Icons.local_gas_station,
  "Gadgets": Icons.devices,
  "Shopping": Icons.shopping_bag,
  "Travel": Icons.flight,
  "Misc": Icons.category,
  "Others": Icons.more_horiz,
};

  /// SAVE TO HIVE
  void saveTransaction() {
  var box = Hive.box('customTransactions');
  print(box.values.toList());

  double amt = double.tryParse(amountController.text) ?? 0;

  if (amt <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Enter valid amount")),
    );
    return;
  }

  box.add({
    "type": type,
    "account": account,
    "category": category,
    "amount": amt,
    "note": desc.text,
    "date": DateTime.now().toString(),
  });

  print("Saved: $amt"); // debug

  Navigator.pop(context);
}

  /// CATEGORY PICKER
  void openCategoryPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GridView.count(
          crossAxisCount: 3,
          padding: const EdgeInsets.all(16),
          children: categories.map((cat) {
            return GestureDetector(
              onTap: () {
                setState(() => category = cat);
                Navigator.pop(context);
              },
              child: Card(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(categoryIcons[cat], size: 30, color: Colors.green),
      const SizedBox(height: 5),
      Text(cat),
    ],
  ),
),
            );
          }).toList(),
        );
      },
    );
  }

  /// KEYPAD BUTTON
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Light green background
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3622), // Dark green theme
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Custom Transactions",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- TRANSACTION TYPE DROPDOWN ---
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: type,
                        isExpanded: true,
                        items: ["Credit", "Debit"]
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => type = v!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- ACCOUNT TYPE DROPDOWN ---
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: account,
                        isExpanded: true,
                        items: ["UPI", "Cash"]
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => account = v!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- DESCRIPTION ---
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A3622),
                    ),
                  ),
                  TextField(
                    controller: desc,
                    decoration: const InputDecoration(
                      hintText: "Name of shop, brand",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF0A3622), width: 2),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- CATEGORY ---
                  const Text(
                    "Category",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A3622),
                    ),
                  ),
                  InkWell(
                    onTap: openCategoryPicker,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            categoryIcons[category] ?? Icons.category,
                            color: const Color(0xFF0A3622),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            category == "Select Category" ? "Choose Category" : category,
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- DATE AND AMOUNT ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Date
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              "Today ${TimeOfDay.now().format(context)}",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF0A3622),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Amount
                      Expanded(
                        child: TextField(
                          controller: amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            prefixText: "₹   ",
                            prefixStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF0A3622), width: 2),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // --- STICKY SAVE BUTTON ---
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A3622),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              onPressed: saveTransaction,
              child: const Text(
                "SAVE",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
