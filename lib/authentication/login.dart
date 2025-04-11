import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'forgot_password.dart';
import 'sign_up.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class login extends ConsumerStatefulWidget {
  const login({super.key});

  @override
  ConsumerState<login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');
    String? savedEmail = prefs.getString('userEmail');

    if (isLoggedIn == true && savedEmail != null) {
      _emailController.text = savedEmail;
      ref.read(rememberMeProvider.notifier).state = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider);
    final isChecked = ref.watch(rememberMeProvider);

    Future<void> login(String email, String password, bool rememberMe) async {
      try {
        final auth = FirebaseAuth.instance;
        await auth.signInWithEmailAndPassword(email: email, password: password);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (rememberMe) {
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userEmail', email);
        } else {
          await prefs.remove('isLoggedIn');
          await prefs.remove('userEmail');
        }
      } on FirebaseAuthException catch (e) {
        throw Exception(e);
      } catch (e) {
        throw Exception("An unexpected error occurred.");
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: SingleChildScrollView(
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
                        fontFamily: 'Nunito',
                        fontSize: 44,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  'Email',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    fontFamily: 'Nonito',
                    color: Color.fromRGBO(102, 102, 102, 1),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
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
                TextField(
                  controller: _passController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        ref.read(rememberMeProvider.notifier).state = value!;
                      },
                    ),
                    Text(
                      'Remember Me',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        fontFamily: 'Nonito',
                        color: Color.fromRGBO(127, 127, 127, 1),
                      ),
                    ),
                    SizedBox(width: 30),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => forgotPassword()),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontFamily: 'Nonito',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(255, 92, 0, 1),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30),
                isLoading
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
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            onPressed: () async {
                              try {
                                // Start loading
                                ref.read(authProvider.notifier).state = true;

                                // Perform login
                                await login(
                                  _emailController.text.trim(),
                                  _passController.text.trim(),
                                  isChecked,
                                );

                                // Navigate only if login succeeded
                                context.go('/homepage');
                              } catch (e) {
                                // Show a snackbar with error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      e.toString().replaceAll('Exception: ', ''),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                // Stop loading
                                ref.read(authProvider.notifier).state = false;
                              }
                            },

                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Nonito',
                                color: Color.fromRGBO(251, 251, 251, 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: 40),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("You don’t have an account?"),
                      TextButton(
                        onPressed: () => context.go('/signUp'),
                        child: Text('Sign Up'),
                      ),
                    ],
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
