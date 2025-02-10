import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/device_data/code_scanner_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_devices_sdk/devices/device_config.dart';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:simple_kiosk_software/remote/blocs/appointment/appointment_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_bloc.dart';
import 'package:simple_kiosk_software/blocs/locale/locale_bloc.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/common/header.dart';
import 'package:simple_kiosk_software/common/video_widget.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:simple_kiosk_software/utils/body_range.dart';
import 'package:simple_kiosk_software/utils/control_measure_page_utils.dart';
import 'package:simple_kiosk_software/utils/kiosk_config.dart';
import 'package:simple_kiosk_software/utils/scanner_utils.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';

class ScannerPage extends StatefulWidget {
  @override
  ScannerPageState createState() => ScannerPageState();
}

class ScannerPageState extends State<ScannerPage> {
  late final AppointmentBloc appointmentBloc;
  // 数据默认值
  String dataDefaultValue = "- - -";
  // 当前播放的视频文件
  String curPlayFile = "";
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;
  // StatelessWidget需要保存上下文才能进行页面跳转，翻译
  late BuildContext mainContext;
  // 扫码数据
  late Map<String, dynamic> scannerData;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 10), () async {
      // 扫码设备能否使用
      if (DeviceConfig().deviceEnable(DeviceType.SCANNER_DEVICE)) {
        // 打开扫码器
        try {
          await ScannerUtils().connect();
        } catch (e) {
          String error = "Scanner open failed, Error:$e";
          LogPrinter.log(error);
          Fluttertoast.showToast(msg: error);
        }
      }
    });
    ScannerUtils().listenData = listenScannerData;
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 监听扫码器数据
  Future<void> listenScannerData(String data) async {
    // 测试id ZGVtbzFAbWVkbHl2ZXMuY29t_walkin_TC
    String patientId = "";
    // 判断时候是json数据
    int endPos = data.indexOf('_');
    if (endPos != -1) {
      patientId = data.substring(0, endPos);
    } else {
      Fluttertoast.showToast(msg: "The QR code data format is incorrect!");
      return;
    }

    // 解析json数据
    LogPrinter.log("qr code normal data:$data");
    try {
      var appointmentBloc = BlocProvider.of<AppointmentBloc>(context);

      try {
        await appointmentBloc.appointmentRepository
            .endKioskApptEvent(KioskConfig().kioskId);
      } catch (e) {
        LogPrinter.log("${KioskConfig().kioskId} TC Stop Event Error:$e");
      }

      await appointmentBloc.appointmentRepository
          .sendStartEvent(data, KioskConfig().kioskId);
      await appointmentBloc.appointmentRepository.getUserDetails(data);
      Map<String, dynamic> userData =
          appointmentBloc.appointmentRepository.data;
      // 判断是否是远程医疗
      if (data.contains("_TC")) {
        UserInfo().teleconsultation = true;
      } else {
        UserInfo().teleconsultation = false;
      }
      UserInfo().name = userData["name"];
      UserInfo().age = userData["age"];
      UserInfo().gender = userData["gender"] == "Female" ? 0 : 1;
      UserInfo().clearResult();
    } catch (e) {
      Fluttertoast.showToast(
          msg: "User information acquisition failed!, Error:$e");
      return;
    }

    // 判断用户信息是否为空
    if (UserInfo().name.isEmpty || UserInfo().age.isEmpty) {
      Fluttertoast.showToast(msg: "User information is incorrect!");
      return;
    }

    ScannerUtils().listenData = null;
    ControlMeasurePageUtils().pageIndex = 0;
    ControlMeasurePageUtils().clearMeasure();

    // 范围根据性别获取
    BodyRange().init();
    // // 关闭扫码器
    // stopScanner(context);
    // 跳转到测试页面
    Navigator.pushNamedAndRemoveUntil(mainContext,
        ControlMeasurePageUtils().firstMeasurePage(), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    mainContext = context;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    init();
    return Scaffold(
      backgroundColor: ColorPalette.colorAppBackground,
      body: Column(
        children: [
          const Header(),
          buildVideoArea(),
          SizedBox(
            height: height * 0.018,
          ),
          SizedBox(
            height: height * 0.29,
            child: buildTipInfoArea(),
          ),
          buildQrCode(),
          const Spacer(),
          buildBackBtn(),
          Footer(),
        ],
      ),
    );
  }

  Widget buildQrCode() {
    return BlocListener<DeviceBloc, DeviceState>(
        listener: (context, state) {
          if (state is DeviceDataUpdated &&
              state.deviceData is CodeScannerData) {
            String data = (state.deviceData as CodeScannerData).scanner;
            Future.delayed(Duration(milliseconds: 10), () async {
              await listenScannerData(data);
            });

            // if (scannerText != data) {
            //   scannerText = data;
            //   Future.delayed(Duration(milliseconds: 10), () async {
            //     await listenScannerData(scannerText);
            //   });
            // }
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onDoubleTap: () {
                if (KioskConfig().envType == "dev_env") {
                  // 开发分支的二维码
                  listenScannerData("ZGVtbzFAbWVkbHl2ZXMuY29t_walkin_TC");
                } else {
                  // 泰国测试人员二维码
                  listenScannerData(
                      "cGVlcmFkYS50YXdvbmdAbmVvcG93ZXJtZWQuY29t_walkin_TC");
                  // 无远程医疗功能 _HS结尾
                  //listenScannerData("ZGVtbzFAbWVkbHl2ZXMuY29t_walkin_HS");
                  // David信息
                  //listenScannerData("ZGF2aWQud29uZ0BtZWRseXZlcy5jb20=_walkin_TC");
                }
              },
              child: Image.asset(
                "assets/images/qr-code.png",
                height: width * 0.2,
                width: width * 0.2,
              ),
            ),
            Image.asset(
              "assets/images/red_down_arrow.png",
              height: width * 0.06,
            ),
          ],
        ));
  }

  Widget buildTipInfoArea() {
    String localeCode =
        BlocProvider.of<LocaleCubit>(mainContext).locale.languageCode;

    return Row(
      children: [
        SizedBox(width: width * 0.08),
        SizedBox(
          width: width * 0.45,
          child: Column(
            children: [
              Text(
                AppLocalizations.of(mainContext)!.scanner_title,
                textAlign: TextAlign.left,
                softWrap: true,
                style: TextStyle(
                  fontSize: localeCode == "ta" ? height * 0.02 : height * 0.028,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Text(
                AppLocalizations.of(mainContext)!.scanner_tip,
                textAlign: TextAlign.left,
                softWrap: true,
                style: TextStyle(
                  fontSize:
                      localeCode == "ta" ? height * 0.018 : height * 0.022,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        SizedBox(
            width: width * 0.35,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(height * 0.01),
                    width: width * 0.25,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey, // 阴影颜色
                              offset: Offset(-10, 10), //阴影xy轴偏移量
                              blurRadius: 25.0, //阴影模糊程度
                              spreadRadius: 5 //阴影扩散程度
                              )
                        ]),
                    child: Image.asset("assets/images/Medlyves_logo_only.png"),
                  ),
                  SizedBox(height: height * 0.008),
                  Text(
                    "Medlyves",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: height * 0.018,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            )),
        SizedBox(width: width * 0.05),
      ],
    );
  }

  // 返回按钮
  Widget buildBackBtn() {
    return Container(
      height: height * 0.08,
      padding: EdgeInsets.only(
          top: height * 0.01, bottom: height * 0.01, right: width * 0.05),
      child: Row(
        children: [
          const Spacer(),
          InkWell(
            onTap: () {
              KioskConfig().healthScreeningMode =
                  HealthScreeningMode.standalone;
              KioskConfig().teleConsultationMode = TeleConsultationMode.off;
              Navigator.of(context).pop();
            },
            child: Container(
                height: height * 0.03,
                width: width * 0.15,
                decoration: BoxDecoration(
                  color: ColorPalette.materialGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(mainContext)!.back,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: height * 0.015,
                        fontWeight: FontWeight.w600),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  // 播放视频区域
  Widget buildVideoArea() {
    return VideoWidget(
        key: GlobalKey(),
        videoName: curPlayFile,
        setLooping: false,
        fromFile: true);
  }

  void init() {
    if (curPlayFile.isEmpty) {
      curPlayFile = getVideoFileName();
    }
  }

  String getVideoFileName() {
    String localeCode =
        BlocProvider.of<LocaleCubit>(mainContext).locale.languageCode;
    String videoFileName = 'qr_code_${localeCode.toUpperCase()}.mp4';
    return '${AppConfig().videosDir}/$localeCode/$videoFileName';
  }
}
