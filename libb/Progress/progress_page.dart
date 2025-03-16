import 'package:flutter/material.dart';

import 'package:percent_indicator/percent_indicator.dart';

import '../Home/home.dart';
import '../Settings/Settings_page.dart';
import 'Goals_progress.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Progress',
          style: TextStyle(
              fontFamily: 'Nonito',
              fontSize: 29,
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(47, 47, 47, 1)),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress Report',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 21,
                      fontFamily: 'Nonito',
                      color: Color.fromRGBO(47, 47, 47, 1),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20, top: 10),
                    padding: EdgeInsets.only(right: 20),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey, width: 1.0),
                    ),
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
                                    ))),
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
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
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
                          color: Color.fromRGBO(47, 47, 47, 1),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => goals_progress()));
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
                  CircularPercentIndicator(
                      center: Text(
                        '80%',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 29,
                          fontFamily: 'Nonito',
                          color: Color.fromRGBO(255, 92, 0, 1),
                        ),
                      ),
                      percent: 0.8,
                      backgroundColor: Color.fromRGBO(240, 240, 240, 1),
                      progressColor: Color.fromRGBO(255, 92, 0, 1),
                      lineWidth: 15,
                      radius: 80.8),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, top: 20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check,
                          color: Color.fromRGBO(255, 92, 0, 1),
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                Color.fromRGBO(255, 164, 80, 1),
                                Color.fromRGBO(255, 92, 0, 1)
                              ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.centerRight)
                              .createShader(bounds),
                          child: Text(
                            '11 Habits Goals has archieved',
                            style: TextStyle(
                              fontFamily: 'Nonito',
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, top: 5),
                    child: Row(
                      children: [
                        Icon(
                          Icons.close,
                          color: Color.fromRGBO(162, 162, 162, 1),
                        ),
                        Text(
                          '6 Habbits Goals hasnt archieved',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              fontFamily: 'Nonito',
                              color: Color.fromRGBO(162, 162, 162, 1)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 70,
                          child: Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 5, bottom: 5),
                                  child: CircularPercentIndicator(
                                    center: Text(
                                      '100%',
                                      style: TextStyle(
                                          fontFamily: 'Nonito',
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color:
                                              Color.fromRGBO(95, 227, 148, 1)),
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
                                        'Journaling Everyday',
                                        style: TextStyle(
                                            fontFamily: 'Nonito',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color:
                                                Color.fromRGBO(47, 47, 47, 1)),
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
                                      padding:
                                          EdgeInsets.only(right: 5, left: 5),
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
                          height: 10,
                        ),
                        SizedBox(
                          height: 75,
                          child: Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5, top: 8, bottom: 8),
                                  child: CircularPercentIndicator(
                                    center: Text(
                                      '100%',
                                      style: TextStyle(
                                        fontFamily: 'Nonito',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(95, 227, 148, 1),
                                      ),
                                    ),
                                    radius: 25,
                                    percent: 1.0,
                                    linearGradient: LinearGradient(colors: [
                                      Color.fromRGBO(55, 200, 113, 1,),
                                      Color.fromRGBO(95, 227, 148, 1),
                                    ]),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        'Cooking Practice',
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
                                  child: Container(
                                      height: 20,
                                      padding:
                                          EdgeInsets.only(left: 5, right: 5),
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
                          height: 10,
                        ),
                        SizedBox(
                          height: 75,
                          child: Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 8, bottom: 8),
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
                                    backgroundColor:
                                        Color.fromRGBO(219, 219, 219, 1),
                                    progressColor:
                                        Color.fromRGBO(176, 176, 176, 1),
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
                                        'Journaling Everyday',
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
                                      color: Color.fromRGBO(149, 149, 149, 1),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () {},
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
                            )
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.blueGrey,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => homepage()));
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
