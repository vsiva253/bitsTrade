import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const _tokenKey = 'authToken';
  static const _tokenTimestampKey = 'authTokenTimestamp';

  // Save token and current timestamp
  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setInt(_tokenTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  // Retrieve token
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Retrieve timestamp
  static Future<int?> getTokenTimestamp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_tokenTimestampKey);
  }

  // Clear token and timestamp
  static Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_tokenTimestampKey);
  }

  // Remove specific key
  static Future<void> remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
