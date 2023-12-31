import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meraalarm/alarm_isolate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:isolate';

class SetAlarm extends StatefulWidget {
  const SetAlarm({Key? key}) : super(key: key);

  @override
  _SetAlarmState createState() => _SetAlarmState();
}

class _SetAlarmState extends State<SetAlarm> {
  TimeOfDay _selectedTime = TimeOfDay.now(); // Variable to store selected time
  String _name = ''; // Variable to store the selected alarm name
  File? videoSelected;
  String videoPath = '';

  // Save alarm details
  Future<void> _saveAlarm(TimeOfDay time, File? videoFile, String videoPath,
      String alarmName) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      prefs.setString('alarm_time', time.format(context));
      if (videoFile != null) {
        prefs.setString('alarm_video_path', videoPath);
        final receivePort = ReceivePort();
        final sendPort = await receivePort.first;

        Isolate.spawn(scheduleAlarm, [sendPort, context, time, videoPath]);

        // Listen for messages from the isolate
        receivePort.listen((message) {
          if (message == "Alarm triggered!") {
            // Close ports here
            receivePort.close();
            sendPort.close();

            // Handle alarm trigger logic
            // ...
          } else if (message is String && message.startsWith("Error: ")) {
            // Handle error message from isolate
            print(message);
          }
        });
      }
      prefs.setString('alarm_name', alarmName);

      print('Alarm created: $alarmName at $time with video $videoPath');
    } catch (e) {
      print('Error saving alarm: $e');
      // Handle the error, show a message to the user, or log it for debugging
    }
  }

  // Function to show time picker and update the selected time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Function to get videoFile
  Future<void> getVideoFile(ImageSource sourceImg) async {
    final videoFile = await ImagePicker().pickVideo(source: sourceImg);

    if (videoFile != null) {
      //Video preview screen
      videoSelected = File(videoFile.path);
      videoPath = videoFile.path;
    }
  }

  Widget buildVideoUploadSection() {
    if (videoSelected != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Video:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Text(
                '...${videoPath.length != 0 ? videoPath.substring(videoPath.length - 10) : videoPath}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Clear video selection
                  setState(() {
                    videoSelected = null;
                    videoPath = '';
                  });
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(100, 40)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
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
            ],
          ),
        ],
      );
    } else {
      return SizedBox(height: 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Set Alarm')),
      body: Container(
        color: Color(0xFF343030), // Background color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Set Alarm...',
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
                  height: 1.2,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: Text('Select Time'),
              ),
              SizedBox(height: 20),
              Text(
                'Selected Time: ${_selectedTime.format(context)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Video',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            getVideoFile(ImageSource.gallery);
                          },
                          child: Text(
                            'Upload',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(Size(150, 60)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  // Color when the button is pressed
                                  return Color(0xFF006DDA);
                                }
                                // Color for the default and other states
                                return Color(0xFF1393DB);
                              },
                            ),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            getVideoFile(ImageSource.camera);
                          },
                          child: Text(
                            'Record',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(Size(150, 60)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  // Color when the button is pressed
                                  return Color(0xFF006DDA);
                                }
                                // Color for the default and other states
                                return Color(0xFF1393DB);
                              },
                            ),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                        ),
                      ],
                    ),
                    buildVideoUploadSection(),
                    SizedBox(height: 30),
                    Text(
                      'Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _name = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter the alarm name',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Save selected time
                        TimeOfDay _savedTime = _selectedTime;

                        // Save video information if selected
                        File? _savedVideoFile;
                        String _savedVideoPath = '';

                        if (videoSelected != null) {
                          _savedVideoFile = videoSelected;
                          _savedVideoPath = videoPath;
                        }

                        // Save alarm name
                        String _savedAlarmName = _name;

                        // Store the alarm information (e.g., using local storage)
                        _saveAlarm(_savedTime, _savedVideoFile, _savedVideoPath,
                            _savedAlarmName);

                        // Clear any selections for next use
                        setState(() {
                          _selectedTime = TimeOfDay.now();
                          videoSelected = null;
                          videoPath = '';
                          _name = '';
                        });

                        // Show success message or navigate to another screen
                      },
                      child: Text(
                        'Create Alarm',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(Size(400, 60)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              // Color when the button is pressed
                              return Color(0xFF006DDA);
                            }
                            // Color for the default and other states
                            return Color(0xFF1393DB);
                          },
                        ),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
