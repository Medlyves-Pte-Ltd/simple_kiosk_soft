import 'package:flutter_devices_sdk/device_data/device_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';

abstract class DeviceEvent {
  bool autoStop = true;
  DeviceType deviceType;
  DeviceEvent({required this.deviceType});
}

class DeviceConnectEvent extends DeviceEvent {
  DeviceConnectEvent({required DeviceType deviceType, bool autoStop = true})
      : super(deviceType: deviceType);
}

class DeviceStartEvent extends DeviceEvent {
  DeviceStartEvent({required DeviceType deviceType, bool autoStop = true})
      : super(deviceType: deviceType);
}

class DeviceUpdateDataEvent extends DeviceEvent {
  DeviceData deviceData;
  DeviceUpdateDataEvent(
      {required this.deviceData,
      required DeviceType deviceType,
      bool autoStop = true})
      : super(deviceType: deviceType);
}

class DeviceStopEvent extends DeviceEvent {
  DeviceStopEvent({required DeviceType deviceType})
      : super(deviceType: deviceType);
}

class DeviceDisconnectEvent extends DeviceEvent {
  DeviceDisconnectEvent({required DeviceType deviceType})
      : super(deviceType: deviceType);
}

class TestUpdateDataEvent extends DeviceEvent {
  DeviceData deviceData;
  TestUpdateDataEvent(
      {required this.deviceData, required DeviceType deviceType})
      : super(deviceType: deviceType);
}
