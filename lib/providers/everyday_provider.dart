import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/habit_model.dart';

class EverydayProvider extends ChangeNotifier {
  List<Habit> _everydayHabits = [];

  List<Habit> get everydayHabits => _everydayHabits;

  Future<void> FetchEveryDay() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(
          'Habits').where('period', isEqualTo: 'Everyday').get();
      _everydayHabits = snapshot.docs
          .map((doc) => Habit.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}