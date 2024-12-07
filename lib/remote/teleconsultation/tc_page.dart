import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:simple_kiosk_software/blocs/locale/locale_bloc.dart';
import 'package:simple_kiosk_software/common/header.dart';
import 'package:simple_kiosk_software/remote/blocs/appointment/appointment_bloc.dart';
import 'package:simple_kiosk_software/remote/blocs/realtime_db/realtime_db_bloc.dart';
import 'package:simple_kiosk_software/remote/blocs/teleconsultation/teleconsultation_bloc.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/remote/general_widgets/kiosk_manager.dart';
import 'package:simple_kiosk_software/remote/models/notifications/appointment_notification.dart';
import 'package:simple_kiosk_software/remote/results/result_list.dart';
import 'package:simple_kiosk_software/remote/teleconsultation/meeting_room.dart';
import 'package:simple_kiosk_software/remote/teleconsultation/tc_navigation.dart';
import 'package:simple_kiosk_software/remote/config/settings.dart';
import 'package:simple_kiosk_software/remote/vitals/measurement_body/blood_oxygen_measurement.dart';
import 'package:simple_kiosk_software/remote/vitals/measurement_body/body_comp_measurement.dart';
import 'package:simple_kiosk_software/remote/vitals/measurement_body/bp_measurement.dart';
import 'package:simple_kiosk_software/remote/vitals/measurement_body/ecg_measurement.dart';
import 'package:simple_kiosk_software/remote/vitals/measurement_body/htwt_measurement.dart';
import 'package:simple_kiosk_software/remote/vitals/measurement_body/temp_measurement.dart';
import 'package:simple_kiosk_software/remote/vitals/start_stop_button.dart';
import 'package:simple_kiosk_software/remote/services/websocket.dart';
import 'package:simple_kiosk_software/remote/utils/app_constants.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:medlyves_mobile_components/blocs/hms_room_overview/room_overview_bloc.dart';
import 'package:medlyves_mobile_components/blocs/hms_room_overview/room_overview_event.dart';
import 'package:medlyves_mobile_components/blocs/hms_room_overview/room_overview_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:simple_kiosk_software/utils/kiosk_config.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'dart:math' as math;

class TCMeetingScreen extends StatelessWidget {
  Map<String, dynamic>? arguments;

  TCMeetingScreen({Key? key, required this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomOverviewBloc(false, false, false, false)
        ..add(const RoomOverviewSubscriptionRequested()),
      child: TCMeetingScreenContent(
        displayName: arguments?["displayName"],
        appointmentId: arguments?["appointmentId"],
      ),
    );
  }
}

class TCMeetingScreenContent extends StatefulWidget {
  final String? displayName;
  final String? appointmentId;

  const TCMeetingScreenContent({Key? key, this.displayName, this.appointmentId})
      : super(key: key);

  @override
  _TCMeetingScreenContentState createState() => _TCMeetingScreenContentState();
}

