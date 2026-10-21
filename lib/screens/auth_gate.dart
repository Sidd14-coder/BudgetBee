import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'welcome_screen.dart';
import 'dashboard_screen.dart';
import 'biometric_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Still checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // User logged in → Dashboard (via Biometric Lock)
        if (snapshot.hasData) {
          return const BiometricScreen(nextScreen: DashboardScreen());
        }

        // User NOT logged in → Welcome
        return const WelcomeScreen();
      },
    );
  }
}
