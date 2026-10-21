import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_drawer.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  Future<void> _launchEmail() async {
    final Uri mailUrl = Uri(
      scheme: 'mailto',
      path: 'budgetbee15144@gmail.com',
      query: 'subject=BudgetBee%20Help%20and%20Support',
    );
    try {
      if (!await launchUrl(mailUrl)) {
        await launchUrl(Uri.parse("https://mail.google.com/mail/?view=cm&fs=1&to=budgetbee15144@gmail.com"), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Mail error: $e");
      await launchUrl(Uri.parse("https://mail.google.com/mail/?view=cm&fs=1&to=budgetbee15144@gmail.com"), mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildExpandableSection(String title, IconData icon, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF0A3622).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF0A3622)),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        children: children,
      ),
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 18, color: Color(0xFF0A3622), fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Help & Support', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0A3622),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
            ),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Image.asset('assets/images/Expense_logo.png', height: 80, width: 80, errorBuilder: (_,__,___) => const Icon(Icons.support_agent, size: 80, color: Color(0xFF0A3622))),
            ),
            const SizedBox(height: 16),
            const Text(
              "How can we help you today?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            _buildExpandableSection(
              'How to Use BudgetBee',
              Icons.menu_book_rounded,
              [
                _bulletPoint('Scan your receipts or enter expenses manually via the "+" button on the Home Page.'),
                _bulletPoint('Your Bank SMS are automatically read to track debits and credits efficiently.'),
                _bulletPoint('Use the AI Chatbot to categorize expenses, get tax advice, and analyze your financial health.'),
                _bulletPoint('Set Goals in the Dream Engine to gamify your saving habits!'),
              ],
            ),

            _buildExpandableSection(
              'FAQs',
              Icons.question_answer_rounded,
              [
                const Text("Q: Is my bank data safe?\nA: Yes! BudgetBee only reads transactional SMS and does not connect to your bank account's backend. Your data stays on your device.", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const Text("Q: How do I earn Trophies?\nA: Keep your expenses low, log in daily for streaks, and achieve your Dream Engine goals!", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const Text("Q: Can I use the chatbot without internet?\nA: No, the AI Assistant requires an active internet connection to generate smart responses.", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),

            _buildExpandableSection(
              'Fix an Issue',
              Icons.build_circle_rounded,
              [
                _bulletPoint('SMS not syncing? Go to Settings and ensure SMS Permissions are fully granted.'),
                _bulletPoint('Chatbot not replying? Check your internet connection or try restarting the app.'),
                _bulletPoint('App crashing? Ensure you are on the latest version of BudgetBee.'),
              ],
            ),

            _buildExpandableSection(
              'Privacy & Security',
              Icons.security_rounded,
              [
                _bulletPoint('App Access: BudgetBee uses biometric authentication (Fingerprint/FaceID) to secure your data locally.'),
                _bulletPoint('Data Storage: All financial records are stored securely in Hive (local database) on your phone constraints.'),
                _bulletPoint('Zero Data Sharing: We do not sell your transactional data to third-party ad networks.'),
              ],
            ),

            const SizedBox(height: 20),
            
            // Contact Us Button
            GestureDetector(
              onTap: _launchEmail,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0A3622), Color(0xFF114F2E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0A3622).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.email_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Contact Us", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("budgetbee15144@gmail.com", style: TextStyle(color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
