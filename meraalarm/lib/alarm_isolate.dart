import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';

void scheduleAlarm(List<dynamic> data) async {
  // Extract data from the list
  final receivePort = data[0] as ReceivePort;
  final context = data[1] as BuildContext;
  final time = data[2] as TimeOfDay;
  final videoPath = data[3] as String;

  // Send receive port back to main isolate
  receivePort.sendPort.send(receivePort.sendPort);

  // Calculate alarm time difference
  final now = DateTime.now();
  final alarmTime = DateTime(
      now.year, now.month, now.day, time.hour, time.minute);
  final waitTime = alarmTime.difference(now);

  // Handle invalid alarm time (past)
  if (waitTime.isNegative) {
    // Send error message to main isolate
    receivePort.sendPort.send("Invalid alarm time: scheduled in the past!");
    return;
  }

  // Wait until alarm time
  await Future.delayed(waitTime);

  // Send video path back to main isolate
  if (videoPath.isNotEmpty) {
    receivePort.sendPort.send(videoPath);
  }

  // Signal completion to main isolate
  receivePort.sendPort.send("Alarm triggered!");
}

  // final receivePort = ReceivePort(); // Isolate's own receive port
  // final sendPort = await receivePort.first; // Wait for sendPort from main isolate
  //
  //
  // sendPort.send(receivePort.sendPort); // Send receive port back
  //
  // await for (final details in receivePort) {
  //
  //   final receivedContext = await receivePort.first as BuildContext;
  //
  //   // Extract time from separate message
  //   final time = await receivePort.first as TimeOfDay;
  //
  //   final now = DateTime.now();
  //   final alarmTime = DateTime(
  //     now.year,
  //     now.month,
  //     now.day,
  //     time.hour,
  //     time.minute,
  //   );
  //
  //   final waitTime = alarmTime.difference(now);
  //   if (waitTime.isNegative) {
  //     // Handle invalid alarm time (scheduled in the past)
  //   } else {
  //     await Future.delayed(waitTime);
  //     sendPort.send(videoPath);
  //   }
  // }

