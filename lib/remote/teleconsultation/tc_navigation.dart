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

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("this tc_navigation");
    }
    return Container(
      height: 7.h,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
      color: ColorPalette.colorAppTheme,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.displayName,
            style: TextStyle(
                fontSize: 10.dp,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(
            width: 2.w,
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
