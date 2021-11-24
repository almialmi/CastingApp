import 'dart:convert';
import 'dart:io';
import 'package:appp/lib.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class PostProvider {
  static Client client;
  // Header Data Will be listed here ...
  static PostProvider _handler;
  static SessionHandler _sessHandler;
  static HttpCallHandler httpCallHandler;
  static const String HOST = baseURL;

  static Future<PostProvider> getInstance() async {
    if (httpCallHandler == null) {
      httpCallHandler = await HttpCallHandler.getInstance();
      _sessHandler = await HttpCallHandler.sessionHandler;
      client = httpCallHandler.client;
    }
    if (_sessHandler == null) {
      _sessHandler = await HttpCallHandler.sessionHandler;
    }
    if (_handler == null) {
      _handler = new PostProvider();
    }

    return _handler;
  }

  Future<String> createUser(
      PostElement post, File profile, File profile1, File profile2) async {
    String header = await _sessHandler.getHeader();
    Map<String, dynamic> requestBody = <String, dynamic>{
      'firstName': post.firstName,
      'lastName': post.lastName,
      'age': post.age,
      'mobile': post.mobile,
      'category': post.categoryId,
      'video': post.video,
//         'photos': post.photos,
      'gender': post.gender,
//         'like': post.like,
    };

    var headers = await SharedPrefUtils.getStringValuesSF().then((token) {
      //print(token);
      return (<String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'cookie': header
      });
    });

    var req =
        http.MultipartRequest('POST', Uri.parse('$baseURL/api/registerUser'))
          ..headers.addAll(headers)
          ..fields.addAll(requestBody);

    final file = await http.MultipartFile.fromPath("photos", profile.path);
    req.files.add(file);
    final file1 = await http.MultipartFile.fromPath("photos", profile1.path);
    req.files.add(file1);
    final file2 = await http.MultipartFile.fromPath("photos", profile2.path);
    req.files.add(file2);

    try {
      var res = await req.send();

      final response = await res.stream.bytesToString();

      final result = jsonDecode(response) as Map<String, dynamic>;
      print("creating $result");
      return ("${result['message']}");
    } catch (e) {
      print("//*** Error: $e");
      throw Exception('Failed to create idea.');
    }
  }

  Future<Post> getPosts(String categoryId, String gender, int page) async {
    String header = await _sessHandler.getHeader();
    var url = Uri.parse(
        '$baseURL/api/fetchMaleAndFemaleUser/$categoryId/$gender?page=$page&size=5');
    final http.Response response = await client.get(url,
        headers: await SharedPrefUtils.getStringValuesSF().then((token) {
          return (<String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
            'cookie': header
          });
        }));
    if (response.statusCode == 200) {
      final Post cats = postFromJson(response.body);
      return cats;
    } else {
      throw Exception('Failed to load cinemas');
    }
  }

  Future<Post> getAllUsers() async {
    String header = await _sessHandler.getHeader();
    var url = Uri.parse('$baseURL/api/fetchAllUser');
    final http.Response response = await client.get(url,
        headers: await SharedPrefUtils.getStringValuesSF().then((token) {
          return (<String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
            'cookie': header
          });
        }));
    if (response.statusCode == 200) {
      final Post cats = postFromJson(response.body);
      print("all users load $cats");
      return cats;
    } else {
      throw Exception('Failed to load cinemas');
    }
  }

  Future<String> deleteUser(String id) async {
    String header = await _sessHandler.getHeader();
    var url = Uri.parse('$baseURL/api/deleteUser/$id');
    final http.Response response = await client.delete(url,
        headers: await SharedPrefUtils.getStringValuesSF().then((token) {
          return (<String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
            'cookie': header
          });
        }));
    try {
      final result = jsonDecode(response.body) as Map<String, dynamic>;
      return ("${result['message']}");
    } catch (e) {
      print("//*** Error: $e");
      throw Exception('Failed to create idea.');
    }
  }

  Future<int> updateLike(String postownerid, String loggdUserId) async {
    String header = await _sessHandler.getHeader();
    var url = Uri.parse('$baseURL/api/updateLike/$postownerid');
    final http.Response response = await client.put(
      url,
      headers: await SharedPrefUtils.getStringValuesSF().then((token) {
        print(token);
        return (<String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
          'cookie': header
        });
      }),
      body: jsonEncode(<String, dynamic>{
        'id': loggdUserId,
      }),
    );
    print(response.body);

    if (response.statusCode != 200) {
      print(response);
      return null;
    }
    final result = jsonDecode(response.body) as Map<String, dynamic>;
    try {
      return int.parse("${result['nomberOfLike']}");
    } catch (e) {
      return null;
    }
  }

  Future<int> updateDislike(String postownerid, String loggdUserId) async {
    String header = await _sessHandler.getHeader();
    var url = Uri.parse('$baseURL/api/updateDisLike/$postownerid');
    final http.Response response = await client.put(
      url,
      headers: await SharedPrefUtils.getStringValuesSF().then((token) {
        print(token);
        return (<String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
          'cookie': header
        });
      }),
      body: jsonEncode(<String, dynamic>{
        'id': loggdUserId,
      }),
    );

    if (response.statusCode != 200) {
      print(response.statusCode);
      return null;
    }
    // nomberOfDisike
    final result = jsonDecode(response.body) as Map<String, dynamic>;
    try {
      return int.parse("${result['nomberOfDisike']}");
    } catch (e) {
      return null;
    }
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

  Future<String> updateUserProfile(PostElement post) async {
    String header = await _sessHandler.getHeader();

    var url = Uri.parse('$baseURL/api/updateUserProfile/${post.id}');
    final http.Response response = await client.put(
      url,
      headers: await SharedPrefUtils.getStringValuesSF().then((token) {
        print(token);
        return (<String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
          'cookie': header
        });
      }),
      body: jsonEncode(<String, dynamic>{
        'firstName': post.firstName,
        'lastName': post.lastName,
        'age': post.age,
        'mobile': post.mobile,
        'category': post.categoryId,
        'video': post.video,
        'gender': post.gender,
      }),
    );
    try {
      final result = jsonDecode(response.body) as Map<String, dynamic>;
      return ("${result['message']}");
    } catch (e) {
      print("//*** Error: $e");
      throw Exception('Failed to update user.');
    }
  }

  Future<String> getallname() async {
    String header = await _sessHandler.getHeader();
    var url = Uri.parse('$baseURL/api/showCategory/');
    final http.Response response = await http.get(url,
        headers: await SharedPrefUtils.getStringValuesSF().then((token) {
          print(token);
          return (<String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
            'cookie': header
          });
        }));

    if (response.statusCode == 200) {
      var jsonbody = response.body;
      var jsondata = jsonDecode(jsonbody);
      return jsondata;
    } else {
      throw Exception('Failed to load category');
    }
  }
}
