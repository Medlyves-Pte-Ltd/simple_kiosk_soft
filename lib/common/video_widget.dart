import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final String videoName;
  final bool setLooping;
  bool fromFile = false;

  VideoWidget({
    Key? key,
    required this.videoName,
    required this.setLooping,
    this.fromFile = false,
  }) : super(key: key);

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.fromFile) {
      _controller = VideoPlayerController.file(File(widget.videoName))
        ..setLooping(widget.setLooping)
        ..setVolume(1.0)
        ..initialize().then((_) {
          setState(() {});
        })
        ..play();
    } else {
      _controller = VideoPlayerController.asset(widget.videoName)
        ..setLooping(widget.setLooping)
        ..initialize().then((_) {
          setState(() {});
        })
        ..play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final videoWidth = screenWidth;
    final videoHeight = videoWidth * 9 / 16;
    print("_VideoWidgetState");

    return Center(
      child: SizedBox(
          height: videoHeight,
          width: videoWidth,
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}
