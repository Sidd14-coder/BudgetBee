// import 'package:flutter/material.dart';
// import 'dart:math';
// import 'package:fl_chart/fl_chart.dart';

// class EmiCalculatorScreen extends StatefulWidget {
//   const EmiCalculatorScreen({super.key});

//   @override
//   State<EmiCalculatorScreen> createState() => _EmiCalculatorScreenState();
// }

// class _EmiCalculatorScreenState extends State<EmiCalculatorScreen> {

//   final TextEditingController loanController = TextEditingController();
//   final TextEditingController interestController = TextEditingController();
//   final TextEditingController tenureController = TextEditingController();

//   double emi = 0;
//   double totalInterest = 0;
//   double totalPayment = 0;

//   void calculateEMI() {

//     double loan = double.tryParse(loanController.text) ?? 0;
//     double annualInterest = double.tryParse(interestController.text) ?? 0;
//     int tenure = int.tryParse(tenureController.text) ?? 0;

//     if (loan == 0 || annualInterest == 0 || tenure == 0) {
//       return;
//     }

//     double monthlyInterest = annualInterest / 12 / 100;

//     double emiValue = (loan * monthlyInterest * pow((1 + monthlyInterest), tenure)) /
//         (pow((1 + monthlyInterest), tenure) - 1);

//     double totalPay = emiValue * tenure;
//     double interest = totalPay - loan;

//     setState(() {
//       emi = emiValue;
//       totalPayment = totalPay;
//       totalInterest = interest;
//     });
//   }

//   void saveEmi() {

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("EMI Saved Successfully (connect with EMI tracker)"),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("EMI Calculator"),
//       ),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),

//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             const Text("Loan Amount"),
//             const SizedBox(height: 5),

//             TextField(
//               controller: loanController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: "Enter loan amount",
//               ),
//             ),

//             const SizedBox(height: 15),

//             const Text("Interest Rate (%)"),
//             const SizedBox(height: 5),

//             TextField(
//               controller: interestController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: "Annual interest rate",
//               ),
//             ),

//             const SizedBox(height: 15),

//             const Text("Loan Tenure (Months)"),
//             const SizedBox(height: 5),

//             TextField(
//               controller: tenureController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: "Enter months",
//               ),
//             ),

//             const SizedBox(height: 20),

//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: calculateEMI,
//                 child: const Text("Calculate EMI"),
//               ),
//             ),

//             const SizedBox(height: 30),

//             if (emi > 0)
//               Card(
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),

//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [

//                       const Text(
//                         "Loan Summary",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),

//                       const SizedBox(height: 15),

//                       Text("Loan Amount: ₹${loanController.text}"),
//                       Text("Interest Rate: ${interestController.text}%"),
//                       Text("Tenure: ${tenureController.text} months"),

//                       const Divider(height: 25),

//                       Text(
//                         "Monthly EMI: ₹${emi.toStringAsFixed(2)}",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),

//                       Text("Total Interest: ₹${totalInterest.toStringAsFixed(2)}"),
//                       Text("Total Payment: ₹${totalPayment.toStringAsFixed(2)}"),

//                       const SizedBox(height: 25),

//                       const Text(
//                         "Loan vs Interest",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       SizedBox(
//                         height: 200,
//                         child: PieChart(
//                           PieChartData(
//                             sections: [

//                               PieChartSectionData(
//                                 value: double.parse(loanController.text),
//                                 color: Colors.blue,
//                                 title: "Loan",
//                               ),

//                               PieChartSectionData(
//                                 value: totalInterest,
//                                 color: Colors.red,
//                                 title: "Interest",
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 25),

//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: saveEmi,
//                           child: const Text("Save EMI"),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import '../chatbot_screen.dart';

class EmiCalculatorScreen extends StatefulWidget {
  const EmiCalculatorScreen({super.key});

  @override
  State<EmiCalculatorScreen> createState() => _EmiCalculatorScreenState();
}

class _EmiCalculatorScreenState extends State<EmiCalculatorScreen> {

  final TextEditingController loanController = TextEditingController();
  final TextEditingController interestController = TextEditingController();
  final TextEditingController tenureController = TextEditingController();

  double emi = 0;
  double totalInterest = 0;
  double totalPayment = 0;

  void calculateEMI() {

    double loan = double.tryParse(loanController.text) ?? 0;
    double annualInterest = double.tryParse(interestController.text) ?? 0;
    int tenure = int.tryParse(tenureController.text) ?? 0;

    if (loan == 0 || annualInterest == 0 || tenure == 0) {
      return;
    }

    double monthlyInterest = annualInterest / 12 / 100;

    double emiValue = (loan * monthlyInterest * pow((1 + monthlyInterest), tenure)) /
        (pow((1 + monthlyInterest), tenure) - 1);

    double totalPay = emiValue * tenure;
    double interest = totalPay - loan;

    setState(() {
      emi = emiValue;
      totalPayment = totalPay;
      totalInterest = interest;
    });
  }

  void saveEmi() {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("EMI Saved Successfully (connect with EMI tracker)"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("EMI Calculator", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Loan Amount"),
                    _buildTextField(loanController, "Enter loan amount (₹)"),
                    const SizedBox(height: 16),
                    _buildLabel("Interest Rate"),
                    _buildTextField(interestController, "Enter interest rate (%)"),
                    const SizedBox(height: 16),
                    _buildLabel("Loan Tenure"),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildTextField(tenureController, "Months"),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
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
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2A6A4E), // Darker green as in mockup
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        onPressed: calculateEMI,
                        child: const Text("Calculate EMI", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    if (emi > 0) ...[
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Monthly EMI", style: TextStyle(fontSize: 16, color: Color(0xFF5A5A5A))),
                          Text("₹${emi.toStringAsFixed(0)}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total Interest", style: TextStyle(fontSize: 16, color: Color(0xFF5A5A5A))),
                          Text("₹${totalInterest.toStringAsFixed(0)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(height: 1, color: Color(0xFFD6E3D8)),
                      const SizedBox(height: 20),
                      
                      const Text("Loan vs Interest", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A3B29))),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(value: double.parse(loanController.text), color: const Color(0xFF2A6A4E), title: "Loan", titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              PieChartSectionData(value: totalInterest, color: const Color(0xFF81A088), title: "Interest", titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF2A6A4E)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: saveEmi,
                          child: const Text("Save EMI", style: TextStyle(color: Color(0xFF2A6A4E), fontWeight: FontWeight.bold)),
                        ),
                      )
                    ]
                  ],
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A3B29))),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.number,
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
