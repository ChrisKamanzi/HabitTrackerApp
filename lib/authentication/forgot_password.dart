import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_otp/email_otp.dart';
import 'package:go_router/go_router.dart';

class forgotPassword extends StatefulWidget {
  const forgotPassword({super.key});

  @override
  _forgotPasswordState createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  TextEditingController _emailController = TextEditingController();
  EmailOTP otpNumber = EmailOTP();

  Future<void> sendOTP() async {
    String email = _emailController.text.trim();
    otpNumber.setConfig(
      appName: "Habit Tracker",
      appEmail: "habbitTracker@example.com",
      otpLength: 6,
      otpType: OTPType.digitsOnly,
      userEmail: email
    );

    bool result = await otpNumber.sendOTP();
    if (result) {
      print('OTP sent successfully to $email');
    } else {
      print('Failed to send OTP');
    }
  }
  String email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, top: 100, right: 30),
          child: Column(
            children: [
              Text(
                'Enter your email below, we will send instructions to reset your password',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color.fromRGBO(102, 102, 102, 1),
                ),
              ),
              SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: 700,
                height: 50,
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color.fromRGBO(255, 164, 80, 1),
                        Color.fromRGBO(255, 92, 0, 1),
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                       await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
                      context.go('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Nunito',
                        color: Color.fromRGBO(251, 251, 251, 1),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
