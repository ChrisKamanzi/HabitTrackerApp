import 'dart:convert';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'newPassword.dart';

class otp extends StatefulWidget {
  final String email;

  const otp({super.key, required this.email});

  @override
  State<otp> createState() => otpState();
}

class otpState extends State<otp> {
  EmailOTP myAuth = EmailOTP();
  String otpCode = "";

  Future<void> verifyOtp() async {
    if (otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a 6-digit OTP")),
      );
      return;
    }

    bool isValid = await myAuth.verifyOTP(
      otp: otpCode,
    );

    if (isValid) {
      print("OTP Success ");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => newPass()),
      );
    } else {
      print("OTP failed ");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 40, top: 100, right: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Enter OTP code we’ve sent to your email',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color.fromRGBO(102, 102, 102, 1),
                ),
              ),
            ),
            SizedBox(height: 40),
            OtpTextField(
              fieldWidth: 45,
              numberOfFields: 6,
              borderColor: Colors.grey,
              showFieldAsBox: true,
              onCodeChanged: (String code) {
                setState(() {
                  otpCode = code;
                });
              },
              onSubmit: (String verificationCode) {
                setState(() {
                  otpCode = verificationCode;
                });
                verifyOtp();
              },
            ),
            SizedBox(height: 40),
            Ink(
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
              child: SizedBox(
                height: 50,
                width: 340,
                child: ElevatedButton(
                  onPressed: () {
                    verifyOtp();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Nunito',
                      color: Colors.white,
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
