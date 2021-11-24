import 'package:appp/lib.dart';

class RequestRepo {
  RequestProvider requestProvider;

  RequestRepo() : assert(RequestProvider != null) {
    RequestProvider.getInstance().then((value) {
      this.requestProvider = value;
    });
  }

  Future<String> createRequest(RequestElement request) async {
    return await requestProvider.createRequest(request);
  }

  Future<Request> getAllRequest() async {
    return await requestProvider.getAllRequests();
  }

  Future<Request> getMyRequest() async {
    return await requestProvider.getMyRequests();
  }

  Future<void> deleteReqyest(String id) async {
    return await requestProvider.deleterequests(id);
  }

  Future<String> updateRequest(RequestElement element) async {
    return await requestProvider.updateRequest(element);
  }
}
