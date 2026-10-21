import 'package:flutter/material.dart';
import '../globals.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _emailVerified = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _verifyEmail(BuildContext context) {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      _showError(context, 'Please enter a valid email');
      return;
    }

    if (registeredEmail.isEmpty) {
      _showError(context, 'No account found. Please register first.');
      return;
    }

    if (email != registeredEmail) {
      _showError(context, 'Email not registered');
      return;
    }

    setState(() {
      _emailVerified = true;
    });
  }

  void _resetPassword(BuildContext context) {
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;

    if (newPass.length < 6) {
      _showError(context, 'Password must be at least 6 characters');
      return;
    }

    if (newPass != confirmPass) {
      _showError(context, 'Passwords do not match');
      return;
    }

    // ✅ UPDATE PASSWORD (UI LEVEL)
    registeredPassword = newPass;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password updated successfully. Please login.'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context); // back to Login
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFFBFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              /// BACK
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 20),

              const Text(
                'Forgot Password',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E78),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                _emailVerified
                    ? 'Set a new password'
                    : 'Verify your registered email',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 30),

              /// EMAIL
              const Text('Email'),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                enabled: !_emailVerified,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('Enter registered email'),
              ),

              if (_emailVerified) ...[
                const SizedBox(height: 16),

                /// NEW PASSWORD
                const Text('New Password'),
                const SizedBox(height: 6),
                TextField(
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  decoration:
                      _inputDecoration('Enter new password').copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// CONFIRM PASSWORD
                const Text('Confirm Password'),
                const SizedBox(height: 6),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration:
                      _inputDecoration('Confirm new password').copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword =
                              !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              /// ACTION BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _emailVerified
                      ? () => _resetPassword(context)
                      : () => _verifyEmail(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C3E78),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _emailVerified ? 'Update Password' : 'Verify Email',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
