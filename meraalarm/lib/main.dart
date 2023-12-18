import 'package:meraalarm/home_page.dart';
import 'package:flutter/material.dart';
import 'package:meraalarm/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MeraAlarm App',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {
        '/video_playback': (context) => VideoPlaybackScreen(
          videoPath: ModalRoute.of(context)?.settings.arguments as String,
        ),
      },
    );
  }
}
