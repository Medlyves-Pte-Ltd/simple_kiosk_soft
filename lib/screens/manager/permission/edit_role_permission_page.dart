import 'package:flutter/material.dart';
import 'package:simple_kiosk_software/utils/permission_config.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class EditRolePermissionPage extends StatefulWidget {
  List<dynamic> permissionList = [];
  Function callBack;
  EditRolePermissionPage(
      {required this.callBack, required this.permissionList});

  @override
  EditRolePermissionPageState createState() => EditRolePermissionPageState();
}

class EditRolePermissionPageState extends State<EditRolePermissionPage> {
  Role role = Role();
  List<String> allPermissionList = [];

  final ScrollController _scrollController = ScrollController();

  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (var it in PermissionModules.values) {
      allPermissionList.add(it.name);
    }

    // ops移除权限
    allPermissionList.remove(PermissionModules.Permission.name);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void checkBoxChanged(int index, bool selected) {
    if (!selected) {
      widget.permissionList.remove(allPermissionList[index]);
    } else {
      widget.permissionList.add(allPermissionList[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.06,
            ),
            Row(
              children: [
                Text("Assign permissions to this role"),
                const Spacer(),
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Expanded(
                child: RawScrollbar(
              thumbColor: Theme.of(context).primaryColor,
              controller: _scrollController,
              thumbVisibility: true, // 一直显示滑动条
              thickness: width * 0.01, // 滑动条的宽度
              radius: const Radius.circular(10),
              interactive: true, // 滑动条为true 可拖动
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: height * 0.01,
                  mainAxisSpacing: height * 0.01,
                  childAspectRatio: 3 / 2,
                ),
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: allPermissionList.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return TDCheckbox(
                    titleFont: Font(size: 13, lineHeight: 12),
                    checked: widget.permissionList
                        .contains(allPermissionList[index]),
                    title: allPermissionList[index],
                    cardMode: true,
                    onCheckBoxChanged: (bool selected) {
                      checkBoxChanged(index, selected);
                    },
                  );
                },
              ),
            )),
            SizedBox(
              height: height * 0.01,
            ),
            ElevatedButton(
              onPressed: () {
                widget.callBack(widget.permissionList);
              },
              child: Text('Modify'),
            ),
          ],
        ),
      ),
    );
  }
}
