import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'AllHabits.dart';
import 'TodayHabit.dart';
import 'package:intl/intl.dart';

class HabbitPagee extends StatefulWidget {
  @override
  State<HabbitPagee> createState() => _HabbitPageState();
}

class _HabbitPageState extends State<HabbitPagee>
    with SingleTickerProviderStateMixin {
  late TextEditingController _yourHabit;
  late TabController _tabController;
  late String _selected;
  late String habbitType;
  final CollectionReference habitsCollection =
      FirebaseFirestore.instance.collection('Habits');
  final DateTime firstDay = DateTime.now();
  final DateTime lastDay = DateTime.utc(2030, 10, 20);
  late DateTime selectedDay;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _yourHabit = TextEditingController();
    _tabController = TabController(length: 2, vsync: this);
    _selected = '1 month(30 days)';
    habbitType = 'Everyday';
    _scrollController = ScrollController();
    selectedDay = DateTime.now().isBefore(firstDay) ? firstDay : DateTime.now();
  }

  @override
  void dispose() {
    _yourHabit.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void deleteGoal(String docId) {
    habitsCollection.doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Habit',
          style: TextStyle(
            fontFamily: 'Nonito',
            fontSize: 21,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "TODAY"),
            Tab(text: "ALL"),
          ],
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          indicatorColor: Colors.transparent,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 10),
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: ListView.separated(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: lastDay.difference(firstDay).inDays + 1,
                separatorBuilder: (context, index) => SizedBox(width: 6),
                itemBuilder: (context, index) {
                  DateTime currentDate = firstDay.add(Duration(days: index));
                  bool isSelected = selectedDay == currentDate;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDay = currentDate;
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => allhabbit(),
                        ),
                      );
                    },
                    child: Container(
                      width: 80,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 6)
                              ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EEE').format(currentDate),
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            DateFormat('d').format(currentDate),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.grey, width: 1),
                  )),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  elevation: MaterialStateProperty.all<double>(0),
                ),
                onPressed: () {
                  NewGoal();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ADD NEW',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: Colors.deepOrange[400],
                        fontFamily: 'Nonito',
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.add,
                      size: 25,
                      color: Colors.deepOrange[400],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.6, // Adjust height dynamically
              child: TabBarView(
                controller: _tabController,
                children: [
                  habbit_page(selectedDate: DateTime.now()),
                  allhabbit(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future NewGoal() => showDialog(
      context: context,
      builder: (context) {
        final textColor = Theme.of(context).textTheme.bodyLarge?.color;
        return AlertDialog(
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
                  'Your Haabit',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Nonito',
                    fontSize: 14,
                    color: textColor,
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
                        color: textColor,
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
                              _selected = newVal ?? _selected;
                            });
                          },
                          value: _selected,
                        ),
                      ),
                    ),
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
                          color: textColor),
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
                            habbitType = newValue ?? habbitType;
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
        );
      });

  void _saveToFirestore() {
    DateTime now = DateTime.now();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('Habits').add({
        'email': user.email,
        'Habit': _yourHabit.text,
        'period': _selected,
        'Habit type': habbitType,
        'created': now,
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
}
