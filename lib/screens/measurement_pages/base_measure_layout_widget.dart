import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:simple_kiosk_software/common/client_details.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/common/header.dart';
import 'package:simple_kiosk_software/common/video_widget.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:simple_kiosk_software/utils/control_measure_page_utils.dart';

class BaseMeasureLayoutWidget extends StatelessWidget {
  // 步骤原形图标数量
  final stepCircleCount = 4;
  String videoFile = '';
  String iconFile = "";
  String title = "";
  Color color = ColorPalette.colorheightWeight;
  double width = 0;
  double height = 0;
  DeviceType deviceType = DeviceType.UNKOWN_DEVICE;

  BaseMeasureLayoutWidget({super.key}) {}

  // 子类需要实现的数据显示函数
  Widget buildCardDataShowArea() {
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          _buildVideoArea(),
          _buildStepArea(),
          _buildCardArea(),
          _buildBackNextControlBtn(context),
          const Footer()
        ],
      ),
    );
  }

  // 播放视频区域
  Widget _buildVideoArea() {
    return VideoWidget(videoName: videoFile, setLooping: false);
  }

  // 显示步骤区域
  Widget _buildStepArea() {
    double radius = height * 0.04;
    double interval = width * 0.06;
    return Container(
      height: height * 0.05,
      margin: EdgeInsets.only(
          left: width * 0.2,
          right: width * 0.2,
          top: height * 0.006,
          bottom: height * 0.006),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: buildStepArea(),
      ),
    );
  }

  // 卡片信息区域
  Widget _buildCardArea() {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(color: ColorPalette.darkGrey, width: 1.5),
        color: ColorPalette.colorAppBackground,
      ),
      margin: EdgeInsets.symmetric(horizontal: width * 0.05),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _buildCardTopArea(),
          const SizedBox(height: 30),
          Expanded(child: buildCardDataShowArea()),
          const Spacer(),
          Container(
            margin: EdgeInsets.only(
                left: width * 0.015,
                right: width * 0.015,
                top: height * 0.003,
                bottom: height * 0.003),
            color: ColorPalette.darkGrey,
            height: 1,
          ),
          const ClientDetails(
            userDetails: {'name': "John Doe", 'gender': "Male", 'age': "30"},
          ),
        ],
      ),
    ));
  }

  // 返回下一步控制按钮
  Widget _buildBackNextControlBtn(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: height * 0.01, bottom: height * 0.01, right: width * 0.05),
      child: Row(
        children: [
          const Spacer(),
          InkWell(
            onTap: () {
              ControlMeasurePageUtils().onBackStep(context);
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
                    "Back",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: height * 0.015,
                        fontWeight: FontWeight.w600),
                  ),
                )),
          ),
          SizedBox(
            width: width * 0.03,
          ),
          _buildResultOrNextBtn(context)
        ],
      ),
    );
  }

  // 卡片顶部区域
  Widget _buildCardTopArea() {
    double imageSize = height * 0.05;
    double titleFontSize = height * 0.02;
    double btnFontSize = height * 0.02;
    return Row(
      children: [
        Image.asset(
          iconFile,
          width: imageSize,
          height: imageSize,
        ),
        const SizedBox(width: 5),
        Padding(
          padding: EdgeInsets.symmetric(vertical: height * 0.01),
          child: IntrinsicWidth(
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: titleFontSize),
                ),
                Container(
                  color: color,
                  height: 1.5,
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () async {},
          child: Container(
            height: height * 0.03,
            width: width * 0.15,
            decoration: BoxDecoration(
              color: ColorPalette.materialGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text("Start",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: btnFontSize,
                      color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }

  // 结果或者下一步按钮
  Widget _buildResultOrNextBtn(BuildContext context) {
    if (ControlMeasurePageUtils().pageIndex !=
        ControlMeasurePageUtils().measurelist.length - 1) {
      return InkWell(
        onTap: () {
          ControlMeasurePageUtils().onNextStep(context);
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
                "Next",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: height * 0.015,
                    fontWeight: FontWeight.w600),
              ),
            )),
      );
    } else {
      return InkWell(
        onTap: () {},
        child: Container(
            height: height * 0.03,
            width: width * 0.15,
            decoration: BoxDecoration(
              color: ColorPalette.materialGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "Results",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: height * 0.015,
                    fontWeight: FontWeight.w600),
              ),
            )),
      );
    }
  }

  Widget _buildCircleArea(int index, Color color) {
    double radius = height * 0.04;
    return Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: Center(
          child: Text(
            "${index + 1}",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: height * 0.03),
          ),
        ));
  }

  List<Widget> buildStepArea() {
    double radius = height * 0.04;
    double interval = width * 0.06;
    List<Widget> list = [];
    int index = 0;
    for (int i = 0;
        i < stepCircleCount && i < ControlMeasurePageUtils().measurelist.length;
        ++i) {
      if (ControlMeasurePageUtils().pageIndex < stepCircleCount - 1) {
        index = i;
      } else {
        //
        index = i + ControlMeasurePageUtils().pageIndex - (stepCircleCount - 2);
        if (ControlMeasurePageUtils().pageIndex ==
            ControlMeasurePageUtils().measurelist.length - 1) {
          index--;
        }
      }

      if (index < ControlMeasurePageUtils().measurelist.length) {
        if (index == ControlMeasurePageUtils().pageIndex) {
          list.add(Image.asset(
            ControlMeasurePageUtils().measurelist[index]['icon_file'],
            height: radius,
          ));
        } else if (index < ControlMeasurePageUtils().pageIndex) {
          if (ControlMeasurePageUtils().measurelist[index]['measured']) {
            list.add(_buildCircleArea(index,
                Color(ControlMeasurePageUtils().measurelist[index]['color'])));
          }
        } else {
          list.add(_buildCircleArea(index, ColorPalette.darkGrey));
        }
      }

      if (i < stepCircleCount - 1) {
        list.add(
          SizedBox(
            width: interval,
          ),
        );
      }
    }

    return list;
  }
}
