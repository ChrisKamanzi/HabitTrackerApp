import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Home/home.dart';
import '../Progress/progress_page.dart';
import 'settings_page.dart';

class account_page extends StatefulWidget {
  const account_page({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<account_page> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _userId;

  @override
  void initState() {
    super.initState();
    User? user = _auth.currentUser;
    if (user != null) {
      _userId = user.uid;
      _nameController.text = user.displayName ?? '';
      _emailController.text = user.email ?? '';
    }
  }

  Future<void> _updateAccount() async {
    String name = _nameController.text.trim();
    String newPassword = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isNotEmpty && newPassword != confirmPassword) {
      _showError("Passwords do not match");
      return;
    }

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Ask for current password to re-authenticate — you need to prompt the user for this
        String currentPassword = await _promptForCurrentPassword(); // custom function

        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email ?? '',
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);

        // Update name in Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'username': name,
        });

        // Optionally update password
        if (newPassword.isNotEmpty) {
          await user.updatePassword(newPassword);
        }

        await user.reload();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account updated successfully")),
        );
      }
    } catch (e) {
      _showError(e.toString());
      print(e);
    }
  }
  Future<String> _promptForCurrentPassword() async {
    String currentPassword = '';
    await showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text("Re-authenticate"),
          content: TextField(
            controller: controller,
            obscureText: true,
            decoration: InputDecoration(hintText: "Enter your current password"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                currentPassword = controller.text;
                Navigator.of(context).pop();
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
    return currentPassword;
  }


  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              // color: Color.fromRGBO(47, 47, 47, 1),
              fontFamily: 'Nonito',
              fontSize: 29),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(102, 102, 102, 1),
                    fontFamily: 'Nonito',
                    fontSize: 14),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey),
                ),
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        hintText: 'Enter your name',
                        contentPadding: EdgeInsets.all(10),
                        suffixIcon: Icon(Icons.edit)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Email', style: _labelTextStyle()),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey),
                ),
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      contentPadding: EdgeInsets.all(10),
                      suffixIcon: Icon(Icons.edit),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Password', style: _labelTextStyle()),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '********',
                      suffixIcon: Icon(Icons.visibility_off_sharp),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Confirm Password', style: _labelTextStyle()),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey),
                ),
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Confirm your password',
                      suffixIcon: Icon(Icons.visibility_off_sharp),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Ink(
                width: 400,
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                        colors: <Color>[
                          Color.fromRGBO(255, 164, 80, 1),
                          Color.fromRGBO(255, 92, 0, 1),
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.centerRight)),
                child: ElevatedButton(
                  onPressed: _updateAccount,
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    'Update',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(251, 251, 251, 1),
                        fontFamily: 'Nonito',
                        fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => homepage()));
                },
                icon: Icon(Icons.home),
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => progresss()));
                },
                icon: Icon(Icons.trending_up_outlined),
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => settings()));
                },
                icon: Icon(Icons.settings),
              ),
              label: '')
        ],
      ),
    );
  }

  TextStyle _labelTextStyle() {
    return TextStyle(
        fontWeight: FontWeight.w600,
        color: Color.fromRGBO(102, 102, 102, 1),
        fontFamily: 'Nonito',
        fontSize: 14);
  }
}
