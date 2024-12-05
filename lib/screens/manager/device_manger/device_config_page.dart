import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/screens/manager/device_manger/kiosk_type_device_config/sample_kiosk_device_config_view.dart';

class DeviceConfigPage extends StatefulWidget {
  @override
  DeviceConfigPageState createState() => DeviceConfigPageState();
}

class DeviceConfigPageState extends State<DeviceConfigPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Device Config'),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [Expanded(child: SampleKioskDeviceConfigView()), Footer()],
      ),
    );
  }
}
