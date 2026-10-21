import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/gamification_service.dart';

class GamificationDashboard extends StatelessWidget {
  const GamificationDashboard({super.key});

  final List<Map<String, String>> allBadges = const [
    {'id': '7_day_streak', 'name': '7-Day Streak', 'icon': '🔥', 'desc': 'Log in 7 days in a row.'},
    {'id': '30_day_streak', 'name': 'Monthly Master', 'icon': '📅', 'desc': 'Log in 30 days in a row.'},
    {'id': 'zero_spender', 'name': 'Zero Spender', 'icon': '💎', 'desc': 'Check app with zero debits.'},
    {'id': 'super_saver', 'name': 'Super Saver', 'icon': '💰', 'desc': 'Keep spending under 50% of income.'},
  ];

  void shareToWhatsApp(int level, int streak) async {
    final String message = "I'm currently Level $level on BudgetBee with a $streak-Day login streak! 🔥🚀 Tracking my financial health has never been this fun.";
    final Uri whatsappUrl = Uri.parse("whatsapp://send?text=${Uri.encodeComponent(message)}");
    final Uri webFallbackUrl = Uri.parse("https://wa.me/?text=${Uri.encodeComponent(message)}");
    
    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(webFallbackUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      await launchUrl(webFallbackUrl, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    int level = GamificationService.currentLevel;
    int xp = GamificationService.xp;
    int streak = GamificationService.currentStreak;
    List<String> unlocked = GamificationService.unlockedBadges;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F7),
      appBar: AppBar(
        title: const Text("Trophies & Gamification", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF0A3622),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF29A185), Color(0xFF0A3622)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF0A3622).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Text('🏆', style: TextStyle(fontSize: 32)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Level $level Master', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('$xp Total XP', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            const Text("Your Badges", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            
            // Badges Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allBadges.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                var badge = allBadges[index];
                bool isUnlocked = unlocked.contains(badge['id']);
                
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isUnlocked ? const Color(0xFF29A185) : Colors.grey.shade300,
                      width: isUnlocked ? 2 : 1,
                    ),
                    boxShadow: [
                      if (isUnlocked)
                        BoxShadow(color: const Color(0xFF29A185).withOpacity(0.2), blurRadius: 10, spreadRadius: 2),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        badge['icon']!,
                        style: TextStyle(
                          fontSize: 42,
                          color: isUnlocked ? null : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        badge['name']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isUnlocked ? Colors.black87 : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        badge['desc']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: isUnlocked ? Colors.black54 : Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => shareToWhatsApp(level, streak),
                icon: const Icon(Icons.share, color: Colors.white),
                label: const Text("Flaunt on WhatsApp", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366), // WhatsApp Green
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
