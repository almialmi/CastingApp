import 'dart:convert';
import 'dart:io';
import 'package:appp/lib.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class CategoryProvider {
  static Client client;
  static CategoryProvider _handler;
  static SessionHandler _sessHandler;
  static HttpCallHandler httpCallHandler;
  static const String HOST = baseURL;

  static Future<CategoryProvider> getInstance() async {
    if (httpCallHandler == null) {
      httpCallHandler = await HttpCallHandler.getInstance();
      _sessHandler = await HttpCallHandler.sessionHandler;
      client = httpCallHandler.client;
    }
    if (_sessHandler == null) {
      _sessHandler = await HttpCallHandler.sessionHandler;
    }
    if (_handler == null) {
      _handler = new CategoryProvider();
    }
    return _handler;
  }

  Future<String> createCategory(Category cat, File profile) async {
    String header = await _sessHandler.getHeader();
    Map<String, String> requestBody = <String, String>{
      "name": cat.name,
    };

    var headers = await SharedPrefUtils.getStringValuesSF().then((token) {
      return (<String, String>{
        'Content-Type': 'multipart/form-data;charset=UTF-8',
        'Authorization': 'Bearer $token',
        'cookie': header
      });
    });

    var req =
        http.MultipartRequest('POST', Uri.parse('$baseURL/api/createCategory/'))
          ..headers.addAll(headers)
          ..fields.addAll(requestBody);
    final file = await http.MultipartFile.fromPath("photo", profile.path);
    req.files.add(file);
    print(file);

    try {
      var res = await req.send();
      final response = await res.stream.bytesToString();
      print(response);
      final result = jsonDecode(response) as Map<String, dynamic>;
      print(result);
      return ("${result['message']}");
    } catch (e) {
      print("//*** Error: $e");
      throw Exception('Failed to create idea.');
    }
  }

  Future<List<Category>> getCategory() async {
    String headers = await _sessHandler.getHeader();
    var url = Uri.parse('$baseURL/api/showCategory/');
    final http.Response response = await client.get(url,
        headers: await _sessHandler.getStringValuesSF().then((token) {
          return (<String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
            'cookie': headers,
          });
        }));
   
    if (response.statusCode == 200) {
      final List<Category> cats = categoryFromJson(response.body);
      return cats;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<String> deleteCategory(String id) async {
    String headers = await _sessHandler.getHeader();
    var url = Uri.parse('$baseURL/api/deleteCategory/$id');
    final http.Response response = await client.delete(url,
        headers: await SharedPrefUtils.getStringValuesSF().then((token) {
          print(token);
          return (<String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
            'cookie': headers
          });
        }));
    try {
      final result = jsonDecode(response.body) as Map<String, dynamic>;
      print(result);
      return ("${result['message']}");
    } catch (e) {
      print("//*** Error: $e");
      throw Exception('Failed to delete category.');
    }
  }

  Future<void> updateCategoryimage(Category category, File profile) async {
    String header = await _sessHandler.getHeader();
    var headers = await SharedPrefUtils.getStringValuesSF().then((token) {
      return (<String, String>{
        'Content-Type': 'multipart/form-data;charset=UTF-8',
        'Authorization': 'Bearer $token',
        'cookie': header
      });
    });
    Map<String, String> requestBody = <String, String>{
      "name": category.name,
    };
    var req = http.MultipartRequest('PUT',
        Uri.parse('$baseURL/api/upadteCategotyProfilePic/${category.id}'))
      ..headers.addAll(headers)
      ..fields.addAll(requestBody);

    final file = await http.MultipartFile.fromPath("photo", profile.path);
    req.files.add(file);
    try {
      var res = await req.send();
      final response = await res.stream.bytesToString();
      print(response);
      return response;
    } catch (e) {
      print("//*** Error: $e");
      throw Exception('Failed to update cat image.');
    }
  }

  Future<void> updateCategory(Category category) async {
    String header = await _sessHandler.getHeader();

    var url = Uri.parse('$baseURL/api/updateCatagoryProfile/${category.id}');
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
        "name": category.name,
      }),
    );

    if (response.statusCode != 200) {
      print(response.body);
      throw Exception('Failed to update category.');
    }
  }

  Future<void> deleterequests(String id) async {
    var url = Uri.parse('$baseURL/api/deleteRequest/$id');
    final http.Response response = await client.delete(url,
        headers: await SharedPrefUtils.getStringValuesSF().then((token) {
          print(token);
          return (<String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          });
        }));

    if (response.statusCode != 200) {
      throw Exception('Cant delete request');
    }
  }
}
