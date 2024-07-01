import 'package:flutter/material.dart';
import 'package:base_kiosk_software/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:base_kiosk_software/utils/device_id_map.dart';
import 'package:base_kiosk_software/utils/storage_utils.dart';

enum CardType { HW, BC, BP, BF, BG, ECG, BO, BT }

class FrailtyCard extends StatefulWidget {
  final CardType cardtype;
  const FrailtyCard({Key? key, required this.cardtype}) : super(key: key);

  @override
  State<FrailtyCard> createState() => _FrailtyCardState();
}

class _FrailtyCardState extends State<FrailtyCard> {
  Map<String, String> data = {
    'patientId': '',
    'age': '',
    'gender': '',
    'height': '',
    'weight': '',
    'systolic': '',
    'diastolic': '',
    'bpHeartRate': '',
    'bodyFatPercentage': '',
    'bodyFatMass': '',
    'basalMetabolism': '',
    'bodyWaterPercentage': '',
    'skeletalMusclePercentage': '',
    'visceralFatLevel': '',
    'protein': ''
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StorageUtils.getData(data.keys.toSet()).then((value) {
      setState(() {
        data = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = Localizations.localeOf(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    String title = "";
    String imagePath = "";
    List<String>? bodyTextList = [];
    Color themecolour = Colors.black;
    double cardWidth = screenWidth / 2;
    double cardHeight = screenHeight / 2;
    List<String>? bodyParameterList = [];

    switch (widget.cardtype) {
      case CardType.HW:
        title = AppLocalizations.of(context)!.hw;
        themecolour = ColorPalette.colorheightWeight;
        imagePath = 'assets/images/heightweight_logo.png';
        bodyTextList = [
          '${data['height']} ${DeviceMap.CODETOUNIT['height']}',
          '${data['weight']} ${DeviceMap.CODETOUNIT['weight']}'
        ];
        cardHeight = screenHeight * 0.14;
        cardWidth = screenWidth * 0.38;
        bodyParameterList = [
          '${AppLocalizations.of(context)!.nounithw_height}:',
          '${AppLocalizations.of(context)!.nounithw_weight}:'
        ];
        break;
      case CardType.BC:
        title = AppLocalizations.of(context)!.bcm;
        themecolour = ColorPalette.colorbodyComp;
        imagePath = 'assets/images/bodycomposition_logo.png';
        bodyParameterList = [
          '${AppLocalizations.of(context)!.bcm_fat}:',
          '${AppLocalizations.of(context)!.bcm_fatmass}:',
          '${AppLocalizations.of(context)!.bcm_metabolism}:',
          '${AppLocalizations.of(context)!.bcm_water}:',
          '${AppLocalizations.of(context)!.bcm_skeletal}:',
          '${AppLocalizations.of(context)!.bcm_visceralfat}:',
          '${AppLocalizations.of(context)!.bcm_protein}:',
        ];
        bodyTextList = [
          '${data['bodyFatPercentage']} ${DeviceMap.CODETOUNIT['bodyFatPercentage']}',
          '${data['bodyFatMass']} ${DeviceMap.CODETOUNIT['bodyFatMass']}',
          '${data['basalMetabolism']} ${DeviceMap.CODETOUNIT['basalMetabolism']}',
          '${data['bodyWaterPercentage']} ${DeviceMap.CODETOUNIT['bodyWaterPercentage']}',
          '${data['skeletalMusclePercentage']} ${DeviceMap.CODETOUNIT['skeletalMusclePercentage']}',
          '${data['visceralFatLevel']} ${DeviceMap.CODETOUNIT['visceralFatLevel']}',
          '${data['protein']} ${DeviceMap.CODETOUNIT['protein']}',
        ];
        cardHeight = screenHeight * 0.26;
        cardWidth = screenWidth * 0.87;
        break;
      case CardType.BP:
        title = AppLocalizations.of(context)!.bp;
        themecolour = ColorPalette.colorbloodPressure;
        imagePath = 'assets/images/bloodpressure_logo.png';
        bodyTextList = [
          '${data['systolic']} / ${data['diastolic']} ${DeviceMap.CODETOUNIT['systolic']}',
          '${data['bpHeartRate']} ${DeviceMap.CODETOUNIT['bpHeartRate']}'
        ];
        cardHeight = screenHeight * 0.14;
        cardWidth = screenWidth * 0.429;
        bodyParameterList = [
          '${AppLocalizations.of(context)!.shortform_bp_bloodpressure}:',
          '${AppLocalizations.of(context)!.shortform_bp_pulse}:'
        ];
        break;
      case CardType.BF:
        // TODO: Handle this case.
        break;
      case CardType.BG:
        // TODO: Handle this case.
        break;
      case CardType.ECG:
        // TODO: Handle this case.
        break;
      case CardType.BO:
        // TODO: Handle this case.
        break;
      case CardType.BT:
        // TODO: Handle this case.
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
                child: widget.cardtype == CardType.BC
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
          SizedBox(
              width: currentLocale.languageCode == 'ta'
                  ? cardWidth * 0.04
                  : cardWidth * 0.06),
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
        Text('$parameter', textScaler: const TextScaler.linear(1.15)),
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
        Text('$parameter ', textScaler: const TextScaler.linear(1.1)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
          textScaler: const TextScaler.linear(1.2),
        ),
      ],
    );
  }
}
