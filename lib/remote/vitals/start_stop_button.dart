import 'package:flutter/material.dart';

class StartStopButton extends StatelessWidget {
  final Color color;
  final String buttonName;
  final VoidCallback onPressed;
  double width = 0;
  double height = 0;

  StartStopButton(
      {super.key,
      required this.color,
      required this.buttonName,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return TextButton(
        onPressed: onPressed,
        child: Container(
          height: height * 0.04,
          width: width * 0.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
          ),
          child: Center(
            child: Text(
              buttonName,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: height * 0.025),
            ),
          ),
        ));
  }
}
