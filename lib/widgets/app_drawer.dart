import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';
import '../services/google_auth_service.dart';
import '../services/user_service.dart';
import '../globals.dart';
import '../screens/welcome_screen.dart';
import '../screens/follow_us_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/help_support_screen.dart';
import '../screens/monthly_report_screen.dart';
import '../screens/credit_card_screen.dart';
import '../screens/health_doctor_screen.dart';
import '../screens/category_analytics_screen.dart';
import '../screens/analytics_screen.dart';
import '../screens/tax_assistant_screen.dart';
import '../screens/dream_engine_screen.dart';
import '../screens/subscription_manager_screen.dart'; // ADDED

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var user = getUserFromHive();
    String name = "User";
    String email = "user@email.com";
    
    if (user != null) {
      name = user['name'] ?? 'User';
      email = user['email'] ?? 'user@email.com';
    } else if (loggedInUserName.isNotEmpty) {
      name = loggedInUserName;
      email = loggedInUserEmail;
    }

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
            decoration: const BoxDecoration(
              color: Color(0xFF0A3622),
              borderRadius: BorderRadius.only(topRight: Radius.circular(24)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.amber,
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
          _drawerTile(context, Icons.insert_chart, 'View Monthly Report', () {
            Navigator.pop(context);
            Navigator.push(context, CupertinoPageRoute(builder: (_) => const MonthlyReportScreen()));
          }),
          const Divider(height: 1),
          _drawerTile(context, Icons.credit_card, 'Credit Card Manager', () {
            Navigator.pop(context);
            Navigator.push(context, CupertinoPageRoute(builder: (_) => const CreditCardScreen()));
          }),
          const Divider(height: 1),

          _drawerTile(context, Icons.medical_services, 'Health Doctor & Subs', () {
            Navigator.pop(context);
            Navigator.push(context, CupertinoPageRoute(builder: (_) => const HealthDoctorScreen()));
          }),
          const Divider(height: 1),
          _drawerTile(context, Icons.pie_chart, 'Category Analytics', () {
            Navigator.pop(context);
            Navigator.push(context, CupertinoPageRoute(builder: (_) => const CategoryAnalyticsScreen()));
          }),
          const Divider(height: 1),
          _drawerTile(context, Icons.analytics, 'Detailed Analytics', () {
            Navigator.pop(context);
            Navigator.push(context, CupertinoPageRoute(builder: (_) => const AnalyticsScreen()));
          }),
          const Divider(height: 1),
          _drawerTile(context, Icons.receipt_long, 'Tax Dashboard', () {
            Navigator.pop(context);
            Navigator.push(context, CupertinoPageRoute(builder: (_) => const TaxAssistantScreen()));
          }),
          const Divider(height: 1),
          _drawerTile(context, Icons.stars, 'The Dream Engine', () {
            Navigator.pop(context);
            Navigator.push(context, CupertinoPageRoute(builder: (_) => const DreamEngineScreen()));
          }),
          const Divider(height: 1),
          _drawerTile(context, Icons.subscriptions, 'Smart Subscriptions', () {
            Navigator.pop(context);
            Navigator.push(context, CupertinoPageRoute(builder: (_) => const SubscriptionManagerScreen()));
          }),
          const Divider(height: 1),
          _drawerTile(context, Icons.person, 'Invite friends', () {
            Navigator.pop(context);
            Share.share('Hey! I am using BudgetBee to track my expenses.');
          }),
          const Divider(height: 1),
          _drawerTile(context, Icons.favorite, 'Follow us', () {
            Navigator.pop(context);
            Navigator.push(context, CupertinoPageRoute(builder: (_) => const FollowUsScreen()));
          }, Colors.red),
          const Divider(height: 1),
          _drawerTile(context, Icons.help_outline_rounded, 'Help & Support', () {
            Navigator.pop(context);
            Navigator.push(context, CupertinoPageRoute(builder: (_) => const HelpSupportScreen()));
          }, Colors.green),
          const Divider(height: 1),
          _drawerTile(context, Icons.settings, 'Setting', () {
            Navigator.pop(context);
            Navigator.push(context, CupertinoPageRoute(builder: (_) => const SettingsScreen()));
          }, Colors.blue),
          const Divider(height: 1),
          _drawerTile(context, Icons.logout, 'Log out', () async {
            Navigator.pop(context);
            await GoogleAuthService.signOut();
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (_) => const WelcomeScreen()),
              (_) => false,
            );
          }, Colors.orange),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerTile(BuildContext context, IconData icon, String text, VoidCallback onTap, [Color iconColor = Colors.black87]) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(text),
      onTap: onTap,
    );
  }
}
