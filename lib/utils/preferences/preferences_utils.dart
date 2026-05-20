import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUtils {
  static Future<SharedPreferences> getSharePref() async {
    return await SharedPreferences.getInstance();
  }

  static Future<bool> clearData() async {
    return (await getSharePref()).clear();
  }

  static Future<bool> setString(String key, String data) async {
    return (await getSharePref()).setString(key, data);
  }

  static Future<bool> setInt(String key, int data) async {
    return (await getSharePref()).setInt(key, data);
  }

  static Future<bool> setBool(String key, bool data) async {
    return (await getSharePref()).setBool(key, data);
  }

  static Future<String?> getString(String key) async {
    return (await getSharePref()).getString(key);
  }

  static Future<int?> getInt(String key) async {
    return (await getSharePref()).getInt(key);
  }

  static Future<bool> getBool(String key) async {
    var result = (await getSharePref()).getBool(key);
    if (result != null) {
      return result;
    } else {
      return false;
    }
  }

  static Future<void> deleteKey(String key) async {
    await (await getSharePref()).remove(key);
  }
}
