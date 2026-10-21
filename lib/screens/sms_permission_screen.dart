import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'login_screen.dart';

class SmsPermissionScreen extends StatelessWidget {
  SmsPermissionScreen({super.key});
  final Telephony telephony = Telephony.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SMS Permission')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sms, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                'Allow SMS Access',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'We read bank SMS to track expenses automatically.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  final ok = await telephony.requestSmsPermissions;
                  if (ok == true) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  }
                },
                child: const Text('Allow Permission'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
