import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum GenderLabel { gender }

class DropDownField extends StatefulWidget {
  final GenderLabel label;
  final Function(String?) onChanged;

  const DropDownField({Key? key, required this.label, required this.onChanged})
      : super(key: key);

  @override
  State<DropDownField> createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final dropdownHeight = screenHeight * 0.05;
    final dropdownWidth = screenWidth * 0.53;
    final fontSize = screenHeight * 0.02;
    final boxWidth = screenWidth * 0.017;
    String text;
    List<String> genderOptions = [
      AppLocalizations.of(context)!.male,
      AppLocalizations.of(context)!.female,
    ];

    switch (widget.label) {
      case GenderLabel.gender:
        text = AppLocalizations.of(context)!.gender;
        break;
      default:
        text = "";
    }

    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(35),
      borderSide: const BorderSide(
        color: ColorPalette.greyDisabledButtonWidgetBorder,
        width: 1.0,
      ),
    );

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
          height: dropdownHeight,
          width: dropdownWidth,
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              value: selectedGender,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: dropdownHeight / 4, horizontal: boxWidth * 2),
                  border: border,
                  focusedBorder: border,
                  enabledBorder: border),
              onChanged: (String? newValue) {
                setState(() {
                  selectedGender = newValue;
                });
                // Call the onChanged callback provided by the parent
                widget.onChanged(newValue);
              },
              items: genderOptions.map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(
                    gender,
                    style: TextStyle(
                      fontSize: fontSize * 0.5,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
