import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:telephony/telephony.dart';
import 'package:animations/animations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'data/refresh_totals.dart';
import 'services/notification_service.dart';
import 'services/gamification_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService().init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();

  await Hive.openBox('emiBox');
  await Hive.openBox('paymentHistory'); // 🔥 IMPORTANT

  await Hive.openBox('customTransactions');

  await Hive.openBox('userBox');
  await Hive.openBox('creditCardBox');
  await Hive.openBox('dreamBox');
  await Hive.openBox('merchantCategoryBox'); // LEGACY
  await Hive.openBox('transactionCategoryBox'); // NEW: For per-transaction manual overrides
  await Hive.openBox('gamificationBox'); // NEW: 10x Gamification Persistent Storage
  await Hive.openBox('smsTransactionsBox'); // NEW: Local SMS Backup to prevent data loss on deletion

  // ✅ REQUEST SMS PERMISSION ONCE AT APP START
  final telephony = Telephony.instance;
  await telephony.requestSmsPermissions;

  // ✅ CALCULATE TOTALS AFTER PERMISSION
  await refreshTotals();
  
  // ✅ SETUP GAMIFICATION DAILY XP
  await GamificationService.checkDailyLogin();
  await GamificationService.evaluateFinancialBadges();

  runApp(const ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.outfitTextTheme(Theme.of(context).textTheme),
        primaryColor: const Color(0xFF0A3622), // Ultra-premium ultra-dark green
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A3622),
          primary: const Color(0xFF0A3622),
          secondary: const Color(0xFFD4AF37), // Pure gold for a classic wealth feel
        ),
        scaffoldBackgroundColor: const Color(0xFFF9FAFB), // Softer, ultra-modern grey-white
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF0A3622),
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: GoogleFonts.outfit(
            color: Colors.white, 
            fontSize: 22, 
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 6,
          shadowColor: Colors.black.withOpacity(0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.horizontal,
            ),
            TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.horizontal,
            ),
          },
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
