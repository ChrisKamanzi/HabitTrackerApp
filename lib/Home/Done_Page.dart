import 'package:flutter/material.dart';


import '../Habbit/TodayHabit.dart';



class done_page extends StatelessWidget {
  const done_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            'assets/images/add.png',
          ),
          Text(
            'Done!',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              fontFamily: 'Nonito',
              color: Color.fromRGBO(47, 47, 47, 1),
            ),
          ),
          SizedBox(height: 20),
          Text(
            textAlign: TextAlign.center,
            'New Habit Goal has added',
            style: TextStyle(
                fontFamily: 'Nonito',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color.fromRGBO(102, 102, 102, 1)),
          ),
          Text(
            'Let’s do the best to achieve your goal!',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Nonito',
              fontSize: 16,
              color: Color.fromRGBO(102, 102, 102, 1),
            ),
          ),
          SizedBox(height: 20),
          Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color.fromRGBO(255, 164, 80, 1),
                  Color.fromRGBO(255, 92, 0, 1)
                ],
              ),
            ),
            child: SizedBox(
              width: 298,
              height: 49,
              child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: <Color>[
                      Color.fromRGBO(255, 164, 80, 1),
                      Color.fromRGBO(255, 92, 0, 1),
                    ], begin: Alignment.bottomLeft, end: Alignment.centerRight),
                    borderRadius: BorderRadius.circular(5)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,

                    shadowColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>  habbit_page(selectedDate: DateTime.now(),)));
                  },
                  child: Text('OK',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Nonito',
                          fontWeight: FontWeight.w800,
                          color: Color.fromRGBO(251, 251, 251, 1))),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
