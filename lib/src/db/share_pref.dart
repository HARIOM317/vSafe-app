import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreference {
  static SharedPreferences? _preferences;
  static const String key = 'user_type';

  static init() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  static Future saveUserType(String type) async {
    return await _preferences!.setString(key, type);
  }

  static Future<String>? getUserType() async =>
      _preferences!.getString(key) ?? "";
}
