import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum MiscCardType { ClientDetails }

class MiscCard extends StatelessWidget {
  final Map<String, dynamic> userDetails;
  final TextStyle? style;
  final TextAlign textAlign;

  const MiscCard({
    Key? key,
    required this.userDetails,
    this.style,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = Localizations.localeOf(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final baseFontSize = screenHeight * 0.018;
    final cardWidth = screenWidth * 0.87;
    final cardHeight = currentLocale.languageCode == 'ta'
        ? screenHeight * 0.115
        : screenHeight * 0.095;
    final boxHeight = screenHeight * 0.015;
    TextStyle defaultStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: baseFontSize,
      color: Colors
          .black, // Ensures text color is explicitly set, aiding readability.
    );
    // Extract values from userDetails map
    final String patientId = userDetails['patientId'] ?? '';
    final String gender = userDetails['gender'] ?? '';
    final String age = userDetails['age'] ?? '';

    return Container(
      height: cardHeight,
      width: cardWidth,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(color: ColorPalette.materialGreen, width: 2.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicWidth(
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.client_details,
                  style: defaultStyle,
                ),
                Container(
                  color: ColorPalette.darkGrey,
                  height: 1,
                ),
              ],
            ),
          ),
          SizedBox(height: boxHeight),
          currentLocale.languageCode == 'ta'
              ? Row(
                  children: [
                    SizedBox(
                      width: cardWidth * 0.03,
                    ),
                    Column(
                      children: [
                        SizedBox(
                            width: cardWidth * 0.45,
                            child: buildPatientID(
                                AppLocalizations.of(context)!.patient_id,
                                patientId,
                                defaultStyle,
                                currentLocale)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildDetailText(AppLocalizations.of(context)!.gender,
                            gender, defaultStyle),
                        buildDetailText(AppLocalizations.of(context)!.age, age,
                            defaultStyle),
                      ],
                    ),
                  ],
                )
              : Padding(
                  padding: EdgeInsets.only(right: cardWidth * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: cardWidth * 0.45,
                          child: buildPatientID(
                              AppLocalizations.of(context)!.patient_id,
                              patientId,
                              defaultStyle,
                              currentLocale)),
                      buildDetailText(AppLocalizations.of(context)!.gender,
                          gender, defaultStyle),
                      buildDetailText(
                          AppLocalizations.of(context)!.age, age, defaultStyle),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget buildDetailText(String label, String value, TextStyle baseStyle) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: "$label ", style: baseStyle),
          TextSpan(
            text: value,
            style: baseStyle.copyWith(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget buildPatientID(
      String label, String value, TextStyle baseStyle, Locale currentLocale) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(text: "$label ", style: baseStyle),
          TextSpan(
            text: value,
            style: baseStyle.copyWith(fontWeight: FontWeight.normal),
          ),
        ],
      ),
      maxLines: currentLocale.languageCode == 'ta' ? 2 : 1,
    );
  }
}
