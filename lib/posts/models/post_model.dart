import 'dart:convert';

import 'package:appp/lib.dart';
import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String firstName,
      lastName,
      email,
      age,
      mobile,
      category,
      video,
      photos,
      gender,
      like,
      orderNumber;

  Post(
      {this.firstName,
      this.lastName,
      this.email,
      this.age,
      this.mobile,
      this.category,
      this.video,
      this.photos,
      this.gender,
      this.like,
      this.orderNumber});
  @override
  List<Object> get props => [
        firstName,
        lastName,
        age,
        email,
        mobile,
        category,
        video,
        photos,
        gender,
        like,
        orderNumber
      ];

  factory Post.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return Post(
      firstName: json['firstName'],
      lastName: json["lastName"],
      email: json['email'],
      mobile: json['mobile'],
      category: json["category"],
      video: json["video"],
      age: json["age"],
      photos: json['photos'],
      gender: json["gender"],
      like: json["like"],
    );
  }

  String toJson() {
    return jsonEncode({
      "firstName": this.firstName,
      "lastName": this.lastName,
      "email": this.email,
      "age": this.age,
      "mobile": this.mobile,
      "category": this.category,
      "video": this.video,
      "photos": this.photos,
      "gender": this.gender,
      "like": this.like
    });
  }
}
