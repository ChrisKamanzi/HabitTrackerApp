import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../Home/home.dart';


class newPass extends StatelessWidget {
  const newPass({super.key});

  @override
  Widget build(BuildContext context) {
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
                height: 50,
              ),
            ),
            OtpTextField(
              fieldWidth: 55,
              numberOfFields: 5,
              borderColor: Colors.grey,
              showFieldAsBox: true,
              onSubmit: (String verification_code) {},
              onCodeChanged: (String code) {},
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50,
              width: 340,
              child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: <Color>[
                  Color.fromRGBO(255, 164, 80, 1),
                  Color.fromRGBO(255, 92, 0, 1),
                ],
                    begin: Alignment.bottomLeft,
                      end: Alignment.centerRight
                    ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                        shadowColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        )),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => homepage()));
                    },
                    child: Text(
                      'Reset Your Password',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Nonito',
                        fontSize: 14,
                        color: Color.fromRGBO(251, 251,251,1)
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
