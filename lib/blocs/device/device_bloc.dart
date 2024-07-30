import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_devices_sdk/device_data/blood_oxygen_data.dart';
import 'package:flutter_devices_sdk/device_data/blood_pressure_data.dart';
import 'package:flutter_devices_sdk/device_data/body_composition_data.dart';
import 'package:flutter_devices_sdk/device_data/body_temperature_data.dart';
import 'package:flutter_devices_sdk/device_data/height_data.dart';
import 'package:flutter_devices_sdk/device_data/weight_data.dart';
import 'package:simple_kiosk_software/blocs/device/device_state.dart';
import 'package:flutter_devices_sdk/device_data/device_data.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:simple_kiosk_software/blocs/device/device_event.dart';
import 'package:simple_kiosk_software/utils/log_printer.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  DeviceBloc() : super(DeviceInitial()) {
    on<DeviceConnectEvent>(_onDeviceConnectEvent);
    on<DeviceStartEvent>(_onDeviceStartEvent);
    on<DeviceUpdateDataEvent>(_onDeviceDataUpdatedEvent);
    on<DeviceStopEvent>(_onDeviceStopEvent);
    on<DeviceDisconnectEvent>(_onDeviceDisconnectEvent);
    on<TestUpdateDataEvent>(_onTestDataUpdatedEvent);
  }

  Future<void> _onDeviceConnectEvent(
      DeviceConnectEvent event, Emitter<DeviceState> emit) async {
    DeviceType deviceType = event.deviceType;
    LogPrinter.log('Trying to connect from bloc.');
    emit(DeviceConnected(deviceType: deviceType));
    Future.delayed(const Duration(milliseconds: 100),
        () => add(DeviceStartEvent(deviceType: deviceType)));
  }

  Future<void> _onDeviceStartEvent(
      DeviceStartEvent event, Emitter<DeviceState> emit) async {
    DeviceType deviceType = event.deviceType;
    LogPrinter.log('Started Device from bloc.');
    emit(DeviceDataLoading(deviceType: deviceType));

    if (deviceType == DeviceType.HEIGHT_DEVICE) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        add(DeviceUpdateDataEvent(
            deviceData: HeightData("176.5"), deviceType: deviceType));
      });
    } else if (deviceType == DeviceType.WEIGHT_DEVICE) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        add(DeviceUpdateDataEvent(
            deviceData: WeightData("81.5"), deviceType: deviceType));
      });
    } else if (deviceType == DeviceType.TEMP_DEVICE) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        add(DeviceUpdateDataEvent(
            deviceData: BodyTemperatureData("37.5"), deviceType: deviceType));
      });
    } else if (deviceType == DeviceType.BP_DEVICE) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        add(DeviceUpdateDataEvent(
            deviceData: BloodPrssureData("140", "80", "107"),
            deviceType: deviceType));
      });
    } else if (deviceType == DeviceType.BC_DEVICE) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        add(DeviceUpdateDataEvent(
            deviceData: BodyCompositionData(
                bodyFatPercentage: "95",
                basalMetabolism: "1120",
                bodyWaterPercentage: "70",
                proteinPercentage: "80",
                visceralFatLevel: "1",
                boneMass: "40"),
            deviceType: deviceType));
      });
    } else if (deviceType == DeviceType.BO_DEVICE) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        add(DeviceUpdateDataEvent(
            deviceData: BloodOxygenData("98", "80"), deviceType: deviceType));
      });
    }
  }

  Future<void> _onDeviceDataUpdatedEvent(
      DeviceUpdateDataEvent event, Emitter<DeviceState> emit) async {
    DeviceType deviceType = event.deviceType;
    DeviceData deviceData = event.deviceData;
    LogPrinter.log('Callback received. Cancel subscription.');
    LogPrinter.log('Trying to stop the device.');
    emit(DeviceDataUpdated(deviceType: deviceType, deviceData: deviceData));
    Future.delayed(const Duration(milliseconds: 200),
        () => add(DeviceDisconnectEvent(deviceType: event.deviceType)));
  }

  Future<void> _onDeviceStopEvent(
      DeviceStopEvent event, Emitter<DeviceState> emit) async {
    DeviceType deviceType = event.deviceType;
    LogPrinter.log('Device stoped from bloc.');
    emit(DeviceStopped(deviceType: deviceType));
    Future.delayed(const Duration(milliseconds: 100),
        () => add(DeviceDisconnectEvent(deviceType: deviceType)));
  }

  Future<void> _onDeviceDisconnectEvent(
      DeviceDisconnectEvent event, Emitter<DeviceState> emit) async {
    DeviceType deviceType = event.deviceType;
    LogPrinter.log(deviceType.toString());
    LogPrinter.log('Disconnected.');
    emit(DeviceDisconnected(deviceType: deviceType));
  }

  Future<void> _onTestDataUpdatedEvent(
      TestUpdateDataEvent event, Emitter<DeviceState> emit) async {
    DeviceType deviceType = event.deviceType;
    DeviceData deviceData = event.deviceData;
    LogPrinter.log(deviceData.toString());
    emit(DeviceDataUpdated(deviceType: deviceType, deviceData: deviceData));
  }
}
