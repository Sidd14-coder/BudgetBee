import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart'; // 🔥 Universal Drawer Injected
import '../globals.dart';
import '../services/google_auth_service.dart';
import 'welcome_screen.dart';
import 'follow_us_screen.dart';
import 'settings_screen.dart';
import 'investment_ideas_screen.dart';
import 'saving_ideas_screen.dart';
import 'package:share_plus/share_plus.dart';
import '../data/refresh_totals.dart';
import 'emi/emi_tracker_card.dart';
import '../services/user_service.dart';
import '../widgets/chatbot_fab.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    loadUser(); // 🔥 ADD THIS
    _loadProfileData();
  }

  void loadUser() {
  var user = getUserFromHive();

  if (user != null) {
    loggedInUserName = user['name'] ?? '';
    loggedInUserEmail = user['email'] ?? '';
  }
}

  Future<void> _loadProfileData() async {
    await refreshTotals();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFFEE), // Very light green bg
      endDrawer: const AppDrawer(), // 🔥 Hooked Universal App Drawer
      drawerEnableOpenDragGesture: false,
      floatingActionButton: const ChatbotFab(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HEADER =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
              decoration: const BoxDecoration(
                color: Color(0xFF0A3622),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(34)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Builder(
                        builder: (ctx) => IconButton(
                          icon: const Icon(Icons.more_vert,
                              color: Colors.white),
                          onPressed: () {
                            Scaffold.of(ctx).openEndDrawer();
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.amber,
                    child: Text(
                      loggedInUserName.isNotEmpty
                          ? loggedInUserName[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    loggedInUserName.isNotEmpty
                        ? loggedInUserName
                        : 'User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loggedInUserEmail,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),
            _sectionTitle('🏆 Achievements & Badges'),
            _badgesSection(),

            const SizedBox(height: 26),
            _sectionTitle('🏦 Bank Accounts'),

_bankAccountsSection(),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF114F2E), Color(0xFF0A3622)]),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF0A3622).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
                  ]
                ),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.show_chart, color: Colors.white, size: 20),
                  label: const Text(
                    'View Investment Ideas',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const InvestmentIdeasScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),

            _sectionTitle('Financial Summary'),
            const SizedBox(height: 14),
            _financeCards(),
            const SizedBox(height: 20),

            _sectionTitle('EMI Tracker'),
            const SizedBox(height: 10),
            EmiTrackerCard(income: totalCredit),
            const SizedBox(height: 20),

// 🔥 UPDATED SPENDING ALERT UI
_spendingAlert(context),
          ],
        ),
      ),
    );
  }

  // ===== FINANCE CARDS =====
  // ===== FINANCE CARDS =====
