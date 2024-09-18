enum DeviceType {
  HW_DEVICE,
  TEMP_DEVICE,
  BC_DEVICE,
  SPO2_DEVICE,
  BP_DEVICE,
  ECG_DEVICE,
  SCANNER_DEVICE,
  PRINTER_DEVICE,
  UNKOWN_DEVICE;

  static DeviceType fromString(String value) {
    // Iterate over the enum values
    for (var enumValue in DeviceType.values) {
      if (enumValue.name.toLowerCase() == value.toLowerCase()) {
        return enumValue;
      }
    }

    return DeviceType.UNKOWN_DEVICE;
  }
}
