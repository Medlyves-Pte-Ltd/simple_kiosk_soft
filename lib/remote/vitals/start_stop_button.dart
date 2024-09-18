import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class StartStopButton extends StatelessWidget {
  final Color color;
  final String buttonName;
  final VoidCallback onPressed;
  const StartStopButton(
      {super.key,
      required this.color,
      required this.buttonName,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Container(
          width: 15.w,
          padding: EdgeInsets.all(1.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: color,
          ),
          child: Center(
            child: Text(
              buttonName,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11.dp),
            ),
          ),
        ));
  }
}
