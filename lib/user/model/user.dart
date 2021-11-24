

import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';
Userr userrFromJson(String str) => Userr.fromJson(json.decode(str));

String userrToJson(Userr data) => json.encode(data.toJson());
@JsonSerializable()
class Userr {
  Userr({this.id, this.userName, this.email, this.password, this.profilePic});
  String password;
  String id;
  dynamic userName;
  String email;
  String profilePic;

  factory Userr.fromJson(Map<String, dynamic> json) => Userr(
        id: json["_id"],
        userName: json["userName"],
        email: json["email"],
        password: json["password"],
        profilePic: json['profilePic'],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userName": userName,
        "email": email,
        "profilePic": profilePic,
        "password": password
      };
}

