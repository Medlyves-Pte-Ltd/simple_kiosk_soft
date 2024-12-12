import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:simple_kiosk_software/remote/vitals/viewmodels/vital_measurement_controller.dart';
import 'package:simple_kiosk_software/remote/utils/app_constants.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import 'package:simple_kiosk_software/remote/results/body_composition.dart';
import 'package:simple_kiosk_software/remote/results/basic_vitals.dart';
import 'package:simple_kiosk_software/remote/blocs/appointment/appointment_bloc.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResultList extends StatefulWidget {
  const ResultList({super.key});

  @override
  State<ResultList> createState() => _ResultListState();
}

class _ResultListState extends State<ResultList>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  double width = 0;
  double height = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchVitalsData();
      log("vitals data fetched");
    });
  }

  void fetchVitalsData() async {
    final vitalsData =
        Provider.of<VitalMeasurementsController>(context, listen: false);
    await vitalsData.fetchVitalMeasurements();
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    VitalMeasurementsController vitalMeasurementsController =
        Provider.of<VitalMeasurementsController>(context);
    return Column(children: [
      SizedBox(height: height * 0.01),
      SizedBox(
        height: height * 0.05,
        child: TabBar(
          controller: _tabController,
          splashFactory: NoSplash.splashFactory,
          dividerColor: Colors.transparent,
          indicatorColor: ColorPalette.colorAppTheme,
          unselectedLabelColor: Colors.black,
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          labelColor: ColorPalette.colorAppBackground,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding:
              const EdgeInsetsDirectional.fromSTEB(20.0, 5.0, 20.0, 5.0),
          indicator: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: const BorderSide(
                  width: 5,
                  color: Color.fromARGB(200, 103, 155, 206),
                  strokeAlign: BorderSide.strokeAlignOutside),
            ),
            color: const Color.fromARGB(200, 103, 155, 206),
          ),
          tabs: <Widget>[
            Tab(
              child: Text(
                AppLocalizations.of(context)!.basic_vitals,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: height * 0.015),
              ),
            ),
            Tab(
              child: Text(
                AppLocalizations.of(context)!.bcm,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: height * 0.015),
              ),
            ),
            Tab(
              child: Text(
                AppLocalizations.of(context)!.summary_ecg,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: height * 0.015),
              ),
            ),
          ],
        ),
      ),

      // if (vitalMeasurementsController.getVerifyLoader)
      //       const Center(
      //           child: CircularProgressIndicator(
      //               color: ColorPalette.colorAppTheme)),
      SizedBox(
        height: height * 0.01,
      ),
      SizedBox(
        height: height * 0.4,
        child: Stack(
          children: [
            TabBarView(
              controller: _tabController,
              clipBehavior: Clip.antiAlias,
              children: <Widget>[
                VitalList(
                    vitalMeasurementsController: vitalMeasurementsController),
                BodyCompositionWidget(
                    vitalMeasurementsController: vitalMeasurementsController),
                ECGImage(),
              ],
            ),
          ],
        ),
      ),
    ]);
  }
}

class ECGImage extends StatelessWidget {
  ECGImage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Map<String, dynamic> patientBodyInfo =
        context.watch<AppointmentBloc>().getPatientBodyInfo();
    String? ecgImagePath = patientBodyInfo["ecg_img"];
    return Center(
      child: ecgImagePath != null
          ? GestureDetector(
              onTap: () {
                showImagePreview(context, ecgImagePath);
              },
              child: Image.file(
                File(ecgImagePath),
              ),
            )
          : Text(AppLocalizations.of(context)!.ecg_img_unavail,
              style: TextStyle(
                  fontSize: height * 0.015, fontWeight: FontWeight.bold)),
    );
  }

  void showImagePreview(BuildContext context, String imagePath) async {
    await showImageViewer(
      context,
      Image.file(File(imagePath)).image,
      swipeDismissible: true,
    );
  }
}
