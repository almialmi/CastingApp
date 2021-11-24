import 'dart:convert';
import 'package:appp/lib.dart';
import 'package:json_annotation/json_annotation.dart';
part 'request_model.g.dart';

Request requestFromJson(String str) => Request.fromJson(json.decode(str));

String requestToJson(Request data) => json.encode(data.toJson());

@JsonSerializable()
class Request {
  Request({
    this.totalItems,
    this.totalPages,
    this.pageNumber,
    this.pageSize,
    this.request,
  });

  int totalItems;
  dynamic totalPages;
  dynamic pageNumber;
  int pageSize;
  List<RequestElement> request;

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        totalItems: json["totalItems"],
        totalPages: json["totalPages"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        request: List<RequestElement>.from(
            json["Request"].map((x) => RequestElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "totalPages": totalPages,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "Request": List<dynamic>.from(request.map((x) => x.toJson())),
      };
}

class RequestElement {
  RequestElement({
    this.approve,
    this.id,
    this.description,
    this.applyer,
    this.requestedUser,
    this.duration,
    this.dateForWork,
    this.applyerid,
    this.requestedUserId,
    this.v,
  });

  String approve;
  String id;
  String description;
  Applyer applyer;
  RequestedUser requestedUser;
  String duration;
  DateTime dateForWork;
  String applyerid;
  String requestedUserId;
  int v;

  factory RequestElement.fromJson(Map<String, dynamic> json) => RequestElement(
        approve: json["approve"],
        id: json["_id"],
        description: json["description"],
        applyer: Applyer.fromJson(json["applyer"]),
        requestedUser: RequestedUser.fromJson(json["requestedUser"]),
        duration: json["duration"],
        dateForWork: DateTime.parse(json["dateForWork"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "approve": approve,
        "_id": id,
        "description": description,
        "applyer": applyer.toJson(),
        "requestedUser": requestedUser.toJson(),
        "duration": duration,
        "dateForWork": dateForWork.toIso8601String(),
        "__v": v,
      };
}

class Applyer {
  Applyer({
    this.id,
    this.userName,
    this.email,
    this.profilePic,
  });

  String id;
  String userName;
  String email;
  String profilePic;

  factory Applyer.fromJson(Map<String, dynamic> json) => Applyer(
      id: json["_id"],
      userName: json["userName"],
      email: json["email"],
      profilePic: json["profilePic"]);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userName": userName,
        "email": email,
        "profilePic": profilePic
      };
}

class RequestedUser {
  RequestedUser({
    this.photo1,
    this.id,
    this.firstName,
    this.lastName,
    this.mobile,
  });

  String photo1;
  String id;
  String firstName;
  String lastName;
  String mobile;

  factory RequestedUser.fromJson(Map<String, dynamic> json) => RequestedUser(
        photo1: json["photo1"],
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        mobile: json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "photo1": photo1,
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
      };
}