Widget _financeCards() {
  final double difference = totalDebit - totalCredit;
  final bool isOverspending = difference > 0;

  final String title = isOverspending ? 'Overspend' : 'Savings';
  final Color color = isOverspending ? Colors.red : Colors.green;
  final String sign = isOverspending ? '-' : '+';
  final double displayAmount = difference.abs();

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: [
        _miniCard('Credit', totalCredit, const LinearGradient(colors: [Color(0xFF69DB7C), Color(0xFF2B8A3E)])),
        const SizedBox(width: 14),
        _miniCard('Debit', totalDebit, const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFC92A2A)])),
        const SizedBox(width: 14),

        // 🔥 UPDATED CARD (Dynamic)
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              gradient: isOverspending ? const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFC92A2A)]) : const LinearGradient(colors: [Color(0xFF4BACFF), Color(0xFF0056D2)]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.account_balance_wallet, color: Colors.white),
                const SizedBox(height: 12),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13, color: Colors.white)),
                const SizedBox(height: 6),
                Text(
                  '$sign ₹${displayAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
  Widget _bankAccountsSection() {
  if (bankBalances.isEmpty) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'No bank SMS found yet',
        style: TextStyle(color: Colors.black54),
      ),
    );
  }

  return Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Column(
    children: bankBalances.entries
        .where((e) => e.value > 0) // ✅ sirf real balance wale banks
        .map((entry) {
      final bankName = entry.key;
      final balance = entry.value;

      final logoPath = _getBankLogo(bankName);
      final acc = bankAccounts[bankName] ?? '';

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 🔵 BANK LOGO
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                logoPath,
                width: 36,
                height: 36,
                errorBuilder: (_, __, ___) => Image.asset(
                  'assets/banks/default.png',
                  width: 36,
                  height: 36,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // 🔵 BANK NAME + ACCOUNT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bankName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  if (acc.isNotEmpty)
                    Text(
                      acc,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                ],
              ),
            ),

            // 🔵 BALANCE
            Text(
              '₹${balance.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.green,
              ),
            ),
          ],
        ),
      );
    }).toList(),
  ),
);
}

  Widget _badgesSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _premiumBadge(
            title: 'Saver 🥉',
            desc: 'Kept spending below income',
            unlocked: totalCredit > totalDebit,
            gradient: const [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
          ),
          const SizedBox(width: 16),
          _premiumBadge(
            title: 'Investor 🚀',
            desc: 'Has active savings',
            unlocked: (totalCredit - totalDebit) > 5000,
            gradient: const [Color(0xFFF2994A), Color(0xFFF2C94C)],
          ),
          const SizedBox(width: 16),
          _premiumBadge(
            title: 'Elite 💎',
            desc: 'High Financial Health',
            unlocked: totalCredit > 0 && (totalDebit/totalCredit) < 0.5,
            gradient: const [Color(0xFF1CB5E0), Color(0xFF000851)],
          ),
        ],
      ),
    );
  }

  Widget _premiumBadge({required String title, required String desc, required bool unlocked, required List<Color> gradient}) {
    return Container(
      width: 150,
      height: 140,
      decoration: BoxDecoration(
        gradient: unlocked ? LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
        color: unlocked ? null : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(24),
        boxShadow: unlocked
            ? [
                BoxShadow(
                  color: gradient.last.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
      ),
      child: Stack(
        children: [
          // Subtle shimmer overlay
          if (unlocked)
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: unlocked ? Colors.white.withOpacity(0.2) : Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        unlocked ? Icons.emoji_events_rounded : Icons.lock_outline_rounded,
                        color: unlocked ? Colors.white : Colors.grey,
                        size: 20,
                      ),
                    ),
                    if (unlocked)
                      const Icon(Icons.check_circle, color: Colors.white, size: 18)
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        color: unlocked ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: unlocked ? Colors.white.withOpacity(0.85) : Colors.grey.shade500,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniCard(String title, double value, Gradient gradient) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            const Icon(Icons.account_balance_wallet, color: Colors.white),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13, color: Colors.white)),
            const SizedBox(height: 6),
            Text(
              '₹${value.toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== 🔥 UPDATED SPENDING ALERT =====
  Widget _spendingAlert(BuildContext context) {
    if (totalCredit <= 0) return const SizedBox.shrink();

    Color color;
    IconData icon;
    String title, desc, btn;
    VoidCallback action;

    if (totalDebit > totalCredit) {
      color = Colors.red;
      icon = Icons.warning_rounded;
      title = 'Spending Alert';
      desc = 'Your expenses are higher than your income.';
      btn = 'View Saving Ideas';
      action = () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SavingIdeasScreen()),
          );
    } else if (isHighSpending) {
      color = Colors.orange;
      icon = Icons.trending_up;
      title = 'High Spending';
      desc = 'You are close to your spending limit.';
      btn = 'Reduce Expenses';
      action = () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SavingIdeasScreen()),
          );
    } else {
      color = Colors.green;
      icon = Icons.check_circle;
      title = 'Good Job';
      desc = 'Your spending is under control.';
      btn = 'Explore Investments';
      action = () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const InvestmentIdeasScreen()),
          );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 140,
            decoration: BoxDecoration(
              color: color,
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(20)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: action,
                      child: Text(
                        btn,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== CARD =====
  Widget _card(Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  // Extracted to universal AppDrawer


  static Widget _sectionTitle(String title) {
    // String mapping to remove emojis
    String cleanTitle = title.replaceAll(RegExp(r'[^a-zA-Z ]'), '').trim();
    if(cleanTitle == 'Account Details') cleanTitle = 'Account Details'; // Sanity check

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(cleanTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0A3622))),
    );
  }

  static Widget _infoRow(String label, String value) => Row(
        children: [
          SizedBox(
            width: 80,
            child: Text('$label:',
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(value)),
        ],
      );

  String _getBankLogo(String bankName) {
  final name = bankName.toLowerCase().replaceAll(' ', '');

  if (name.contains('indiapost')) return 'assets/banks/indiapostpayments.png';
  if (name.contains('bankofindia') || name.contains('boi')) return 'assets/banks/bankofindia.png';
  if (name.contains('hdfc')) return 'assets/banks/hdfc.png';
  if (name.contains('axis')) return 'assets/banks/axisbank.png';
  if (name.contains('statebankofindia') || name.contains('sbi')) return 'assets/banks/statebankofindia.png';
  if (name.contains('icici')) return 'assets/banks/default.png'; // add icici logo later if you want
  if (name.contains('kotak')) return 'assets/banks/kotakmahindra.png';
  if (name.contains('punjabnational')) return 'assets/banks/punjabnational.png';
  if (name.contains('canara')) return 'assets/banks/canarabank.png';
  if (name.contains('unionbank')) return 'assets/banks/unionbankofindia.png';
  if (name.contains('indusind')) return 'assets/banks/indusind.png';
  if (name.contains('yesbank')) return 'assets/banks/yes_bank.png';
  if (name.contains('idf')) return 'assets/banks/idfc_first.png';
  if (name.contains('uco')) return 'assets/banks/uco_bank.png';
  if (name.contains('paytm')) return 'assets/banks/paytmpayments.png';
  if (name.contains('nsdl')) return 'assets/banks/nsdl_payments.png';
  if (name.contains('jana')) return 'assets/banks/janasmallfinance.png';
  if (name.contains('equitas')) return 'assets/banks/equitassmallfinance.png';
  if (name.contains('ujjivan')) return 'assets/banks/ujjivansmallfinance.png';
  if (name.contains('esaf')) return 'assets/banks/esafsmallfinance.png';
  if (name.contains('suryoday')) return 'assets/banks/suryodaysmallfinance.png';
  if (name.contains('ausmall')) return 'assets/banks/ausmallfinance.png';
  if (name.contains('karnataka')) return 'assets/banks/karnataka.png';
  if (name.contains('karurvysya')) return 'assets/banks/karurvysya.png';
  if (name.contains('centralbank')) return 'assets/banks/centralbankofindia.png';
  if (name.contains('bankofbaroda') || name.contains('bob')) return 'assets/banks/bankofbaroda.png';
  if (name.contains('indianbank')) return 'assets/banks/indianbank.png';
  if (name.contains('indianoverseas')) return 'assets/banks/indianoverseasbank.png';
  if (name.contains('cityunion')) return 'assets/banks/cityunion.png';
  if (name.contains('federal')) return 'assets/banks/federal.png';
  if (name.contains('tamilnadmercantile')) return 'assets/banks/tamilnadmercantile.png';
  if (name.contains('southindian')) return 'assets/banks/southindian.png';
  if (name.contains('rbl')) return 'assets/banks/rblbank.png';
  if (name.contains('hsbc')) return 'assets/banks/hsbc_india.png';
  if (name.contains('deutsche')) return 'assets/banks/deutschebankindia.png';
  if (name.contains('barclays')) return 'assets/banks/barclaysbankindia.png';
  if (name.contains('bnp')) return 'assets/banks/bnp_paribasindia.png';
  if (name.contains('jio')) return 'assets/banks/jiopayments.png';
  if (name.contains('airtel')) return 'assets/banks/airtelpayments.png';
  if (name.contains('fino')) return 'assets/banks/finopayments.png';

  return 'assets/banks/default.png';
}
}
