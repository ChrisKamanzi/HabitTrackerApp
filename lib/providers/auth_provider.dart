import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false);

  Future<void> login(String email, String password, bool rememberMe) async {
    state = true; // Start loading

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (rememberMe) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', userCredential.user?.email ?? '');
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('isLoggedIn');
        await prefs.remove('userEmail');
      }
    } catch (e) {
      print("Login Failed: $e");
    } finally {
      state = false; // Stop loading
    }
  }
}

// Provider for authentication state
final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});

// Provider for "Remember Me" checkbox
final rememberMeProvider = StateProvider<bool>((ref) => false);
