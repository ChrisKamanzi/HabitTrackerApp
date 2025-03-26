import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'newPassword.dart';

class otp extends StatefulWidget {
  final String? email;

  const otp({super.key, this.email});

  @override
  State<otp> createState() => _OTPState();
}

class _OTPState extends State<otp> {
  EmailOTP myAuth = EmailOTP();
  String otpCode = "";

  @override
  void initState() {
    super.initState();
    if (widget.email != null) {
      myAuth.setConfig(
        appEmail: "admin@HabitTracker.com",
        appName: "Habit Tracker",
        userEmail: widget.email!,
        otpLength: 6,
        otpType: OTPType.digitsOnly,
      );
      sendOtp(); // Automatically send OTP when screen opens
    }
  }

  Future<void> sendOtp() async {
    if (widget.email == null) {
      print("Email is null. Cannot send OTP.");
      return;
    }

    bool otpSent = await myAuth.sendOTP();

    if (otpSent) {
      print("OTP sent successfully to ${widget.email}");
    } else {
      print("Failed to send OTP");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send OTP. Please try again.")),
      );
    }
  }

  Future<void> verifyOtp() async {
    otpCode = otpCode.trim(); // Ensure no extra spaces

    if (otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid 6-digit OTP.")),
      );
      return;
    }

    print("Entered OTP: $otpCode");

    bool isValid = await myAuth.verifyOTP(otp: otpCode);

    if (isValid) {
      print("OTP verified successfully!");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => newPass())//email: widget.email!, oobCode: otpCode,)),
      );
    } else {
      print("OTP verification failed!");
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
                'Enter the OTP code sent to your email',
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
              fieldWidth: 40,
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
                  onPressed: verifyOtp,
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
