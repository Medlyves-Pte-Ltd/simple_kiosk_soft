import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:simple_kiosk_software/remote/blocs/liveness/liveness_bloc.dart';
import 'package:simple_kiosk_software/remote/utils/app_constants.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class DateTimeSection extends StatefulWidget {
  const DateTimeSection({super.key});

  @override
  State<DateTimeSection> createState() => _DateTimeSectionState();
}

class _DateTimeSectionState extends State<DateTimeSection> {
  DateTime _currentDateTime = DateTime.now();
  Timer? _timer;
  late bool _isConnected = false;
  ConnectivityResult connectivityResult = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    checkForInternet();
  }

  void checkForInternet() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _currentDateTime = DateTime.now();
          });
          isConnectedToInternet();
        } else {
          timer.cancel();
        }
      });
    });
  }

  void isConnectedToInternet() async {
    connectivityResult = await Connectivity().checkConnectivity();
    if (mounted) {
      setState(() {
        _isConnected = connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi;
      });
    }
  }

  @override
  void dispose() {
    // Cancel the Timer in the dispose() method
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 25.h, // Expand the width to the screen width
      padding: EdgeInsets.only(top: 8.h, bottom: 1.h, left: 4.w, right: 4.w),
      color: ColorPalette.colorAppTheme,
      child: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                formatDate(_currentDateTime),
                style: TextStyle(
                  fontSize: 30.dp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 1.5.h),
              Icon(
                _isConnected ? Icons.wifi : Icons.wifi_off,
                size: 35.dp,
              ),
              SizedBox(width: 1.5.h),
              BlocBuilder<LivenessBloc, LivenessState>(
                builder: (BuildContext context, LivenessState state) {
                  return Icon(
                    state.isConnected
                        ? Icons.cloud_done_outlined
                        : Icons.cloud_off,
                    size: 35.dp,
                  );
                },
              ),
            ]),
            SizedBox(height: 1.h),
            Text(
              formatTime(_currentDateTime),
              style: TextStyle(fontSize: 20.dp, color: Colors.black),
            ),
            SizedBox(height: 1.h),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss a').format(dateTime);
  }
}
