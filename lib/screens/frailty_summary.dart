import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/common/client_details.dart';
import 'package:simple_kiosk_software/screens/frailty_result_card.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:simple_kiosk_software/utils/control_measure_page_utils.dart';
import 'package:simple_kiosk_software/utils/user_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FrailtySummaryPage extends StatelessWidget {
  double width = 0;
  double height = 0;
  late BuildContext mainContext;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    mainContext = context;

    return Scaffold(
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(10),
              // color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.results_title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 22,
                    ),
                    maxLines: 2,
                  ),
                  const Padding(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 20, bottom: 10),
                      child: ClientDetails(userDetails: {})),
                  const FrailtyCard(cardtype: CardType.HW),
                  const SizedBox(height: 20),
                  const FrailtyCard(cardtype: CardType.BP),
                  const SizedBox(height: 20),
                  const FrailtyCard(cardtype: CardType.BT),
                  const SizedBox(height: 20),
                  const FrailtyCard(cardtype: CardType.BO),
                  const SizedBox(height: 20),
                  const FrailtyCard(cardtype: CardType.BC),
                  const SizedBox(height: 20),
                  const FrailtyCard(cardtype: CardType.BF),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      UserInfo().clear();
                      ControlMeasurePageUtils().pageIndex = 0;
                      Navigator.pushNamed(context, '/');
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
                            "Exit",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: height * 0.015,
                                fontWeight: FontWeight.w600),
                          ),
                        )),
                  ),
                ],
              ))),
    );
  }
}
