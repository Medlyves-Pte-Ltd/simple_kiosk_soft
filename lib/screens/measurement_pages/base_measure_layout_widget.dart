import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:simple_kiosk_software/common/client_details.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/common/header.dart';
import 'package:simple_kiosk_software/common/video_widget.dart';

class BaseMeasureLayoutWidget extends StatelessWidget {
  String videoFile = 'assets/videos/zh/heightweight_ZH.mp4';
  String iconFile = "assets/images/heightweight_logo.png";
  String title = "Height & Weight";
  Color color = ColorPalette.colorbodytemperature;
  double width = 0;
  double height = 0;
  ValueNotifier<String> _height = ValueNotifier('- - -');
  ValueNotifier<String> _weight = ValueNotifier('- - -');

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
          _buildBackNextControlBtn(),
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
    return Container(
      height: height * 0.05,
      margin: EdgeInsets.only(
          left: width * 0.2,
          right: width * 0.2,
          top: height * 0.006,
          bottom: height * 0.006),
      child: Row(
        children: [
          Image.asset(
            iconFile,
            height: height * 0.06,
          ),
          SizedBox(
            width: width * 0.1,
          ),
          Container(
            height: height * 0.15,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: ColorPalette.darkGrey),
            child: Text(
              "2",
              style: TextStyle(color: Colors.white, fontSize: height * 0.04),
            ),
          ),
          SizedBox(
            width: width * 0.1,
          ),
          Container(
            height: height * 0.06,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: ColorPalette.darkGrey),
            child: Text(
              "3",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            width: width * 0.1,
          ),
          Container(
            height: height * 0.06,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: ColorPalette.darkGrey),
            child: Text(
              "4",
              style: TextStyle(color: Colors.white, fontSize: height * 0.03),
            ),
          )
        ],
      ),
    );
  }

  // 卡片信息区域
  Widget _buildCardArea() {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(color: ColorPalette.darkGrey, width: 1.0),
        color: ColorPalette.colorAppBackground,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _buildCardTopArea(),
          const SizedBox(height: 30),
          Expanded(child: buildCardDataShowArea()),
          const Spacer(),
          const ClientDetails(
            userDetails: {'patientId': "2014", 'gender': "男", 'age': "30"},
          ),
        ],
      ),
    ));
  }

  // 返回下一步控制按钮
  Widget _buildBackNextControlBtn() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Spacer(),
          Container(
            width: width * 0.2,
            decoration: BoxDecoration(
              color: ColorPalette.materialGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "返回",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: height * 0.015,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            width: width * 0.1,
          ),
          Container(
            width: width * 0.2,
            decoration: BoxDecoration(
              color: ColorPalette.materialGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "下一步",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: height * 0.015,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // 卡片顶部区域
  Widget _buildCardTopArea() {
    return Row(
      children: [
        Image.asset(
          iconFile,
          width: 40,
          height: 40,
        ),
        const SizedBox(width: 5),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: IntrinsicWidth(
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
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
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: ColorPalette.materialGreen,
            ),
            child: const Text("开始",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget buildCardDataShowArea() {
    //return const SizedBox.shrink();
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "高度 (cm)",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 30),
              ValueListenableBuilder<String>(
                  valueListenable: _height,
                  builder: (context, value, child) {
                    return Text(
                      value,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff4ca9a9)),
                    );
                  })
            ],
          ),
          const SizedBox(width: 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "体重 (kg)",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 30),
              ValueListenableBuilder<String>(
                  valueListenable: _weight,
                  builder: (context, value, child) {
                    return Text(
                      value,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff4ca9a9)),
                    );
                  })
            ],
          )
        ],
      ),
    );
    //throw UnimplementedError();
  }
}
