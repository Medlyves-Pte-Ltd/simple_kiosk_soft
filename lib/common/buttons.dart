import 'dart:async';
import 'package:flutter/material.dart';
import 'package:base_kiosk_software/constants/colors.dart';

enum ButtonType { language, mode, measure, backtomode, getstarted, end }

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer(this.delay);

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }
}

double calculateFontSize(
    String text, double buttonHeight, Locale currentLocale) {
  const double baseFactor = 0.6;
  const double scaleFactor = 0.5;

  // Calculate the base font size based on button height
  double baseFontSize = buttonHeight * baseFactor;

  // Adjust font size based on text length
  double fontSize = baseFontSize - (text.length * scaleFactor);

  // Ensure font size doesn't go below a minimum value
  if (currentLocale.languageCode == 'ta') {
    return fontSize.clamp(10, 24);
  } else {
    return fontSize.clamp(12, 24);
  }
}

class GreenButton extends StatefulWidget {
  final String buttonText;
  final VoidCallback onTap;
  final bool disabled;
  final ButtonType buttontype;

  const GreenButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    required this.disabled,
    required this.buttontype,
  });

  @override
  State<GreenButton> createState() => _GreenButtonState();
}

class _GreenButtonState extends State<GreenButton> {
  final _debouncer = Debouncer(const Duration(milliseconds: 800));

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth;
    double buttonHeight;
    Color buttonColour;
    double fontsize;
    Locale currentLocale = Localizations.localeOf(context);

    switch (widget.buttontype) {
      case ButtonType.language: //for language selection page
        buttonWidth = screenWidth * 0.3;
        buttonHeight = screenHeight * 0.09375;
        buttonColour = ColorPalette.materialGreen;
        fontsize = buttonHeight * 0.28;
        break;
      case ButtonType.mode: //for mode selection page
        buttonWidth = screenWidth * 0.55;
        buttonHeight = screenHeight * 0.09375;
        buttonColour = ColorPalette.materialGreen;
        fontsize = buttonHeight * 0.3;
        break;
      case ButtonType.measure: //for start, stop, retake, back, next, results
        buttonWidth = screenWidth * 0.167;
        buttonHeight = screenHeight * 0.03125;
        buttonColour = ColorPalette.materialGreen;
        fontsize =
            calculateFontSize(widget.buttonText, buttonHeight, currentLocale);
        break;
      case ButtonType.backtomode: //for back to mode in clinic mode
        buttonWidth = screenWidth * 0.167;
        buttonHeight = screenHeight * 0.03125;
        buttonColour = ColorPalette.materialGreen;
        fontsize = currentLocale.languageCode == 'ta'
            ? calculateFontSize(
                    widget.buttonText, buttonHeight, currentLocale) *
                0.9
            : calculateFontSize(widget.buttonText, buttonHeight, currentLocale);
        break;
      case ButtonType.end: //for end session
        buttonWidth = currentLocale.languageCode == 'ta'
            ? screenWidth * 0.24
            : screenWidth * 0.194;
        buttonHeight = screenHeight * 0.03125;
        buttonColour = ColorPalette.colorbloodPressure;
        fontsize =
            calculateFontSize(widget.buttonText, buttonHeight, currentLocale);
        break;
      case ButtonType
            .getstarted: //for get started on login page for frailty & LVAD
        buttonWidth = screenWidth * 0.37;
        buttonHeight = screenHeight * 0.052;
        buttonColour = ColorPalette.materialGreen;
        fontsize = buttonHeight * 0.4;
        break;
      default:
        buttonWidth = screenWidth * 0.1;
        buttonHeight = screenHeight * 0.09375;
        buttonColour = ColorPalette.materialGreen;
        fontsize = buttonHeight * 0.3;
        break;
    }

    return SizedBox(
      height: buttonHeight,
      width: buttonWidth,
      child: TextButton(
        onPressed: widget.disabled
            ? null
            : () {
                _debouncer.run(() {
                  widget
                      .onTap(); // Execute onTap callback after debounceDuration
                });
              },
        style: TextButton.styleFrom(
            backgroundColor: widget.disabled
                ? ColorPalette.greyDisabledButtonWidgetBorder
                : buttonColour,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.only(bottom: 0.5)),
        child: Text(
          widget.buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorPalette.colorAppBackground,
            fontSize: fontsize,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
    );
  }
}
