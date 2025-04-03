import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'YourHabits.dart';
class habbit_page extends StatefulWidget {
  final DateTime selectedDate;
  habbit_page(
      {
    required this.selectedDate,
    super.key,
  }
  );

  @override
  State<habbit_page> createState() => _habbit_pageState();
}

class _habbit_pageState extends State<habbit_page> {
  @override
  TextEditingController _yourHabit = TextEditingController();
  String? _selected;
  String? habbitType;
  var selectedValue;

  late TextEditingController _HabitController;
  final CollectionReference habitsCollection =
      FirebaseFirestore.instance.collection('Habits');

  void deleteGoal(String docId) {
    habitsCollection.doc(docId).delete();
  }

  void initState() {
    super.initState();
    _selected = '1 month(30 days)';
    habbitType = 'Everyday';
  }

  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today Habit',
                      style: TextStyle(
                          fontFamily: 'Nonito',
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                         // color: textColor
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: habitsCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No habits found.'));
                }

                final theme = Theme.of(context);
                final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
                final backgroundColor = theme.cardColor; // Adapts to dark/light mode
                final completedColor = theme.brightness == Brightness.dark
                    ? Colors.green[900] // Dark green for dark mode
                    : Color.fromRGBO(237, 255, 244, 1); // Light green for light mode

                var everydayHabits = snapshot.data!.docs.where((document) {
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  return data['Habit type'] == 'Everyday';
                }).toList();

                if (everydayHabits.isEmpty) {
                  return Center(child: Text('No everyday habits found.'));
                }

                String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

                return ListView(
                  children: everydayHabits.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    Map<String, dynamic>? completedDays = data['completedDays'];
                    bool isCompleted = completedDays != null && completedDays.containsKey(today);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: 500,
                        height: 70,
                        child: Card(
                          color: isCompleted ? completedColor : backgroundColor, // Dynamic color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data['Habit'],
                                  style: TextStyle(
                                    fontFamily: 'Nonito',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: textColor, // Adaptive text color
                                  ),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isCompleted,
                                      onChanged: (bool? newValue) async {
                                        if (newValue != null) {
                                          Map<String, dynamic> updatedCompletedDays = Map.from(completedDays ?? {});

                                          if (newValue) {
                                            updatedCompletedDays[today] = true;
                                          } else {
                                             updatedCompletedDays.remove(today);
                                          }

                                          try {
                                            await habitsCollection.doc(document.id).update({
                                              'completedDays': updatedCompletedDays,
                                            });
                                          } catch (e) {
                                            print("Error updating habit: $e");
                                          }
                                        }
                                      },
                                      activeColor: theme.colorScheme.primary, // Adaptive check color
                                    ),

                                    PopupMenuButton(
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: Color.fromRGBO(102, 102, 102, 1),
                                      ),
                                      itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<int>>[
                                        PopupMenuItem<int>(
                                          value: 1,
                                          child: TextButton(
                                            onPressed: () {

                                              UpdateFirestore(
                                                document.id,
                                                _yourHabit.text.toString(),
                                                data['period'],
                                                data['Habbit type'],
                                              );
                                            },
                                            child: Text('Edit'),
                                          ),
                                        ),
                                        PopupMenuItem<int>(
                                          value: 2,
                                          child: TextButton(
                                            onPressed: () {
                                              deleteGoal(document.id);
                                            },
                                            child: Text('Delete'),
                                          ),
                                        ),
                                      ],
                                    )                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),

          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
  Future NewGoal() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Create New Habit',
                style: TextStyle(
                  fontFamily: 'Nonito',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                ),
              )
            ],
          ),
          content: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Your Habit',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Nonito',
                    fontSize: 14,
                    color: Color.fromRGBO(47, 47, 47, 1),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _yourHabit,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Text(
                      'Period',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nonito',
                        fontSize: 14,
                        color: Color.fromRGBO(47, 47, 47, 1),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 50,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
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
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Habbit Type',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Nonito',
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(47, 47, 47, 1)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: DropdownButton<String>(

                        value: habbitType,
                        onChanged: (String? newValue) {
                          setState(() {
                            habbitType = newValue;
                          });
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
                    )
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
                      Navigator.of(context).pop();
                      Navigator.pop(context);
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
            ),
          ),
        ),
      );

  void _saveToFirestore() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('Habits').add({
        'email': user.email,
        'Habit': _yourHabit.text,
        'period': _selected,
        'Habit type': habbitType,
      }).then((value) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('GOAL ADDED'),
            );
          },
        );
        print('HABIT added');
      }).catchError((error) {
        print('Failed to add goal: $error');
      });
    }
  }

  Future Editd() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Create New Habit',
                style: TextStyle(
                  fontFamily: 'Nonito',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                ),
              )
            ],
          ),
          content: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Your Habit',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Nonito',
                    fontSize: 14,
                    color: Color.fromRGBO(47, 47, 47, 1),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _yourHabit,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Text(
                      'Period',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nonito',
                        fontSize: 14,
                        color: Color.fromRGBO(47, 47, 47, 1),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 50,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
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
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Habbit Type',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Nonito',
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(47, 47, 47, 1)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: DropdownButton<String>(

                        value: habbitType,
                        onChanged: (String? newValue) {
                          setState(() {
                            habbitType = newValue;
                          });
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
                    )
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
                      Navigator.of(context).pop();
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
            ),
          ),
        ),
      );

  Future<void> _updateGoal(String docId, String newGoal, String? newPeriod,
      String? newHabbitType) async {
    try {
      await FirebaseFirestore.instance.collection('Habits').doc(docId).update({
        'Habit': newGoal,
        'period': newPeriod,
        'Habbit type': newHabbitType,
      });
      print("Goal updated successfully!");
    } catch (error) {
      print("Error updating goal: $error");
    }
  }

  Future<void> UpdateFirestore(String docId, String currentGoal,
      String? currentPeriod, String? currentHabbitType) {
    TextEditingController _HabitController =
        TextEditingController(text: currentGoal);
    String? selectedPeriod = currentPeriod;
    String? selectedHabbitType = currentHabbitType;

    return showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'EDIT HABIT',
                style: TextStyle(
                  fontFamily: 'Nonito',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
              )
            ],
          ),
          content: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Your Habit',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Nonito',
                    fontSize: 14,
                    color: Color.fromRGBO(47, 47, 47, 1),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _HabitController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Text(
                      'Period',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nonito',
                        fontSize: 14,
                        color: Color.fromRGBO(47, 47, 47, 1),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
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
                              selectedPeriod = newVal;
                            });
                          },
                          value: selectedPeriod,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Habit Type',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Nonito',
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(47, 47, 47, 1),
                      ),
                    ),
                    SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: DropdownButton<String>(
                        value: selectedHabbitType,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedHabbitType = newValue;
                          });
                        },
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'Everyday',
                            child: Text('Everyday'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Every week',
                            child: Text('Every week'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Every Months',
                            child: Text('Every Months'),
                          ),
                        ],
                      ),
                    )
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
                      ),
                    ),
                    onPressed: () async {
                      await _updateGoal(docId, _HabitController.text,
                          selectedPeriod, selectedHabbitType);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'UPDATE',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Nonito',
                        fontSize: 14,
                        color: Color.fromRGBO(251, 251, 251, 1),
                      ),
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
