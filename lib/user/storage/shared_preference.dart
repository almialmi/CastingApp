import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefKeys {
  SharedPrefKeys._();
  static const String darkModeEnabled = 'darkModeEnabled';
}

class SharedPrefUtils {
  static const ID = 'id';
  static SharedPrefUtils _instance;
  static SharedPreferences _preferences;

  SharedPrefUtils._internal();

  static addStringToSF(String role, String email, String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('role', role);
    prefs.setString('email', email);
    prefs.setString('id', id);
  }

  static getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    return stringValue;
  }

 

  // static getrolevalue() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String stringValue = prefs.getString('role');
  //   return stringValue;
  // }

  static getidvalue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString(ID);
    return stringValue;
  }

  static getemailvalue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('email');
    return stringValue;
  }

  static destroyStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future<SharedPrefUtils> get instance async {
    if (_instance == null) {
      _instance = SharedPrefUtils._internal();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

  Future<void> setDarkModeInfo(bool isDarkModeEnabled) async =>
      await _preferences.setBool(
          SharedPrefKeys.darkModeEnabled, isDarkModeEnabled);

  bool get isDarkModeEnabled =>
      _preferences.getBool(SharedPrefKeys.darkModeEnabled);
}
