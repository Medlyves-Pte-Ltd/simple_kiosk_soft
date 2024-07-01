import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/common/header.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/providers/stepperprovider.dart';
import 'package:provider/provider.dart';

class Layout1 extends StatelessWidget {
  final Widget content1;

  const Layout1({super.key, required this.content1});

  @override
  Widget build(BuildContext context) {
    //final stepper = Provider.of<StepperProvider>(context);
    return Column(
      children: [
        const Header(),
        Expanded(child: content1),
        //stepper.footerVisibility ?
        const Footer()
      ],
    );
  }
}
