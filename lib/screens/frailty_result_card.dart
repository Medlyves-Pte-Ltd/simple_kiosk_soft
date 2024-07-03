import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';

// ignore: constant_identifier_names
enum CardType { HW, BC, BP, BT, ECG, BO, BF }

class FrailtyCard extends StatefulWidget {
  final CardType cardtype;
  const FrailtyCard({Key? key, required this.cardtype}) : super(key: key);

  @override
  State<FrailtyCard> createState() => _FrailtyCardState();
}

class _FrailtyCardState extends State<FrailtyCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = Localizations.localeOf(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    String title;
    String imagePath;
    List<String>? bodyTextList;
    Color themecolour;
    double cardWidth;
    double cardHeight;
    List<String>? bodyParameterList;

    switch (widget.cardtype) {
      case CardType.HW:
        title = '身高体重';
        themecolour = ColorPalette.colorheightWeight;
        imagePath = 'assets/images/heightweight_logo.png';
        bodyTextList = ['${UserInfo().height} cm', '${UserInfo().weight} kg'];
        cardHeight = screenHeight * 0.14;
        cardWidth = screenWidth * 0.9;
        bodyParameterList = ['身高:', '体重:'];
        break;
      case CardType.BC:
        title = "身体成分";
        themecolour = ColorPalette.colorbodyComp;
        imagePath = 'assets/images/bodycomposition_logo.png';
        bodyParameterList = [
          '体脂率:',
          '体脂量:',
          '基础代谢:',
          '水分含量:',
          '骨骼肌率:',
          '内脏脂肪水平:',
          '蛋白质:'
        ];
        bodyTextList = [
          UserInfo().bodyFatPercentage,
          UserInfo().bodyFatMass,
          UserInfo().basalMetabolism,
          UserInfo().bodyWaterPercentage,
          UserInfo().skeletalMusclePercentage,
          UserInfo().visceralFatLevel,
          UserInfo().protein,
        ];
        cardHeight = screenHeight * 0.35;
        cardWidth = screenWidth * 0.9;
        break;
      case CardType.BF:
        title = "血脂";
        themecolour = ColorPalette.colorbloodoxygen;
        imagePath = 'assets/images/blood_fit.png';
        bodyParameterList = [
          '胆固醇:',
          '高密度脂蛋白:',
          '甘油三酯:',
          '低密度脂蛋白:',
        ];
        bodyTextList = [
          UserInfo().chol,
          UserInfo().hdl,
          UserInfo().trig,
          UserInfo().ldl,
        ];
        cardHeight = screenHeight * 0.25;
        cardWidth = screenWidth * 0.9;
        break;
      case CardType.BP:
        title = '血压';
        themecolour = ColorPalette.colorbloodPressure;
        imagePath = 'assets/images/bloodpressure_logo.png';
        bodyTextList = [
          '${UserInfo().systolic} / ${UserInfo().diastolic}',
          (UserInfo().heartRate)
        ];
        cardHeight = screenHeight * 0.14;
        cardWidth = screenWidth * 0.9;
        bodyParameterList = ['BP:', 'HR:'];
        break;
      case CardType.BT: //增加显示体温
        title = '体温';
        themecolour = ColorPalette.colorbodytemperature;
        imagePath = 'assets/images/temperature_icon.png';
        bodyTextList = ['${UserInfo().temperature} °C'];
        cardHeight = screenHeight * 0.14;
        cardWidth = screenWidth * 0.9;
        bodyParameterList = ['体温:'];
        break;
      case CardType.ECG: //增加显示心电图
        title = "心电图";
        themecolour = ColorPalette.colorbodytemperature;
        imagePath = ' ';
        bodyTextList = [''];
        cardHeight = screenHeight * 0.14;
        cardWidth = screenWidth * 0.9;
        bodyParameterList = [];
        break;
      case CardType.BO: //增加显示血氧
        title = "血氧";
        themecolour = ColorPalette.colorbloodoxygen;
        imagePath = 'assets/images/spo2_icon.png';
        bodyTextList = [UserInfo().bloodOxygen];
        cardHeight = screenHeight * 0.14;
        cardWidth = screenWidth * 0.9;
        bodyParameterList = ['血氧:'];
        break;
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: ColorPalette.greyDisabledButtonWidgetBorder, width: 2.5),
        borderRadius: BorderRadius.circular(10),
      ),
      height: cardHeight,
      width: cardWidth,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: screenHeight * 0.01,
          ),
          Row(
            children: [
              SizedBox(
                width: screenWidth * 0.006,
              ),
              Image.asset(
                imagePath,
                height: screenHeight * 0.04,
              ),
              SizedBox(width: screenWidth * 0.012),
              IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight * 0.018),
                    ),
                    Container(
                      color: themecolour,
                      height: 1.5,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          Row(
            children: [
              Expanded(
                child: widget.cardtype == CardType.BC ||
                        widget.cardtype == CardType.BF
                    ? _buildBodyCompositionDetails(cardWidth, bodyParameterList,
                        bodyTextList, currentLocale)
                    : Padding(
                        padding: EdgeInsets.only(left: cardWidth * 0.15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: bodyParameterList
                              .asMap()
                              .entries
                              .map((entry) => _buildTextHWBP(
                                  entry.value, bodyTextList![entry.key]))
                              .toList(),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBodyCompositionDetails(
      double cardWidth,
      List<String> bodyParameterList,
      List<String> bodyTextList,
      Locale currentLocale) {
    final int halfLength = bodyParameterList.length ~/ 2;
    final List<Widget> firstHalf = bodyParameterList
        .asMap()
        .entries
        .take(halfLength)
        .map((entry) => _buildTextRows(entry.value, bodyTextList[entry.key]))
        .toList();

    final List<Widget> secondHalf = bodyParameterList
        .asMap()
        .entries
        .skip(halfLength)
        .map((entry) => _buildTextRows(entry.value, bodyTextList[entry.key]))
        .toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: cardWidth * 0.06),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: firstHalf,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: secondHalf,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextRows(String parameter, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ' $parameter ',
          textScaler: const TextScaler.linear(1.15),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
          textScaler: const TextScaler.linear(1.25),
        ),
      ],
    );
  }

  Widget _buildTextHWBP(String parameter, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '$parameter ',
          textScaler: const TextScaler.linear(1.1),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
          textScaler: const TextScaler.linear(1.2),
        ),
      ],
    );
  }
}
