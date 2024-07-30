import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/common/zoom_image.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class SummaryEcg extends StatelessWidget {
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;
  double titleFontSize = 0;
  double dataFontSize = 0;
  final ScrollController _scrollController = ScrollController();
  late BuildContext mainContext;

  @override
  Widget build(BuildContext context) {
    mainContext = context;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    titleFontSize = height * 0.02;
    dataFontSize = height * 0.02;

    return Column(
      children: [
        buildCardTopArea("assets/images/ecg.png",
            AppLocalizations.of(mainContext)!.ecg, ColorPalette.colorEcg),
        // buildTableWidget(),
        const SizedBox(
          height: 0.02,
        ),
        SizedBox(
          height: height * 0.3,
          width: width * 0.9,
          child: buildEcgImage(),
        )
      ],
    );
    // return buildBodyCompositionArea();
  }

  Widget buildItem(String title, String? data) {
    double titleFontSize = height * 0.02;
    double dataFontSize = height * 0.02;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style:
              TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: height * 0.01),
        Text(
          data ?? "",
          style: TextStyle(
              fontSize: dataFontSize,
              fontWeight: FontWeight.bold,
              color: ColorPalette.materialGreen),
        )
      ],
    );
  }

  Widget buildBodyCompositionArea() {
    return RawScrollbar(
        thumbColor: ColorPalette.darkGrey,
        // 一直显示滑动条
        thumbVisibility: true,
        // 滑动条的宽度
        thickness: 6,
        radius: const Radius.circular(10),
        // 滑动条为true 可拖动
        interactive: true,
        controller: _scrollController,
        child: ListView(
          controller: _scrollController,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            buildCardTopArea("assets/images/ecg.png",
                AppLocalizations.of(mainContext)!.ecg, ColorPalette.colorEcg),
            // buildTableWidget(),
            Container(
              padding: EdgeInsets.only(top: height * 0.1),
              height: height * 0.3,
              width: width * 0.9,
              child: buildEcgImage(),
            )
          ],
        ));
  }

  Widget buildTableWidget() {
    return SizedBox(
      height: height * 0.3,
      child: GridView(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          // 一行几列
          crossAxisCount: 3,
          // 设置每子元素的大小（宽高比）
          childAspectRatio: 1.8,
          // 元素的左右的 距离
          crossAxisSpacing: width * 0.02,
          // 子元素上下的 距离
          mainAxisSpacing: height * 0.01,
        ),
        children: [
          buildItem(AppLocalizations.of(mainContext)!.ecg_hr, UserInfo().HR),
          buildItem(AppLocalizations.of(mainContext)!.ecg_pr, UserInfo().PR),
          buildItem(AppLocalizations.of(mainContext)!.ecg_qt, UserInfo().QT),
          buildItem(AppLocalizations.of(mainContext)!.ecg_qtc, UserInfo().QTc),
          buildItem(AppLocalizations.of(mainContext)!.ecg_p_width,
              UserInfo().P_Width),
          buildItem(AppLocalizations.of(mainContext)!.ecg_qrs_dur,
              UserInfo().QRS_Dur),
          buildItem(
              AppLocalizations.of(mainContext)!.ecg_p_axis, UserInfo().P_Axis),
          buildItem(AppLocalizations.of(mainContext)!.ecg_qrs_axis,
              UserInfo().QRS_Axis),
          buildItem(
              AppLocalizations.of(mainContext)!.ecg_t_axis, UserInfo().T_Axis),
        ],
      ),
    );
  }

  Widget buildEcgImage() {
    if (UserInfo().ResultImage.isNotEmpty) {
      return GestureDetector(
        child: Image.file(File(UserInfo().ResultImage), fit: BoxFit.fitWidth),
        onTap: () {
          Navigator.of(mainContext).push(TDSlidePopupRoute(
              slideTransitionFrom: SlideTransitionFrom.center,
              builder: (x) {
                return ZoomImage(
                  url: UserInfo().ResultImage,
                  size: Size(
                    width,
                    height,
                  ),
                  imageSource: ImageSource.File,
                  isEnlarge: false,
                );
              }));
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  // 卡片顶部区域
  Widget buildCardTopArea(String iconFile, String title, Color color) {
    double imageSize = height * 0.05;
    double titleFontSize = height * 0.02;
    return Row(
      children: [
        Image.asset(
          iconFile,
          width: imageSize,
          height: imageSize,
        ),
        SizedBox(width: width * 0.005),
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
      ],
    );
  }
}
