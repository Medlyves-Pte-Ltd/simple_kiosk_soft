import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/screens/manager/admin_login_page.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class Footer extends StatelessWidget {
  Footer({Key? key});
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final footerHeight = height * 0.05;
    final fontSize = footerHeight * 0.30;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: footerHeight,
        width: double.infinity,
        color: ColorPalette.headerFooterBackground,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        iconSize: height * 0.03,
                        onPressed: () {
                          Navigator.of(context).push(TDSlidePopupRoute(
                              modalBarrierColor:
                                  TDTheme.of(context).fontGyColor2,
                              isDismissible: false,
                              slideTransitionFrom: SlideTransitionFrom.center,
                              builder: (context) {
                                return TDPopupCenterPanel(
                                  closeClick: () {
                                    Navigator.maybePop(context);
                                  },
                                  child: SizedBox(
                                    height: height * 0.5,
                                    width: width * 0.8,
                                    child: AdminLoginPage(),
                                  ),
                                );
                              }));
                          // Navigator.pushNamedAndRemoveUntil(
                          //     context, '/KioskManager', ((route) => false));
                        },
                        icon: Icon(Icons.settings))),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.powered_by,
                  style: TextStyle(fontSize: fontSize, color: Colors.white),
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                Image.asset(
                  'assets/images/Medlyves_name_only.png',
                  height: footerHeight * 0.5,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '${AppLocalizations.of(context)!.version} ${AppConfig().appVersion}',
                  style:
                      TextStyle(fontSize: height * 0.016, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
