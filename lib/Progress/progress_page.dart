import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_application/widget/drawer.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../Habbit/goals.dart';
import '../widget/bottomNavBar.dart';

class progresss extends StatefulWidget {
  const progresss({super.key});

  @override
  State<progresss> createState() => _progresssState();
}

class _progresssState extends State<progresss> {
  String status = 'This month';
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    status = ' This month';
    super.initState();
  }

  Future<List<Map<String, dynamic>>> fetchGoals() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Goal').get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching goals: $e');
      return [];
    }
  }

  Future<int> calculateAchievedGoals() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Goal')
          .where('archieved', isEqualTo: true)
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error: $e');
      return 0;
    }
  }

  Future<int> calculateTotalGoals() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Goal').get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error: $e');
      return 0;
    }
  }

  Future<double> calculatePercentAchieved() async {
    int achieved = await calculateAchievedGoals();
    int total = await calculateTotalGoals();
    return total > 0 ? (achieved / total).clamp(0.0, 1.0) : 0.0;
  }
  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate a network request
  }
  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Progress',
          style: TextStyle(
            fontFamily: 'Nonito',
            fontSize: 29,
            fontWeight: FontWeight.w700,
            // color: textColor
          ),
        ),
      ),
      drawer:AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(

                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Goals',
                          style: TextStyle(
                            fontFamily: 'Nonito',
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            //  color: textColor,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => goal()));
                            },
                            child: ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(colors: [
                                Color.fromRGBO(255, 164, 80, 1),
                                Color.fromRGBO(255, 92, 0, 1)
                              ]).createShader(bounds),
                              child: Text(
                                'see all',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  fontFamily: 'Nonito',
                                ),
                              ),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FutureBuilder<double>(
                      future: calculatePercentAchieved(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text("Error: ${snapshot.error}"));
                        }

                        double percentAchieved = snapshot.data ?? 0.0;

                        return CircularPercentIndicator(
                          center: Text(
                            "${(percentAchieved * 100).toInt()}%",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 29,
                              fontFamily: 'Nonito',
                              color: Color.fromRGBO(255, 92, 0, 1),
                            ),
                          ),
                          percent: percentAchieved,
                          backgroundColor: Color.fromRGBO(240, 240, 240, 1),
                          progressColor: Color.fromRGBO(255, 92, 0, 1),
                          lineWidth: 15,
                          radius: 80.8,
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Column(
                        children: [
                          SizedBox(
                              height: 500,
                              child: SingleChildScrollView(
                                child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('Goal')
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> goalSnapshot) {
                                    if (!goalSnapshot.hasData ||
                                        goalSnapshot.data!.docs.isEmpty) {
                                      return Center(
                                          child: Text("No goals available"));
                                    }

                                    return Column(
                                      children: goalSnapshot.data!.docs
                                          .take(3)
                                          .map((goalDoc) {
                                        var goalData = goalDoc.data()
                                            as Map<String, dynamic>;
                                        String goalTitle = goalData['Goal'];
                                        String? selectedHabit =
                                            goalData['selecedHabit'];

                                        if (selectedHabit == null ||
                                            selectedHabit.isEmpty) {
                                          return Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                                "No habit assigned for this goal"),
                                          );
                                        }

                                        return StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('Habits')
                                              .where('Habit',
                                                  isEqualTo: selectedHabit)
                                              .snapshots(),
                                          builder: (context, habitSnapshot) {
                                            if (habitSnapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }

                                            if (!habitSnapshot.hasData ||
                                                habitSnapshot
                                                    .data!.docs.isEmpty) {
                                              return Padding(
                                                padding: const EdgeInsets.all(10),
                                                child: Text(
                                                    "Habit data not found for $selectedHabit"),
                                              );
                                            }

                                            var habitData = habitSnapshot
                                                .data!.docs.first
                                                .data() as Map<String, dynamic>;
                                            Map<String, dynamic>
                                                completedDaysMap =
                                                habitData['completedDays'] ?? {};
                                            List<String> completedDates =
                                                completedDaysMap.keys.toList();

                                            DateTime now = DateTime.now();
                                            DateTime thirtyDaysAgo =
                                                now.subtract(Duration(days: 30));

                                            int completedDays = completedDates
                                                .map((date) =>
                                                    DateTime.parse(date))
                                                .where((date) =>
                                                    date.isAfter(thirtyDaysAgo))
                                                .length;

                                            double progress = completedDays / 30;

                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, right: 5, top: 10),
                                              child: Card(
                                                elevation: 2,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // Circular progress indicator
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                left: 5,
                                                                top: 5,
                                                                bottom: 5),
                                                        child:
                                                            CircularPercentIndicator(
                                                          center: Text(
                                                            '${(progress * 100).toStringAsFixed(0)}%',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Nonito',
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight.w700,
                                                              color:
                                                                  Color.fromRGBO(
                                                                      95,
                                                                      227,
                                                                      148,
                                                                      1),
                                                            ),
                                                          ),
                                                          radius: 25,
                                                          percent: progress,
                                                          linearGradient:
                                                              LinearGradient(
                                                                  colors: [
                                                                Color.fromRGBO(55,
                                                                    200, 113, 1),
                                                                Color.fromRGBO(95,
                                                                    227, 148, 1),
                                                              ]),
                                                        ),
                                                      ),
                                                      SizedBox(width: 20),

                                                      // Title and completed goal text
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 10),
                                                            child: Text(
                                                              goalTitle,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Nonito',
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: textColor,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            '$completedDays from 30 days target',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.w400,
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Nonito',
                                                              color: textColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 10),
                                                      // Achieved status tag
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                right: 10),
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 5),
                                                          height: 20,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(80),
                                                            color: progress >= 1.0
                                                                ? Colors.greenAccent[
                                                                    100]
                                                                : Colors
                                                                    .grey[300],
                                                          ),
                                                          child: Text(
                                                            progress >= 1.0
                                                                ? 'Achieved'
                                                                : 'UnAchieved',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Nonito',
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              color: progress >=
                                                                      1.0
                                                                  ? Colors.green
                                                                  : Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
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
                              )),
                          TextButton(
                              onPressed: () {
                                goal();
                              },
                              child: ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      Color.fromRGBO(255, 164, 80, 1),
                                      Color.fromRGBO(255, 92, 0, 1)
                                    ]).createShader(bounds),
                                child: Text(
                                  'See all',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      fontFamily: 'Nonito',
                                      color: Colors.white),
                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
