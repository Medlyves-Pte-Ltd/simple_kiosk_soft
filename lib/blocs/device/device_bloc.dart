import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:flutter_devices_sdk/device_manager.dart';

import 'package:flutter_devices_sdk/device_data/device_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_devices_sdk/devices/device_base_model.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/constants/app_constants.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  DeviceManager deviceManager = DeviceManager();
  StreamSubscription<DeviceData>? _dataSubscription;

  DeviceBloc() : super(DeviceInitial()) {
    on<DeviceConnectEvent>(_onDeviceConnectEvent);
    on<DeviceStartEvent>(_onDeviceStartEvent);
    on<DeviceUpdateDataEvent>(_onDeviceDataUpdatedEvent);
    on<DeviceStopEvent>(_onDeviceStopEvent);
    on<DeviceDisconnectEvent>(_onDeviceDisconnectEvent);
  }

  Future<void> _onDeviceConnectEvent(
      DeviceConnectEvent event, Emitter<DeviceState> emit) async {
    DeviceType deviceType = event.deviceType;
    DeviceBaseModel? device = deviceManager.getDevice(deviceType);

    LogPrinter.log('Trying to connect from bloc.');
    bool? result = await device?.connect();
    LogPrinter.log('Device connected status: $result.');
    emit(DeviceConnected(deviceType: deviceType));
    Future.delayed(const Duration(milliseconds: 100),
        () => add(DeviceStartEvent(deviceType: deviceType)));
  }

  Future<void> _onDeviceStartEvent(
      DeviceStartEvent event, Emitter<DeviceState> emit) async {
    DeviceType deviceType = event.deviceType;
    DeviceBaseModel? device = deviceManager.getDevice(deviceType);

    LogPrinter.log('Trying to start from bloc.');
    _dataSubscription = device?.onDataReady.listen((data) {
      add(DeviceUpdateDataEvent(deviceType: deviceType, deviceData: data));
    });
    await device?.start();
    LogPrinter.log('Started Device from bloc.');
    LogPrinter.log('listen for callback.');
    emit(DeviceDataLoading(deviceType: deviceType));
  }

  Future<void> _onDeviceDataUpdatedEvent(
      DeviceUpdateDataEvent event, Emitter<DeviceState> emit) async {
    DeviceType deviceType = event.deviceType;
    // DeviceData deviceData = event.deviceData;
    LogPrinter.log('Callback received. Cancel subscription.');
    // _dataSubscription!.cancel();
    // LogPrinter.log(deviceData.toString());
    LogPrinter.log('Trying to stop the device.');
    // emit(DeviceDataUpdated(deviceType: deviceType, deviceData: deviceData));
    Future.delayed(const Duration(milliseconds: 500),
        () => add(DeviceDisconnectEvent(deviceType: event.deviceType)));
  }

  Future<void> _onDeviceStopEvent(
      DeviceStopEvent event, Emitter<DeviceState> emit) async {
    DeviceType deviceType = event.deviceType;
    DeviceBaseModel? device = deviceManager.getDevice(deviceType);

    LogPrinter.log('Trying to stop from bloc.');
    await device?.stop();
    LogPrinter.log('Device stoped from bloc.');
    emit(DeviceStopped(deviceType: deviceType));
    Future.delayed(const Duration(milliseconds: 100),
        () => add(DeviceDisconnectEvent(deviceType: deviceType)));
  }

  Future<void> _onDeviceDisconnectEvent(
      DeviceDisconnectEvent event, Emitter<DeviceState> emit) async {
    DeviceType deviceType = event.deviceType;
    DeviceBaseModel? device = deviceManager.getDevice(deviceType);
    LogPrinter.log(deviceType.toString());

    LogPrinter.log('Disconnecting');
    await device?.disconnect();
    LogPrinter.log('Disconnected.');
    emit(DeviceDisconnected(deviceType: deviceType));
  }
}
