class TransactionModel {
  final double amount;
  final DateTime date;
  final bool isCredit;
  final String description;
  final String bank;
  final double? balance;
  final String? reference;

  TransactionModel({
    required this.amount,
    required this.date,
    required this.isCredit,
    required this.description,
    required this.bank,
    this.balance,
    this.reference,
  });

  factory TransactionModel.fromSms({
    required double amount,
    required DateTime date,
    required bool isCredit,
    required String description,
    required String bank,
    double? balance,
    String? reference,
  }) {
    return TransactionModel(
      amount: amount,
      date: date,
      isCredit: isCredit,
      description: description,
      bank: bank,
      balance: balance,
      reference: reference,
    );
  }
}
