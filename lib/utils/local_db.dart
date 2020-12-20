import 'package:shared_preferences/shared_preferences.dart';

class LocalDatabaseService {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  updateSecurityToken(String token) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString("token", token);
  }

  deleteSecurityToken() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove('token');
  }

  Future<String> getSecurityToken() async {
    final SharedPreferences prefs = await _prefs;
    String token = prefs.getString('token');
    if (token == null) {
      token = '0';
    }
    return token;
  }
}
