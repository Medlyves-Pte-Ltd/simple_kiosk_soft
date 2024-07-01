import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/providers/stepperprovider.dart';
import 'package:provider/provider.dart';

enum TextFieldLabel {
  patientId,
  age,
}

class LoginTextField extends StatefulWidget {
  final TextFieldLabel textfieldType;
  final Function(String) onChanged;

  const LoginTextField({
    Key? key,
    required this.textfieldType,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  final FocusNode _textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textFieldFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _textFieldFocusNode.removeListener(_onFocusChange);
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    final stepper = Provider.of<StepperProvider>(context, listen: false);
    if (_textFieldFocusNode.hasFocus) {
      stepper.setFooterVisibility(false);
    } else {
      stepper.setFooterVisibility(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final textfieldHeight = screenHeight * 0.05;
    final textfieldWidth = screenWidth * 0.53;
    final boxWidth = screenWidth * 0.017;
    final fontSize = screenHeight * 0.02;
    String text;

    switch (widget.textfieldType) {
      case TextFieldLabel.patientId:
        text = AppLocalizations.of(context)!.patient_id;
        break;
      case TextFieldLabel.age:
        text = AppLocalizations.of(context)!.age;
        break;
      default:
        text = "";
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(width: boxWidth),
        SizedBox(
          height: textfieldHeight,
          width: textfieldWidth,
          child: TextField(
            focusNode: _textFieldFocusNode,
            keyboardType: getTextInputType(widget.textfieldType),
            maxLength: widget.textfieldType == TextFieldLabel.age ? 2 : null,
            inputFormatters: [
              widget.textfieldType == TextFieldLabel.age
                  ? FilteringTextInputFormatter.digitsOnly
                  : FilteringTextInputFormatter.singleLineFormatter
            ],
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              counterText: "",
              contentPadding: EdgeInsets.symmetric(
                  vertical: textfieldHeight / 4, horizontal: boxWidth * 2),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(35),
                borderSide: const BorderSide(
                  color: ColorPalette.greyDisabledButtonWidgetBorder,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(35),
                borderSide: const BorderSide(
                  color: ColorPalette.greyDisabledButtonWidgetBorder,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextInputType getTextInputType(TextFieldLabel textFieldLabel) {
    TextInputType textinput;
    switch (widget.textfieldType) {
      case TextFieldLabel.patientId:
        textinput = TextInputType.text;
        return textinput;
      case TextFieldLabel.age:
        textinput = TextInputType.number;
        return textinput;
      default:
        return TextInputType.text;
    }
  }
}
