import 'dart:io';
import 'package:flutter/material.dart';
import '../services/ocr_service.dart';
import '../screens/custom/add_transaction_screen.dart';
import '../screens/receipt_splitter_screen.dart';

class ScanningOverlayScreen extends StatefulWidget {
  final File imageFile;

  const ScanningOverlayScreen({super.key, required this.imageFile});

  @override
  State<ScanningOverlayScreen> createState() => _ScanningOverlayScreenState();
}

class _ScanningOverlayScreenState extends State<ScanningOverlayScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _laserAnimation;

  final List<String> _loadingTexts = [
    "Initializing BudgetBee Vision AI...",
    "Scanning document grid...",
    "Extracting line items and numbers...",
    "Cross-referencing merchants...",
    "Finalizing classification...",
  ];
  int _textIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _laserAnimation = Tween<double>(begin: 0.05, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _cycleText();
    _processReceipt();
  }

  Future<void> _cycleText() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 1200));
      if (mounted) {
        setState(() {
          _textIndex = (_textIndex + 1) % _loadingTexts.length;
        });
      }
    }
  }

  Future<void> _processReceipt() async {
    final startTime = DateTime.now();

    Map<String, dynamic>? extractedData;
    try {
      extractedData = await OCRService.scanReceipt(widget.imageFile);
    } catch (e) {
      // handled below
    }

    final elapsed = DateTime.now().difference(startTime);
    // Force at least 4 seconds of animation for maximum "Shock Factor"
    if (elapsed.inSeconds < 4) {
      await Future.delayed(Duration(seconds: 4 - elapsed.inSeconds));
    }

    if (!mounted) return;

    if (extractedData != null) {
      String amount = extractedData['amount']?.toString() ?? "";
      String merchant = extractedData['merchant'] ?? "";
      String category = extractedData['category'] ?? "Select Category";

      const validCategories = [
        "Food", "Health", "Grocery", "Bills", "Education", "Fuel", 
        "Gadgets", "Shopping", "Travel", "Misc", "Others"
      ];
      if (!validCategories.contains(category)) {
        category = "Others";
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ReceiptSplitterScreen(receiptData: extractedData!),
        ),
      );
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vision AI couldn't extract text from receipt.")),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
              child: Image.file(
                widget.imageFile,
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Technical Overlay Grid
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(),
            ),
          ),

          // Animated Laser
          AnimatedBuilder(
            animation: _laserAnimation,
            builder: (context, child) {
              return Positioned(
                top: MediaQuery.of(context).size.height * _laserAnimation.value,
                left: 0,
                right: 0,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00FF87),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00FF87).withOpacity(0.8),
                        blurRadius: 20,
                        spreadRadius: 10,
                      )
                    ],
                  ),
                ),
              );
            },
          ),

          // Bottom Scanning Status
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF00FF87).withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FF87).withOpacity(0.2),
                    blurRadius: 20,
                  )
                ]
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.document_scanner, color: Color(0xFF00FF87), size: 40),
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _loadingTexts[_textIndex],
                      key: ValueKey<int>(_textIndex),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        color: Color(0xFF00FF87),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    backgroundColor: Colors.white24,
                    color: const Color(0xFF00FF87),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FF87).withOpacity(0.15)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
