import 'package:cloud_firestore/cloud_firestore.dart';

class Subscription {
  String id;
  String name;
  double amount;
  String category;
  DateTime nextDueDate;
  String billingCycle; // "Monthly", "Yearly", "Weekly"
  bool isActive;
  bool isAutoDetected;

  Subscription({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.nextDueDate,
    required this.billingCycle,
    this.isActive = true,
    this.isAutoDetected = false,
  });

  factory Subscription.fromMap(Map<String, dynamic> data, String id) {
    return Subscription(
      id: id,
      name: data['name'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      category: data['category'] ?? 'Subscriptions',
      nextDueDate: (data['nextDueDate'] as Timestamp).toDate(),
      billingCycle: data['billingCycle'] ?? 'Monthly',
      isActive: data['isActive'] ?? true,
      isAutoDetected: data['isAutoDetected'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'category': category,
      'nextDueDate': Timestamp.fromDate(nextDueDate),
      'billingCycle': billingCycle,
      'isActive': isActive,
      'isAutoDetected': isAutoDetected,
    };
  }
}
