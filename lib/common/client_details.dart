import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';

class ClientDetails extends StatelessWidget {
  final TextStyle? style;
  final TextAlign textAlign;

  const ClientDetails({
    Key? key,
    this.style,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final baseFontSize = screenHeight * 0.018;
    final cardWidth = screenWidth * 0.87;
    final cardHeight = screenHeight * 0.085;
    final boxHeight = screenHeight * 0.01;

    TextStyle defaultStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: baseFontSize,
      color: Colors
          .black, // Ensures text color is explicitly set, aiding readability.
    );

    return Container(
      height: cardHeight,
      width: cardWidth,
      padding: const EdgeInsets.all(6),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildDetailText(AppLocalizations.of(context)!.name,
                  UserInfo().name, defaultStyle),
              buildDetailText(
                  AppLocalizations.of(context)!.gender,
                  UserInfo().gender == 1
                      ? AppLocalizations.of(context)!.male
                      : AppLocalizations.of(context)!.female,
                  defaultStyle),
              buildDetailText(AppLocalizations.of(context)!.age, UserInfo().age,
                  defaultStyle),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDetailText(String label, String value, TextStyle baseStyle) {
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
    );
  }
}
