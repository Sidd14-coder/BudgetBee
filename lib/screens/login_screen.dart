// import 'package:flutter/material.dart';
// import 'register_screen.dart';
// import 'dashboard_screen.dart';
// import 'forgot_password_screen.dart';
// import '../globals.dart';
// import '../data/refresh_totals.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   bool _isLoading = false;
//   bool _obscurePassword = true;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleLogin(BuildContext context) async {
//     FocusScope.of(context).unfocus();

//     final email = _emailController.text.trim();
//     final password = _passwordController.text;

//     // -------- BASIC VALIDATION --------
//     if (email.isEmpty || !email.contains('@')) {
//       _showError(context, 'Please enter a valid email');
//       return;
//     }

//     if (password.length < 6) {
//       _showError(context, 'Password must be at least 6 characters');
//       return;
//     }

//     // -------- CHECK REGISTERED USER --------
//     if (registeredEmail.isEmpty || registeredPassword.isEmpty) {
//       _showError(context, 'No account found. Please register first.');
//       return;
//     }

//     if (email != registeredEmail || password != registeredPassword) {
//       _showError(context, 'Invalid email or password');
//       return;
//     }

//     setState(() => _isLoading = true);

//     // -------- SET LOGGED-IN USER --------
//     loggedInUserEmail = email;
//     loggedInUserName = email.split('@').first.toUpperCase();

//     // -------- LOAD FINANCIAL DATA --------
//     await refreshTotals();

//     if (!mounted) return;

//     setState(() => _isLoading = false);

//     // -------- NAVIGATE --------
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (_) => const DashboardScreen(),
//       ),
//     );
//   }

//   void _showError(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFCFFBFF),
//       resizeToAvoidBottomInset: true,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),

//               /// BACK BUTTON
//               IconButton(
//                 padding: EdgeInsets.zero,
//                 alignment: Alignment.centerLeft,
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed: () => Navigator.pop(context),
//               ),

//               const SizedBox(height: 20),

//               /// TITLE
//               const Text(
//                 'Login',
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF2C3E78),
//                 ),
//               ),

//               const SizedBox(height: 8),

//               const Text(
//                 'Login using your registered account',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.black54,
//                 ),
//               ),

//               const SizedBox(height: 32),

//               /// EMAIL
//               const Text('Email'),
//               const SizedBox(height: 6),
//               TextField(
//                 controller: _emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 textInputAction: TextInputAction.next,
//                 decoration: _inputDecoration('Enter your email'),
//               ),

//               const SizedBox(height: 16),

//               /// PASSWORD
//               const Text('Password'),
//               const SizedBox(height: 6),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: _obscurePassword,
//                 textInputAction: TextInputAction.done,
//                 decoration: _inputDecoration('Enter your password').copyWith(
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword
//                           ? Icons.visibility_off
//                           : Icons.visibility,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscurePassword = !_obscurePassword;
//                       });
//                     },
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 12),

//               /// FORGOT PASSWORD
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const ForgotPasswordScreen(),
//                       ),
//                     );
//                   },
//                   child: const Text(
//                     'Forgot Password?',
//                     style: TextStyle(color: Color(0xFF2C3E78)),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               /// LOGIN BUTTON
//               SizedBox(
//                 width: double.infinity,
//                 height: 52,
//                 child: ElevatedButton(
//                   onPressed:
//                       _isLoading ? null : () => _handleLogin(context),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF2C3E78),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                   ),
//                   child: _isLoading
//                       ? const SizedBox(
//                           height: 22,
//                           width: 22,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2,
//                           ),
//                         )
//                       : const Text(
//                           'Login',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                 ),
//               ),

//               const SizedBox(height: 40),

//               /// REGISTER LINK
//               Center(
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const RegisterScreen(),
//                       ),
//                     );
//                   },
//                   child: RichText(
//                     text: const TextSpan(
//                       style: TextStyle(fontSize: 14),
//                       children: [
//                         TextSpan(
//                           text: "Don’t have an account? ",
//                           style: TextStyle(color: Colors.black54),
//                         ),
//                         TextSpan(
//                           text: 'Create one',
//                           style: TextStyle(
//                             color: Color(0xFF2C3E78),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   InputDecoration _inputDecoration(String hint) {
//     return InputDecoration(
//       hintText: hint,
//       filled: true,
//       fillColor: Colors.white,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide.none,
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'register_screen.dart';
// import 'dashboard_screen.dart';
// import 'forgot_password_screen.dart';
// import '../globals.dart';
// import '../data/refresh_totals.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   bool _isLoading = false;
//   bool _obscurePassword = true;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleLogin(BuildContext context) async {
//     FocusScope.of(context).unfocus();

//     final email = _emailController.text.trim();
//     final password = _passwordController.text;

//     // -------- BASIC VALIDATION --------
//     if (email.isEmpty || !email.contains('@')) {
//       _showError(context, 'Please enter a valid email');
//       return;
//     }

//     if (password.length < 6) {
//       _showError(context, 'Password must be at least 6 characters');
//       return;
//     }

//     // -------- CHECK REGISTERED USER --------
//     if (registeredEmail.isEmpty || registeredPassword.isEmpty) {
//       _showError(context, 'No account found. Please register first.');
//       return;
//     }

//     if (email != registeredEmail || password != registeredPassword) {
//       _showError(context, 'Invalid email or password');
//       return;
//     }

