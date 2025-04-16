import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EndApptButton extends StatelessWidget {
  final VoidCallback? navigation;

  EndApptButton({
    super.key,
    required this.navigation,
  });

  double width = 0;
  double height = 0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height * 0.08,
      width: width * 0.5,
      child: OutlinedButton.icon(
          onPressed: () => navigation!(),
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.white,
            size: height * 0.025,
          ),
          label: Text(
            AppLocalizations.of(context)!.end_appt,
            style: TextStyle(color: Colors.white, fontSize: height * 0.02),
          ),
          style: ButtonStyle(
            // backgroundColor:
            //     MaterialStatePropertyAll(ColorPalette.colorAppTheme),
            side: MaterialStateProperty.resolveWith<BorderSide>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  // Return the outline color for the pressed state if needed
                  return const BorderSide(color: Colors.white, width: 1.0);
                }
                // Return the default outline color for other states
                return const BorderSide(color: Colors.white, width: 2.0);
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(17.0), // Adjust the radius as needed
              ),
            ),
          )),
    );
  }
}
