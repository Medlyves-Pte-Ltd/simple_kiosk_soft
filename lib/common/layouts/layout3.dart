import 'package:flutter/material.dart';

class Content2Body extends StatelessWidget {
  Widget topWidget;
  Widget Function(BuildContext)
      content3Builder; // Builder function for Content3Widget
  Widget
      navigSpace; //navigSpace should be a row of navigation buttons (stateful widgets)

  Content2Body({
    super.key,
    required this.topWidget,
    required this.content3Builder,
    required this.navigSpace,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: screenHeight * 0.0875,
          child: topWidget,
        ),
        Expanded(
          child: content3Builder(context), // Using the builder function
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth *0.065),
          child: Container(
            alignment: Alignment.center,
            height: screenHeight * 0.07,
            child: navigSpace,
          ),
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

// Usage
// Content2Body(
//   topWidget: YourTopWidget(),
//   navigSpace: YourNavigSpaceWidget(),
//   content3Builder: (context) {
//     // Build your Content3Widget's UI here
//     return YourContent3Widget();
//   },
// );
