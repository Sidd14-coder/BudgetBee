import '../models/emi_model.dart';

List<EmiModel> emiList = [];

double get totalEmi {
  double sum = 0;
  for (var e in emiList) {
    sum += e.monthlyEmi;
  }
  return sum;
}
