class EmiModel {
  String name;
  double loanAmount;
  double monthlyEmi;
  int tenure;
  int remainingMonths;
  int paidMonths;
  DateTime nextDue;

  EmiModel({
    required this.name,
    required this.loanAmount,
    required this.monthlyEmi,
    required this.tenure,
    required this.remainingMonths,
    required this.paidMonths,
    required this.nextDue,
  });
}
