import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewAlarm extends StatefulWidget {
  const ViewAlarm({super.key});

  @override
  State<ViewAlarm> createState() => _ViewAlarmState();
}

class _ViewAlarmState extends State<ViewAlarm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Alarm')),
    );
  }
}
