// import 'package:flutter/material.dart';
// import 'login_screen.dart';
// import '../globals.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   void _register(BuildContext context) {
//     if (!_formKey.currentState!.validate()) return;

//     // ✅ SAVE REGISTERED USER (UI-LEVEL, NO BACKEND)
//     registeredEmail = _emailController.text.trim();
//     registeredPassword = _passwordController.text;

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Account created successfully. Please login.'),
//         backgroundColor: Colors.green,
//       ),
//     );

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (_) => const LoginScreen(),
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
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 20),

//                 /// BACK BUTTON
//                 IconButton(
//                   padding: EdgeInsets.zero,
//                   alignment: Alignment.centerLeft,
//                   icon: const Icon(Icons.arrow_back),
//                   onPressed: () => Navigator.pop(context),
//                 ),

//                 const SizedBox(height: 20),

//                 /// TITLE
//                 const Text(
//                   'Create Account',
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF2C3E78),
//                   ),
//                 ),

//                 const SizedBox(height: 8),

//                 const Text(
//                   'Create a new account to get started',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.black54,
//                   ),
//                 ),

//                 const SizedBox(height: 32),

//                 /// NAME
//                 const Text('Full Name'),
//                 const SizedBox(height: 6),
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: _inputDecoration('Enter your full name'),
//                   validator: (v) =>
//                       v == null || v.trim().isEmpty ? 'Name is required' : null,
//                 ),

//                 const SizedBox(height: 16),

//                 /// EMAIL
//                 const Text('Email'),
//                 const SizedBox(height: 6),
//                 TextFormField(
//                   controller: _emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: _inputDecoration('Enter your email'),
//                   validator: (v) {
//                     if (v == null || v.isEmpty) {
//                       return 'Email is required';
//                     }
//                     if (!v.contains('@')) {
//                       return 'Enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),

//                 const SizedBox(height: 16),

//                 /// PASSWORD
//                 const Text('Password'),
//                 const SizedBox(height: 6),
//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: _inputDecoration('Create a password'),
//                   validator: (v) {
//                     if (v == null || v.isEmpty) {
//                       return 'Password is required';
//                     }
//                     if (v.length < 6) {
//                       return 'Minimum 6 characters';
//                     }
//                     return null;
//                   },
//                 ),

//                 const SizedBox(height: 16),

//                 /// CONFIRM PASSWORD
//                 const Text('Confirm Password'),
//                 const SizedBox(height: 6),
//                 TextFormField(
//                   controller: _confirmPasswordController,
//                   obscureText: true,
//                   decoration: _inputDecoration('Confirm your password'),
//                   validator: (v) {
//                     if (v != _passwordController.text) {
//                       return 'Passwords do not match';
//                     }
//                     return null;
//                   },
//                 ),

//                 const SizedBox(height: 24),

//                 /// CREATE ACCOUNT BUTTON
//                 SizedBox(
//                   width: double.infinity,
//                   height: 52,
//                   child: ElevatedButton(
//                     onPressed: () => _register(context),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF2C3E78),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                     ),
//                     child: const Text(
//                       'Create Account',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 40),

//                 /// LOGIN LINK
//                 Center(
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => const LoginScreen(),
//                         ),
//                       );
//                     },
//                     child: RichText(
//                       text: const TextSpan(
//                         style: TextStyle(fontSize: 14),
//                         children: [
//                           TextSpan(
//                             text: 'Already have an account? ',
//                             style: TextStyle(color: Colors.black54),
//                           ),
//                           TextSpan(
//                             text: 'Login',
//                             style: TextStyle(
//                               color: Color(0xFF2C3E78),
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),
//               ],
//             ),
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
// import 'login_screen.dart';
// import '../globals.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   void _register(BuildContext context) {
//     if (!_formKey.currentState!.validate()) return;

//     // ✅ SAVE REGISTERED USER (UI-LEVEL, NO BACKEND)
//     registeredEmail = _emailController.text.trim();
//     registeredPassword = _passwordController.text;

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Account created successfully. Please login.'),
//         backgroundColor: Colors.green,
//       ),
//     );

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (_) => const LoginScreen(),
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
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 20),

