import 'package:appp/lib.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHandler {
  static const ID = 'id';
  static const SET_COOKIE = 'set-cookie';
  static const TOKEN = 'token';
  static const USER_NAME = 'userName';
  static const PASSWORD = 'password';
  static const EMAIL = 'email';
  static const COOK = "cookie";
  static const ROLE = "role";

  final SharedPreferences _preferences;

  static SharedPrefHandler _handler;

  SharedPrefHandler(this._preferences);

 

  static Future<SharedPrefHandler> getInstance() async {
    if (_handler == null) {
      SharedPreferences _sharedPreferences =
          await SharedPreferences.getInstance();
      _handler = new SharedPrefHandler(_sharedPreferences);
    }
    return _handler;
  }

  Future<void> saveCookie(String setCookie, String token) async {
    if (_handler == null) {
      await SharedPrefHandler.getInstance();
    }
    _handler._preferences.setString(SharedPrefHandler.TOKEN, token);
    _handler._preferences.setString(SharedPrefHandler.SET_COOKIE, setCookie);
    return;
  }

  Future<String> getCookieHeader() async {
    if (_handler == null) {
      await SharedPrefHandler.getInstance();
    }
    String cookie =
        _handler._preferences.getString(SharedPrefHandler.SET_COOKIE);
    return cookie;
  }

  static getCookieValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString(SharedPrefHandler.SET_COOKIE);
    return stringValue;
  }

  Future<String> getTokenHeader() async {
    if (_handler == null) {
      await SharedPrefHandler.getInstance();
    }
    String cookie = _handler._preferences.getString(SharedPrefHandler.TOKEN);
    return cookie;
  }

  Future<Userr> getUser() async {
    String id = _handler._preferences.getString(ID);
    String username = _handler._preferences.getString(USER_NAME);
    String email = _handler._preferences.getString(EMAIL);

    Userr user = Userr(
      id: id,
      email: email,
      userName: username,
    );
    if (user.id == "" || user.userName == "" || user.email == "") {
      return null;
    }
    return user;
  }

  Future<bool> setUser(String id, String role, String email) async {
    if (_handler == null) {
      await SharedPrefHandler.getInstance();
    }
    bool res = await _handler._preferences.setString(ID, id);
    if (!res) {
      return res;
    }
    res = await _handler._preferences.setString(ROLE, role);
    if (!res) {
      return res;
    }
    res = await _handler._preferences.setString(EMAIL, email);
    if (!res) {
      return res;
    }

    return res;
  }

  static getrolevalue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString(SharedPrefHandler.ROLE);
    return stringValue;
  }

  static Future<String> getidvalue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString(ID);
    return stringValue;
  }
}
