  import 'package:shared_preferences/shared_preferences.dart';

class StorageUtils{
  static Future<void> saveData(Map<String, String> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("$data");
    data.forEach((key, value) {
      prefs.setString(key, value);
    });
  }

static Future<Map<String, String>> getData(Set<String> keys) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> res = {};

    keys.forEach((element) {
      res[element] = prefs.getString(element) ?? "";
    });

    return res;
  }

  static Future<void> removeData(Set<String> keys) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    keys.forEach((element) {
      prefs.remove(element);
    });
  }
  
  static Future<void> clearData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
