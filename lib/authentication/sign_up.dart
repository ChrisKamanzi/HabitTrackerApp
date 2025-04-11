import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class sign_up extends StatefulWidget {
  const sign_up({super.key});

  @override
  State<sign_up> createState() => _sign_upState();
}

class _sign_upState extends State<sign_up> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  List<String> countries = [];
  String? selectedCountry;

  String? error_text;

  void validatePassword() {
    if (_passController.text != _confirmController.text) {
      error_text = 'Password dont match';
    } else {
      error_text = null;
    }
  }

  Future<void> signIn() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': _usernameController.text.trim(),
          'email': user.email,
          'createdAt': Timestamp.now(),
        });

        print("User data saved to Firestore!"); // Debugging log

        if (!mounted) return;

        context.go('/login');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    final response =
        await http.get(Uri.parse('https://restcountries.com/v3.1/all'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        countries = data
            .map((country) => country['name']['common'].toString())
            .toList();
        countries.sort();
      });
    } else {
      throw Exception('Failed to load countries');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(top: 70, left: 40, right: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign Up',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 44,
                  color: Color.fromRGBO(47, 47, 47, 1),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Name',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(102, 102, 102, 1),
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  )),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Email',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(102, 102, 102, 1),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Password',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(102, 102, 102, 1),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: TextField(
                  controller: _passController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Password Confirmation',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color.fromRGBO(102, 102, 102, 1),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: TextField(
                  onChanged: (value) => validatePassword(),
                  controller: _confirmController,
                  obscureText: true,
                  decoration: InputDecoration(
                    errorText: error_text,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Nationality',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color.fromRGBO(102, 102, 102, 1),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: DropdownButtonFormField<String>(
                  value: selectedCountry,
                  isExpanded: true,
                  items: countries.map((country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCountry = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: 1000,
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: <Color>[
                      Color.fromRGBO(255, 164, 80, 1),
                      Color.fromRGBO(255, 92, 0, 1),
                    ], begin: Alignment.bottomLeft, end: Alignment.centerRight),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ElevatedButton(
                      onPressed: () {
                        validatePassword();
                        if (error_text == null) {
                          signIn();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Password Dismatch')));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color.fromRGBO(251, 251, 251, 1),
                        ),
                      )),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Row(
                  children: [
                    Center(
                      child: Text(
                        'Already have an account?',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Nonito',
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(127, 127, 127, 1)),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(
                        'Log in',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Nonito',
                          fontWeight: FontWeight.w800,
                          color: Color.fromRGBO(255, 92, 0, 1),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
