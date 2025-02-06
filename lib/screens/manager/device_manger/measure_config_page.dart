import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:simple_kiosk_software/common/common.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_kiosk_software/utils/control_measure_page_utils.dart';
import 'package:simple_kiosk_software/utils/permission_config.dart';

class MeasureConfigPage extends StatefulWidget {
  bool allowEdit = true;

  @override
  MeasureConfigPageState createState() => MeasureConfigPageState();
}

class MeasureConfigPageState extends State<MeasureConfigPage> {
  final _scrollController = ScrollController();

  List<dynamic> _measureConfigList = [];
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _measureConfigList = copyWithList(ControlMeasurePageUtils().configList);
    widget.allowEdit = PermissionConfig()
        .havePermission(PermissionModules.DeviceConfiguration);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Measure Configuration'),
        ),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: buildBody());
  }

  Widget buildBody() {
    return Column(
      children: [
        Expanded(
          child: RawScrollbar(
            thumbColor: Colors.grey,
            controller: _scrollController,
            thumbVisibility: true, // 一直显示滑动条
            thickness: 6, // 滑动条的宽度
            radius: const Radius.circular(10),
            interactive: true, // 滑动条为true 可拖动
            child: ReorderableListView.builder(
                scrollController: _scrollController,
                padding: const EdgeInsets.only(left: 8, right: 8),
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: deviceItem,
                itemCount: _measureConfigList.length,
                onReorder: _onReorder),
          ),
        ),
        widget.allowEdit ? buildSaveBtn() : const SizedBox.shrink()
      ],
    );
  }

  Widget deviceItem(BuildContext context, int index) {
    if (index >= _measureConfigList.length) {
      return const SizedBox.shrink();
    }

    bool enable = _measureConfigList[index]['enable'] as bool;
    String? name = _measureConfigList[index]['name'] as String;

    return Container(
      key: ObjectKey(index),
      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
            color: widget.allowEdit
                ? ColorPalette.materialGreen
                : ColorPalette.darkGrey,
            width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: height * 0.05,
            height: height * 0.05,
            decoration: BoxDecoration(
              color: ColorPalette.materialGreen,
              borderRadius: BorderRadius.circular(150),
            ),
            alignment: Alignment.center,
            child: Text(
              "${index + 1}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const Spacer(),
          selectDeviceEnable(index, enable),
        ],
      ),
    );
  }

  // 设置设备能否使用
  // Set whether the device can be used
  Widget selectDeviceEnable(int index, bool enable) {
    // 在编辑状态
    // In editing status
    if (widget.allowEdit) {
      return Switch(
          value: enable,
          activeColor: ColorPalette.materialGreen,
          inactiveThumbColor: Colors.red,
          onChanged: (value) {
            enable = value;
            _measureConfigList[index]['enable'] = value;
            setState(() {});
          });
    } else {
      // 不在编辑状态，不能点击, 颜色会变灰
      // Not in editing status, cannot be clicked, color will turn gray
      return IgnorePointer(
        ignoring: true,
        child: Switch(
            value: enable,
            activeColor: ColorPalette.materialGreen,
            activeTrackColor: Colors.grey,
            inactiveThumbColor: Colors.red,
            inactiveTrackColor: Colors.grey,
            onChanged: (value) {}),
      );
    }
  }

  Widget buildSaveBtn() {
    return Container(
      height: height * 0.08,
      padding: EdgeInsets.only(
          top: height * 0.01, bottom: height * 0.01, right: width * 0.05),
      child: Row(
        children: [
          const Spacer(),
          InkWell(
            onTap: () async {
              ControlMeasurePageUtils().configList =
                  copyWithList(_measureConfigList);
              String error = await ControlMeasurePageUtils().saveFile();
              if (error.isNotEmpty) {
                Fluttertoast.showToast(msg: error);
              } else {
                Fluttertoast.showToast(
                    msg: "save success, please reboot machine");
              }
            },
            child: Container(
                height: height * 0.03,
                width: width * 0.15,
                decoration: BoxDecoration(
                  color: ColorPalette.materialGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Save",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: height * 0.015,
                        fontWeight: FontWeight.w600),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  _onReorder(int oldIndex, int newIndex) {
    if (!widget.allowEdit) {
      return;
    }
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    var item = _measureConfigList.removeAt(oldIndex);
    _measureConfigList.insert(newIndex, item);
    setState(() {});
  }
}
