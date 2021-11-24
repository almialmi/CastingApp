import 'dart:convert';
import 'package:appp/lib.dart';
import 'package:appp/request/model/request_model.dart' as req;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class RequestProvider {
  static Client client;
  // Header Data Will be listed here ...
  static RequestProvider _handler;
  static SessionHandler _sessHandler;
  static HttpCallHandler httpCallHandler;
  static const String HOST = baseURL;

  static Future<RequestProvider> getInstance() async {
    if (httpCallHandler == null) {
      httpCallHandler = await HttpCallHandler.getInstance();
      _sessHandler = await HttpCallHandler.sessionHandler;
      client = httpCallHandler.client;
    }
    if (_sessHandler == null) {
      _sessHandler = await HttpCallHandler.sessionHandler;
    }
    if (_handler == null) {
      _handler = new RequestProvider();
    }

    return _handler;
  }

  Future<String> createRequest(RequestElement request) async {
    String header = await _sessHandler.getHeader();
    var url = Uri.parse('$baseURL/api/createRequest/');
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
        'description': request.description,
        'duration': request.duration,
        'dateForWork': request.dateForWork.toString(),
        'applyer': request.applyerid,
        'requestedUser': request.requestedUserId
      }),
    );

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        return ("${result['message']}");
      }
     
    } catch (e) {
      throw Exception('Failed to create request.');
    }
  }

  Future<req.Request> getAllRequests() async {
    String header = await _sessHandler.getHeader();

    var url = Uri.parse('$baseURL/api/showRequests/');
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
      final req.Request request = requestFromJson(response.body);
      return request;
    } else {
      throw Exception('Failed to load requests');
    }
  }

  Future<req.Request> getMyRequests() async {
    String header = await _sessHandler.getHeader();
    var url = Uri.parse('$baseURL/api/fetchOwnRequest/');
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
      final req.Request request = requestFromJson(response.body);
      return request;
    } else {
      throw Exception('Failed to load requests');
    }
  }

  Future<void> deleterequests(String id) async {
    String header = await _sessHandler.getHeader();
    var url = Uri.parse('$baseURL/api/deleteRequest/$id');
    final http.Response response = await client.delete(url,
        headers: await SharedPrefUtils.getStringValuesSF().then((token) {
          return (<String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
            'cookie': header
          });
        }));

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        return ("${result['message']}");
      }
     
    } catch (e) {
      throw Exception('Failed to update request.');
    }
  }

  Future<String> updateRequest(RequestElement element) async {
    String header = await _sessHandler.getHeader();
    var url = Uri.parse('$baseURL/api/approveOrRejectRequest/${element.id}');
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
        'description': element.description,
        'applyer': element.applyer,
        'requestedUser': element.requestedUser,
        'approve': element.approve,
        'duration': element.duration,
         'dateForWork': element.dateForWork,
      }),
    );
    print("the id is ${element.id}");
    print("this should work${response.body}");

    if (response.statusCode != 200) {
      print(response.statusCode);
      throw Exception('Failed to update request.');
    }
  }
}
