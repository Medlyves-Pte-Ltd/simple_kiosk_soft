import 'package:flutter_devices_sdk/device_data/device_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';

abstract class DeviceState {
  final DeviceType? deviceType;
  DeviceState({this.deviceType});
}

class DeviceInitial extends DeviceState {}

class DeviceConnected extends DeviceState {
  DeviceConnected({required DeviceType deviceType})
      : super(deviceType: deviceType);
}

class DeviceDataLoading extends DeviceState {
  DeviceDataLoading({required DeviceType deviceType})
      : super(deviceType: deviceType);
}

class DeviceDataUpdated extends DeviceState {
  final DeviceData deviceData;
  DeviceDataUpdated({required DeviceType deviceType, required this.deviceData})
      : super(deviceType: deviceType);
}

class DeviceStopped extends DeviceState {
  DeviceStopped({required DeviceType deviceType})
      : super(deviceType: deviceType);
}

class DeviceDisconnected extends DeviceState {
  DeviceDisconnected({required DeviceType deviceType})
      : super(deviceType: deviceType);
}

class DeviceFailure extends DeviceState {
  DeviceFailure({required DeviceType deviceType})
      : super(deviceType: deviceType);
}
