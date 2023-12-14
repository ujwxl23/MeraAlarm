import 'dart:io';

import 'package:flutter/material.dart';

class VideoPreview extends StatefulWidget {

  final File videoFile;
  final String videoPath;

  VideoPreview({ required this.videoFile, required this.videoPath});

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
