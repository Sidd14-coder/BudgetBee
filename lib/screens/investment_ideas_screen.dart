// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../widgets/chatbot_fab.dart';

// class InvestmentIdeasScreen extends StatelessWidget {
//   const InvestmentIdeasScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F6FB),

//       // ===== PREMIUM APP BAR =====
//       appBar: AppBar(
        
//         elevation: 0,
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xFF0A33FF),
//                 Color(0xFF4B6CFF),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         title: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: const [
//             Icon(Icons.trending_up, color: Colors.white),
//             SizedBox(width: 8),
//             Text(
//               'Investment Ideas',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 0.4,
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: const ChatbotFab(),
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
//           ListView(
//             padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
//             children: const [
//               _InsightHeader(),
//               SizedBox(height: 16),

//               _IdeaCard(
//                 title: 'Emergency Fund',
//                 description:
//                     'Keep at least 6 months of expenses in a savings account or liquid fund.',
//                 reason:
//                     'Protects you during job loss, medical emergencies, or unexpected expenses.',
//                 icon: Icons.security,
//                 gradientColors: [Color(0xFF66BB6A), Color(0xFF43A047)],
//                 risk: 'Low Risk',
//                 bestForStudents: true,
//               ),

//               _IdeaCard(
//                 title: 'SIP in Index Mutual Funds',
//                 description:
//                     'Invest a fixed amount monthly in Nifty 50 or Sensex index funds.',
//                 reason:
//                     'Low cost, diversified, and ideal for long-term wealth creation.',
//                 icon: Icons.trending_up,
//                 gradientColors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
//                 risk: 'Medium Risk',
//                 bestForStudents: true,
//               ),

//               _IdeaCard(
//                 title: 'Public Provident Fund (PPF)',
//                 description:
//                     'Government-backed long-term investment with tax benefits.',
//                 reason:
//                     'Safe investment with guaranteed returns and tax-free maturity.',
//                 icon: Icons.account_balance,
//                 gradientColors: [Color(0xFF7986CB), Color(0xFF3949AB)],
//                 risk: 'Low Risk',
//                 bestForStudents: false,
//               ),

//               _IdeaCard(
//                 title: 'Recurring Deposit (RD)',
//                 description:
//                     'Save a fixed amount every month in a bank RD.',
//                 reason:
//                     'Low-risk option for disciplined saving with predictable returns.',
//                 icon: Icons.savings,
//                 gradientColors: [Color(0xFFFFB74D), Color(0xFFF57C00)],
//                 risk: 'Low Risk',
//                 bestForStudents: true,
//               ),

//               SizedBox(height: 8),

//               // ===== NEW SIP SECTION =====
//               _SipCalculatorSection(),

//               // ===== FOOTER =====
//               _FooterCTA(),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ================= INSIGHT HEADER ======================
// class _InsightHeader extends StatelessWidget {
//   const _InsightHeader();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: const [
//           Icon(Icons.lightbulb_outline, color: Colors.orange),
//           SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               'Start investing early. Even small amounts invested consistently can grow significantly over time.',
//               style: TextStyle(fontSize: 14, color: Colors.black87),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ================= IDEA CARD ===========================
// class _IdeaCard extends StatelessWidget {
//   final String title;
//   final String description;
//   final String reason;
//   final IconData icon;
//   final List<Color> gradientColors;
//   final String risk;
//   final bool bestForStudents;

