import 'dart:convert';
import 'dart:io';
import 'package:appp/lib.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class EventProvider {
  static Client client;
  // Header Data Will be listed here ...
  static EventProvider _handler;
  static SessionHandler _sessHandler;
  static HttpCallHandler httpCallHandler;
  static const String HOST = baseURL;

  static Future<EventProvider> getInstance() async {
    if (httpCallHandler == null) {
      httpCallHandler = await HttpCallHandler.getInstance();
      _sessHandler = await HttpCallHandler.sessionHandler;
      client = httpCallHandler.client;
    }
    if (_sessHandler == null) {
      _sessHandler = await HttpCallHandler.sessionHandler;
    }
    if (_handler == null) {
      _handler = new EventProvider();
    }
    return _handler;
  }

  Future<String> createEvent(EventElement event, File profile) async {
    String header = await _sessHandler.getHeader();
    Map<String, String> requestBody = <String, String>{
      'name': event.name,
      'description': event.description,
      'category': event.categoryId,
      'startDate': event.startDate.toString(),
      'endDate': event.endDate.toString(),
    };

    var headers = await SharedPrefUtils.getStringValuesSF().then((token) {
      return (<String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'cookie': header
      });
    });

    var req =
        http.MultipartRequest('POST', Uri.parse('$baseURL/api/registerEvent'))
          ..headers.addAll(headers)
          ..fields.addAll(requestBody);

    final file = await http.MultipartFile.fromPath("photo", profile.path);
    req.files.add(file);
    try {
      var res = await req.send();
      final response = await res.stream.bytesToString();
      final result = jsonDecode(response) as Map<String, dynamic>;
      return ("${result['message']}");
    } catch (e) {
      print("//*** Error: $e");
      throw Exception('Failed to create idea.');
    }
  }

  Future<Event> getevents(String booleann) async {
    String header = await _sessHandler.getHeader();
    var url = Uri.parse('$baseURL/api/showEvents/$booleann');
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
      final Event event = eventFromJson(response.body);
      return event;
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<Show> showRemainingTime(String id) async {
    String header = await _sessHandler.getHeader();

    var url = Uri.parse('$baseURL/api/showRemaingTimeAndExpiredDate/$id');
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
      final Show event = showFromJson(response.body);
      return event;
    } else {
      throw Exception('Failed to load remaining time');
    }
  }

  Future<String> deleteEvent(String id) async {
    String header = await _sessHandler.getHeader();
    var url = Uri.parse('$baseURL/api/deleteEvent/$id');
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
      throw Exception('Failed to delete event.');
    }
  }

  Future<String> updateEvent(EventElement event, File profile) async {
    String header = await _sessHandler.getHeader();
    print("wts wrong");
    Map<String, String> requestBody = <String, String>{
      "name": event.name,
      'description': event.description,
      'category': event.categoryId,
      'startDate': event.startDate.toString(),
      'endDate': event.endDate.toString(),
    };

    var headers = await SharedPrefUtils.getStringValuesSF().then((token) {
      return (<String, String>{
        'Content-Type': 'multipart/form-data;charset=UTF-8',
        'Authorization': 'Bearer $token',
        'cookie': header
      });
    });
    var req = http.MultipartRequest(
        'PUT', Uri.parse('$baseURL/api/updateEventProfilePic/${event.id}'))
      ..headers.addAll(headers)
      ..fields.addAll(requestBody);
    final file = await http.MultipartFile.fromPath("photo", profile.path);
    req.files.add(file);
    try {
      var res = await req.send();
      final response = await res.stream.bytesToString();
      final result = jsonDecode(response) as Map<String, dynamic>;
      return ("${result['message']}");
      //return Category.fromJson(jsonDecode(response));
    } catch (e) {
      print("//*** Error: $e");
      throw Exception('Failed to update event.');
    }
  }

  Future<String> updateEventNotpic(EventElement event) async {
    String header = await _sessHandler.getHeader();

    var url = Uri.parse('$baseURL/api/updateEventProfile/${event.id}');
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
        "name": event.name,
        'description': event.description,
        'category': event.categoryId,
        'startDate': event.startDate.toString(),
        'endDate': event.endDate.toString(),
      }),
    );
    try {
      final result = jsonDecode(response.body) as Map<String, dynamic>;
      return ("${result['message']}");
      //return Category.fromJson(jsonDecode(response));
    } catch (e) {
      print("//*** Error: $e");
      throw Exception('Failed to update event.');
    }
  }
}
