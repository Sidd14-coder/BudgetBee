import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/subscription_model.dart';
import '../models/transaction_model.dart';

class SubscriptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get userId => _auth.currentUser?.uid;

  // Collection Reference
  CollectionReference get _subsCollection {
    if (userId == null) throw Exception("User not logged in");
    return _firestore.collection('users').doc(userId).collection('subscriptions');
  }

  // Get all Subscriptions Stream
  Stream<List<Subscription>> getSubscriptions() {
    return _subsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Subscription.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  // Add a new Subscription
  Future<void> addSubscription(Subscription sub) async {
    await _subsCollection.add(sub.toMap());
  }

  // Update Subscription
  Future<void> updateSubscription(Subscription sub) async {
    await _subsCollection.doc(sub.id).update(sub.toMap());
  }

  // Delete Subscription
  Future<void> deleteSubscription(String id) async {
    await _subsCollection.doc(id).delete();
  }

  // Mark as Paid for the cycle (updates next due date depending on cycle)
  Future<void> markAsPaid(Subscription sub) async {
    DateTime next;
    if (sub.billingCycle == 'Monthly') {
      next = DateTime(sub.nextDueDate.year, sub.nextDueDate.month + 1, sub.nextDueDate.day);
    } else if (sub.billingCycle == 'Yearly') {
      next = DateTime(sub.nextDueDate.year + 1, sub.nextDueDate.month, sub.nextDueDate.day);
    } else if (sub.billingCycle == 'Weekly') {
      next = sub.nextDueDate.add(const Duration(days: 7));
    } else {
      next = DateTime(sub.nextDueDate.year, sub.nextDueDate.month + 1, sub.nextDueDate.day);
    }
    
    // Log as transaction as well
    if (userId != null) {
      await _firestore.collection('users').doc(userId).collection('transactions').add({
        'title': '${sub.name} Subscription',
        'amount': sub.amount,
        'category': sub.category,
        'date': Timestamp.fromDate(DateTime.now()),
        'type': 'Expense',
        'note': 'Auto-logged subscription payment'
      });
    }

    sub.nextDueDate = next;
    await updateSubscription(sub);
  }
}
