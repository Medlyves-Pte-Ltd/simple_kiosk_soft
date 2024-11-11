import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:simple_kiosk_software/blocs/locale/locale_bloc.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/common/header.dart';
import 'package:simple_kiosk_software/screens/check/audio_player_check.dart';
import 'package:simple_kiosk_software/screens/check/audio_record_check.dart';
import 'package:simple_kiosk_software/screens/check/blood_fit_check.dart';
import 'package:simple_kiosk_software/screens/check/blood_glucose_check.dart';
import 'package:simple_kiosk_software/screens/check/blood_oxygen_check.dart';
import 'package:simple_kiosk_software/screens/check/blood_pressure_check.dart';
import 'package:simple_kiosk_software/screens/check/body_composition_check.dart';
import 'package:simple_kiosk_software/screens/check/body_temperature_check.dart';
import 'package:simple_kiosk_software/screens/check/camera_check_1.dart';
import 'package:simple_kiosk_software/screens/check/camera_check_2.dart';
import 'package:simple_kiosk_software/screens/check/ecg_check.dart';
import 'package:simple_kiosk_software/screens/check/height_check.dart';
import 'package:simple_kiosk_software/screens/check/printer_check.dart';
import 'package:simple_kiosk_software/screens/check/scanner_check.dart';
import 'package:simple_kiosk_software/screens/check/thai_card_check.dart';
import 'package:simple_kiosk_software/screens/check/weight_check.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';

class QuickTestDevicePage extends StatelessWidget {
  late BuildContext mainContext;
  QuickTestDevicePage() {
    UserInfo().name = "User";
    UserInfo().age = "25";
    UserInfo().gender = 1;
    UserInfo().clearResult();
  }

  List<Widget> items = [
    HeightCheck(),
    WeightCheck(),
    BodyTemperatureCheck(),
    BloodOxygenCheck(),
    // BloodFitCheck(),
    // BloodGlucoseCheck(),
    BloodPressureCheck(),
    BodyCompositionCheck(),
    ECGCheck(),
    PrinterCheck(),
    ScannerCheck(),
    ThaiCardCheck(),
    CameraCheck1(),
    CameraCheck2(),
    AudioPlayerCheck(),
    //AudioRecordCheck()
  ];
  // 屏幕宽度
  double width = 0;

  // 屏幕高度
  double height = 0;

  @override
  Widget build(BuildContext context) {
    mainContext = context;
    //BlocProvider.of<LocaleCubit>(context).loadLocale(Locale("zh"));
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Device Test'),
      ),
      body: Column(
        children: [Expanded(child: _renderScrollArea()), Footer()],
      ),
    );
  }

  // 滚动区域
  Widget _renderScrollArea() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: height * 0.01,
        mainAxisSpacing: height * 0.01,
        childAspectRatio: 2 / 3,
      ),
      itemCount: items.length,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return items[index];
      },
    );
  }
}
