import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Keys
  static const String _keyIsLogin = 'is_login';
  static const String _keyUser = 'user_data';
  static const String _keyToken = 'jwt_token';
  static const String _keyFcmToken = 'fcm_token';
  static const String _keyOnboarding = 'onboarding_completed';
  static const String _keyLastReadAyat = 'last_read_ayat';
  static const String _keyLastReadHal = 'last_read_halaman';

  // Auth & User
  static bool get isLogin => _prefs.getBool(_keyIsLogin) ?? false;
  static set isLogin(bool value) => _prefs.setBool(_keyIsLogin, value);

  static String? get token => _prefs.getString(_keyToken);
  static set token(String? value) {
    if (value == null) {
      _prefs.remove(_keyToken);
    } else {
      _prefs.setString(_keyToken, value);
    }
  }

  static String? get userJson => _prefs.getString(_keyUser);
  static set userJson(String? value) {
    if (value == null) {
      _prefs.remove(_keyUser);
    } else {
      _prefs.setString(_keyUser, value);
    }
  }

  static String? get fcmToken => _prefs.getString(_keyFcmToken);
  static set fcmToken(String? value) {
    if (value == null) {
      _prefs.remove(_keyFcmToken);
    } else {
      _prefs.setString(_keyFcmToken, value);
    }
  }

  static String? get lastReadAyat => _prefs.getString(_keyLastReadAyat);
  static set lastReadAyat(String? value) {
    if (value == null) {
      _prefs.remove(_keyLastReadAyat);
    } else {
      _prefs.setString(_keyLastReadAyat, value);
    }
  }

  static int? get lastReadHal => _prefs.getInt(_keyLastReadHal);
  static set lastReadHal(int? value) {
    if (value == null) {
      _prefs.remove(_keyLastReadHal);
    } else {
      _prefs.setInt(_keyLastReadHal, value);
    }
  }

  static bool get onboardingCompleted => _prefs.getBool(_keyOnboarding) ?? false;
  static set onboardingCompleted(bool value) => _prefs.setBool(_keyOnboarding, value);

  // Clear session on logout
  static Future<void> clearAuth() async {
    await _prefs.remove(_keyIsLogin);
    await _prefs.remove(_keyUser);
    await _prefs.remove(_keyToken);
  }

  // Generic helpers
  static String? getString(String key) => _prefs.getString(key);
  static Future<bool> setString(String key, String value) => _prefs.setString(key, value);
  static bool? getBool(String key) => _prefs.getBool(key);
  static Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);
  static double? getDouble(String key) => _prefs.getDouble(key);
  static Future<bool> setDouble(String key, double value) => _prefs.setDouble(key, value);
  static int? getInt(String key) => _prefs.getInt(key);
  static Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);
  static Future<bool> remove(String key) => _prefs.remove(key);
}
