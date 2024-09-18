import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static Future<void> setData(String key, String val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, val);
  }

  static Future<String> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? readKey = prefs.getString(key);
    return readKey!;
  }

  static Future<bool> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    Future<bool> isremoved = prefs.remove(key);
    return isremoved;
  }
}
