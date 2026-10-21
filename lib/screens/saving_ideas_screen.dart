import 'package:flutter/material.dart';
import '../widgets/chatbot_fab.dart';
import '../widgets/app_drawer.dart';

class SavingIdeasScreen extends StatelessWidget {
  const SavingIdeasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      endDrawer: const AppDrawer(),

      // ===== PREMIUM APP BAR =====
      appBar: AppBar(
        
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0A3DFF),
                Color(0xFF4F6BFF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.savings, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              'Saving Ideas',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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
              image: DecorationImage(
                image: AssetImage('assets/images/bd_whatsapp.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: const [
              // ===== INSIGHT HEADER =====
              _SavingInsightHeader(),

              SizedBox(height: 16),

              _SavingCard(
                title: 'Follow 50-30-20 Rule',
                description: '50% needs, 30% wants, 20% savings.',
                reason: 'Creates a healthy and disciplined money habit.',
                icon: Icons.pie_chart_rounded,
                gradientColors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                difficulty: 'Easy',
                bestForStudents: true,
              ),

              _SavingCard(
                title: 'Reduce Food Delivery',
                description: 'Cook more at home, order less online.',
                reason: 'Food delivery quietly drains your wallet.',
                icon: Icons.fastfood_rounded,
                gradientColors: [Color(0xFFFFA726), Color(0xFFFB8C00)],
                difficulty: 'Medium',
                bestForStudents: true,
              ),

              _SavingCard(
                title: 'Cancel Unused Subscriptions',
                description: 'Remove OTT, music, and unused apps.',
                reason: 'Small subscriptions become big yearly losses.',
                icon: Icons.subscriptions_rounded,
                gradientColors: [Color(0xFFEF5350), Color(0xFFE53935)],
                difficulty: 'Easy',
                bestForStudents: true,
              ),

              _SavingCard(
                title: 'Set Daily Spending Limit',
                description: 'Track and limit daily expenses.',
                reason: 'Controls impulse buying effectively.',
                icon: Icons.track_changes_rounded,
                gradientColors: [Color(0xFF66BB6A), Color(0xFF43A047)],
                difficulty: 'Medium',
                bestForStudents: true,
              ),

              _SavingCard(
                title: 'Use Cash for Daily Expenses',
                description: 'Spend only what you withdraw.',
                reason: 'Seeing money physically reduces overspending.',
                icon: Icons.account_balance_wallet_rounded,
                gradientColors: [Color(0xFFAB47BC), Color(0xFF8E24AA)],
                difficulty: 'Hard',
                bestForStudents: false,
              ),

              SizedBox(height: 8),

              // ===== FOOTER =====
              _SavingFooterCTA(),
            ],
          ),
        ],
      ),
    );
  }
}

// =======================================================
// ================= INSIGHT HEADER ======================
// =======================================================
class _SavingInsightHeader extends StatelessWidget {
  const _SavingInsightHeader();

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
              'Saving small amounts consistently is more powerful than saving large amounts occasionally.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =======================================================
// ================= SAVING CARD =========================
// =======================================================
class _SavingCard extends StatelessWidget {
  final String title;
  final String description;
  final String reason;
  final IconData icon;
  final List<Color> gradientColors;
  final String difficulty;
  final bool bestForStudents;

  const _SavingCard({
    required this.title,
    required this.description,
    required this.reason,
    required this.icon,
    required this.gradientColors,
    required this.difficulty,
    required this.bestForStudents,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(18),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ===== ICON =====
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

            // ===== CONTENT =====
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _DifficultyBadge(level: difficulty),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    reason,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  if (bestForStudents) ...[
                    const SizedBox(height: 10),
                    const _StudentSavingTag(),
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

// =======================================================
// ================= DIFFICULTY BADGE ====================
// =======================================================
class _DifficultyBadge extends StatelessWidget {
  final String level;
  const _DifficultyBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    Color color;
    if (level == 'Easy') {
      color = Colors.green;
    } else if (level == 'Medium') {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        level,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// =======================================================
// ================= STUDENT TAG =========================
// =======================================================
class _StudentSavingTag extends StatelessWidget {
  const _StudentSavingTag();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.school, size: 14, color: Colors.blue),
        SizedBox(width: 4),
        Text(
          'Best for Students',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}

// =======================================================
// ================= FOOTER CTA ==========================
// =======================================================
class _SavingFooterCTA extends StatelessWidget {
  const _SavingFooterCTA();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Save Smart • Spend Wisely',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
