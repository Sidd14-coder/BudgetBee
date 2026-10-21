// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';

// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9FAFB),
//       appBar: AppBar(
        
//         backgroundColor: const Color(0xFF0A33FF),
//         title: const Text(
//         'Settings',
//         style: TextStyle(color: Colors.white),
//         ),

//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: ListView(
//         children: [
//           _section('APP INFORMATION'),

//           _item(
//             icon: Icons.info_outline,
//             title: 'About App',
//             onTap: () => _showDialog(
//               context,
//               'About BudgetBee',
//               'BudgetBee is a personal finance management application designed to help users track income, expenses, and savings.\n\n'
//               'The app provides clear financial summaries, spending alerts, and insights to encourage better money management habits.\n\n'
//               'This project is developed as an academic and learning-based application using Flutter.',
//             ),
//           ),
//           _divider(),

//           _staticItem(
//             icon: Icons.system_update,
//             title: 'App Version',
//             value: 'v1.0.0',
//           ),
//           _divider(),

//           _item(
//             icon: Icons.code,
//             title: 'Developer Info',
//             onTap: () => _showDialog(
//               context,
//               'Developer Information',
//               'This application is developed using Flutter framework.\n\n'
//               'It focuses on clean UI design, modular structure, and practical implementation of mobile app development concepts.\n\n'
//               'The project demonstrates real-world use cases such as expense tracking, data summarization, and user interaction.',
//             ),
//           ),
//           _divider(),

//           _item(
//             icon: Icons.book,
//             title: 'Open Source Licenses',
//             onTap: () => _showDialog(
//               context,
//               'Open Source Licenses',
//               'BudgetBee uses open-source libraries such as Flutter SDK and community-supported packages.\n\n'
//               'These libraries help accelerate development while maintaining performance and reliability.\n\n'
//               'All licenses are respected as per open-source guidelines.',
//             ),
//           ),

//           const SizedBox(height: 24),

//           _section('LEGAL'),

//           _item(
//             icon: Icons.privacy_tip_outlined,
//             title: 'Privacy Policy',
//             onTap: () => _showDialog(
//               context,
//               'Privacy Policy',
//               'Your privacy is important.\n\n'
//               'BudgetBee does NOT collect, store, or share any personal user data.\n\n'
//               'All financial data remains on the user’s device and is used only for displaying summaries and insights.',
//             ),
//           ),
//           _divider(),

//           _item(
//             icon: Icons.description_outlined,
//             title: 'Terms & Conditions',
//             onTap: () => _showDialog(
//               context,
//               'Terms & Conditions',
//               'By using this application, you agree that:\n\n'
//               '• The app is for personal expense tracking only.\n'
//               '• Financial summaries are estimates based on user data.\n'
//               '• The developer is not responsible for financial decisions made using this app.',
//             ),
//           ),
//           _divider(),

//           _item(
//             icon: Icons.warning_amber_outlined,
//             title: 'Disclaimer',
//             onTap: () => _showDialog(
//               context,
//               'Disclaimer',
//               'BudgetBee does not provide financial or investment advice.\n\n'
//               'All insights are informational and should not be considered professional guidance.\n\n'
//               'Users are responsible for verifying financial decisions independently.',
//             ),
//           ),

//           const SizedBox(height: 24),

//           _section('ENGAGEMENT'),

//           _item(
//             icon: Icons.share_outlined,
//             title: 'Share App',
//             onTap: () {
//               Share.share(
//                 'I am using BudgetBee to track my expenses and manage my finances. Give it a try!',
//               );
//             },
//           ),
//           _divider(),

//           _item(
//             icon: Icons.star_rate_outlined,
//             title: 'Rate App',
//             onTap: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text(
//                     'Thank you for supporting BudgetBee! ⭐',
//                   ),
//                 ),
//               );
//             },
//           ),
//           _divider(),

//           _item(
//             icon: Icons.feedback_outlined,
//             title: 'Send Feedback',
//             onTap: () => _showDialog(
//               context,
//               'Feedback',
//               'Your feedback is valuable.\n\n'
//               'Suggestions and improvements help enhance the quality and usability of the application.\n\n'
//               'Thank you for taking the time to explore BudgetBee.',
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ---------- HELPERS ----------

//   static Widget _section(String title) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 22, 16, 8),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontWeight: FontWeight.bold,
//           color: Color.fromARGB(255, 6, 6, 6),
//         ),
//       ),
//     );
//   }

//   static Widget _item({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.blue),
//       title: Text(title),
//       trailing: const Icon(Icons.chevron_right),
//       onTap: onTap,
//     );
//   }

//   static Widget _staticItem({
//     required IconData icon,
//     required String title,
//     required String value,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.blue),
//       title: Text(title),
//       trailing: Text(value),
//     );
//   }

//   static Widget _divider() => const Divider(height: 1);

