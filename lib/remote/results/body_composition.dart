import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/remote/vitals/viewmodels/vital_measurement_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/remote/utils/device_id_map.dart';

class BodyCompositionWidget extends StatelessWidget {
  final VitalMeasurementsController vitalMeasurementsController;

  BodyCompositionWidget({Key? key, required this.vitalMeasurementsController})
      : super(key: key);
  double height = 0;
  List<DataRow> buildTableRows(BuildContext context) {
    List<DataRow> dataRows = [];
    final bodyCompositionData =
        vitalMeasurementsController.vitalData.where((reading) {
      int deviceId = reading.deviceId;
      return deviceId >= 4 && deviceId <= 16;
    }).toList();

    // sort based on device ID, in ascending order
    bodyCompositionData.sort((a, b) => a.deviceId.compareTo(b.deviceId));

    for (int i = 0; i < bodyCompositionData.length; i++) {
      dataRows.add(
        DataRow(
          cells: [
            DataCell(Text(
              DeviceMap.IDTONAME(context, bodyCompositionData[i].deviceId),
              style: TextStyle(
                  fontSize: height * 0.015, fontWeight: FontWeight.bold),
            )),
            DataCell(Text(
              bodyCompositionData[i].units == "N.A." ||
                      bodyCompositionData[i].units == "-" ||
                      bodyCompositionData[i].units == ""
                  ? "${bodyCompositionData[i].value}"
                  : "${bodyCompositionData[i].value} ${bodyCompositionData[i].units}",
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
          dataRowHeight: height * 0.08,
          columns: [
            DataColumn(
              label: Text(
                AppLocalizations.of(context)!.vital,
                style: TextStyle(
                    fontSize: height * 0.018, fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(AppLocalizations.of(context)!.results,
                  style: TextStyle(
                      fontSize: height * 0.018, fontWeight: FontWeight.bold)),
            ),
          ],
          rows: buildTableRows(context),
        ),
      ),
    );
  }
}
