import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/devices/device_config.dart';
import 'package:flutter_devices_sdk/device_type.dart';
import 'package:flutter_devices_sdk/view/device_config_page.dart';

class _TabData {
  final Widget tab;
  final Widget body;

  _TabData({required this.tab, required this.body});
}

class MeasMainPage extends StatefulWidget {
  const MeasMainPage({super.key});

  @override
  _MeasMainPageState createState() => _MeasMainPageState();
}

class _MeasMainPageState extends State<MeasMainPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  List<_TabData> _tabDataList = [];
  List<Widget> _tabBarList = [];
  List<Widget> _tabViewList = [];
  int pageCount = 0;
  int _currentIndex = 0;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    loadPage();
    _tabController = TabController(length: _tabDataList.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void onRefresh() {
    setState(() {});
  }

  Widget tabBarItem(String text, String icon, int index) {
    return Row(
      children: [
        _currentIndex == index
            ? Image.asset(icon, width: 20, height: 20)
            : Container(
                width: 20, // 宽度设置为100
                height: 20, // 高度也设置为100
                decoration: const BoxDecoration(
                  shape: BoxShape.circle, // 形状设置为圆形
                  color: Colors.grey, // 设置圆形的颜色
                ),
                child: Center(
                  child: Text(
                    '${index + 1}', // 圆形内的文本
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
        //Text(text),
      ],
    );
  }

  void loadPage() {
    _tabDataList = [];
    for (int i = 0; i < DeviceConfig().availableDeviceList.length; ++i) {
      switch (DeviceConfig().availableDeviceList[i].deviceType) {
        case DeviceType.HW_DEVICE:
          _tabDataList.add(_TabData(
              tab: tabBarItem("身高体重", "assets/images/heightweight_logo.png", i),
              body: HeightWeightPage()));
          break;
        case DeviceType.BP_DEVICE:
          _tabDataList.add(_TabData(
              tab: tabBarItem("血压", "assets/images/bloodpressure_logo.png", i),
              body: BloodPressurePage()));
          break;
        case DeviceType.BC_DEVICE:
          _tabDataList.add(_TabData(
              tab: tabBarItem(
                  "人体成分", "assets/images/bodycomposition_logo.png", i),
              body: BodyCompositionPage()));
          break;
        case DeviceType.TEMP_DEVICE:
          _tabDataList.add(_TabData(
              tab: tabBarItem("体温", "assets/images/temperature_icon.png", i),
              body: BodyTemperaturePage()));
          break;
        case DeviceType.BO_DEVICE:
          _tabDataList.add(_TabData(
              tab: tabBarItem("血氧", "assets/images/spo2_icon.png", i),
              body: BloodOxygenPage()));
          break;
        case DeviceType.BF_DEVICE:
        case DeviceType.BO_DEVICE:
          _tabDataList.add(_TabData(
              tab: tabBarItem("血脂", "assets/images/blood_fit.png", i),
              body: BloodFitPage()));
          break;
        case DeviceType.ECG_DEVICE:
          break;
        case DeviceType.PRINTER_DEVICE:
          break;
        case DeviceType.SCANNER_DEVICE:
          break;
        default:
          break;
      }
    }

    _tabDataList
        .add(_TabData(tab: const Text('体检结果'), body: FrailtySummaryPage()));
    _tabDataList
        .add(_TabData(tab: const Text('设备配置'), body: DeviceConfigPage()));

    _tabBarList = _tabDataList.map((e) => e.tab).toList();
    _tabViewList = _tabDataList.map((e) => e.body).toList();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    loadPage();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Global().bkColor(),
        toolbarHeight: 0,
      ),
      backgroundColor: Global().bkColor(),
      body: DefaultTabController(
          length: _tabBarList.length,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TabBar(
                  controller: _tabController,
                  tabAlignment: TabAlignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  dividerHeight: 0,
                  isScrollable: true,
                  indicatorColor: const Color(0xFF63F7DE),
                  indicatorSize: TabBarIndicatorSize.label,
                  unselectedLabelColor: Colors.grey,
                  unselectedLabelStyle: const TextStyle(fontSize: 18),
                  labelColor: Colors.white,
                  labelStyle: const TextStyle(fontSize: 24),
                  tabs: _tabBarList),
              Expanded(
                child: TabBarView(
                  children: _tabViewList,
                ),
              ),
              const Footer(),
            ],
          )),
    );
  }
}
