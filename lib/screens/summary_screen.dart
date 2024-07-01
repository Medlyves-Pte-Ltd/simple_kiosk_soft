import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:base_kiosk_software/blocs/device/device_bloc.dart';
import 'package:base_kiosk_software/blocs/device/device_event.dart';
import 'package:base_kiosk_software/common/buttons.dart';
import 'package:base_kiosk_software/common/frailty_other_result_card.dart';
import 'package:base_kiosk_software/common/frailty_result_card.dart';
import 'package:base_kiosk_software/common/layouts/layout1.dart';
import 'package:base_kiosk_software/common/layouts/layout3frailty.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:base_kiosk_software/utils/print_cmd.dart';
import 'package:base_kiosk_software/utils/storage_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:base_kiosk_software/providers/stepperprovider.dart';
import 'package:provider/provider.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  @override
  State<SummaryScreen> createState() => SummaryScreenState();
}

class SummaryScreenState extends State<SummaryScreen> {
  Map<String, String> userDetails = {'patientId': '', 'age': '', 'gender': ''};
  bool isPrinterReady = false;

  @override
  void initState() {
    super.initState();
    // Call getUserDetails when the widget is initialized
    StorageUtils.getData(userDetails.keys.toSet()).then((userDetailsData) {
      setState(() {
        userDetails = userDetailsData;
      });
    }).catchError((error) {
      // Handle error if getUserDetails fails
      print("Error fetching user details: $error");
    });

    PrintCmd.createBitmapImage(context).then((value) => setState(() {
          isPrinterReady = true;
        }));
  }

  @override
  Widget build(BuildContext context) {
    StepperProvider stepperProvider = Provider.of<StepperProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double boxWidth = screenWidth * 0.0639;

    return Scaffold(
        body: Layout1(
      content1: Content2Frailty(
        firstRow: MiscCard(
          userDetails: userDetails,
        ),
        secondRow: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FrailtyCard(cardtype: CardType.HW),
            SizedBox(width: boxWidth),
            const FrailtyCard(cardtype: CardType.BP)
          ],
        ),
        thirdRow: const FrailtyCard(cardtype: CardType.BC),
        navigSpace: GreenButton(
            buttonText: AppLocalizations.of(context)!.end_session,
            onTap: () {
              stepperProvider.resetFrailty();
              handleEndSession(context);
            },
            disabled: !isPrinterReady,
            buttontype: ButtonType.end),
      ),
    ));
  }

  handleEndSession(BuildContext context) async {
    BlocProvider.of<DeviceBloc>(context)
        .add(DeviceConnectEvent(deviceType: DeviceType.PRINTER_DEVICE));
    StorageUtils.clearData();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
