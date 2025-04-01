import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/habit_model.dart';

class EverydayHabitsNotifier extends StateNotifier<List<Habit>> {
  EverydayHabitsNotifier() : super([]);

  Future<void> fetchEverydayHabits() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Habits')
          .where('period', isEqualTo: 'Everyday')
          .get();
      state = snapshot.docs
          .map((doc) => Habit.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print(error);
    }
  }
}

final everydayHabitsProvider =
    StateNotifierProvider<EverydayHabitsNotifier, List<Habit>>((ref) {
  return EverydayHabitsNotifier();
});