//   static void _showDialog(
//     BuildContext context,
//     String title,
//     String message,
//   ) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text(title),
//         content: SingleChildScrollView(child: Text(message)),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:animations/animations.dart';
import '../globals.dart';
import '../widgets/app_drawer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        
        backgroundColor: const Color(0xFF0A3622),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          _section('APP INFORMATION'),

          _item(
            icon: Icons.info_outline,
            title: 'About App',
            onTap: () => _showDialog(
              context,
              'About BudgetBee',
              'BudgetBee is a personal finance management application designed to help users track income, expenses, and savings.\n\n'
              'The app provides clear financial summaries, spending alerts, and insights to encourage better money management habits.\n\n'
              'This project is developed as an academic and learning-based application using Flutter.',
            ),
          ),
          _divider(),

          _staticItem(
            icon: Icons.system_update,
            title: 'App Version',
            value: 'v1.0.0',
          ),
          _divider(),

          _item(
            icon: Icons.code,
            title: 'Developer Info',
            onTap: () => _showDialog(
              context,
              'Developer Information',
              'This application is developed using Flutter framework.\n\n'
              'It focuses on clean UI design, modular structure, and practical implementation of mobile app development concepts.\n\n'
              'The project demonstrates real-world use cases such as expense tracking, data summarization, and user interaction.',
            ),
          ),
          _divider(),

          _item(
            icon: Icons.book,
            title: 'Open Source Licenses',
            onTap: () => _showDialog(
              context,
              'Open Source Licenses',
              'BudgetBee uses open-source libraries such as Flutter SDK and community-supported packages.\n\n'
              'These libraries help accelerate development while maintaining performance and reliability.\n\n'
              'All licenses are respected as per open-source guidelines.',
            ),
          ),

          const SizedBox(height: 24),

          _section('AI INTERFACE'),
          StatefulBuilder(
            builder: (context, setLocalState) {
              return SwitchListTile(
                secondary: const Icon(Icons.whatshot, color: Colors.orange),
                title: const Text('Savage "Roast" Mode'),
                subtitle: const Text('AI will be brutally honest, sarcastic, and funny about your bad spending habits.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                activeColor: Colors.orange,
                value: isSavageModeEnabled,
                onChanged: (val) {
                  setLocalState(() {
                    isSavageModeEnabled = val;
                  });
                },
              );
            }
          ),
          _divider(),

          const SizedBox(height: 24),

          _section('SECURITY'),
          _item(
            icon: Icons.security,
            title: 'Biometric Lock',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Biometric lock is active by default for maximum privacy.')),
              );
            },
          ),
          _divider(),

          const SizedBox(height: 24),

          _section('LEGAL'),

          _item(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () => _showDialog(
              context,
              'Privacy Policy',
              'Your privacy is important.\n\n'
              'BudgetBee does NOT collect, store, or share any personal user data.\n\n'
              'All financial data remains on the user’s device and is used only for displaying summaries and insights.',
            ),
          ),
          _divider(),

          _item(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            onTap: () => _showDialog(
              context,
              'Terms & Conditions',
              'By using this application, you agree that:\n\n'
              '• The app is for personal expense tracking only.\n'
              '• Financial summaries are estimates based on user data.\n'
              '• The developer is not responsible for financial decisions made using this app.',
            ),
          ),
          _divider(),

          _item(
            icon: Icons.warning_amber_outlined,
            title: 'Disclaimer',
            onTap: () => _showDialog(
              context,
              'Disclaimer',
              'BudgetBee does not provide financial or investment advice.\n\n'
              'All insights are informational and should not be considered professional guidance.\n\n'
              'Users are responsible for verifying financial decisions independently.',
            ),
          ),

          const SizedBox(height: 24),

          _section('ENGAGEMENT'),

          _item(
            icon: Icons.share_outlined,
            title: 'Share App',
            onTap: () {
              Share.share(
                'I am using BudgetBee to track my expenses and manage my finances. Give it a try!',
              );
            },
          ),
          _divider(),

          _item(
            icon: Icons.star_rate_outlined,
            title: 'Rate App',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Thank you for supporting BudgetBee! ⭐',
                  ),
                ),
              );
            },
          ),
          _divider(),

          _item(
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            onTap: () => _showDialog(
              context,
              'Feedback',
              'Your feedback is valuable.\n\n'
              'Suggestions and improvements help enhance the quality and usability of the application.\n\n'
              'Thank you for taking the time to explore BudgetBee.',
            ),
          ),
        ],
      ),
    );
  }

  // ---------- HELPERS ----------

  static Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 6, 6, 6),
        ),
      ),
    );
  }

  static Widget _item({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  static Widget _staticItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: Text(value),
    );
  }

  static Widget _divider() => const Divider(height: 1);

  static void _showDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    showModal(
      context: context,
      configuration: const FadeScaleTransitionConfiguration(),
      builder: (_) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(message)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
