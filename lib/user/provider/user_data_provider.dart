import 'dart:convert';
import 'dart:io';

import 'package:appp/lib.dart';
import 'package:appp/user/model/verify_model.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';

class UserProvider {
  static http.Client client;
  // Header Data Will be listed here ...
  static UserProvider _handler;
  static SessionHandler _sessHandler;

  static HttpCallHandler httpCallHandler;
  static const String HOST = baseURL;

  static Future<UserProvider> getInstance() async {
    if (_handler == null) {
      _handler = new UserProvider();
      if (httpCallHandler == null) {
        httpCallHandler = await HttpCallHandler.getInstance();
        _sessHandler = await HttpCallHandler.sessionHandler;
        client = httpCallHandler.client;
      }
      if (_sessHandler == null) {
        _sessHandler = await HttpCallHandler.sessionHandler;
      }
    }
    return _handler;
  }

  Future<Userr> getLoggedInUser() async {
    while (true) {
      if (_sessHandler == null) {
        _sessHandler = SessionHandler(await () async {
          SharedPrefHandler hand = await SharedPrefHandler.getInstance();
          while (true) {
            if (hand == null) {
              hand = await SharedPrefHandler.getInstance();
            } else {
              break;
            }
          }
          return hand;
        }());
      } else {
        break;
      }
    }
    final user = await _sessHandler.getUser();
    return user;
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    var url = Uri.parse('$HOST/api/adminAndNormalUserLogin');
    final response = await client.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'password': password, 'email': email}),
    );

    final result = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      _sessHandler.updateCookie(response);
      String headers = await _sessHandler.getHeader();
      Map<String, dynamic> payload = Jwt.parseJwt(headers);
      final emaill = payload['email'].toString();
      // print("this is email $email");
      final role = payload['role'].toString();
      final id = payload['admin_id'].toString();

      _sessHandler.saveUser(id, role, emaill);
    }
    return ("${result['message']}");
  }

  Future<bool> logout() async {
    _sessHandler.saveCookie("", "");
    _sessHandler.saveUser("", "", "");
    return true;
  }

  Future<String> registor(
      String email, String password, String username) async {
    var url = Uri.parse('$baseURL/api/registerNormalUser');
    print(url);
    final response = await client.post(
      url,
      headers: (<String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }),
      body: jsonEncode(<String, dynamic>{
        'userName': username,
        'password': password,
        'email': email,
      }),
    );
    final result = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      _sessHandler.updateCookie(response);
    }
    return ("${result['message']}");
  }

  Future<Userr> fetchOwnProfile() async {
    String headers = await _sessHandler.getHeader();
    var url = Uri.parse('$baseURL/api/fetchOwnProfile/');
    final http.Response response = await client.get(url,
        headers: await _sessHandler.getStringValuesSF().then((token) {
          return (<String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
            'cookie': headers,
          });
        }));

    if (response.statusCode == 200) {
      final Userr user = userrFromJson(response.body);
      print("this is user responce $user");
      return user;
    } else {
      throw Exception('Failed to load  user profile');
    }
  }

  Future<void> updateprofilepic(File profile) async {
    String header = await _sessHandler.getHeader();
    var headers = await SharedPrefUtils.getStringValuesSF().then((token) {
      return (<String, String>{
        'Content-Type': 'multipart/form-data;charset=UTF-8',
        'Authorization': 'Bearer $token',
        'cookie': header
      });
    });
    var req =
        http.MultipartRequest('PUT', Uri.parse('$baseURL/api/updateProfilePic'))
          ..headers.addAll(headers);
    final file = await http.MultipartFile.fromPath("photo", profile.path);
    req.files.add(file);
    try {
      var res = await req.send();
      final response = await res.stream.bytesToString();
      return jsonDecode(response);
    } catch (e) {
      throw Exception('Failed to update profile.');
    }
  }

  Future<void> updateUser(Userr user) async {
    String header = await _sessHandler.getHeader();

    var url = Uri.parse('$baseURL/api/updateAdminAndNormalUserProfile');
    final http.Response response = await client.put(
      url,
      headers: await SharedPrefUtils.getStringValuesSF().then((token) {
        return (<String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
          'cookie': header
        });
      }),
      body: jsonEncode(<String, dynamic>{
        'userName': user.userName,
        'email': user.email,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile.');
    }
  }

  Future<Verify> showverificationmessage(String code) async {
    var url = Uri.parse('$baseURL/api/verfiyEmail/$code');
    final response = await http.get(
      url,
      headers: (<String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }),
    );
    if (response.statusCode == 200) {
      final Verify event = verifyFromJson(response.body);
      return event;
    } else {
      throw Exception('Failed to load verfication message');
    }
  }

  Future<String> resetPassword(
      String email, String password, String username) async {
    var url = Uri.parse('$baseURL/api/resetPassword');
    final response = await client.post(
      url,
      headers: (<String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }),
      body: jsonEncode(<String, dynamic>{
        'userName': username,
        'password': password,
        'email': email,
      }),
    );
    final result = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      _sessHandler.updateCookie(response);
    }
    return ("${result['message']}");
  }
}
