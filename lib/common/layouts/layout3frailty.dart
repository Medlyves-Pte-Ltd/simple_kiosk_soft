import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:base_kiosk_software/common/header_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Content2Frailty extends StatelessWidget {
  Widget firstRow;
  Widget secondRow;
  Widget thirdRow;
  Widget navigSpace;

  Content2Frailty(
      {super.key,
      required this.firstRow,
      required this.secondRow,
      required this.thirdRow,
      required this.navigSpace});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double topPadding = screenHeight * 0.0646;
    double bottomPadding = screenHeight * 0.02;
    double rightPadding = screenWidth * 0.07;
    Locale currentLocale = Localizations.localeOf(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: HeaderText(text: AppLocalizations.of(context)!.results_title),
        ),
        SizedBox(child: firstRow),
        SizedBox(
          child: secondRow,
        ),
        Container(
          height: currentLocale.languageCode == 'ta'
              ? screenHeight * 0.34
              : screenHeight * 0.31,
          child: thirdRow,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth *0.065),
          child: Container(
            alignment: Alignment.centerRight,
            height: screenHeight * 0.07,
            child: navigSpace,
          ),
        ),
      ],
    );
  }
}
