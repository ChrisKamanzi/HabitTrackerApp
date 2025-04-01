import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forgot_password.dart';
import 'package:go_router/go_router.dart';
import 'sign_up.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _LoginState();
}

class _LoginState extends State<login> {
  bool _isChecked = false;
  bool _isLoading = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  Future<void> Login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passController.text.trim());

      if (_isChecked) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', userCredential.user?.email ?? '');
        print('saved');
      }
      context.go('/homepage');
    } catch (e) {
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText(
                      'Login',
                      textStyle: TextStyle(
                        fontFamily: 'Nunito', // Fixed the font name typo
                        fontSize: 44,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 30,
                ),
                Text(
                  'Email',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    fontFamily: 'Nonito',
                    color: Color.fromRGBO(102, 102, 102, 1),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        )),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Password',
                  style: TextStyle(
                    fontFamily: 'Nonito',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(102, 102, 102, 1),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: _passController,
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        )),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                        value: _isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        }),
                    Text(
                      'Remember Me',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          fontFamily: 'Nonito',
                          color: Color.fromRGBO(127, 127, 127, 1)),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => forgotPassword()));
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                              fontFamily: 'Nonito',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(255, 92, 0, 1)),
                        ))
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                _isLoading // Show CircularProgressIndicator if loading
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: 400,
                        height: 50,
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
                                    borderRadius: BorderRadius.circular(4)),
                              ),
                              onPressed: Login,
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Nonito',
                                    color: Color.fromRGBO(251, 251, 251, 1)),
                              )),
                        ),
                      ),
                SizedBox(height: 40),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Row(
                      children: [
                        Text(
                          'You dont have an account:?',
                          style: TextStyle(
                            fontFamily: 'Nonito',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(127, 127, 127, 1),
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go('/signUp'),
                         child: Text( 'Sign Up',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Nonito',
                              fontWeight: FontWeight.w800,
                              color: Color.fromRGBO(255, 92, 0, 1)),
                        ) ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
