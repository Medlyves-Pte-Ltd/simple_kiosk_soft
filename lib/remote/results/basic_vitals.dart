import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/remote/vitals/viewmodels/vital_measurement_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/remote/utils/device_id_map.dart';

class VitalList extends StatelessWidget {
  final VitalMeasurementsController vitalMeasurementsController;

  VitalList({Key? key, required this.vitalMeasurementsController})
      : super(key: key);
  double height = 0;
  List<DataRow> buildTableRows(BuildContext context) {
    List<DataRow> dataRows = [];
    final basicVitalData =
        vitalMeasurementsController.vitalData.where((reading) {
      int deviceId = reading.deviceId;
      return (deviceId >= 1 && deviceId <= 3) ||
          (deviceId >= 17 && deviceId <= 22);
    }).toList();

    for (int i = 0; i < basicVitalData.length; i++) {
      dataRows.add(
        DataRow(
          cells: [
            DataCell(Text(
              DeviceMap.IDTONAME(context, basicVitalData[i].deviceId),
              style: TextStyle(
                  fontSize: height * 0.015, fontWeight: FontWeight.bold),
            )),
            DataCell(Text(
              basicVitalData[i].units == "N.A." ||
                      basicVitalData[i].units == "-" ||
                      basicVitalData[i].units == ""
                  ? "${basicVitalData[i].value}"
                  : "${basicVitalData[i].value} ${basicVitalData[i].units}",
              style: TextStyle(
                  fontSize: height * 0.015, fontWeight: FontWeight.bold),
            )),
          ],
        ),
      );
    }
    return dataRows;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Center(
        child: DataTable(
          dataRowHeight: height * 0.048,
          columns: [
            DataColumn(
                label: Text(
              AppLocalizations.of(context)!.vital,
              style: TextStyle(
                  fontSize: height * 0.018, fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              AppLocalizations.of(context)!.results,
              style: TextStyle(
                  fontSize: height * 0.018, fontWeight: FontWeight.bold),
            )),
          ],
          rows: buildTableRows(context),
        ),
      ),
    );
  }
}
