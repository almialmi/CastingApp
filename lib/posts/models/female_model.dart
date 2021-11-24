import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'female_model.g.dart';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

@JsonSerializable()
class Post {
  Post({
    this.totalItems,
    this.totalPages,
    this.pageNumber,
    this.pageSize,
    this.post,
  });

  int totalItems;
  dynamic totalPages;
  dynamic pageNumber;
  int pageSize;
  List<PostElement> post;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        totalItems: json["totalItems"],
        totalPages: json["totalPages"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        post: List<PostElement>.from(
            json["post"].map((x) => PostElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "totalPages": totalPages,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "post": List<dynamic>.from(post.map((x) => x.toJson())),
      };
}

class PostElement {
  PostElement({
    this.photo1,
    this.photo2,
    this.photo3,
    //this.photo4,
    this.gender,
    this.like,
    this.disLike,
    this.id,
    this.firstName,
    this.lastName,
    this.age,
    this.mobile,
    this.category,
    this.video,
    this.categoryId,
  });

  String photo1;
  String photo2;
  String photo3;
  //Photo photo4;
  String gender;
  List<dynamic> like;
  List<dynamic> disLike;
  String id;
  String firstName;
  String lastName;
  int age;
  String mobile;
  CategoryNoPic category;
  String video;
  String categoryId;

  factory PostElement.fromJson(Map<String, dynamic> json) => PostElement(
        photo1: json["photo1"],
        photo2: json["photo2"],
        photo3: json["photo3"],
        //photo4: Photo.fromJson(json["photo4"]),
        gender: json["gender"],
        like: List<dynamic>.from(json["like"].map((x) => x)),
        disLike: List<dynamic>.from(json["disLike"].map((x) => x)),
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        age: json["age"],
        mobile: json["mobile"],
        categoryId: CategoryNoPic.fromJson(json["category"]).id,
        category: CategoryNoPic.fromJson(json["category"]),
        video: json["video"],
      );

  Map<String, dynamic> toJson() => {
        "photo1": photo1,
        "photo2": photo2,
        "photo3": photo3,
        //"photo4": photo4.toJson(),
        "gender": gender,
        "like": List<dynamic>.from(like.map((x) => x)),
        "disLike": List<dynamic>.from(disLike.map((x) => x)),
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "age": age,
        "mobile": mobile,
        "category": category.toJson(),
        "video": video,
      };
}

class CategoryNoPic {
  CategoryNoPic({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory CategoryNoPic.fromJson(Map<String, dynamic> json) {
    try {
      return CategoryNoPic(
        id: json["_id"],
        name: json["name"],
      );
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        "_id": id,
        "name": name,
      };
    } catch (e) {
      return null;
    }
  }
}
