import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserNotifier extends StateNotifier<String?> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserNotifier() : super(null) {
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(user.uid).get();
      state = userDoc['username'] as String?;
    }
  }

  Future<void> refreshUsername() async {
    await _fetchUsername();
  }
}

final userProvider = StateNotifierProvider<UserNotifier, String?>((ref) {
  return UserNotifier();
});
