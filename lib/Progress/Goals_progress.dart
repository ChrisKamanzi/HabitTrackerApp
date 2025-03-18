import 'package:flutter/material.dart';

import 'package:percent_indicator/percent_indicator.dart';

import '../Home/home.dart';
import '../Settings/Settings_page.dart';
import 'card_detail.dart';
import 'progress_page.dart';

class goals_progress extends StatefulWidget {
  const goals_progress({super.key});

  @override
  State<goals_progress> createState() => _goals_progressState();
}

class _goals_progressState extends State<goals_progress> {
  String status = 'This month';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Goals'),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20, top: 10),
            padding: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey, width: 2.0)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  items: [
                    DropdownMenuItem<String>(
                        value: 'one',
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'This month',
                              style: TextStyle(
                                fontFamily: 'Nonito',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(47, 47, 47, 1),
                              ),
                            )
                        )
                    ),
                    DropdownMenuItem(
                        value: 'Two',
                        child: Text(
                          'All',
                          style: TextStyle(
                            fontFamily: 'Nonito',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(47, 47, 47, 1),
                          ),
                        ))
                  ],
                  onChanged: (String? newVAlue) {
                    newVAlue = status;
                  }),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => card_detail()));
              },
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, bottom: 8),
                      child: CircularPercentIndicator(
                        center: Text(
                          '100%',
                          style: TextStyle(
                              fontFamily: 'Nonito',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(95, 227, 148, 1)),
                        ),
                        radius: 25,
                        percent: 1.0,
                        linearGradient: LinearGradient(colors: [
                          Color.fromRGBO(
                            55,
                            200,
                            113,
                            1,
                          ),
                          Color.fromRGBO(95, 227, 148, 1),
                        ]),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Container(
                          child: Text(
                            'Journaling Everyday',
                            style: TextStyle(
                                fontFamily: 'Nonito',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(47, 47, 47, 1)),
                          ),
                        ),
                        Text(
                          '7 from 7 days target',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            fontFamily: 'Nonito',
                            color: Color.fromRGBO(47, 47, 47, 1),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80),
                            color: Colors.greenAccent[100],
                          ),
                          child: Text(
                            'Achieved',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Nonito',
                                fontWeight: FontWeight.w500,
                                color: Colors.green),
                          )),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => card_detail()));
              },
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 8, bottom: 8),
                      child: CircularPercentIndicator(
                        center: Text(
                          '100%',
                          style: TextStyle(
                              fontFamily: 'Nonito',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(95, 227, 148, 1)),
                        ),
                        radius: 25,
                        percent: 1.0,
                        linearGradient: LinearGradient(colors: [
                          Color.fromRGBO(
                            55,
                            200,
                            113,
                            1,
                          ),
                          Color.fromRGBO(95, 227, 148, 1),
                        ]),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Text(
                          'Cooking Practice',
                          style: TextStyle(
                            fontFamily: 'Nonito',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(47, 47, 47, 1),
                          ),
                        ),
                        Text(
                          '7 from 7 days target',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            fontFamily: 'Nonito',
                            color: Color.fromRGBO(47, 47, 47, 1),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                          padding: EdgeInsets.only(
                            right: 10,
                            left: 10,
                          ),
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80),
                            color: Colors.greenAccent[100],
                          ),
                          child: Text(
                            'Achieved',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Nonito',
                                fontWeight: FontWeight.w500,
                                color: Colors.green),
                          )),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => card_detail()));
              },
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 8, bottom: 8),
                      child: CircularPercentIndicator(
                        center: Text(
                          '70%',
                          style: TextStyle(
                              fontFamily: 'Nonito',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey),
                        ),
                        radius: 25,
                        percent: 0.7,
                        backgroundColor: Color.fromRGBO(219, 219, 219, 1),
                        progressColor: Color.fromRGBO(176, 176, 176, 1),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Text(
                          'Vitamin ',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            fontFamily: 'Nonito',
                            color: Color.fromRGBO(47, 47, 47, 1),
                          ),
                        ),
                        Text(
                          '7 from 7 days target',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            fontFamily: 'Nonito',
                            color: Color.fromRGBO(47, 47, 47, 1),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        'Unarchieved',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Nonito',
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(149, 149, 149, 1)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => card_detail()));
              },
              child: SizedBox(
                height: 73,
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 8, bottom: 5),
                        child: CircularPercentIndicator(
                          center: Text(
                            '100%',
                            style: TextStyle(
                                fontFamily: 'Nonito',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(95, 227, 148, 1)),
                          ),
                          radius: 25,
                          percent: 1.0,
                          linearGradient: LinearGradient(colors: [
                            Color.fromRGBO(
                              55,
                              200,
                              113,
                              1,
                            ),
                            Color.fromRGBO(95, 227, 148, 1),
                          ]),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              'Meditate',
                              style: TextStyle(
                                  fontFamily: 'Nonito',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(47, 47, 47, 1)),
                            ),
                          ),
                          Text(
                            '7 from 7 days target',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              fontFamily: 'Nonito',
                              color: Color.fromRGBO(47, 47, 47, 1),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80),
                              color: Colors.greenAccent[100],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Text(
                                'Achieved',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Nonito',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green),
                              ),
                            ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => card_detail()));
              },
              child: SizedBox(
                height: 70,
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                        child: CircularPercentIndicator(
                          center: Text(
                            '70%',
                            style: TextStyle(
                                fontFamily: 'Nonito',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey),
                          ),
                          radius: 25,
                          percent: 0.7,
                          backgroundColor: Color.fromRGBO(219, 219, 219, 1),
                          progressColor: Color.fromRGBO(176, 176, 176, 1),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              'Learn Arabic',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                fontFamily: 'Nonito',
                                color: Color.fromRGBO(47, 47, 47, 1),
                              ),
                            ),
                          ),
                          Text(
                            '7 from 7 days target',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              fontFamily: 'Nonito',
                              color: Color.fromRGBO(47, 47, 47, 1),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          'Unarchieved',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Nonito',
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(149, 149, 149, 1)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> homepage()));
              },
              icon: Icon(
                Icons.home,
              ),
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
      ]),
    );
  }
}
