import 'package:appp/lib.dart';
import 'package:http/http.dart';

class SessionHandler {
  SessionHandler(this._pref);

  final SharedPrefHandler _pref;
  Map<String, String> headers = {"content-type": "text/json"};
  Map<String, String> cookies = {};

  Future<String> getHeader() async {
    var cook = await this._pref.getCookieHeader();
    return cook;
  }

  


  Future<String> getStringValuesSF() async {
    var token = await this._pref.getTokenHeader();
    return token;
  }

  Future<void> saveCookie(String newCookieHeader , String newtokenHeader) async {
    await this._pref.saveCookie(newCookieHeader , newtokenHeader);
    return;
  }

  Future<bool> updateCookie(Response response) async {
    if (response == null) {
      return false;
    }
    _updateCookie(response);
    String cookieString = _generateCookieHeader();
    String tokenString = _generatetoken();
    if (cookieString == '') {
      return false;
    }
    await saveCookie(cookieString , tokenString);
    return true;
  }

  void _updateCookie(Response response) {
    String allSetCookie = response.headers['set-cookie'];

    if (allSetCookie != null) {
      var setCookies = allSetCookie.split(',');

      for (var setCookie in setCookies) {
        var cookies = setCookie.split(';');

        for (var cookie in cookies) {
          _setCookie(cookie);
        }
      }

      headers['cookie'] = _generateCookieHeader();
    }
  }

  void _setCookie(String rawCookie) {
    if (rawCookie.length > 0) {
      //rawCookie.split('=').where((s) => s.isNotEmpty).toList(growable: false)
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];

        // ignore keys that aren't cookies
        if (key == 'Path' || key == 'Expires') return;

        this.cookies[key] = value;
      }
    }
  }

  String _generateCookieHeader() {
    String cookie = "";

    for (var key in cookies.keys) {
      if (cookie.length > 0) cookie += ";";
      cookie += key + "=" + cookies[key];
      //cookie += cookies[key];
    }
    return cookie;
  }

  String _generatetoken() {
    String cookie = "";

    for (var key in cookies.keys) {
      if (cookie.length > 0) cookie += ";";
      cookie += cookies[key];
      //cookie += cookies[key];
    }
    return cookie;
  }

  Future<bool> saveUser(String id , String role  , String email) async {
    return await this._pref.setUser(id, role, email);
  }

  Future<Userr> getUser() async {
    return await this._pref.getUser();
  }
}
