import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:simple_kiosk_software/remote/general_widgets/popup_dialog.dart';
import 'package:simple_kiosk_software/remote/teleconsultation/end_appt_button.dart';
import 'package:simple_kiosk_software/remote/utils/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TCNavigation extends StatefulWidget {
  final String displayName;
  final VoidCallback onExit;
  final bool isEndbuttonVisible;

  const TCNavigation({
    super.key,
    this.isEndbuttonVisible = true,
    required this.displayName,
    required this.onExit,
  });

  @override
  State<TCNavigation> createState() => _TCNavigationState();
}

class _TCNavigationState extends State<TCNavigation> {
  bool isCallDoctorButtonVisible = true;

  double width = 0;
  double height = 0;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("this tc_navigation");
    }

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.1,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
      color: ColorPalette.colorAppTheme,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.displayName,
            style: TextStyle(
                fontSize: height * 0.02,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(
            width: width * 0.01,
          ),
          widget.isEndbuttonVisible
              ? EndApptButton(navigation: _showExitConfirmationDialog)
              : Container(),
        ],
      ),
    );
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupDialog(
          title: AppLocalizations.of(context)!.cfm_exit,
          subtitle: AppLocalizations.of(context)!.cfm_end_appt,
          showCancelButton: true,
          showOkButton: false,
          showConfirmButton: true,
          onPressedConfirm: () {
            Navigator.of(context).pop(); // close dialog
            widget.onExit(); // Call the exit callback
          },
        );
      },
    );
  }
}
