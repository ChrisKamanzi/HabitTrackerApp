import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

import '../Home/home.dart';

class newPass extends StatelessWidget {
  const newPass({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _passwordController = TextEditingController();

    // Firebase Authentication instance
    final FirebaseAuth _auth = FirebaseAuth.instance;

    // Function to change password
    Future<void> changePassword(String newPassword) async {
      try {
        User? user = _auth.currentUser;

        if (user != null) {
          await user.updatePassword(newPassword);
          print("Password changed successfully!");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => homepage()),
          );
        }
      } catch (e) {
        print("Error updating password: $e");
      }
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 40, right: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter New Password',
              style: TextStyle(
                fontFamily: 'Nomito',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(102, 102, 102, 1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                height: 55,
              ),
            ),
            SizedBox(
              height: 40,
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    )),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50,
              width: 340,
              child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color.fromRGBO(255, 164, 80, 1),
                        Color.fromRGBO(255, 92, 0, 1),
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(5)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    String newPassword = _passwordController.text;

                    if (newPassword.isNotEmpty) {
                      // Call function to change password
                      changePassword(newPassword);
                    } else {
                      // Show error message if password is empty
                      print("Password cannot be empty.");
                    }
                  },
                  child: Text(
                    'Reset Your Password',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Nonito',
                      fontSize: 14,
                      color: Color.fromRGBO(251, 251, 251, 1),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
