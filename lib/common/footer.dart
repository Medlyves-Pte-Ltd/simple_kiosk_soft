import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/constants/colors.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.of(context).size.width;
    final footerHeight = screenHeight * 0.05;
    final fontSize = footerHeight * 0.30;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: footerHeight,
        width: double.infinity,
        color: ColorPalette.headerFooterBackground,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Powered By:   ",
                style: TextStyle(fontSize: fontSize, color: Colors.white)),
            Image.asset(
              'assets/images/Medlyves_logo_only.png',
              height: footerHeight * 0.8,
              fit: BoxFit.contain,
            ),
            SizedBox(
              width: screenWidth * 0.02,
            ),
            Image.asset(
              'assets/images/Medlyves_name_only.png',
              height: footerHeight * 0.5,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
