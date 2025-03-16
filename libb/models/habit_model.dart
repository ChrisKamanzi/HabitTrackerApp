class Habit {
  final String Habitname;
  final String period;

  Habit({required this.Habitname, required this.period});

  factory Habit.fromFirestore(Map<String, dynamic> data) {
    return Habit(
      Habitname: data['Habit'] ?? '',
      period: data['period'] ?? '',
    );
  }
}
