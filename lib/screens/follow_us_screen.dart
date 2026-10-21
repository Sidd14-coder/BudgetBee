// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class FollowUsScreen extends StatelessWidget {
//   const FollowUsScreen({super.key});

//   Future<void> _launchUrl(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFCFFBFF),

//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0A33FF),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text('Follow us', style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//       ),

//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/bd_whatsapp.jpeg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: GridView.count(
//               crossAxisCount: 2,
//               crossAxisSpacing: 20,
//               mainAxisSpacing: 20,
//               children: [
//                 _SocialCard(
//                   imagePath: 'assets/icons/instagram.png',
//                   label: 'Instagram',
//                   onTap: () => _launchUrl(
//                     'https://www.instagram.com/budgetbee15?igsh=MXVnNG9lZ2d2N3VzMA==',
//                   ),
//                 ),
//                 _SocialCard(
//                   imagePath: 'assets/icons/twitter.png',
//                   label: 'X (Twitter)',
//                   onTap: () => _launchUrl('https://x.com/Budgetbee_'),
//                 ),
//                 _SocialCard(
//                   imagePath: 'assets/icons/linkedin.png',
//                   label: 'LinkedIn',
//                   onTap: () => _launchUrl('https://www.linkedin.com/in/budgetbee-4b6a2b3a9'),
//                 ),
//                 _SocialCard(
//                   imagePath: 'assets/icons/gmail.png',
//                   label: 'Gmail',
//                   onTap: () => _launchUrl('mailto:budgetbee15144@gmail.com'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SocialCard extends StatelessWidget {
//   final String imagePath;
//   final String label;
//   final VoidCallback onTap;

//   const _SocialCard({
//     required this.imagePath,
//     required this.label,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(20),
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 8,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               imagePath,
//               height: 48,
//               width: 48,
//             ),
//             const SizedBox(height: 12),
//             Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_drawer.dart';

class FollowUsScreen extends StatelessWidget {
  const FollowUsScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      endDrawer: const AppDrawer(),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3622),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Follow us', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bd_whatsapp.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _SocialCard(
                  imagePath: 'assets/icons/instagram.png',
                  label: 'Instagram',
                  onTap: () => _launchUrl(
                    'https://www.instagram.com/budgetbee15?igsh=MXVnNG9lZ2d2N3VzMA==',
                  ),
                ),
                _SocialCard(
                  imagePath: 'assets/icons/twitter.png',
                  label: 'X (Twitter)',
                  onTap: () => _launchUrl('https://x.com/Budgetbee_'),
                ),
                _SocialCard(
                  imagePath: 'assets/icons/linkedin.png',
                  label: 'LinkedIn',
                  onTap: () => _launchUrl('https://www.linkedin.com/in/budgetbee-4b6a2b3a9'),
                ),
                _SocialCard(
                  imagePath: 'assets/icons/gmail.png',
                  label: 'Gmail',
                  onTap: () => _launchUrl('mailto:budgetbee15144@gmail.com'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const _SocialCard({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 48,
              width: 48,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
