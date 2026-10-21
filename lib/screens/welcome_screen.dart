// import 'package:flutter/material.dart';
// import '../services/google_auth_service.dart';
// import 'dashboard_screen.dart';
// import 'login_screen.dart';
// import 'register_screen.dart';
// import '../services/user_service.dart';

// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: const Color(0xFFCFFBFF),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),

//             /// LOGO
//             Padding(
//               padding: const EdgeInsets.only(left: 40),
//               child: Image.asset(
//                 'assets/images/Expense_logo.png',
//                 width: size.width * 0.8,
//                 height: size.height * 0.5,
//                 fit: BoxFit.contain,
//               ),
//             ),

//             const SizedBox(height: 12),

//             /// CONTENT
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Welcome To..',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black87,
//                       ),
//                     ),

//                     const SizedBox(height: 6),

//                     const Text(
//                       'BudgetBee',
//                       style: TextStyle(
//                         fontSize: 34,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF2C3E78),
//                       ),
//                     ),

//                     const SizedBox(height: 8),

//                     const Text(
//                       'A place where you can track all your expense',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.black54,
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     const Text(
//                       "Let’s get started..",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     /// 🔥 CONTINUE WITH GOOGLE (CORRECT)
//                     SizedBox(
//                       width: double.infinity,
//                       height: 52,
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           final user =
//                               await GoogleAuthService.signInWithGoogle();

//                           if (user != null && context.mounted) {

//                             //ADD THIS LINE
//                             saveUserToHive(user.displayName ?? '', user.email ?? '');

//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => const DashboardScreen(),
//                               ),
//                             );
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: Colors.black87,
//                           elevation: 2,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Icon(Icons.g_mobiledata, size: 28),
//                             SizedBox(width: 10),
//                             Text(
//                               'Continue with Google',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 14),

//                     /// CREATE MANUAL ACCOUNT
//                     SizedBox(
//                       width: double.infinity,
//                       height: 52,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const RegisterScreen(),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: Colors.black87,
//                           elevation: 2,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Icon(Icons.person_outline),
//                             SizedBox(width: 10),
//                             Text(
//                               'Create Manual Account',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     const Spacer(),

//                     /// LOGIN TEXT (MANUAL LOGIN ONLY)
//                     Center(
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const LoginScreen(),
//                             ),
//                           );
//                         },
//                         child: RichText(
//                           text: TextSpan(
//                             style: const TextStyle(fontSize: 14),
//                             children: const [
//                               TextSpan(
//                                 text: 'Already have an account? ',
//                                 style: TextStyle(color: Colors.black54),
//                               ),
//                               TextSpan(
//                                 text: 'Login',
//                                 style: TextStyle(
//                                   color: Color(0xFF2C3E78),
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import '../services/google_auth_service.dart';
// import 'dashboard_screen.dart';
// import 'login_screen.dart';
// import 'register_screen.dart';
// import '../services/user_service.dart';

// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: const Color(0xFFD5F5E3),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),

//             /// LOGO
//             Padding(
//               padding: const EdgeInsets.only(left: 40),
//               child: Image.asset(
//                 'assets/images/Expense_logo.png',
//                 width: size.width * 0.8,
//                 height: size.height * 0.4,
//                 fit: BoxFit.contain,
//               ),
//             ),

//             const SizedBox(height: 12),

//             /// CONTENT
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Welcome To..',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black87,
//                       ),
//                     ),

//                     const SizedBox(height: 6),

//                     const Text(
//                       'BudgetBee',
//                       style: TextStyle(
//                         fontSize: 34,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF2C3E78),
//                       ),
//                     ),

//                     const SizedBox(height: 8),

//                     const Text(
//                       'A place where you can track all your expense',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.black54,
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     const Text(
//                       "Let’s get started..",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     /// 🔥 CONTINUE WITH GOOGLE (CORRECT)
//                     SizedBox(
//                       width: double.infinity,
//                       height: 52,
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           final user =
//                               await GoogleAuthService.signInWithGoogle();

//                           if (user != null && context.mounted) {

//                             //ADD THIS LINE
//                             saveUserToHive(user.displayName ?? '', user.email ?? '');

//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => const DashboardScreen(),
//                               ),
//                             );
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: Colors.black87,
//                           elevation: 2,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Icon(Icons.g_mobiledata, size: 28),
//                             SizedBox(width: 10),
//                             Text(
//                               'Continue with Google',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 14),

//                     /// CREATE MANUAL ACCOUNT
//                     SizedBox(
//                       width: double.infinity,
//                       height: 52,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const RegisterScreen(),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: Colors.black87,
//                           elevation: 2,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Icon(Icons.person_outline),
//                             SizedBox(width: 10),
//                             Text(
//                               'Create Manual Account',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     const Spacer(),

//                     /// LOGIN TEXT (MANUAL LOGIN ONLY)
//                     Center(
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const LoginScreen(),
//                             ),
//                           );
//                         },
//                         child: RichText(
//                           text: TextSpan(
//                             style: const TextStyle(fontSize: 14),
//                             children: const [
//                               TextSpan(
//                                 text: 'Already have an account? ',
//                                 style: TextStyle(color: Colors.black54),
//                               ),
//                               TextSpan(
//                                 text: 'Login',
//                                 style: TextStyle(
//                                   color: Color(0xFF2C3E78),
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import '../services/google_auth_service.dart';
// import 'dashboard_screen.dart';
// import 'login_screen.dart';
// import 'register_screen.dart';
// import '../services/user_service.dart';

// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: const Color(0xFFD5F5E3),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// SPACE AT TOP (Increased to move components lower)
//             SizedBox(height: size.height * 0.15),

//             /// CONTENT & LOGO ALIGNED TO LEFT
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     /// LOGO
//                     Transform.translate(
//                       offset: const Offset(0, 0), // Pushed right by +60
//                       child: Image.asset(
//                         'assets/images/ChatGPT Image Jan 31, 2026, 04_15_02 PM.png',
//                         width: size.width * 0.8, // Reduced size to prevent overflow
//                         height: 200,
//                         alignment: Alignment.centerLeft,
//                         fit: BoxFit.contain,
//                       ),
//                     ),
                    
//                     const SizedBox(height: 24),

//                     const Text(
//                       'Welcome To..',
//                       style: TextStyle(
//                         fontSize: 20,
//                         color: Colors.black87,
//                       ),
//                     ),

//                     const SizedBox(height: 8),

//                     RichText(
//                       text: const TextSpan(
//                         children: [
//                           TextSpan(
//                             text: 'Budget',
//                             style: TextStyle(
//                               fontSize: 40,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF1CB5AF), // Cyan/Teal color matching the first image
//                             ),
//                           ),
//                           TextSpan(
//                             text: 'Bee',
//                             style: TextStyle(
//                               fontSize: 40,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF2C3E78), // Deep blue
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 8),

//                     const Text(
//                       'A place where you can track all your\nexpense',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.black54,
//                       ),
//                     ),

//                     const SizedBox(height: 48),

//                     const Text(
//                       "Let’s get started..",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     /// 🔥 CONTINUE WITH GOOGLE (CORRECT)
//                     SizedBox(
//                       width: double.infinity,
//                       height: 52,
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           final user =
//                               await GoogleAuthService.signInWithGoogle();

//                           if (user != null && context.mounted) {
//                             //ADD THIS LINE
//                             saveUserToHive(user.displayName ?? '', user.email ?? '');

//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => const DashboardScreen(),
//                               ),
//                             );
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: Colors.black87,
//                           elevation: 2,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Icon(Icons.g_mobiledata, size: 28),
//                             SizedBox(width: 10),
//                             Text(
//                               'Continue with Google',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     /// CREATE MANUAL ACCOUNT
//                     SizedBox(
//                       width: double.infinity,
//                       height: 52,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const RegisterScreen(),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: Colors.black87,
//                           elevation: 2,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Icon(Icons.person_outline),
//                             SizedBox(width: 10),
//                             Text(
//                               'Create Manual Account',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     const Spacer(),

//                     /// LOGIN TEXT (MANUAL LOGIN ONLY)
//                     Center(
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const LoginScreen(),
//                             ),
//                           );
//                         },
//                         child: RichText(
//                           text: const TextSpan(
//                             style: TextStyle(fontSize: 14),
//                             children: [
//                               TextSpan(
//                                 text: 'Already have an account? ',
//                                 style: TextStyle(color: Colors.black54),
//                               ),
//                               TextSpan(
//                                 text: 'Login',
//                                 style: TextStyle(
//                                   color: Color(0xFF2C3E78),
//                                   fontWeight: FontWeight.bold,
//                                   decoration: TextDecoration.underline,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../services/google_auth_service.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import '../services/user_service.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFD5F5E3),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// SPACE AT TOP (Increased to move components lower)
            SizedBox(height: size.height * 0.15),

            /// CONTENT & LOGO ALIGNED TO LEFT
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// LOGO
                    Transform.translate(
                      offset: const Offset(0, 0), // Pushed right by +60
                      child: Image.asset(
                        'assets/images/ChatGPT Image Jan 31, 2026, 04_15_02 PM.png',
                        height: 200, // Reduced size
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.contain,
                      ),
                    ),
                    
                    const SizedBox(height: 24),

                    const Text(
                      'Welcome To..',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 8),

                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Budget',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1CB5AF), // Cyan/Teal color matching the first image
                            ),
                          ),
                          TextSpan(
                            text: 'Bee',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E78), // Deep blue
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'A place where you can track all your\nexpense',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 48),

                    const Text(
                      "Let’s get started..",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔥 CONTINUE WITH GOOGLE (CORRECT)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () async {
                          final user =
                              await GoogleAuthService.signInWithGoogle();

                          if (user != null && context.mounted) {
                            //ADD THIS LINE
                            saveUserToHive(user.displayName ?? '', user.email ?? '');

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DashboardScreen(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/icons/Google.png', width: 24, height: 24),
                            const SizedBox(width: 10),
                            const Text(
                              'Continue with Google',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// CREATE MANUAL ACCOUNT
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/icons/Manual.png', width: 24, height: 24),
                            const SizedBox(width: 10),
                            const Text(
                              'Create Manual Account',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    /// LOGIN TEXT (MANUAL LOGIN ONLY)
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
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
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
