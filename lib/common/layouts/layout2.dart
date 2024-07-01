import 'package:flutter/material.dart';

enum StageType { beforeMeasurement, measurement }

class Content1Body extends StatelessWidget {
  Widget videoSpace;
  Widget Function(BuildContext) content2Builder;
  StageType stage;

  Content1Body(
      {super.key,
      required this.stage,
      required this.videoSpace,
      required this.content2Builder});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.of(context).size.width;
    //for testing space occupied by content1
    //content1 = Container(color: ColorPalette.colorbodyComp);
    double videoPadding;

    switch (stage) {
      case StageType.beforeMeasurement:
        videoPadding = screenHeight * 0.02;
        break;
      case StageType.measurement:
        videoPadding = 0;
        break;
    }

    return Column(
      children: [
        // SizedBox(height: videoPadding),
        Container(width: screenWidth, child: videoSpace),
        Expanded(child: content2Builder(context)),
      ],
    );
  }
}

class Content2Widget extends StatefulWidget {
  final Widget Function(BuildContext) builder; // Builder function

  const Content2Widget({Key? key, required this.builder}) : super(key: key);

  @override
  _Content2WidgetState createState() => _Content2WidgetState();
}

class _Content2WidgetState extends State<Content2Widget> {
  // Add your state variables and methods here
  @override
  Widget build(BuildContext context) {
    // Call the builder function to build the UI
    return widget.builder(context);
  }
}
