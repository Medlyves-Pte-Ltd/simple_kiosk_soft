import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;

  const HeaderText({
    Key? key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  String _insertNewLine(String text, int breakpoint) {
    if (text.length <= breakpoint) return text;
    int insertPosition = text.substring(0, breakpoint).lastIndexOf(' ');
    if (insertPosition == -1) {
      return text;
    }
    return text.substring(0, insertPosition) +
        '\n' +
        text.substring(insertPosition + 1);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    //final boxHeight = screenHeight * 0.04;
    final fontSize = screenHeight * 0.027;
    //final int breakpoint = (screenWidth / 20).floor();

    //final modifiedText = _insertNewLine(text, breakpoint);

    return SizedBox(
      //height: boxHeight,
      child: Center(
        child: Text(
          text,
          textAlign: textAlign,
          style: style?.copyWith(fontSize: fontSize) ??
              TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: fontSize,
              ),
          maxLines: 2,
        ),
      ),
    );
  }
}
