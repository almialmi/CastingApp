import 'dart:convert';
import 'package:appp/lib.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ComputitionProvider {
  static Client client;
  // Header Data Will be listed here ...
  static ComputitionProvider _handler;
  static SessionHandler _sessHandler;
  static HttpCallHandler httpCallHandler;
  static const String HOST = baseURL;

  static Future<ComputitionProvider> getInstance() async {
    if (httpCallHandler == null) {
      httpCallHandler = await HttpCallHandler.getInstance();
      _sessHandler = await HttpCallHandler.sessionHandler;
      client = httpCallHandler.client;
    }
    if (_sessHandler == null) {
      _sessHandler = await HttpCallHandler.sessionHandler;
    }
    if (_handler == null) {
      _handler = new ComputitionProvider();
    }

    return _handler;
  }

  Future<COmputationPost> createComputition(COmputationPost comp) async {
    String header = await _sessHandler.getHeader();
    var url = Uri.parse('$baseURL/api/registerComputationPost/');
    print("min honk ahun demo");
    final response = await client.post(
      url,
      headers: await SharedPrefUtils.getStringValuesSF().then((token) {
        return (<String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
          'cookie': header
        });
      }),
      body: jsonEncode(<String, dynamic>{
        'user': comp.userid,
        'eventForComputation': comp.eventid,
        'video': comp.video,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
    
      return COmputationPost.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create request.');
    }
  }

  Future<Computation> getComputations(String id) async {
    String header = await _sessHandler.getHeader();
    var url = Uri.parse('$baseURL/api/showComputationPosts/$id');
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
      print(response.statusCode);
      final Computation compute = computationFromJson(response.body);
      return compute;
    } else {
      throw Exception('Failed to load computition');
    }
  }

  Future<void> deleteComputition(String id) async {
    String header = await _sessHandler.getHeader();
    var url = Uri.parse('$baseURL/api/deleteComputationPost/$id');
    final http.Response response = await client.delete(url,
        headers: await SharedPrefUtils.getStringValuesSF().then((token) {
          print(token);
          return (<String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
            'cookie': header
          });
        }));

    if (response.statusCode != 200) {
      throw Exception('Cant delete compution');
    }
  }

  Future<String> updateJudgePoints(String id, int judgePoints) async {
    String header = await _sessHandler.getHeader();

    var url = Uri.parse('$baseURL/api/fillJugePoints/$id');
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
        'jugePoints': judgePoints,
      }),
    );

    if (response.statusCode != 200) {
      print(response.statusCode);
      throw Exception('Failed to update like.');
    }
    final result = jsonDecode(response.body) as Map<String, dynamic>;
    try {
      return ("${result['message']}");
    } catch (e) {
      return null;
    }
  }

  Future<Winners> winers(String id) async {
    String header = await _sessHandler.getHeader();
    var url = Uri.parse('$baseURL/api/showBestThreeWinners/$id');
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
      final Winners compute = winnersFromJson(response.body);
      return compute;
    } else {
      throw Exception('Failed to load computition');
    }
  }

  Future<int> updateLike(String postownerid, String loggdUserId) async {
    String header = await _sessHandler.getHeader();
    var url = Uri.parse('$baseURL/api/updateNumberOfLikes/$postownerid');
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
    var url = Uri.parse('$baseURL/api/updateNumberOfDisLikes/$postownerid');
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
}
