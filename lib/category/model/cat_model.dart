import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
part 'cat_model.g.dart';

List<Category> categoryFromJson(String str) =>
    List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class Category {
  Category({
    this.photo,
    this.id,
    this.name,
  });

  String photo;
  String id;
  String name;

  static Map<String, List<Map<String, dynamic>>> categoriesToJson(
      List<Category> categories) {
    try {
      final value = {
        "categories": Category.categoryToJson(categories),
      };
      return value;
    } catch (e) {}
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    final name = json["name"];
    if (name == null) {
      return null;
    }
    return Category(
      photo: json["photo"],
      id: json["_id"],
      name: name,
    );
  }

  @override
  String toString() => '_id: $id , name:$name , photo: $photo';

  static List<Category> listFromJson(
      List<Map<String, dynamic>> categoriesJson) {
    return categoriesJson.map((json) {
      return Category.fromJson(json);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        "photo": photo,
        "_id": id,
        "name": name,
      };

  static List<Map<String, dynamic>> categoryToJson(List<Category> data) =>
      List<Map<String, dynamic>>.from(data.map((x) => x.toJson()));
}

enum Type { BUFFER }

final typeValues = EnumValues({"Buffer": Type.BUFFER});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
