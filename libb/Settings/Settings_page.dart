import 'package:flutter/material.dart';


import '../Home/home.dart';
import '../Progress/progress_page.dart';
import 'Account_page.dart';

class settings extends StatelessWidget {
  const settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Setting',
          style: TextStyle(
              fontFamily: 'Nonito',
              fontWeight: FontWeight.w700,
              fontSize: 29,
              color: Color.fromRGBO(47, 47, 47, 1)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Card(
          color: Colors.white,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => account_page()));
                  },
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Account',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Nonito',
                                color: Color.fromRGBO(47, 47, 47, 1)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(Icons.keyboard_arrow_right),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 422,
                  height: 58,
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Terms and Conditions',
                              style: TextStyle(
                                  fontFamily: 'Nonito',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Color.fromRGBO(47, 47, 47, 1)),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(Icons.keyboard_arrow_right),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 422,
                  height: 58,
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Policy',
                            style: TextStyle(
                                fontFamily: 'Nonito',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Color.fromRGBO(47, 47, 47, 1)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(Icons.keyboard_arrow_right),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 422,
                  height: 58,
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'About App',
                            style: TextStyle(
                                fontFamily: 'Nonito',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Color.fromRGBO(47, 47, 47, 1)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(Icons.keyboard_arrow_right),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(items: <BottomNavigationBarItem>[
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
