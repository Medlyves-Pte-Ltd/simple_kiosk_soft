import 'package:flutter/material.dart';
import 'package:flutter_devices_sdk/log/log_printer.dart';
import 'package:flutter_devices_sdk/view/colors.dart';
import 'package:simple_kiosk_software/common/common.dart';
import 'package:simple_kiosk_software/common/footer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_kiosk_software/screens/manager/general/permission/add_admin_page.dart';
import 'package:simple_kiosk_software/screens/manager/general/permission/add_ops_page.dart';
import 'package:simple_kiosk_software/screens/manager/general/permission/edit_role_permission_page.dart';
import 'package:simple_kiosk_software/utils/permission_config.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class PermissionConfigPage extends StatefulWidget {
  bool allowEdit = true;
  @override
  State<PermissionConfigPage> createState() => PermissionConfigPageState();
}

class PermissionConfigPageState extends State<PermissionConfigPage> {
  final _scrollController = ScrollController();
  // 角色列表
  List<dynamic> roleList = [];
  // 屏幕宽度
  double width = 0;
  // 屏幕高度
  double height = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    roleList = copyWithList(PermissionConfig().roleList);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void addAdmin() {
    Navigator.of(context).push(TDSlidePopupRoute(
        modalBarrierColor: TDTheme.of(context).fontGyColor2,
        isDismissible: false,
        slideTransitionFrom: SlideTransitionFrom.center,
        builder: (context) {
          return TDPopupCenterPanel(
            closeClick: () {
              Navigator.maybePop(context);
            },
            child: SizedBox(
              height: height * 0.5,
              width: width * 0.8,
              child: AddAdminPage(
                callBack: (Role role) {
                  roleList.add(role.toJson());
                  Navigator.maybePop(context);
                  setState(() {});
                },
              ),
            ),
          );
        }));
  }

  void addOps() {
    Navigator.of(context).push(TDSlidePopupRoute(
        modalBarrierColor: TDTheme.of(context).fontGyColor2,
        isDismissible: false,
        slideTransitionFrom: SlideTransitionFrom.center,
        builder: (context) {
          return TDPopupCenterPanel(
            closeClick: () {
              Navigator.maybePop(context);
            },
            child: SizedBox(
              height: height * 0.8,
              width: width * 0.8,
              child: AddOpsPage(
                callBack: (Role role) {
                  roleList.add(role.toJson());
                  Navigator.maybePop(context);
                  setState(() {});
                },
              ),
            ),
          );
        }));
  }

  // 编辑角色权限
  void editRolePermission(int index) {
    Navigator.of(context).push(TDSlidePopupRoute(
        modalBarrierColor: TDTheme.of(context).fontGyColor2,
        isDismissible: false,
        slideTransitionFrom: SlideTransitionFrom.center,
        builder: (context) {
          return TDPopupCenterPanel(
            closeClick: () {
              Navigator.maybePop(context);
            },
            child: SizedBox(
              height: height * 0.6,
              width: width * 0.8,
              child: EditRolePermissionPage(
                callBack: (List<dynamic> permissionList) {
                  roleList[index]["permission_list"] = permissionList;
                  Navigator.maybePop(context);
                  setState(() {});
                },
                permissionList:
                    copyWithList(roleList[index]["permission_list"]),
              ),
            ),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Permission Configuration'),
      ),
      backgroundColor: Colors.white,
      //resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: addAdmin,
                child: Text('Add Admin'),
              ),
              ElevatedButton(
                onPressed: addOps,
                child: Text('Add Ops'),
              ),
            ],
          ),
          Expanded(
            child: RawScrollbar(
              thumbColor: Colors.grey,
              controller: _scrollController,
              thumbVisibility: true, // 一直显示滑动条
              thickness: 8, // 滑动条的宽度
              radius: const Radius.circular(10),
              interactive: true, // 滑动条为true 可拖动
              child: ReorderableListView.builder(
                  scrollController: _scrollController,
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: deviceItem,
                  itemCount: roleList.length,
                  onReorder: _onReorder),
            ),
          ),
          widget.allowEdit ? buildSaveBtn() : const SizedBox.shrink(),
          Footer(),
        ],
      ),
    );
  }

  Widget deviceItem(BuildContext context, int index) {
    if (index >= roleList.length) {
      return const SizedBox.shrink();
    }

    String account = roleList[index]["account"];
    String accountClassString = roleList[index]["account_class"];
    RoleClass roleClassEnum = RoleClass.values.byName(accountClassString);

    return ListTile(
      key: ObjectKey(index),
      selectedColor: ColorPalette.materialGreen,
      title: Text("$account"),
      subtitle: Text("$accountClassString"),
      leading: CircleAvatar(
        child: Icon(Icons.person),
      ),
      trailing: SizedBox(
        width: width * 0.15,
        child: Row(
          children: [
            Spacer(),
            Visibility(
                visible: roleClassEnum == RoleClass.ops,
                child: InkWell(
                  child: Icon(Icons.edit_note),
                  onTap: () {
                    editRolePermission(index);
                  },
                )),
            InkWell(
              child: Icon(Icons.delete_forever),
              onTap: () async {
                roleList.removeAt(index);
                LogPrinter.log("delete account ${account} success");
                setState(() {});
              },
            )
          ],
        ),
      ),
      onTap: () {},
    );
  }

  _onReorder(int oldIndex, int newIndex) {
    if (!widget.allowEdit) {
      return;
    }
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    var item = roleList.removeAt(oldIndex);
    roleList.insert(newIndex, item);
    setState(() {});
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
              PermissionConfig().roleList = copyWithList(roleList);
              String errorInfo = await PermissionConfig().saveFile();
              if (errorInfo.isNotEmpty) {
                Fluttertoast.showToast(msg: errorInfo);
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
