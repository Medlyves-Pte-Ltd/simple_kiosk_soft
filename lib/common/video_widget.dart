import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final String videoName;
  final bool setLooping;
  final Function(bool)? onVideoInitialised;

  const VideoWidget({
    Key? key,
    required this.videoName,
    required this.setLooping,
    this.onVideoInitialised,
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
    _controller = VideoPlayerController.asset(widget.videoName)
      ..setLooping(widget.setLooping)
      ..initialize().then((_) {
        setState(() {});
        widget.onVideoInitialised!(_controller.value.isInitialized);
      })
      ..play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final videoWidth = screenWidth;
    final videoHeight = videoWidth * 9 / 16;

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
