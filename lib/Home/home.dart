import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_application/widget.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Habbit/YourHabits.dart';
import '../Habbit/goals.dart';
import '../Progress/progress_page.dart';
import '../Settings/Settings_page.dart';
import '../providers/username_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class homepage extends ConsumerStatefulWidget {
  const homepage({super.key});
  @override
  ConsumerState<homepage> createState() => _homepageState();
}
class _homepageState extends ConsumerState<homepage> {
  TextEditingController _yourHabit = TextEditingController();
  String? _selected;
  String? habbitType;
  var selectedValue;

  final CollectionReference habitsCollection =
      FirebaseFirestore.instance.collection('Habits');
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    homepage(),
    progresss(),
    settings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selected = '1 month(30 days)';
    habbitType = 'Everyday';
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, dd MMMM yyyy').format(now);
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final userState = ref.watch(userProvider);
    final username = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$formattedDate',
          style: TextStyle(
              fontFamily: 'Nonito', fontWeight: FontWeight.w700, fontSize: 16),
          textAlign: TextAlign.start,
        ),
      ),
      drawer: Drawer(
        child: TextButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', false);
            await prefs.remove('userEmail');
            context.go('/login');
          },
          child: Text('Logout'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 20),
              child: RichText(
                text: TextSpan(
                    text: 'Hello',
                    style: TextStyle(
                      fontFamily: 'Nonito',
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: username,
                          style: TextStyle(
                            fontSize: 28,
                            fontFamily: 'Nonito',
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(255, 164, 80, 1),
                          ))
                    ]),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                height: 189,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(255, 164, 80, 1),
                      Color.fromRGBO(255, 92, 0, 1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Center(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Habits')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text("No habits found for today"));
                      }

                      String today =
                          DateFormat('yyyy-MM-dd').format(DateTime.now());

                      int totalHabitsToday = snapshot.data!.docs.length;

                      int completedHabitsToday =
                          snapshot.data!.docs.where((doc) {
                        var habitData = doc.data() as Map<String, dynamic>;
                        Map<String, dynamic>? completedDays =
                            habitData['completedDays'];
                        return completedDays != null &&
                            completedDays.containsKey(today);
                      }).length;

                      double completionPercentage = totalHabitsToday > 0
                          ? (completedHabitsToday / totalHabitsToday)
                          : 0.0;

                      return Stack(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: CircularPercentIndicator(
                                  radius: 70.0,
                                  lineWidth: 20.0,
                                  percent: completionPercentage,
                                  // Updated dynamically
                                  center: Text(
                                    '${(completionPercentage * 100).toInt()}%',
                                    // Convert to integer
                                    style: TextStyle(
                                      fontFamily: 'Nonito',
                                      fontSize: 21,
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                  ),
                                  progressColor: Colors.white,
                                  backgroundColor: Colors.white54,
                                ),
                              ),
                              SizedBox(width: 20),
                              Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: Column(
                                  children: [
                                    Text(
                                      '$completedHabitsToday of $totalHabitsToday habits',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Nonito',
                                        fontSize: 20,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                    ),
                                    Text(
                                      'completed today!',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Nonito',
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Image.asset(
                              'assets/images/calendar.png',
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 8.5),
              child: SizedBox(
                height: 340,
                child: Card(
                  elevation: 2,
                  color: Theme.of(context).cardColor, // Adaptive background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10, left: 10),
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
                                  /*  color: Theme.of(context)
                                        .textTheme
                                          .bodyLarge
                                          ?.color ??
                                      Colors.black,*/
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HabbitPagee()));
                                },
                                child: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                          colors: <Color>[
                                        Color.fromRGBO(255, 164, 80, 1),
                                        Color.fromRGBO(255, 92, 0, 1)
                                      ],
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.centerRight)
                                      .createShader(bounds),
                                  child: Text(
                                    'See all',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      fontFamily: 'Nonito',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: habitsCollection.snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(child: Text('No habits found.'));
                            }
                            final theme = Theme.of(context);
                            final textColor =
                                theme.textTheme.bodyLarge?.color ??
                                    Colors.black;
                            final backgroundColor = theme.cardColor;
                            final completedColor =
                                theme.brightness == Brightness.dark
                                    ? Colors.green[900]
                                    : Color.fromRGBO(237, 255, 244, 1);

                            var everydayHabits =
                                snapshot.data!.docs.where((document) {
                              Map<String, dynamic> data =
                                  document.data() as Map<String, dynamic>;
                              return data['Habit type'] == 'Everyday';
                            }).toList();

                            if (everydayHabits.isEmpty) {
                              return Center(
                                  child: Text('No everyday habits found.'));
                            }

                            String today =
                                DateFormat('yyyy-MM-dd').format(DateTime.now());

                            return Column(
                              children: everydayHabits
                                  .take(3)
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data() as Map<String, dynamic>;
                                Map<String, dynamic>? completedDays =
                                    data['completedDays'];
                                bool isCompleted = completedDays != null &&
                                    completedDays.containsKey(today);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    width: 500,
                                    height: 70,
                                    child: Card(
                                      color: isCompleted
                                          ? completedColor
                                          : backgroundColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              data['Habit'],
                                              style: TextStyle(
                                                fontFamily: 'Nonito',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: textColor,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Checkbox(
                                                  value: isCompleted,
                                                  onChanged: (bool? newValue) {
                                                    if (newValue != null) {
                                                      habitsCollection
                                                          .doc(document.id)
                                                          .update({
                                                        'completed': newValue,
                                                        'completedDays': {
                                                          ...completedDays ??
                                                              {},
                                                          today: newValue,
                                                        }
                                                      });
                                                    }
                                                  },
                                                  activeColor:
                                                      theme.colorScheme.primary,
                                                ),
                                                PopupMenuButton(
                                                  icon: Icon(
                                                    Icons.more_vert,
                                                    color: textColor,
                                                  ),
                                                  itemBuilder:
                                                      (BuildContext context) =>
                                                          <PopupMenuEntry<int>>[
                                                    PopupMenuItem<int>(
                                                      value: 1,
                                                      child: TextButton(
                                                        onPressed: () {
                                                          // Edit functionality
                                                        },
                                                        child: Text('Edit',
                                                            style: TextStyle(
                                                                color:
                                                                    textColor)),
                                                      ),
                                                    ),
                                                    PopupMenuItem<int>(
                                                      value: 2,
                                                      child: TextButton(
                                                        onPressed: () {
                                                          // Delete functionality
                                                        },
                                                        child: Text('Delete',
                                                            style: TextStyle(
                                                                color:
                                                                    textColor)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
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
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(
                left: 4,
                right: 5,
              ),
              child: SizedBox(
                height: 470,
                child: Card(
                  elevation: 2,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[850] // Dark mode color
                      : Colors.white, // Light mode color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'Your Goals',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 21,
                                  fontFamily: 'Nonito',
                                  /*  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white // Text color in dark mode
                                      : Color.fromRGBO(47, 47, 47, 1),*/
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => goal()),
                                  );
                                },
                                child: Text(
                                  'See all',
                                  style: TextStyle(
                                    fontFamily: 'Nonito',
                                    fontSize: 14,
                                    color: Color.fromRGBO(255, 164, 80, 1),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Goal')
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> goalSnapshot) {
                            if (goalSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            return Column(
                              children: goalSnapshot.data!.docs
                                  .take(3)
                                  .map((goalDoc) {
                                var goalData =
                                    goalDoc.data() as Map<String, dynamic>;
                                String goalTitle = goalData['Goal'];
                                String? selectedHabit =
                                    goalData['selecedHabit'];

                                if (selectedHabit == null ||
                                    selectedHabit.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10),
                                    child:
                                        Text("No habit assigned for this goal"),
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
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (!habitSnapshot.hasData ||
                                        habitSnapshot.data!.docs.isEmpty) {
                                      return Text(
                                          "Habit data not found for $selectedHabit");
                                    }
                                    var habitData =
                                        habitSnapshot.data!.docs.first.data()
                                            as Map<String, dynamic>;

                                    Map<String, dynamic> completedDaysMap =
                                        habitData['completedDays'] ?? {};
                                    List<String> completedDates =
                                        completedDaysMap.keys.toList();

                                    DateTime now = DateTime.now();
                                    DateTime thirtyDaysAgo =
                                        now.subtract(Duration(days: 30));

                                    int completedDays = completedDates
                                        .map((date) => DateTime.parse(date))
                                        .where((date) =>
                                            date.isAfter(thirtyDaysAgo))
                                        .length;

                                    double progress = completedDays / 30;

                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, right: 10, top: 10),
                                      child: Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                goalTitle,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                width: 370,
                                                height: 20,
                                                child: LinearProgressIndicator(
                                                  value: progress,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          231, 231, 231, 1),
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    Color.fromRGBO(
                                                        255, 92, 0, 1),
                                                  ),
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
                                              Text(
                                                '$_selected',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 92, 0, 1),
                                                  fontWeight: FontWeight.w500,
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
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green,
        ),
        child: IconButton(
          onPressed: () {
            OpenDialogue();
          },
          icon: Icon(
            Icons.add,
            color: Colors.white54,
          ),
        ),
      ),
    );
  }

  Future OpenDialogue() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Create New Habbit Goal',
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
                  controller: _yourHabit,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                SizedBox(height: 20),
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
                        // isExpanded : true,
                        value: habbitType,
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
                          )
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            habbitType = newValue;
                          });
                        },
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
          ));

  void _saveToFirestore() {
    FirebaseFirestore.instance.collection('Habits').add({
      'Habit': _yourHabit.text,
      'period': _selected,
      'Habbit type': habbitType,
    }).then((value) {
      print('Habbit added');
    }).catchError((error) {
      print(error);
    });
  }
}
