import 'dart:convert';
import 'dart:io';
import 'package:appp/advertisement/advertisement.dart';
import 'package:appp/lib.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AdvertProvider {
  static Client client;
  static AdvertProvider _handler;
  static SessionHandler _sessHandler;
  static HttpCallHandler httpCallHandler;
  static const String HOST = baseURL;

  static Future<AdvertProvider> getInstance() async {
    if (httpCallHandler == null) {
      httpCallHandler = await HttpCallHandler.getInstance();
      _sessHandler = await HttpCallHandler.sessionHandler;
      client = httpCallHandler.client;
    }
    if (_sessHandler == null) {
      _sessHandler = await HttpCallHandler.sessionHandler;
    }
    if (_handler == null) {
      _handler = new AdvertProvider();
    }
    return _handler;
  }

  Future<String> creatAdvert(AdvertElement advert) async {
    String header = await _sessHandler.getHeader();
    var url = Uri.parse('$baseURL/api/createAdvertizement/');
    final response = await client.post(
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
        'topic': advert.topic,
        'description': advert.description,
      }),
    );

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        print("fucking advert responce is $result");
        return ("${result['message']}");
      }
    } catch (e) {
      throw Exception('Failed to create request.');
    }
  }

  Future<Advert> getadverts(String status) async {
    String header = await _sessHandler.getHeader();
    var url = Uri.parse('$baseURL/api/showAdvertizement/$status');
    final http.Response response = await client.get(url,
        headers: await SharedPrefUtils.getStringValuesSF().then((token) {
          print(token);
          return (<String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
            'cookie': header
          });
        }));
    if (response.statusCode == 200) {
      final Advert advert = advertFromJson(response.body);
      print("ewayyyy $advert");
      return advert;
    } else {
      throw Exception('Failed to load adverts');
    }
  }

  Future<String> deleteAdvert(String id) async {
    String headers = await _sessHandler.getHeader();
    var url = Uri.parse('$baseURL/api/deleteAdveritizment/$id');
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
      print("fucking delete responce $result");
      return ("${result['message']}");
    } catch (e) {
      print("//*** Error: $e");
      throw Exception('Failed to delete adverts.');
    }
  }

  Future<String> updateAdverts(AdvertElement advert) async {
    String header = await _sessHandler.getHeader();

    var url = Uri.parse('$baseURL/api/updateAdvertizement/${advert.id}');
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
        "topic": advert.topic,
        "description": advert.description,
        "status": advert.status
      }),
    );

    try {
      final result = jsonDecode(response.body) as Map<String, dynamic>;
      print("fucking updated responce $result");
      return ("${result['message']}");
    } catch (e) {
      print("//*** Error: $e");
      throw Exception('Failed to delete adverts.');
    }
  }
}
