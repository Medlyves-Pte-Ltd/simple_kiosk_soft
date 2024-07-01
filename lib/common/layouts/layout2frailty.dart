import 'package:flutter/material.dart';

class Content1Frailty extends StatelessWidget {
  Widget topWidget;
  Widget Function(BuildContext)
      content3Builder; // Builder function for Content3Widget
  Widget navigSpace;

  Content1Frailty(
      {super.key,
      required this.topWidget,
      required this.content3Builder,
      required this.navigSpace});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    // double screenWidth = MediaQuery.of(context).size.width;
    //for testing space occupied by content1
    //content1 = Container(color: ColorPalette.colorbodyComp);

    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            height: screenHeight * 0.125,
            child: topWidget),
        Expanded(
          child: content3Builder(context), // Using the builder function
        ),
        Container(
          alignment: Alignment.centerRight,
          height: screenHeight * 0.075,
          child: navigSpace,
        ),
      ],
    );
  }
}

class Content3Widget extends StatefulWidget {
  final Widget Function(BuildContext) builder; // Builder function

  const Content3Widget({Key? key, required this.builder}) : super(key: key);

  @override
  _Content3WidgetState createState() => _Content3WidgetState();
}

class _Content3WidgetState extends State<Content3Widget> {
  @override
  Widget build(BuildContext context) {
    // Call the builder function to build the UI
    return widget.builder(context);
  }
}
