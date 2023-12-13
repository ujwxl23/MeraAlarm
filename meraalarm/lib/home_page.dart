import 'package:meraalarm/set_alarm.dart';
import 'package:meraalarm/view_alarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF343030),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.elliptical(180, 120),
                  bottomLeft: Radius.elliptical(180, 120)),
              child: Container(
                color: Colors.blue,
                height: 450,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Column(
                      children: [
                        Image.asset('assets/alarm-clock.png',
                            height: 300, width: 400),
                        Text('MeraAlarm',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 48)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60, top: 20),
              child: Text(
                'Hello....',
                style: TextStyle(
                  color: Color(0xFFFFFFFF), // Text color
                  shadows: [
                    Shadow(
                      offset: Offset(15.0, 9.0),
                      blurRadius: 17.0,
                      color: Color(0xFF000000),
                    ),
                  ],
                  fontFamily: 'Inter',
                  fontSize: 30.0,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SetAlarm()),
                        );
                      },
                      child: Text(
                        'Set Alarm',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(Size(315, 60)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              // Color when the button is pressed
                              return Color(0xFF006DDA);
                            }
                            // Color for the default and other states
                            return Color(0xFF1393DB);
                          },
                        ),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'View Alarm',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(Size(315, 60)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              // Color when the button is pressed
                              return Color(0xFF006DDA);
                            }
                            // Color for the default and other states
                            return Color(0xFF1393DB);
                          },
                        ),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Text(
                      "Created by UJWXL",
                      style: TextStyle(
                        color: Colors.white,
                        // Other styling properties can be added here
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
