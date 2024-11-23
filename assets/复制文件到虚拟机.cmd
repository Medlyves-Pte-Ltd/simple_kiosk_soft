adb devices
List of devices attached
emulator-5554   device
指定某个设备
adb -s emulator-5554 push
复制文件到虚拟机
adb push videos /storage/emulated/0/Documents/kiosk
复制配置文件
adb push configs /storage/emulated/0/Documents/kiosk