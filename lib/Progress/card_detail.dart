import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class card_detail extends StatelessWidget {
  const card_detail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goal: Journaling everyday'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime.utc(2040, 3, 10)),
            Container(
              padding:
                  EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Journaling Everyday',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          fontFamily: 'Nonito',
                          color: Color.fromRGBO(0, 0, 0, 1)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.tealAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Achieved ',
                        style: TextStyle(
                            fontFamily: 'Nonito',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.green),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Habbit Name',
                      style: TextStyle(
                          fontFamily: 'Nonito',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(47, 47, 47, 1)),
                    ),
                    Text(
                      'Journaling',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          fontFamily: 'Nonito',
                          color: Color.fromRGBO(47, 47, 47, 1)),
                    )
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Target',
                      style: TextStyle(
                          fontFamily: 'Nonito',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(47, 47, 47, 1)),
                    ),
                    Text('  7 from 7 days ',
                        style: TextStyle(
                            fontFamily: 'Nonito',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(47, 47, 47, 1)))
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Days complete',
                        style: TextStyle(
                            fontFamily: 'Nonito',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(47, 47, 47, 1))),
                    Text('  0 Day ',
                        style: TextStyle(
                            fontFamily: 'Nonito',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(47, 47, 47, 1)))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Days Failed',
                        style: TextStyle(
                            fontFamily: 'Nonito',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(47, 47, 47, 1))),
                    Text('  7 from 7 days',
                        style: TextStyle(
                            fontFamily: 'Nonito',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(47, 47, 47, 1))),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Habit type',
                        style: TextStyle(
                            fontFamily: 'Nonito',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(47, 47, 47, 1))),
                    Text(' Everyday',
                        style: TextStyle(
                            fontFamily: 'Nonito',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(47, 47, 47, 1)))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Created On',
                        style: TextStyle(
                            fontFamily: 'Nonito',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(47, 47, 47, 1))),
                    Text('  June  4 2022 ',
                        style: TextStyle(
                            fontFamily: 'Nonito',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(47, 47, 47, 1)))
                  ],
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