class _TCMeetingScreenContentState extends State<TCMeetingScreenContent> {
  bool startButtonPressed = false;
  bool deviceStart = false;
  VideoPlayerController _controller =
      VideoPlayerController.asset('assets/videos/en/welcome_EN.mp4');
  late String videoUrl;
  int selectedDevice = 3;
  // final WebSocketService _webSocketService = WebSocketService();
  String authToken = '';
  String header = '';
  String videoName = '';
  bool isUIRendered = false;
  String deviceHeader = '';
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isUIRendered = true;
      });
      getPermissions();
      //_connectToWebSocket();
    });
  }

  // void _initializeVideoController() {
  //   videoUrl = getVideoUrlByStep(deviceToStep(selectedDevice));
  //   _controller = VideoPlayerController.asset(videoUrl)
  //     ..initialize().then((_) => setState(() {}))
  //     ..setLooping(false)
  //     ..play();
  // }

  @override
  void dispose() {
    _controller.dispose();
    //_webSocketService.close();
    super.dispose();
  }

  // Future<void> _connectToWebSocket() async {
  //   const wsPrefix = 'wss://';
  //   final decodedApptID = widget.appointmentId!;
  //   final url = '$wsPrefix$host/ws/$decodedApptID/kiosk';
  //
  //   await _webSocketService.connect(
  //     url,
  //     _handleWebSocketData,
  //     _handleWebSocketError,
  //     _handleWebSocketDone,
  //   );
  // }

  // void _handleWebSocketData(dynamic data) {
  //   print("websocket Data received......$data");
  //   final jsonString = data.toString();
  //   if (jsonString.contains('"command":"end"')) {
  //     print("websocket Data ended......$data");
  //     _handleWebSocketEnd();
  //   } else if (jsonString.contains('"command":"connect_ack"')) {
  //     log('Websocket connected-----------');
  //   } else if (jsonString.contains('"command":"device"')) {
  //     _handleDeviceCommand(jsonString);
  //   } else if (jsonString.contains('"command":"stop_device"')) {
  //     _handleStopDeviceCommand();
  //   }
  // }

  // void _handleWebSocketEnd() {
  //   print("websocket ended by doctor");
  //   context.read<RoomOverviewBloc>().add(const RoomOverviewLeaveRequested());
  //   context
  //       .read<AppointmentBloc>()
  //       .add(SendStopEvent(kioskId: AppConfig().kioskId));
  //   Navigator.of(context).pop();
  // }

  // Future<void> _handleDeviceCommand(String jsonString) async {
  //   final deviceGroup = _extractDeviceGroup(jsonString);
  //
  //   if (deviceGroup != null) {
  //     if (isUIRendered) {
  //       selectedDevice = deviceGroup;
  //       await updateVideoName();
  //
  //       setState(() {
  //         deviceStart = true;
  //         startButtonPressed = true;
  //       });
  //       BlocProvider.of<TeleconsultationBloc>(context)
  //           .add(StartDeviceEvent(handleDeviceType(selectedDevice)));
  //     }
  //   } else {
  //     log("Device group not found in JSON string: $jsonString");
  //   }
  // }
  //
  // void _handleStopDeviceCommand() {
  //   setState(() {
  //     deviceStart = false;
  //     startButtonPressed = false;
  //   });
  //   BlocProvider.of<TeleconsultationBloc>(context)
  //       .add(StopDeviceEvent(handleDeviceType(selectedDevice)));
  // }

  Future<void> handleDeviceUpdate(BuildContext context, int? device) async {
    if (device == null) {
      await _controller.dispose();
      setState(() {
        deviceStart = false;
        startButtonPressed = false;
      });
      videoName = "";
      BlocProvider.of<TeleconsultationBloc>(context)
          .add(StopDeviceEvent(handleDeviceType(selectedDevice)));
    } else if (!deviceStart) {
      if (isUIRendered) {
        setState(() {
          selectedDevice = device;
          deviceStart = true;
          startButtonPressed = true;
        });
        await updateVideoName();
        if (context.mounted) {
          BlocProvider.of<TeleconsultationBloc>(context)
              .add(StartDeviceEvent(handleDeviceType(selectedDevice)));
        }
      }
    }
  }

  handleAppointmentCompleted(BuildContext context) {
    context.read<RoomOverviewBloc>().add(const RoomOverviewLeaveRequested());
    context
        .read<AppointmentBloc>()
        .add(SendStopEvent(kioskId: KioskConfig().kioskId));
    Navigator.of(context).pop();
  }

  DeviceType handleDeviceType(int selectedDevice) {
    switch (selectedDevice) {
      case 1:
        return DeviceType.HEIGHT_DEVICE; // Height & Weight
      case 3:
        return DeviceType.TEMP_DEVICE; // Temperature
      case 4:
        return DeviceType.BP_DEVICE; // Blood Pressure
      case 2:
        return DeviceType.BC_DEVICE; // Body Composition
      case 5:
        return DeviceType.BO_DEVICE; // Oxygen Saturation
      case 6:
        return DeviceType.ECG_DEVICE; // ECG
      default:
        return DeviceType.HEIGHT_DEVICE; // Default
    }
  }

  // int? _extractDeviceGroup(String jsonString) {
  //   try {
  //     final Map<String, dynamic> json = jsonDecode(jsonString);
  //     return json['device_group'];
  //   } catch (e) {
  //     log('Error parsing JSON: $e');
  //     return null;
  //   }
  // }
  //
  // void _handleWebSocketError(dynamic error) {
  //   print("websocket error......$error");
  // }
  //
  // void _handleWebSocketDone() {
  //   if (!_webSocketService.isManuallyClosed) {
  //     print("websocket reconnect......");
  //     _connectToWebSocket();
  //   } else {
  //     print("websocket done......");
  //     _webSocketService.close();
  //   }
  // }

  Future<void> updateVideoName() async {
    videoName = getVideoUrlByStep(deviceToStep(selectedDevice));
    videoUrl = videoName;
    await updateVideoUrl();
  }

  Future<void> updateVideoUrl() async {
    await _controller.dispose();
    _controller = VideoPlayerController.file(File(videoName))
      ..initialize().then((_) => setState(() {}))
      ..setLooping(false)
      ..play();
  }

  int deviceToStep(int selectedDevice) {
    switch (selectedDevice) {
      case 1:
        return 1; // Height & Weight
      case 3:
        return 2; // Temperature
      case 4:
        return 3; // Blood Pressure
      case 2:
        return 4; // Body Composition
      case 5:
        return 5; // Oxygen Saturation
      case 6:
        return 6; // ECG
      default:
        return 1; // Default
    }
  }

  String getVideoUrlByStep(int step) {
    final type = MeasurementType.values[step - 1];
    final info = measurementTypeVideos[type];
    String localeCode =
        BlocProvider.of<LocaleCubit>(context).locale.languageCode;
    if (localeCode == 'th') {
      return info?.videos['Thai']?.startMeasureVid ?? '';
    } else if (localeCode == 'zh') {
      return info?.videos['Chinese']?.startMeasureVid ?? '';
    } else {
      return info?.videos['English']?.startMeasureVid ?? '';
    }
  }

  Future<void> getPermissions() async {
    await Permission.camera.request();
    await Permission.microphone.request();
    await Permission.bluetoothConnect.request();
    while ((await Permission.camera.isDenied)) {
      await Permission.camera.request();
    }
    while ((await Permission.microphone.isDenied)) {
      await Permission.microphone.request();
    }
    while ((await Permission.bluetoothConnect.isDenied)) {
      await Permission.bluetoothConnect.request();
    }
  }

  hangUp() {}

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: BlocProvider(
          create: (context) {
            String? apptId = widget.appointmentId;
            String? newDocPath = apptId == null ? null : 'appointments/$apptId';
            return RealtimeDbBloc(newDocPath);
          },
          child: Scaffold(
            body: Column(
              children: [
                BlocListener<RealtimeDbBloc, RealtimeDbState>(
                    child: Container(),
                    listener: (context, state) async {
                      try {
                        AppointmentNotification notification =
                            AppointmentNotification.fromJson(state.payload);
                        if (notification.status == 'COMPLETED') {
                          handleAppointmentCompleted(context);
                          return;
                        }
                        handleDeviceUpdate(context, notification.device);
                      } catch (e) {
                        debugPrint(
                            'Failed to handle appointment notification: $e');
                      }
                    }),
                //const Header(),
                SizedBox(
                  height: height * 0.33,
                  child: deviceStart
                      ? Center(
                          child: _controller.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                )
                              : SizedBox(
                                  height: height * 0.33,
                                  child: const Center(
                                      child: CircularProgressIndicator()),
                                ),
                        )
                      : Center(
                          child:
                              BlocListener<AppointmentBloc, AppointmentState>(
                            listener: (context, state) {},
                            child:
                                BlocConsumer<AppointmentBloc, AppointmentState>(
                              listener: (context, state) {
                                if (state is AppointmentLoading) {
                                  const CircularProgressIndicator();
                                }
                                if (state is AppointmentEnd) {
                                  const CircularProgressIndicator();
                                }
                                if (state is TeleconsultTokenReceived) {
                                  context.read<RoomOverviewBloc>().add(
                                      RoomOverviewJoinRequested(
                                          'P', state.tcDetails.token));
                                }
                              },
                              builder: (context, state) {
                                if (state is TeleconsultTokenReceived) {
                                  authToken = state.tcDetails.token;
                                  return MeetingPage(
                                    onLeaveButtonPress: hangUp,
                                    showOnlyRemotePeer: false,
                                    meetingWidgetHeight: height * 0.33,
                                  );
                                }
                                return Container(
                                  color: Colors.black,
                                );
                              },
                            ),
                          ),
                        ),
                ),
                Expanded(child: Builder(builder: (context) {
                  //return const ResultList();
                  return deviceStart
                      ? selectDeviceMeasurement()
                      : const ResultList();
                })),
                SizedBox(
                  height: height * 0.05,
                  child: BlocBuilder<RoomOverviewBloc, RoomOverviewState>(
                    builder: (context, state) {
                      return TCNavigation(
                        displayName: widget.displayName ?? '',
                        onExit: () {
                          log('Exit pressed');
                          log("exit 100ms video call");
                          context
                              .read<RoomOverviewBloc>()
                              .add(const RoomOverviewLeaveRequested());
                          context
                              .read<AppointmentBloc>()
                              .add(SendStopEvent(kioskId: KioskConfig().kioskId));
                        },
                        isEndbuttonVisible: !deviceStart,
                      );
                    },
                  ),
                ),
                Footer()
              ],
            ),
          )),
    );
  }

  Widget selectDeviceMeasurement() {
    int step = deviceToStep(selectedDevice);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    Widget measurementWidget;
    switch (step) {
      case 1:
        deviceHeader = AppLocalizations.of(context)!.hw;
        measurementWidget = HtWtMeasurement();
        break;
      case 2:
        deviceHeader = AppLocalizations.of(context)!.temperature;
        measurementWidget = const TempMeasurement();
        break;
      case 3:
        deviceHeader = AppLocalizations.of(context)!.blood_pressure;
        measurementWidget = const BPMeasurement();
        break;
      case 4:
        deviceHeader = AppLocalizations.of(context)!.bcm;
        measurementWidget = const BodyCompMeasurement();
        break;
      case 5:
        deviceHeader = AppLocalizations.of(context)!.bo;
        measurementWidget = const BloodOxygenMeasurement();
        break;
      case 6:
        deviceHeader = AppLocalizations.of(context)!.ecg;
        measurementWidget = const ECGMeasurement();
        break;
      default:
        deviceHeader = '';
        measurementWidget = Container();
    }
    return Stack(children: [
      Container(
        color: ColorPalette.colorAppTheme,
        height: 47.h,
        padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 3.w, bottom: 1.w),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
          ),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.w),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            deviceHeader,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.dp,
                                fontWeight: FontWeight.bold),
                          ),
                          StartStopButton(
                            color:
                                startButtonPressed ? Colors.red : Colors.blue,
                            buttonName: startButtonPressed
                                ? AppLocalizations.of(context)!.stop
                                : AppLocalizations.of(context)!.start,
                            onPressed: _onStartStopButtonPressed,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      measurementWidget,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Positioned(
          right: 35,
          bottom: 20,
          child: SizedBox(
              height: math.max(screenHeight * 0.04, 150),
              width: math.max(screenWidth * 0.2, 160),
              child: MeetingPage(
                onLeaveButtonPress: hangUp,
                showOnlyRemotePeer: true,
                meetingWidgetHeight: math.max(screenHeight * 0.04, 150),
              )))
    ]);
  }

  void _onStartStopButtonPressed() {
    setState(() {
      startButtonPressed = !startButtonPressed;
    });
    if (!startButtonPressed) {
      BlocProvider.of<TeleconsultationBloc>(context)
          .add(StopDeviceEvent(handleDeviceType(selectedDevice)));
      setState(() {
        deviceStart = false;
        startButtonPressed = false;
      });
    } else if (startButtonPressed && isUIRendered) {
      BlocProvider.of<TeleconsultationBloc>(context)
          .add(StartDeviceEvent(handleDeviceType(selectedDevice)));
    }
  }
}
