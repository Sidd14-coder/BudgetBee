// import 'package:flutter/material.dart';
// // import '../../models/emi_model.dart';
// import '../../services/emi_service.dart';
// import 'package:hive/hive.dart';

// class AddEmiScreen extends StatefulWidget {
//   const AddEmiScreen({super.key});

//   @override
//   State<AddEmiScreen> createState() => _AddEmiScreenState();
// }

// class _AddEmiScreenState extends State<AddEmiScreen> {

//   final _formKey = GlobalKey<FormState>();

//   final name = TextEditingController();
//   final loan = TextEditingController();
//   final emi = TextEditingController();
//   final tenure = TextEditingController();
//   final interest = TextEditingController();

//   void saveEmi() {

//   if (!_formKey.currentState!.validate()) return;

//   var box = Hive.box('emiBox');

//   box.add({
//     "name": name.text,
//     "loanAmount": double.tryParse(loan.text) ?? 0,
//     "emi": double.tryParse(emi.text) ?? 0,
//     "tenure": int.tryParse(tenure.text) ?? 0,
//     "paidMonths": 0,
//     "remainingMonths": int.tryParse(tenure.text) ?? 0,
//     "keywords": name.text.toLowerCase(), // 🔥 IMPORTANT
//     "nextDue": DateTime.now().toString(),
//   });

//   Navigator.pop(context);
// }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: AppBar(title: const Text("Add New EMI")),

//       body: Padding(
//         padding: const EdgeInsets.all(16),

//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [

//               TextFormField(
//                 controller: name,
//                 decoration: const InputDecoration(labelText: "Loan Name"),
//                 validator: (v)=>v!.isEmpty?"Enter loan name":null,
//               ),

//               TextFormField(
//                 controller: loan,
//                 decoration: const InputDecoration(labelText: "Loan Amount"),
//                 keyboardType: TextInputType.number,
//               ),

//               TextFormField(
//                 controller: emi,
//                 decoration: const InputDecoration(labelText: "Monthly EMI"),
//                 keyboardType: TextInputType.number,
//               ),

//               TextFormField(
//                 controller: tenure,
//                 decoration: const InputDecoration(labelText: "Loan Tenure (months)"),
//                 keyboardType: TextInputType.number,
//               ),

//               TextFormField(
//                 controller: interest,
//                 decoration: const InputDecoration(labelText: "Rate Of Interest"),
//                 keyboardType: TextInputType.number,
//               ),

//               const SizedBox(height: 20),

//               ElevatedButton(
//                 onPressed: saveEmi,
//                 child: const Text("Add EMI"),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
// import '../../models/emi_model.dart';
import '../../services/emi_service.dart';
import 'package:hive/hive.dart';
import '../chatbot_screen.dart';

class AddEmiScreen extends StatefulWidget {
  const AddEmiScreen({super.key});

  @override
  State<AddEmiScreen> createState() => _AddEmiScreenState();
}

class _AddEmiScreenState extends State<AddEmiScreen> {

  final _formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final loan = TextEditingController();
  final emi = TextEditingController();
  final tenure = TextEditingController();
  final interest = TextEditingController();

  void saveEmi() {

  if (!_formKey.currentState!.validate()) return;

  var box = Hive.box('emiBox');

  box.add({
    "name": name.text,
    "loanAmount": double.tryParse(loan.text) ?? 0,
    "emi": double.tryParse(emi.text) ?? 0,
    "tenure": int.tryParse(tenure.text) ?? 0,
    "paidMonths": 0,
    "remainingMonths": int.tryParse(tenure.text) ?? 0,
    "keywords": name.text.toLowerCase(), // 🔥 IMPORTANT
    "nextDue": DateTime.now().toString(),
  });

  Navigator.pop(context);
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add New EMI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F7F1),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2)),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Loan Name"),
                      _buildTextField(name, "Enter loan name"),
                      const SizedBox(height: 16),
                      _buildLabel("Loan Amount"),
                      _buildTextField(loan, "Enter loan amount (₹)", isNumber: true),
                      const SizedBox(height: 16),
                      _buildLabel("Monthly EMI"),
                      _buildTextField(emi, "Enter monthly EMI amount (₹)", isNumber: true),
                      const SizedBox(height: 16),
                      _buildLabel("Loan Tenure"),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildTextField(tenure, "Months", isNumber: true),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 52,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD6E3D8), // Light green tint
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text("1 year", style: TextStyle(color: Color(0xFF1A3B29), fontWeight: FontWeight.bold, fontSize: 15)),
                                  Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF1A3B29)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildLabel("Interest Rate", subLabel: "(Optional)"),
                      _buildTextField(interest, "Enter interest rate (%)", isNumber: true),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD2E6D4), // Muted green as in mockup
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          onPressed: saveEmi,
                          child: const Text("Add EMI", style: TextStyle(color: Color(0xFF153323), fontSize: 17, fontWeight: FontWeight.w800)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
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

  Widget _buildLabel(String text, {String? subLabel}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A3B29))),
          if (subLabel != null) ...[
            const SizedBox(width: 4),
            Text(subLabel, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
          ]
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint, {bool isNumber = false}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (v) => v!.isEmpty ? "Required" : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0A3622), width: 1.5),
        ),
      ),
    );
  }
}
