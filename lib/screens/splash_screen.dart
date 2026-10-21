// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'welcome_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();

//     Timer(const Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => const WelcomeScreen(), // ✅ FIXED
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFCFFBFF),
//       body: SizedBox.expand(
//         child: Image.asset(
//           'assets/images/Expense_logo.png',
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'dart:async';
import 'auth_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AuthGate(), // ✅ FIXED TO USE AUTHGATE
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5F5E3),
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/Expense_logo.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
