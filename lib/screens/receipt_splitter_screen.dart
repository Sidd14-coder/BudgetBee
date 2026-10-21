import 'package:flutter/material.dart';
import '../../screens/custom/add_transaction_screen.dart';
import 'package:intl/intl.dart';

class ReceiptSplitterScreen extends StatefulWidget {
  final Map<String, dynamic> receiptData;

  const ReceiptSplitterScreen({super.key, required this.receiptData});

  @override
  State<ReceiptSplitterScreen> createState() => _ReceiptSplitterScreenState();
}

class _ReceiptSplitterScreenState extends State<ReceiptSplitterScreen> {
  List<Map<String, dynamic>> _items = [];
  double _totalAmount = 0.0;
  String _merchant = "";
  String _category = "";

  @override
  void initState() {
    super.initState();
    _parseData();
  }

  void _parseData() {
    _merchant = widget.receiptData['merchant'] ?? "Unknown Merchant";
    _category = widget.receiptData['category'] ?? "Others";
    
    // Using the original OCR amount if available
    var tAmount = widget.receiptData['total_amount'] ?? widget.receiptData['amount'];
    _totalAmount = (tAmount is num) ? tAmount.toDouble() : double.tryParse(tAmount.toString()) ?? 0.0;

    final rawItems = widget.receiptData['items'];
    if (rawItems is List) {
      _items = rawItems.map<Map<String, dynamic>>((item) {
        double p = 0.0;
        if (item['price'] is num) {
          p = (item['price'] as num).toDouble();
        } else if (item['price'] != null) {
          p = double.tryParse(item['price'].toString()) ?? 0.0;
        }
        return {
          "name": item['name']?.toString() ?? "Item",
          "price": p,
          "selected": true, // Default: you paid for everything
        };
      }).toList();
    }
  }

  double get _myShare {
    double sum = 0;
    for (var item in _items) {
      if (item['selected'] == true) {
        sum += item['price'];
      }
    }
    
    // Add proportional tax/tips
    double detectedSubtotal = 0;
    for (var item in _items) {
      detectedSubtotal += item['price'];
    }
    
    if (detectedSubtotal > 0 && _totalAmount > detectedSubtotal) {
      double taxAndTips = _totalAmount - detectedSubtotal;
      double myProportion = sum / detectedSubtotal;
      sum += (taxAndTips * myProportion);
    }
    
    return sum;
  }

  final _currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('🧾 Exact-Share Splitter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0A3622),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _items.isEmpty 
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                const Text("AI couldn't find individual items.", style: TextStyle(fontSize: 18, color: Colors.black54)),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A3622)),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddTransactionScreen(
                          initialAmount: _totalAmount > 0 ? _totalAmount.toString() : null,
                          initialDesc: _merchant,
                          initialCategory: _category,
                        ),
                      ),
                    );
                  },
                  child: const Text("Log Full Total Instead", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          )
        : Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    Text(_merchant, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0A3622))),
                    const SizedBox(height: 8),
                    const Text("Select only the items you ate/bought. AI will automatically calculate proportional tax & tips.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return CheckboxListTile(
                      activeColor: const Color(0xFF0A3622),
                      title: Text(item['name'], style: TextStyle(fontSize: 16, fontWeight: item['selected'] ? FontWeight.bold : FontWeight.normal, color: item['selected'] ? Colors.black : Colors.grey)),
                      subtitle: Text(_currency.format(item['price'])),
                      value: item['selected'],
                      onChanged: (val) {
                        setState(() {
                          item['selected'] = val;
                        });
                      },
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Your exact share:", style: TextStyle(fontSize: 16, color: Colors.black54)),
                          Text(_currency.format(_myShare), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF0A3622))),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A3622),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () {
                            // Proceed to add transaction with the exact share
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddTransactionScreen(
                                  initialAmount: _myShare.toStringAsFixed(2),
                                  initialDesc: _merchant,
                                  initialCategory: _category,
                                ),
                              ),
                            );
                          },
                          child: const Text("Log My Share", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
    );
  }
}
