import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart' hide SmsMessage;
import '../globals.dart';
import '../services/emi_service.dart';
import '../services/emi_payment_service.dart';
import '../models/emi_payment_model.dart';
import 'package:hive/hive.dart';
import '../widgets/chatbot_fab.dart';
import '../services/merchant_categorizer.dart'; // ADDED MERGHANT CATEGORIZER
import '../widgets/app_drawer.dart';

class LocalSms {
  final String? body;
  final int? date;
  final String? address;

  LocalSms({this.body, this.date, this.address});
}

/* =========================================================
   TRANSACTION PARSER (STRICT Ã¢â‚¬â€œ NO FALSE POSITIVES)
   ========================================================= */

class ParsedTransaction {
  final bool isDebit;
  final double amount;
  final String merchant;

  ParsedTransaction({
    required this.isDebit,
    required this.amount,
    required this.merchant,
  });
}

ParsedTransaction? parseTransactionSMS(String bodyRaw) {
  // SPAM FILTER (Aligned with refresh_totals.dart)
  final b = bodyRaw.toLowerCase();
  final spamKeywords = [
    'recharge now',
    'play rummy',
    'claim now',
    'lottery',
    'win cash',
    'data pack',
    'validity expires',
    'vip gift',
    'cutt.ly',
    'rummy',
  ];
  for (var word in spamKeywords) {
    if (b.contains(word)) return null; // Reject spam outright
  }

  // MASKING KEYWORDS TO PREVENT DEBITS FROM BEING FLAGGED AS CREDITS
  final body = bodyRaw
      .toUpperCase()
      .replaceAll('CREDIT CARD', '')
      .replaceAll('CREDIT LIMIT', '');

  final debitRegex = RegExp(
    r'\b(DEBIT(?:ED)?|DR\b|WITHDRAWN|SPENT|PURCHASE|PAID|SENT|UPI-DR|DBT)\b',
  );

  final creditRegex = RegExp(
    r'\b(CREDIT(?:ED)?|CR\b|RECEIVED|REFUND|CASHBACK|REVERSAL|UPI-CR)\b',
  );

  bool? isDebit;

  if (debitRegex.hasMatch(body)) isDebit = true;
  if (creditRegex.hasMatch(body)) isDebit = false;

  if (isDebit == null) return null;

  final amountRegex = RegExp(
    r'(?:RS\.?|INR|₹)\s*([\d,]+(?:\.\d{1,2})?)',
    caseSensitive: false,
  );

  final amtMatch = amountRegex.firstMatch(body.replaceAll(',', ''));
  if (amtMatch == null) return null;

  final amount = double.tryParse(amtMatch.group(1) ?? '');
  if (amount == null || amount <= 0) return null;

  final knownMerchants = [
    'AMAZON',
    'FLIPKART',
    'SWIGGY',
    'ZOMATO',
    'PAYTM',
    'GPAY',
    'PHONEPE',
    'OLA',
    'UBER',
    'IRCTC',
    'DMART',
    'RELIANCE',
    'NETFLIX',
    'SPOTIFY',
  ];

  for (final m in knownMerchants) {
    if (body.contains(m)) {
      return ParsedTransaction(isDebit: isDebit, amount: amount, merchant: m);
    }
  }

  final merchantPatterns = [
    RegExp(r'AT\s+([A-Z0-9&\-\s]{3,})'),
    RegExp(r'TO\s+([A-Z0-9&\-\s]{3,})'),
    RegExp(r'FROM\s+([A-Z0-9&\-\s]{3,})'),
  ];

  for (final p in merchantPatterns) {
    final m = p.firstMatch(body);
    if (m != null) {
      final name = m.group(1)!.trim();
      if (!name.contains('ACCOUNT') && name.length > 2) {
        return ParsedTransaction(
          isDebit: isDebit,
          amount: amount,
          merchant: name,
        );
      }
    }
  }

  return ParsedTransaction(
    isDebit: isDebit,
    amount: amount,
    merchant: 'BANK TRANSACTION',
  );
}