//                 /// BACK BUTTON
//                 IconButton(
//                   padding: EdgeInsets.zero,
//                   alignment: Alignment.centerLeft,
//                   icon: const Icon(Icons.arrow_back),
//                   onPressed: () => Navigator.pop(context),
//                 ),

//                 const SizedBox(height: 20),

//                 /// TITLE
//                 const Text(
//                   'Create Account',
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF2C3E78),
//                   ),
//                 ),

//                 const SizedBox(height: 8),

//                 const Text(
//                   'Create a new account to get started',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.black54,
//                   ),
//                 ),

//                 const SizedBox(height: 32),

//                 /// NAME
//                 const Text('Full Name'),
//                 const SizedBox(height: 6),
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: _inputDecoration('Enter your full name'),
//                   validator: (v) =>
//                       v == null || v.trim().isEmpty ? 'Name is required' : null,
//                 ),

//                 const SizedBox(height: 16),

//                 /// EMAIL
//                 const Text('Email'),
//                 const SizedBox(height: 6),
//                 TextFormField(
//                   controller: _emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: _inputDecoration('Enter your email'),
//                   validator: (v) {
//                     if (v == null || v.isEmpty) {
//                       return 'Email is required';
//                     }
//                     if (!v.contains('@')) {
//                       return 'Enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),

//                 const SizedBox(height: 16),

//                 /// PASSWORD
//                 const Text('Password'),
//                 const SizedBox(height: 6),
//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: _inputDecoration('Create a password'),
//                   validator: (v) {
//                     if (v == null || v.isEmpty) {
//                       return 'Password is required';
//                     }
//                     if (v.length < 6) {
//                       return 'Minimum 6 characters';
//                     }
//                     return null;
//                   },
//                 ),

//                 const SizedBox(height: 16),

//                 /// CONFIRM PASSWORD
//                 const Text('Confirm Password'),
//                 const SizedBox(height: 6),
//                 TextFormField(
//                   controller: _confirmPasswordController,
//                   obscureText: true,
//                   decoration: _inputDecoration('Confirm your password'),
//                   validator: (v) {
//                     if (v != _passwordController.text) {
//                       return 'Passwords do not match';
//                     }
//                     return null;
//                   },
//                 ),

//                 const SizedBox(height: 24),

//                 /// CREATE ACCOUNT BUTTON
//                 SizedBox(
//                   width: double.infinity,
//                   height: 52,
//                   child: ElevatedButton(
//                     onPressed: () => _register(context),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF2C3E78),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                     ),
//                     child: const Text(
//                       'Create Account',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 40),

//                 /// LOGIN LINK
//                 Center(
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => const LoginScreen(),
//                         ),
//                       );
//                     },
//                     child: RichText(
//                       text: const TextSpan(
//                         style: TextStyle(fontSize: 14),
//                         children: [
//                           TextSpan(
//                             text: 'Already have an account? ',
//                             style: TextStyle(color: Colors.black54),
//                           ),
//                           TextSpan(
//                             text: 'Login',
//                             style: TextStyle(
//                               color: Color(0xFF2C3E78),
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),
//               ],
//             ),
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
import 'login_screen.dart';
import '../globals.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    // ✅ SAVE REGISTERED USER (UI-LEVEL, NO BACKEND)
    registeredEmail = _emailController.text.trim();
    registeredPassword = _passwordController.text;
    registeredName = _nameController.text.trim();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account created successfully. Please login.'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
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
          child: Form(
            key: _formKey,
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
                  'Create Account',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E78),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Create a new account to get started',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 32),

                /// NAME
                const Text('Full Name'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration('Enter your full name'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Name is required' : null,
                ),

                const SizedBox(height: 16),

                /// EMAIL
                const Text('Email'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration('Enter your email'),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Email is required';
                    }
                    if (!v.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                /// PASSWORD
                const Text('Password'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: _inputDecoration('Create a password'),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Password is required';
                    }
                    if (v.length < 6) {
                      return 'Minimum 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                /// CONFIRM PASSWORD
                const Text('Confirm Password'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: _inputDecoration('Confirm your password'),
                  validator: (v) {
                    if (v != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                /// CREATE ACCOUNT BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => _register(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C3E78),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// LOGIN LINK
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(color: Colors.black54),
                          ),
                          TextSpan(
                            text: 'Login',
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