//     setState(() => _isLoading = true);

//     // -------- SET LOGGED-IN USER --------
//     loggedInUserEmail = email;
//     loggedInUserName = email.split('@').first.toUpperCase();

//     // -------- LOAD FINANCIAL DATA --------
//     await refreshTotals();

//     if (!mounted) return;

//     setState(() => _isLoading = false);

//     // -------- NAVIGATE --------
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (_) => const DashboardScreen(),
//       ),
//     );
//   }

//   void _showError(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFD5F5E3),
//       resizeToAvoidBottomInset: true,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),

//               /// BACK BUTTON
//               IconButton(
//                 padding: EdgeInsets.zero,
//                 alignment: Alignment.centerLeft,
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed: () => Navigator.pop(context),
//               ),

//               const SizedBox(height: 20),

//               /// TITLE
//               const Text(
//                 'Login',
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF2C3E78),
//                 ),
//               ),

//               const SizedBox(height: 8),

//               const Text(
//                 'Login using your registered account',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.black54,
//                 ),
//               ),

//               const SizedBox(height: 32),

//               /// EMAIL
//               const Text('Email'),
//               const SizedBox(height: 6),
//               TextField(
//                 controller: _emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 textInputAction: TextInputAction.next,
//                 decoration: _inputDecoration('Enter your email'),
//               ),

//               const SizedBox(height: 16),

//               /// PASSWORD
//               const Text('Password'),
//               const SizedBox(height: 6),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: _obscurePassword,
//                 textInputAction: TextInputAction.done,
//                 decoration: _inputDecoration('Enter your password').copyWith(
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword
//                           ? Icons.visibility_off
//                           : Icons.visibility,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscurePassword = !_obscurePassword;
//                       });
//                     },
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 12),

//               /// FORGOT PASSWORD
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const ForgotPasswordScreen(),
//                       ),
//                     );
//                   },
//                   child: const Text(
//                     'Forgot Password?',
//                     style: TextStyle(color: Color(0xFF2C3E78)),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               /// LOGIN BUTTON
//               SizedBox(
//                 width: double.infinity,
//                 height: 52,
//                 child: ElevatedButton(
//                   onPressed:
//                       _isLoading ? null : () => _handleLogin(context),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF2C3E78),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                   ),
//                   child: _isLoading
//                       ? const SizedBox(
//                           height: 22,
//                           width: 22,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2,
//                           ),
//                         )
//                       : const Text(
//                           'Login',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                 ),
//               ),

//               const SizedBox(height: 40),

//               /// REGISTER LINK
//               Center(
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const RegisterScreen(),
//                       ),
//                     );
//                   },
//                   child: RichText(
//                     text: const TextSpan(
//                       style: TextStyle(fontSize: 14),
//                       children: [
//                         TextSpan(
//                           text: "Don’t have an account? ",
//                           style: TextStyle(color: Colors.black54),
//                         ),
//                         TextSpan(
//                           text: 'Create one',
//                           style: TextStyle(
//                             color: Color(0xFF2C3E78),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   InputDecoration _inputDecoration(String hint) {
//     return InputDecoration(
//       hintText: hint,
//       filled: true,
//       fillColor: Colors.white,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide.none,
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'dashboard_screen.dart';
import 'forgot_password_screen.dart';
import '../globals.dart';
import '../data/refresh_totals.dart';
import '../services/user_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // -------- BASIC VALIDATION --------
    if (email.isEmpty || !email.contains('@')) {
      _showError(context, 'Please enter a valid email');
      return;
    }

    if (password.length < 6) {
      _showError(context, 'Password must be at least 6 characters');
      return;
    }

    // -------- CHECK REGISTERED USER --------
    if (registeredEmail.isEmpty || registeredPassword.isEmpty) {
      _showError(context, 'No account found. Please register first.');
      return;
    }

    if (email != registeredEmail || password != registeredPassword) {
      _showError(context, 'Invalid email or password');
      return;
    }

    setState(() => _isLoading = true);

    // -------- SET LOGGED-IN USER --------
    loggedInUserEmail = email;
    loggedInUserName = registeredName.isNotEmpty ? registeredName : email.split('@').first.toUpperCase();
    saveUserToHive(loggedInUserName, loggedInUserEmail);

    // -------- LOAD FINANCIAL DATA --------
    await refreshTotals();

    if (!mounted) return;

    setState(() => _isLoading = false);

    // -------- NAVIGATE --------
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const DashboardScreen(),
      ),
    );
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
      backgroundColor: const Color(0xFFD5F5E3),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              /// BACK BUTTON
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 20),

              /// TITLE
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E78),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Login using your registered account',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 32),

              /// EMAIL
              const Text('Email'),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration('Enter your email'),
              ),

              const SizedBox(height: 16),

              /// PASSWORD
              const Text('Password'),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                decoration: _inputDecoration('Enter your password').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// FORGOT PASSWORD
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Color(0xFF2C3E78)),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed:
                      _isLoading ? null : () => _handleLogin(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C3E78),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 40),

              /// REGISTER LINK
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 14),
                      children: [
                        TextSpan(
                          text: "Don’t have an account? ",
                          style: TextStyle(color: Colors.black54),
                        ),
                        TextSpan(
                          text: 'Create one',
                          style: TextStyle(
                            color: Color(0xFF2C3E78),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
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
