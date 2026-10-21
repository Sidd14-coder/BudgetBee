class CreditCardModel {
  String cardName;
  String last4Digits;
  double totalDue;
  double minDue;
  DateTime dueDate;

  CreditCardModel({
    required this.cardName,
    required this.last4Digits,
    required this.totalDue,
    required this.minDue,
    required this.dueDate,
  });

  // Convert to Map for Hive Storage
  Map<String, dynamic> toMap() {
    return {
      'cardName': cardName,
      'last4Digits': last4Digits,
      'totalDue': totalDue,
      'minDue': minDue,
      'dueDate': dueDate.toIso8601String(),
    };
  }

  // Parse from Hive Map
  factory CreditCardModel.fromMap(Map<dynamic, dynamic> map) {
    return CreditCardModel(
      cardName: map['cardName'] ?? 'Unknown Card',
      last4Digits: map['last4Digits'] ?? 'XXXX',
      totalDue: (map['totalDue'] ?? 0.0).toDouble(),
      minDue: (map['minDue'] ?? 0.0).toDouble(),
      dueDate: DateTime.tryParse(map['dueDate'] ?? '') ?? DateTime.now(),
    );
  }
}
