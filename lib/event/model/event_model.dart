import 'dart:convert';

import 'package:appp/lib.dart';
import 'package:json_annotation/json_annotation.dart';
part 'event_model.g.dart';

Event eventFromJson(String str) => Event.fromJson(json.decode(str));

String eventToJson(Event data) => json.encode(data.toJson());

@JsonSerializable()
class Event {
  Event(
      {this.totalItems,
      this.totalPages,
      this.pageNumber,
      this.pageSize,
      this.events,
      this.message});

  int totalItems;
  int totalPages;
  int pageNumber;
  int pageSize;
  String message;
  List<EventElement> events;

  factory Event.fromJson(Map<String, dynamic> json) {
    return json == null
        ? null
        : () {
            try {
              return Event(
                  totalItems: json["totalItems"],
                  totalPages: json["totalPages"],
                  pageNumber: json["pageNumber"],
                  pageSize: int.parse("${json["pageSize"]}"),
                  message: json["message"],
                  events: (json["Events"] as List<dynamic>).map((e) {
                    return e == null ? null : EventElement.fromJson(e);
                  }).toList());
            } catch (e) {
              return [];
            }
          }();
    ;
  }

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "totalPages": totalPages,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "message": message,
        "Events":
            List<Map<String, dynamic>>.from(events.map((x) => x.toJson())),
      };
}

class EventElement {
  EventElement({
    this.photo,
    this.closed,
    this.id,
    this.startDate,
    this.name,
    this.description,
    this.category,
    this.categoryId,
    this.endDate,
  });

  String photo;
  bool closed = false;
  String id;
  DateTime startDate;
  String name;
  String description;
  CategoryNoPic category;

  String categoryId;

  DateTime endDate;

  factory EventElement.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    try {
      final val = EventElement(
        photo: json["photo"],
        closed: json["closed"],
        id: json["_id"],
        startDate: DateTime.parse(json["startDate"]),
        name: json["name"],
        description: json["description"],
        categoryId: CategoryNoPic.fromJson(json["category"]).id,
        category: CategoryNoPic.fromJson(json["category"]),
        endDate: DateTime.parse(json["endDate"]),
      );
      return val;
    } catch (e, a) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    try {
      final json = {
        "photo": photo,
        "closed": closed,
        "_id": id,
        "startDate": startDate.toIso8601String(),
        "name": name,
        "description": description,
        "category": category.toJson(),
        "endDate": endDate.toIso8601String(),
      };
      print(" TO JSOON : $json");
      return json;
    } catch (e, a) {
      return null;
    }
  }
}
