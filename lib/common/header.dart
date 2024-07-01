import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_kiosk_software/constants/colors.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final headerHeight = screenHeight * 0.08;
    final imageWidth = screenWidth * 0.35;
    final boxWidth = screenWidth * 0.04;
    final fontSize = headerHeight * 0.3;

    return AppBar(
        backgroundColor: ColorPalette.headerFooterBackground,
        automaticallyImplyLeading: false,
        toolbarHeight: headerHeight,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage('assets/images/nhc_logo.png'),
              width: imageWidth,
            ),
            SizedBox(
              width: boxWidth,
            ),
            Expanded(
              child: Text(
                "Self-Service Health Screening Kiosk",
                maxLines: 2,
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: ColorPalette.colorAppBackground,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ));
  }
}
