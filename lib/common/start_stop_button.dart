import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/common/buttons.dart';
import 'package:simple_kiosk_software/constants/colors.dart';

class StartStopButton extends StatelessWidget {
  final Color color;
  Color? backgroundColor = ColorPalette.materialGreen;
  final String buttonName;

  final VoidCallback onPressed;
  StartStopButton(
      {super.key,
      required this.color,
      required this.buttonName,
      required this.onPressed,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer(const Duration(milliseconds: 800));
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.18;
    double buttonHeight = screenHeight * 0.03125;
    double fontsize = buttonHeight * 0.55;

    return SizedBox(
      height: buttonHeight,
      width: buttonWidth,
      child: TextButton(
        onPressed: () {
          debouncer.run(() {
            onPressed();
          });
        },
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.only(bottom: 0.5),
        ),
        child: Text(
          buttonName,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: ColorPalette.colorAppBackground,
              fontWeight: FontWeight.w600,
              fontSize: fontsize),
        ),
      ),
    );
  }
}
