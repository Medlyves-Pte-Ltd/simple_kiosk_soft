import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:re_editor/re_editor.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:simple_kiosk_software/common/json_highlight.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_kiosk_software/utils/app_config.dart';

class RangeEditPage extends StatefulWidget {
  @override
  State<RangeEditPage> createState() => RangeEditPageState();
}

class RangeEditPageState extends State<RangeEditPage> {
  CodeLineEditingController? _controller;
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;

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
        title: Text('Range Setting'),
      ),
      backgroundColor: Colors.white,
      //resizeToAvoidBottomInset: false,
      body: Center(
        child: FutureBuilder(
            future: rootBundle.loadString('assets/configs/result_range.json'),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                _controller = CodeLineEditingController.fromText(snapshot.data);
                return Column(
                  children: [
                    Expanded(
                        child: CodeEditor(
                      //readOnly: true,
                      controller: _controller,
                      style: CodeEditorStyle(
                        codeTheme: CodeHighlightTheme(languages: {
                          'json': CodeHighlightThemeMode(mode: langJson)
                        }, theme: atomOneLightTheme),
                      ),
                      wordWrap: false,
                      indicatorBuilder: (context, editingController,
                          chunkController, notifier) {
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
                    buildSaveBtn(),
                    Footer(),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
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
              // /storage/emulated/0/Android/data/com.medlyves.simple_kiosk_software/files/downloads/test.json
              final Directory? downloadsDir =
                  await getApplicationDocumentsDirectory();
              var file = File('${AppConfig().configDir}/test.json');
              // var file = File(
              //     '/storage/emulated/0/Android/data/com.medlyves.simple_kiosk_software/files/test.json');
              File? fileCached;
              try {
                fileCached = await file.writeAsString(_controller!.text);
              } catch (e) {
                print(e);
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
