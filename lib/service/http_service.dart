import 'dart:developer';

import 'package:appp/lib.dart';
import 'package:http/http.dart';

import 'dart:async';

// This HTTP CALL Handler class is to be called by all the
// data_provider classes of each features
class HttpCallHandler extends Service {
  Client client = new Client();

  // Header Data Will be listed here ...
  static HttpCallHandler _handler;
  static SessionHandler _sessHandler;
  static const String HOST = baseURL;

  static Future<SessionHandler> get sessionHandler async {
    if (_handler == null) {
      await HttpCallHandler.getInstance();
      return _sessHandler;
    }
  
    return _sessHandler;
  }

  static Future<HttpCallHandler> getInstance() async {
    if (_sessHandler == null) {
      var pref = await SharedPrefHandler.getInstance();
      _sessHandler = await SessionHandler(pref);
    }
    if (_handler == null) {
      _handler = new HttpCallHandler();
      return _handler;
    }
    return _handler;
  }

 

}
