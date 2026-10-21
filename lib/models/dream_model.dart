class DreamModel {
  String id;
  String name;
  double targetAmount;
  double savedAmount;
  DateTime deadline;

  DreamModel({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    required this.deadline,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'deadline': deadline.toIso8601String(),
    };
  }

  factory DreamModel.fromMap(Map<dynamic, dynamic> map) {
    return DreamModel(
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: map['name'] ?? 'Untitled Dream',
      targetAmount: (map['targetAmount'] ?? 0.0).toDouble(),
      savedAmount: (map['savedAmount'] ?? 0.0).toDouble(),
      deadline: DateTime.tryParse(map['deadline'] ?? '') ?? DateTime.now().add(const Duration(days: 30)),
    );
  }
}
