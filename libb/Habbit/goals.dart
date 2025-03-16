import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'newGoal.dart';

class goal extends StatefulWidget {
  const goal({super.key});

  @override
  State<goal> createState() => _goalState();
}

class _goalState extends State<goal> {
  TextEditingController _yourGoal = TextEditingController();
  String? _selected;
  String? habbitType;
  var selectedValue;

  void initState() {
    super.initState();
    _selected = '1 month';
    habbitType = 'Everyday';
  }

  final CollectionReference goalCollection =
      FirebaseFirestore.instance.collection('Goal');

  void deleteGoal(String docID) {
    goalCollection.doc(docID).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            'Your Goals',
            style: TextStyle(
                fontFamily: 'Nonito',
                fontSize: 30,
                fontWeight: FontWeight.w800),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: 200,
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: Colors.grey, width: 1))),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      elevation: MaterialStateProperty.all<double>(0)),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => newGoal()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.add,
                        size: 25,
                        weight: 20,
                        color: Colors.deepOrange[400],
                      ),
                      Text(
                        ' ADD NEW',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: Colors.deepOrange[400],
                          fontFamily: 'Nonito',
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Goal').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> goalSnapshot) {
                if (goalSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!goalSnapshot.hasData || goalSnapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No goals found"));
                }

                return ListView(
                  children: goalSnapshot.data!.docs.map((goalDoc) {
                    var goalData = goalDoc.data() as Map<String, dynamic>?;
                    if (goalData == null ||
                        !goalData.containsKey('selecedHabit')) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("No habit assigned for this goal"),
                      );
                    }

                    String goalTitle = goalData['Goal'] ?? "No Title";
                    String? selectedHabit = goalData['selecedHabit'];

                    if (selectedHabit == null || selectedHabit.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("No habit assigned for this goal"),
                      );
                    }

                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Habits')
                          .where('Habit', isEqualTo: selectedHabit)
                          .snapshots(),
                      builder: (context, habitSnapshot) {
                        if (habitSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!habitSnapshot.hasData ||
                            habitSnapshot.data!.docs.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child:
                                Text("Habit data not found for $selectedHabit"),
                          );
                        }

                        var habitData = habitSnapshot.data!.docs.first.data()
                            as Map<String, dynamic>?;
                        if (habitData == null ||
                            !habitData.containsKey('completedDays')) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "Invalid habit data",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Nonito',
                                  fontSize: 10,
                                  color: Colors.orange),
                            ),
                          );
                        }

                        Map<String, dynamic> completedDaysMap =
                            habitData['completedDays'] ?? {};
                        List<String> completedDates =
                            completedDaysMap.keys.toList();

                        String today =
                            DateFormat('yyyy-MM-dd').format(DateTime.now());

                        bool isCompletedToday =
                            completedDaysMap.containsKey(today);

                        DateTime now = DateTime.now();
                        DateTime thirtyDaysAgo =
                            now.subtract(Duration(days: 30));

                        int completedDays = completedDates
                            .map((date) =>
                                DateTime.tryParse(date) ?? DateTime(2000))
                            .where((date) => date.isAfter(thirtyDaysAgo))
                            .length;

                        double progress = completedDays / 30;

                        return Padding(
                          padding:
                              EdgeInsets.only(left: 15, right: 15, top: 10),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(goalTitle,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  SizedBox(height: 5),
                                  Container(
                                    width: 370,
                                    height: 20,
                                    child: LinearProgressIndicator(
                                      value: progress.isFinite ? progress : 0.0,
                                      borderRadius: BorderRadius.circular(10),
                                      backgroundColor:
                                          Color.fromRGBO(231, 231, 231, 1),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color.fromRGBO(255, 92, 0, 1)),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Completed $completedDays out of 30 days",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Nonito',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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

  Future openDialogue() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit',
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
                  'Your Goal',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Nonito',
                    fontSize: 14,
                    color: Color.fromRGBO(47, 47, 47, 1),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Finish 5 Philosophy Books',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                SizedBox(height: 15),
                Text(
                  'Habbit Name',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Nonito',
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(47, 47, 47, 1),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Read Philosophy ',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                SizedBox(
                  height: 20,
                ),
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
                              value: '1 month',
                              child: Text('1 month'),
                            ),
                            DropdownMenuItem<String>(
                              value: '2 months',
                              child: Text('2 months'),
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
                    onPressed: () {},
                    child: Text(
                      'UPDATE',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Nonito',
                          fontSize: 14,
                          color: Color.fromRGBO(251, 251, 251, 1)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Ink(
                  width: 328,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                      close();
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Nonito',
                          fontSize: 14,
                          color: Colors.black),
                    ),
                  ),
                )
              ],
            )),
          ));

  Future close() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Container(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close)),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.delete_outline,
                  size: 80,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Are you sure want to delete?',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      fontFamily: 'Nonito',
                      color: Colors.black),
                ),
                SizedBox(
                  height: 30,
                ),
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
                    onPressed: () async {
                      await sure();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'DELETE',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Nonito',
                          fontSize: 14,
                          color: Color.fromRGBO(251, 251, 251, 1)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Ink(
                  width: 328,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Nonito',
                          fontSize: 14,
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ));

  Future sure() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.delete_outline,
                  size: 50,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'List has been deleted',
                  style: TextStyle(
                      fontFamily: 'Nonito',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(47, 47, 47, 1)),
                ),
                SizedBox(
                  height: 30,
                ),
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
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'OK',
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
          ));

  Future NewGoal() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Create New Goal',
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
                  'Your Goal',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Nonito',
                    fontSize: 14,
                    color: Color.fromRGBO(47, 47, 47, 1),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _yourGoal,
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
                    SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 50,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          items: [
                            DropdownMenuItem<String>(
                              value: '1 month',
                              child: Text('1 month'),
                            ),
                            DropdownMenuItem<String>(
                              value: '2 months',
                              child: Text('2 months'),
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
                        // isExpanded : true,
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
                      //   _saveToFirestore();
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
          ));

  Future<void> EditGoal(String docId, String currentGoal, String? currentPeriod,
      String? currentHabbitType) {
    TextEditingController _goalController =
        TextEditingController(text: currentGoal);
    String? selectedPeriod = currentPeriod;
    String? selectedHabbitType = currentHabbitType;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'EDIT GOAL',
                style: TextStyle(
                    fontFamily: 'Nonito',
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
              )
            ],
          ),
          content: Expanded(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _goalController,
                    decoration: InputDecoration(
                      labelText: currentGoal,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  SizedBox(height: 15),
                  DropdownButton<String>(
                    value: selectedPeriod,
                    items: [
                      DropdownMenuItem(
                          value: '1 month', child: Text('1 month')),
                      DropdownMenuItem(
                          value: '2 months', child: Text('2 months')),
                    ],
                    onChanged: (String? newVal) {
                      selectedPeriod = newVal;
                    },
                  ),
                  DropdownButton<String>(
                    value: selectedHabbitType,
                    items: [
                      DropdownMenuItem(
                          value: 'Everyday', child: Text('Everyday')),
                      DropdownMenuItem(
                          value: 'Every week', child: Text('Every week')),
                      DropdownMenuItem(
                          value: 'Every Month', child: Text('Every Month')),
                    ],
                    onChanged: (String? newValue) {
                      selectedHabbitType = newValue;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await _updateGoal(docId, _goalController.text,
                          selectedPeriod, selectedHabbitType);
                      Navigator.pop(context);
                    },
                    child: Text("UPDATE"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _updateGoal(String docId, String newGoal, String? newPeriod,
      String? newHabbitType) async {
    try {
      await FirebaseFirestore.instance.collection('Goal').doc(docId).update({
        'Goal': newGoal,
        'period': newPeriod,
        'Habbit type': newHabbitType,
      });
      print("Goal updated successfully!");
    } catch (error) {
      print("Error updating goal: $error");
    }
  }
}