//   const _IdeaCard({
//     required this.title,
//     required this.description,
//     required this.reason,
//     required this.icon,
//     required this.gradientColors,
//     required this.risk,
//     required this.bestForStudents,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(20),
//       onTap: () {},
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 18),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.06),
//               blurRadius: 14,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(18),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 52,
//               width: 52,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: gradientColors,
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: Icon(icon, color: Colors.white, size: 26),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           title,
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       _RiskBadge(risk: risk),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   Text(description,
//                       style:
//                           const TextStyle(fontSize: 14, color: Colors.black87)),
//                   const SizedBox(height: 8),
//                   Text(reason,
//                       style:
//                           const TextStyle(fontSize: 12, color: Colors.grey)),
//                   if (bestForStudents) ...[
//                     const SizedBox(height: 10),
//                     const _StudentTag(),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ================= RISK BADGE ==========================
// class _RiskBadge extends StatelessWidget {
//   final String risk;
//   const _RiskBadge({required this.risk});

//   @override
//   Widget build(BuildContext context) {
//     final isLow = risk.contains('Low');
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: isLow
//             ? Colors.green.withOpacity(0.15)
//             : Colors.orange.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         risk,
//         style: TextStyle(
//           fontSize: 11,
//           fontWeight: FontWeight.w600,
//           color: isLow ? Colors.green : Colors.orange,
//         ),
//       ),
//     );
//   }
// }

// // ================= STUDENT TAG =========================
// class _StudentTag extends StatelessWidget {
//   const _StudentTag();

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: const [
//         Icon(Icons.school, size: 14, color: Colors.blue),
//         SizedBox(width: 4),
//         Text(
//           'Best for Students',
//           style: TextStyle(
//               fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue),
//         ),
//       ],
//     );
//   }
// }

// // ================= SIP CALCULATOR SECTION ==============
// class _SipCalculatorSection extends StatelessWidget {
//   const _SipCalculatorSection();

//   Future<void> _openSipCalculator() async {
//     final Uri url =
//         Uri.parse('https://groww.in/calculators/sip-calculator');

//     if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
//       throw 'Could not open SIP Calculator';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(20),
//       onTap: _openSipCalculator,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 18),
//         padding: const EdgeInsets.all(18),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFF0A33FF), Color(0xFF4B6CFF)],
//           ),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.12),
//               blurRadius: 14,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         child: Row(
//           children: const [
//             Icon(Icons.calculate, color: Colors.white, size: 28),
//             SizedBox(width: 14),
//             Expanded(
//               child: Text(
//                 'SIP Investment Calculator',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//             Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ================= FOOTER ==============================
// class _FooterCTA extends StatelessWidget {
//   const _FooterCTA();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 8),
//       child: Center(
//         child: Text(
//           'Learn • Invest • Grow',
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w600,
//             color: Colors.grey.shade600,
//             letterSpacing: 0.6,
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/chatbot_fab.dart';
import '../widgets/app_drawer.dart';

class InvestmentIdeasScreen extends StatelessWidget {
  const InvestmentIdeasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5F0),
      endDrawer: const AppDrawer(),

      // ===== PREMIUM APP BAR =====
      appBar: AppBar(
        
        elevation: 0,
        backgroundColor: const Color(0xFF236C4A),
        title: const Text(
          'Investment Ideas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.4,
          ),
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
      floatingActionButton: const ChatbotFab(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5F0),
              image: DecorationImage(
                image: AssetImage('assets/images/bd_whatsapp.jpeg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color(0xFFE8F5F0),
                  BlendMode.multiply,
                ),
              ),
            ),
          ),
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: const [
              _InsightHeader(),
              SizedBox(height: 16),

              _IdeaCard(
                title: 'Emergency Fund',
                description:
                    'Keep at least 6 months of expenses in a savings account or liquid fund.',
                reason:
                    'Protects you during job loss, medical emergencies, or unexpected expenses.',
                icon: Icons.security,
                gradientColors: [Color(0xFF66BB6A), Color(0xFF43A047)],
                risk: 'Low Risk',
                bestForStudents: true,
              ),

              _IdeaCard(
                title: 'SIP in Index Mutual Funds',
                description:
                    'Invest a fixed amount monthly in Nifty 50 or Sensex index funds.',
                reason:
                    'Low cost, diversified, and ideal for long-term wealth creation.',
                icon: Icons.trending_up,
                gradientColors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                risk: 'Medium Risk',
                bestForStudents: true,
              ),

              _IdeaCard(
                title: 'Public Provident Fund (PPF)',
                description:
                    'Government-backed long-term investment with tax benefits.',
                reason:
                    'Safe investment with guaranteed returns and tax-free maturity.',
                icon: Icons.account_balance,
                gradientColors: [Color(0xFF7986CB), Color(0xFF3949AB)],
                risk: 'Low Risk',
                bestForStudents: false,
              ),

              _IdeaCard(
                title: 'Recurring Deposit (RD)',
                description:
                    'Save a fixed amount every month in a bank RD.',
                reason:
                    'Low-risk option for disciplined saving with predictable returns.',
                icon: Icons.savings,
                gradientColors: [Color(0xFFFFB74D), Color(0xFFF57C00)],
                risk: 'Low Risk',
                bestForStudents: true,
              ),

              SizedBox(height: 8),

              // ===== NEW SIP SECTION =====
              _SipCalculatorSection(),

              // ===== FOOTER =====
              _FooterCTA(),
            ],
          ),
        ],
      ),
    );
  }
}

// ================= INSIGHT HEADER ======================
class _InsightHeader extends StatelessWidget {
  const _InsightHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.lightbulb_outline, color: Colors.orange),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Start investing early. Even small amounts invested consistently can grow significantly over time.',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= IDEA CARD ===========================
class _IdeaCard extends StatelessWidget {
  final String title;
  final String description;
  final String reason;
  final IconData icon;
  final List<Color> gradientColors;
  final String risk;
  final bool bestForStudents;

  const _IdeaCard({
    required this.title,
    required this.description,
    required this.reason,
    required this.icon,
    required this.gradientColors,
    required this.risk,
    required this.bestForStudents,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _RiskBadge(risk: risk),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(description,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87)),
                  const SizedBox(height: 8),
                  Text(reason,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.grey)),
                  if (bestForStudents) ...[
                    const SizedBox(height: 10),
                    const _StudentTag(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= RISK BADGE ==========================
class _RiskBadge extends StatelessWidget {
  final String risk;
  const _RiskBadge({required this.risk});

  @override
  Widget build(BuildContext context) {
    final isLow = risk.contains('Low');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isLow
            ? Colors.green.withOpacity(0.15)
            : Colors.orange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        risk,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isLow ? Colors.green : Colors.orange,
        ),
      ),
    );
  }
}

// ================= STUDENT TAG =========================
class _StudentTag extends StatelessWidget {
  const _StudentTag();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.school, size: 14, color: Colors.blue),
        SizedBox(width: 4),
        Text(
          'Best for Students',
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue),
        ),
      ],
    );
  }
}

// ================= SIP CALCULATOR SECTION ==============
class _SipCalculatorSection extends StatelessWidget {
  const _SipCalculatorSection();

  Future<void> _openSipCalculator() async {
    final Uri url =
        Uri.parse('https://groww.in/calculators/sip-calculator');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not open SIP Calculator';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: _openSipCalculator,
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF236C4A),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Text(
          'SIP Investment Calculator',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// ================= FOOTER ==============================
class _FooterCTA extends StatelessWidget {
  const _FooterCTA();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Center(
        child: Text(
          'Learn • Invest • Grow',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }
}
