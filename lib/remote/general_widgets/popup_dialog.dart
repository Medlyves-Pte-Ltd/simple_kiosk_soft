import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PopupDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showCancelButton;
  final bool showOkButton;
  final bool showConfirmButton;
  final VoidCallback? onPressedConfirm;

  const PopupDialog(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.showCancelButton,
      required this.showOkButton,
      required this.showConfirmButton,
      required this.onPressedConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(subtitle),
      actions: <Widget>[
        showConfirmButton
            ? TextButton(
                onPressed: onPressedConfirm,
                child: Text(AppLocalizations.of(context)!.confirm))
            : const SizedBox(),
        showCancelButton
            ? TextButton(
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: const TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : const SizedBox(),
        showOkButton
            ? TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(), // Close the dialog
                child: Text(AppLocalizations.of(context)!.ok),
              )
            : const SizedBox(),
      ],
    );
  }
}