bool isEmiPayment(String bodyRaw) {
  final body = bodyRaw.toUpperCase();

  final emiKeywords = [
    'EMI',
    'INSTALLMENT',
    'LOAN REPAYMENT',
    'LOAN PAYMENT',
    'ECS',
  ];

  for (final k in emiKeywords) {
    if (body.contains(k)) {
      return true;
    }
  }

  return false;
}

/* =========================================================
   TRANSACTIONS SCREEN
   ========================================================= */

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final Telephony telephony = Telephony.instance;

  List<LocalSms> messages = [];
  bool isLoading = true;

  Set<String> detectedBanks = {};
  String? selectedBank;
  bool showAccounts = false;

  @override
  void initState() {
    super.initState();
    loadSms();
  }

  String extractBankName(LocalSms msg) {
    final sender = (msg.address ?? '').toUpperCase();

    if (sender.contains('BOI')) return 'Bank of India';
    if (sender.contains('SBI')) return 'State Bank of India';
    if (sender.contains('HDFC')) return 'HDFC Bank';
    if (sender.contains('ICICI')) return 'ICICI Bank';
    if (sender.contains('AXIS')) return 'Axis Bank';
    if (sender.contains('KOTAK')) return 'Kotak Mahindra Bank';
    if (sender.contains('IDFC')) return 'IDFC First Bank';
    if (sender.contains('PNB')) return 'Punjab National Bank';
    if (sender.contains('CANARA')) return 'Canara Bank';
    if (sender.contains('UNION')) return 'Union Bank of India';
    if (sender.contains('INDIANBANK')) return 'Indian Bank';
    if (sender.contains('IOB')) return 'Indian Overseas Bank';
    if (sender.contains('CENTRAL')) return 'Central Bank of India';
    if (sender.contains('UCO')) return 'UCO Bank';
    if (sender.contains('YES')) return 'Yes Bank';
    if (sender.contains('RBL')) return 'RBL Bank';
    if (sender.contains('FEDERAL')) return 'Federal Bank';
    if (sender.contains('IDBI')) return 'IDBI Bank';
    if (sender.contains('HSBC')) return 'HSBC Bank';
    if (sender.contains('DBS')) return 'DBS Bank';
    if (sender.contains('DEUTSCHE')) return 'Deutsche Bank';
    if (sender.contains('STANDARD')) return 'Standard Chartered Bank';
    if (sender.contains('BARCLAYS')) return 'Barclays Bank';
    if (sender.contains('BNP')) return 'BNP Paribas Bank';

    // Ã°Å¸ÂÂ¦ Payments Banks
    if (sender.contains('IPPB') || sender.contains('IPB')) {
      return 'India Post Payments Bank';
    }
    if (sender.contains('PAYTM')) return 'Paytm Payments Bank';
    if (sender.contains('FINO')) return 'Fino Payments Bank';
    if (sender.contains('NSDL')) return 'NSDL Payments Bank';
    if (sender.contains('AIRTEL')) return 'Airtel Payments Bank';
    if (sender.contains('JIO')) return 'Jio Payments Bank';

    // Ã°Å¸ÂÂ¦ Small Finance Banks
    if (sender.contains('UJJIVAN')) return 'Ujjivan Small Finance Bank';
    if (sender.contains('EQUITAS')) return 'Equitas Small Finance Bank';
    if (sender.contains('SURYODAY')) return 'Suryoday Small Finance Bank';
    if (sender.contains('ESAF')) return 'ESAF Small Finance Bank';
    if (sender.contains('AU')) return 'AU Small Finance Bank';
    if (sender.contains('JANASMALL')) return 'Jana Small Finance Bank';
    if (sender.contains('CAPITAL')) return 'Capital Small Finance Bank';

    // Ã°Å¸ÂÂ¦ State / Co-operative Banks
    if (sender.contains('MAHARASHTRA')) return 'Bank of Maharashtra';
    if (sender.contains('KARNATAKA')) return 'Karnataka Bank';
    if (sender.contains('KARUR')) return 'Karur Vysya Bank';
    if (sender.contains('SARASWAT')) return 'Saraswat Co-operative Bank';
    if (sender.contains('SHAMRAO')) return 'Shamrao Vithal Co-operative Bank';
    if (sender.contains('TJSB')) return 'TJSB Sahakari Bank';
    if (sender.contains('SOUTHDIAN') || sender.contains('SIB')) {
      return 'South Indian Bank';
    }
    if (sender.contains('TAMILNAD')) return 'Tamilnad Mercantile Bank';
    if (sender.contains('JNK') || sender.contains('JKB')) {
      return 'Jammu & Kashmir Bank';
    }

    // Ã°Å¸Â§Â¾ Slice (card based NBFC)
    if (sender.contains('SLICE') || sender.contains('SLC')) return 'Slice';

    // fallback
    final parts = sender.split('-');
    if (parts.length >= 2) {
      return parts[1];
    }

    return sender;
  }

  bool isInRange(int? ts) {
    if (ts == null) return false;

    final d = DateTime.fromMillisecondsSinceEpoch(ts);
    final now = DateTime.now();

    if (currentFilter == FilterType.weekly) {
      return d.isAfter(now.subtract(const Duration(days: 7)));
    }

    final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
    return d.isAfter(threeMonthsAgo);
  }

  Future<void> loadSms() async {
    setState(() => isLoading = true);

    final ok = await telephony.requestSmsPermissions;
    if (ok != true) {
      setState(() => isLoading = false);
      return;
    }

    final smsBox = Hive.box('smsTransactionsBox');

    // READ FROM HIVE PERSISTED DATA INSTEAD OF PHONE INBOX!
    // This allows deleted SMS to still remain in the app
    final List<LocalSms> sms = [];
    for (var key in smsBox.keys) {
      sms.add(LocalSms(
        body: smsBox.get(key),
        date: int.tryParse(key.toString()) ?? 0,
        address:
            'HIVE-BANK', // extractBankName will fallback to body text parsing inside allTransactions if we needed it, but wait!
      ));
    }

    // Sort Newest to Oldest (DESC)
    sms.sort((a, b) => (b.date ?? 0).compareTo(a.date ?? 0));

    double debitSum = 0;
    double creditSum = 0;

    dailyDebitMap.clear();
    dailyCreditMap.clear();
    detectedBanks.clear();

    final List<LocalSms> filtered = [];

    for (var msg in sms) {
      if (!isInRange(msg.date)) continue;

      final parsed = parseTransactionSMS(msg.body ?? '');
      if (parsed == null) continue;

      // â­ EMI detection
      if (isEmiPayment(msg.body ?? '')) {
        if (parsed.isDebit) {
          var emiBox = Hive.box('emiBox');
          var historyBox = Hive.box('paymentHistory');
          var emiList = emiBox.values.toList();
          for (int i = 0; i < emiList.length; i++) {
            var emi = emiList[i];
            // ðŸ”¥ MATCH AMOUNT
            if (parsed.amount == emi['emi']) {
              // âœ… UPDATE EMI
              int remaining = emi['remainingMonths'];
              if (remaining > 0) {
                emi['remainingMonths'] = remaining - 1;
                emiBox.putAt(i, emi);
              }
              // âœ… SAVE HISTORY
              historyBox.add({
                "name": emi['name'],
                "amount": parsed.amount,
                "date": DateTime.fromMillisecondsSinceEpoch(msg.date ?? 0)
                    .toString(),
              });
              break;
            }
          }
        }
      }
      // Use the much more advanced body extractor since address might be missing in Hive
      final bankName = extractBankNameFromSMS(msg.body ?? '');
      if (bankName != 'Unknown Bank') {
        detectedBanks.add(bankName);
      }

      msg = LocalSms(body: msg.body, date: msg.date, address: bankName);

      final dateTime = DateTime.fromMillisecondsSinceEpoch(msg.date!);
      final day = DateTime(dateTime.year, dateTime.month, dateTime.day);

      if (parsed.isDebit) {
        debitSum += parsed.amount;
        dailyDebitMap[day] = (dailyDebitMap[day] ?? 0) + parsed.amount;
      } else {
        creditSum += parsed.amount;
        dailyCreditMap[day] = (dailyCreditMap[day] ?? 0) + parsed.amount;
      }

      filtered.add(msg);
    }

    setState(() {
      messages = filtered;
      totalDebit = debitSum;
      totalCredit = creditSum;
      globalTotalSpent = debitSum;
      isLoading = false;
    });
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1];
  }

  @override
  @override
  Widget build(BuildContext context) {
    final displayMessages = selectedBank == null
        ? messages
        : messages.where((msg) {
            final bank = msg.address;
            return bank == selectedBank;
          }).toList();

    final Map<String, List<LocalSms>> groupedMessages = {};

    for (var msg in displayMessages) {
      final date = DateTime.fromMillisecondsSinceEpoch(msg.date ?? 0);
      final key = "${_monthName(date.month)}, ${date.year}";
      groupedMessages.putIfAbsent(key, () => []);
      groupedMessages[key]!.add(msg);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Transaction',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        backgroundColor: const Color(0xFF0A3622),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                Scaffold.of(ctx).openEndDrawer();
              },
            ),
          )
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
                opacity: 0.6,
              ),
            ),
          ),
          SafeArea(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      // ACCOUNTS DROPDOWN SECTION
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Accounts",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0A3622)),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.3)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        showAccounts = !showAccounts;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            selectedBank ?? "Select your bank",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Icon(
                                              showAccounts
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              size: 24),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (showAccounts)
                                    Container(
                                      constraints:
                                          const BoxConstraints(maxHeight: 200),
                                      child: ListView(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics: const BouncingScrollPhysics(),
                                        children: [
                                          // "All Banks" option
                                          if (selectedBank != null)
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedBank = null;
                                                  showAccounts = false;
                                                });
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 10),
                                                child: const Text(
                                                    "Show All Banks",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic)),
                                              ),
                                            ),
                                          ...detectedBanks.map((bank) {
                                            bool isSelected =
                                                selectedBank == bank;
                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedBank = bank;
                                                  showAccounts = false;
                                                });
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 12),
                                                color: isSelected
                                                    ? Colors.grey.shade300
                                                    : Colors.transparent,
                                                child: Text(
                                                  bank,
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ),
                                            );
                                          }).toList()
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // TRANSACTIONS LIST
                      Expanded(
                        child: ListView(
                          padding:
                              const EdgeInsets.only(bottom: 80), // For FABs
                          children: groupedMessages.entries.map((entry) {
                            final month = entry.key;
                            final msgs = entry.value;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Text(
                                    month,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF0A3622),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ...msgs.map((msg) {
                                  final parsed =
                                      parseTransactionSMS(msg.body ?? '')!;
                                  final date =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          msg.date ?? 0);

                                  final color = parsed.isDebit
                                      ? const Color(0xFFEF5350)
                                      : const Color(0xFF66BB6A);
                                  final bgColor = parsed.isDebit
                                      ? const Color(0xFFFFEBEB)
                                      : const Color(0xFFE8F5E9);
                                  final sign = parsed.isDebit ? '-' : '+';
                                  final type =
                                      parsed.isDebit ? 'Debit' : 'Credit';
                                  final formattedDate =
                                      '${date.day}/${date.month}/${date.year}';

                                  final cleanName =
                                      MerchantCategorizer.getCleanName(
                                          msg.body ?? '');
                                  final catData =
                                      MerchantCategorizer.getCategoryAndIcon(
                                          msg.body ?? '',
                                          isDebit: parsed.isDebit);
                                  final catName = catData['category'];
                                  final IconData catIcon = catData['icon'];
                                  final Color catColor = catData['color'];

                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.05),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4)),
                                        ]),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(20),
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(24)),
                                            ),
                                            builder: (_) {
                                              bool applyGlobally = false;
                                              return StatefulBuilder(
                                                builder: (BuildContext context,
                                                    StateSetter setModalState) {
                                                  return SafeArea(
                                                    child:
                                                        DraggableScrollableSheet(
                                                      expand: false,
                                                      builder: (_,
                                                              controller) =>
                                                          SingleChildScrollView(
                                                        controller: controller,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(24),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Center(
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    catColor
                                                                        .withOpacity(
                                                                            0.15),
                                                                radius: 30,
                                                                child: Icon(
                                                                    catIcon,
                                                                    color:
                                                                        catColor,
                                                                    size: 30),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 16),
                                                            Center(
                                                              child: Text(
                                                                  cleanName,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          22,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color(
                                                                          0xFF1E002B))),
                                                            ),
                                                            const SizedBox(
                                                                height: 8),

                                                            Center(
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        6),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: catColor
                                                                      .withOpacity(
                                                                          0.1),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                ),
                                                                child: Text(
                                                                    catName,
                                                                    style: TextStyle(
                                                                        color:
                                                                            catColor,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            13)),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 24),

                                                            Text(
                                                              'Amount: $sign ₹${parsed.amount.toStringAsFixed(2)}',
                                                              style: TextStyle(
                                                                color: color,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 8),

                                                            Text(
                                                                'Type & Date: $type • $formattedDate',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),

                                                            const Divider(
                                                                height: 32),

                                                            const Text(
                                                                'Bank SMS Detail',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14)),
                                                            const SizedBox(
                                                                height: 8),

                                                            Text(msg.body ?? '',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    height: 1.4,
                                                                    color: Colors
                                                                        .black54)),

                                                            const SizedBox(
                                                                height: 30),

                                                            // ================= ML CATEGORY TRAINING WIDGET =================
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(16),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color(
                                                                    0xFFF9FAFB),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.3)),
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      const Icon(
                                                                          Icons
                                                                              .auto_awesome,
                                                                          color: Color(
                                                                              0xFFE8B923),
                                                                          size:
                                                                              18),
                                                                      const SizedBox(
                                                                          width:
                                                                              8),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          'Train AI: Categorize "$cleanName"',
                                                                          style: const TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 14,
                                                                              color: Color(0xFF1E002B)),
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          6),
                                                                  const Text(
                                                                      'If this transaction is in the wrong category, fix it here. You can optionally apply this globally.',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Colors.grey)),
                                                                  const SizedBox(
                                                                      height:
                                                                          12),
                                                                  CheckboxListTile(
                                                                    contentPadding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    controlAffinity:
                                                                        ListTileControlAffinity
                                                                            .leading,
                                                                    title: Text(
                                                                        'Apply to all future transactions for $cleanName',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w600)),
                                                                    value:
                                                                        applyGlobally,
                                                                    onChanged:
                                                                        (bool?
                                                                            value) {
                                                                      setModalState(
                                                                          () {
                                                                        applyGlobally =
                                                                            value ??
                                                                                false;
                                                                      });
                                                                    },
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          8),
                                                                  DropdownButtonFormField<
                                                                      String>(
                                                                    value: MerchantCategorizer
                                                                            .predefinedCategories
                                                                            .containsKey(catName)
                                                                        ? catName
                                                                        : null,
                                                                    hint: const Text(
                                                                        "Select new Category"),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      border: OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8)),
                                                                      contentPadding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              16,
                                                                          vertical:
                                                                              8),
                                                                    ),
                                                                    items: MerchantCategorizer
                                                                        .predefinedCategories
                                                                        .keys
                                                                        .map((String
                                                                            cName) {
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value:
                                                                            cName,
                                                                        child: Text(
                                                                            cName,
                                                                            style:
                                                                                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                                                      );
                                                                    }).toList(),
                                                                    onChanged:
                                                                        (String?
                                                                            newValue) async {
                                                                      if (newValue !=
                                                                          null) {
                                                                        await MerchantCategorizer.learnTransactionCategory(
                                                                            msg.body ??
                                                                                '',
                                                                            newValue);
                                                                        if (applyGlobally) {
                                                                          await MerchantCategorizer.learnMerchantCategory(
                                                                              cleanName,
                                                                              newValue);
                                                                        }
                                                                        if (context
                                                                            .mounted) {
                                                                          Navigator.pop(
                                                                              context); // Close bottom Sheet
                                                                          setState(
                                                                              () {}); // Trigger refresh on entire transactions list
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            SnackBar(
                                                                              content: Text(applyGlobally ? 'Saved category "$newValue" for $cleanName!' : 'Saved category "$newValue" for this transaction!'),
                                                                              backgroundColor: Colors.green,
                                                                            ),
                                                                          );
                                                                        }
                                                                      }
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 24),
                                                            SizedBox(
                                                              width: double.infinity,
                                                              child: OutlinedButton.icon(
                                                                onPressed: () async {
                                                                  bool? confirm = await showDialog<bool>(
                                                                    context: context,
                                                                    builder: (ctx) => AlertDialog(
                                                                      title: const Text('Delete Transaction?'),
                                                                      content: const Text('This will permanently remove this transaction from the app.'),
                                                                      actions: [
                                                                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCEL')),
                                                                        TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('DELETE', style: TextStyle(color: Colors.red))),
                                                                      ],
                                                                    )
                                                                  );
                                                                  
                                                                  if (confirm == true) {
                                                                    var box = Hive.box('smsTransactionsBox');
                                                                    await box.delete(msg.date.toString());
                                                                    if (context.mounted) {
                                                                       Navigator.pop(context); // Close bottomSheet
                                                                       loadSms(); // Refresh the list entirely
                                                                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaction deleted.', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
                                                                    }
                                                                  }
                                                                },
                                                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                                                label: const Text('Delete Transaction', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                                                style: OutlinedButton.styleFrom(
                                                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                                                  side: const BorderSide(color: Colors.red),
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 40),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 20),
                                          child: Row(
                                            children: [
                                              // SMART CATEGORY ICON
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: catColor
                                                      .withOpacity(0.15),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: Icon(catIcon,
                                                    color: catColor, size: 24),
                                              ),
                                              const SizedBox(width: 14),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // CLEAN MERCHANT NAME
                                                    Text(
                                                      cleanName,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize: 15,
                                                          color: Color(
                                                              0xFF1E002B)),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 6,
                                                                  vertical: 2),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: catColor
                                                                .withOpacity(
                                                                    0.1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          child: Text(catName,
                                                              style: TextStyle(
                                                                  color:
                                                                      catColor,
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(
                                                          '• $formattedDate',
                                                          style: TextStyle(
                                                              color: Colors.grey
                                                                  .shade600,
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                '$sign ₹${parsed.amount.toStringAsFixed(0)}',
                                                style: TextStyle(
                                                  color: color,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

// Add helper to replace the old extractBankName
String extractBankNameFromSMS(String body) {
  final b = body.toUpperCase();

  if (b.contains('IPPB') || b.contains('INDIA POST'))
    return 'India Post Payments Bank';
  if (b.contains('BANK OF INDIA') || b.contains('BOI') || b.contains('BOIIND'))
    return 'Bank of India';
  if (b.contains('SLICE') || b.contains('SLCEIT')) return 'Slice';
  if (b.contains('HDFC')) return 'HDFC Bank';
  if (b.contains('SBI') || b.contains('STATE BANK'))
    return 'State Bank of India';
  if (b.contains('ICICI')) return 'ICICI Bank';
  if (b.contains('AXIS')) return 'Axis Bank';
  if (b.contains('KOTAK')) return 'Kotak Mahindra Bank';
  if (b.contains('PNB') || b.contains('PUNJAB NATIONAL'))
    return 'Punjab National Bank';
  if (b.contains('CANARA')) return 'Canara Bank';
  if (b.contains('UNION BANK')) return 'Union Bank of India';
  if (b.contains('INDUSIND')) return 'IndusInd Bank';
  if (b.contains('YES BANK')) return 'Yes Bank';
  if (b.contains('IDFC')) return 'IDFC First Bank';
  if (b.contains('UCO')) return 'UCO Bank';
  if (b.contains('PAYTM')) return 'Paytm Payments Bank';

  return 'Unknown Bank';
}
