import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/remote/vitals/viewmodels/vital_measurement_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_kiosk_software/remote/utils/device_id_map.dart';

class VitalList extends StatelessWidget {
  final VitalMeasurementsController vitalMeasurementsController;

  const VitalList({Key? key, required this.vitalMeasurementsController})
      : super(key: key);

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
            DataCell(
                Text(DeviceMap.IDTONAME(context, basicVitalData[i].deviceId))),
            DataCell(Text(
              basicVitalData[i].units == "N.A." ||
                      basicVitalData[i].units == "-" ||
                      basicVitalData[i].units == ""
                  ? "${basicVitalData[i].value}"
                  : "${basicVitalData[i].value} ${basicVitalData[i].units}",
            )),
          ],
        ),
      );
    }
    return dataRows;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: DataTable(
          columns: [
            DataColumn(label: Text(AppLocalizations.of(context)!.vital)),
            DataColumn(label: Text(AppLocalizations.of(context)!.results)),
          ],
          rows: buildTableRows(context),
        ),
      ),
    );
  }
}
