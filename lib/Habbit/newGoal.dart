import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class newGoal extends StatefulWidget {
  const newGoal({super.key});

  @override
  State<newGoal> createState() => _newGoalState();
}

class _newGoalState extends State<newGoal> {
  final TextEditingController _yourGoal = TextEditingController();
  String? _selected;
  String? habbitType;
  String? selectedHabit;
  List<String> habits = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchHabits();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NEW GOAL',
          style: TextStyle(
            fontFamily: 'Nonito',
            fontWeight: FontWeight.w800,
            fontSize: 30,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
        child: Form(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your Goal',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Nonito',
                fontSize: 24,
                color: Color.fromRGBO(47, 47, 47, 1),
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              height: 45,
              child: TextFormField(
                controller: _yourGoal,
                decoration: InputDecoration(
                    hintText: 'Enter your Goal',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),
            SizedBox(height: 15),
            /* Card(
              color: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: DropdownButton(
                  isExpanded: true,
                  items: [
                    DropdownMenuItem<String>(
                      value: '1 month(30 days)',
                      child: Text('1 month(30 days)'),
                    ),
                    DropdownMenuItem<String>(
                      value: '2 months(60 days)',
                      child: Text('2 months(60 days)'),
                    ),
                  ],
                  onChanged: (String? newVal) {
                    setState(() {
                      _selected = newVal;
                    });
                  },
                  value: _selected,
                ),
              ),
            ),
            */

            Card(
              color: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selected,
                    hint: Text('Select Period'),
                    onChanged: (String? newVal) {
                      setState(() {
                        _selected = newVal;
                      });
                    },

                    items: const [
                      DropdownMenuItem<String>(
                        value: '1 month(30 days)',
                        child: Text('1 month(30 days)'),
                      ),
                      DropdownMenuItem<String>(
                        value: '2 months(60 days)',
                        child: Text('2 months(60 days)'),
                      ),
                    ],
                    icon: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Card(
              color: Colors.transparent,
              elevation: 0,

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text('Target'),
                  value: habbitType,
                  onChanged: (String? newValue) {
                    setState(() {
                      habbitType = newValue;
                    }
                    );
                  },
                  items: const [
                    DropdownMenuItem<String>(
                        value: 'Everyday', child: Text('Everyday')),
                    DropdownMenuItem<String>(
                      value: 'Every week',
                      child: Text('Every week'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Every Months',
                      child: Text('Every Months'),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.grey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        items: habits.map((String habit) {
                          return DropdownMenuItem<String>(
                            value: habit,
                            child: Text(habit),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedHabit = newValue;
                          });
                        },
                        value: selectedHabit,
                        hint: Text('Choose a habit'),
                        icon: Icon(Icons.arrow_drop_down),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Ink(
              width: 328,
              height: 48,
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
                      borderRadius: BorderRadius.circular(4),
                    )),
                onPressed: () {
                  _saveToFirestore();
                },
                child: Text(
                  'Create New',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Nonito',
                      fontSize: 14,
                      color: Color.fromRGBO(251, 251, 251, 1)),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  void _saveToFirestore() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('Goal').add({
        'email': user.email,
        'Goal': _yourGoal.text,
        'period': _selected,
        'Habbit type': habbitType,
        'selecedHabit': selectedHabit,
      }).then((value) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('GOAL ADDED'),
            );
          },
        );
        print('Goal added');
        _clearInputs();
      }).catchError((error) {
        print('Failed to add goal: $error');
      });
    }
  }

  Future<void> fetchHabits() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Habits').get();
      final List<String> fetchedHabits =
          snapshot.docs.map((doc) => doc['Habit'] as String).toList();
      setState(() {
        habits = fetchedHabits;
      });
    } catch (e) {
      print('Error fetching habits: $e');
    }
  }

  void _clearInputs() {
    setState(() {
      _yourGoal.clear();
      _selected = null;
      habbitType = null;
      selectedHabit = null;
    });
  }
}
