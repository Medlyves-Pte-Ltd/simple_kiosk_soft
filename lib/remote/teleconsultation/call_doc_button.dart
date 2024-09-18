import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CallDoctorButton extends StatelessWidget {
  final VoidCallback callDoctorPressed;
  const CallDoctorButton({
    super.key,
    required this.callDoctorPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 3.5.h,
      width: 27.w,
      child: OutlinedButton.icon(
          onPressed: callDoctorPressed,
          icon: Icon(
            Icons.call,
            color: Colors.white,
            size: 11.dp,
          ),
          label: Text(
            AppLocalizations.of(context)!.call_doc,
            style: TextStyle(color: Colors.white, fontSize: 9.dp),
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
