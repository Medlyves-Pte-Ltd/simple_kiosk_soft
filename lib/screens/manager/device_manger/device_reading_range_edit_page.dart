import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:re_editor/re_editor.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/common/json_highlight.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_kiosk_software/utils/body_range.dart';
import 'package:simple_kiosk_software/utils/permission_config.dart';

class DeviceReadingRangeEditPage extends StatefulWidget {
  @override
  State<DeviceReadingRangeEditPage> createState() =>
      DeviceReadingRangeEditPageState();
}

class DeviceReadingRangeEditPageState
    extends State<DeviceReadingRangeEditPage> {
  CodeLineEditingController? _controller;
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CodeLineEditingController.fromText(BodyRange().jsonRange);
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
        title: Text('Device Reading Range Setting'),
      ),
      backgroundColor: Colors.white,
      //resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: CodeEditor(
              readOnly: !PermissionConfig()
                  .havePermission(PermissionModules.Permission),
              autofocus: false,
              controller: _controller,
              style: CodeEditorStyle(
                fontSize: height * 0.016,
                codeTheme: CodeHighlightTheme(
                    languages: {'json': CodeHighlightThemeMode(mode: langJson)},
                    theme: atomOneLightTheme),
              ),
              wordWrap: false,
              indicatorBuilder:
                  (context, editingController, chunkController, notifier) {
                return Row(
                  children: [
                    DefaultCodeLineNumber(
                      controller: editingController,
                      notifier: notifier,
                    ),
                    DefaultCodeChunkIndicator(
                        width: 20,
                        controller: chunkController,
                        notifier: notifier)
                  ],
                );
              },
              sperator: Container(width: 1, color: Colors.blue),
            )),
            Visibility(
                child: buildSaveBtn(),
                visible: PermissionConfig()
                    .havePermission(PermissionModules.Permission)),
            Footer(),
          ],
        ),
      ),
    );
  }

  // 返回按钮
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
              if (_controller == null) {
                return;
              }
              String error = await BodyRange().writeFile(_controller!.text);
              if (error.isNotEmpty) {
                Fluttertoast.showToast(msg: error);
              } else {
                Fluttertoast.showToast(msg: "save success");
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
}
