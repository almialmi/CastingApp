// To parse this JSON data, do
//
//     final advert = advertFromJson(jsonString);

import 'dart:convert';

Advert advertFromJson(String str) => Advert.fromJson(json.decode(str));

String advertToJson(Advert data) => json.encode(data.toJson());

class Advert {
    Advert({
        this.totalItems,
        this.totalPages,
        this.pageNumber,
        this.pageSize,
        this.adverts,
    });

    int totalItems;
    dynamic totalPages;
    dynamic pageNumber;
    int pageSize;
    List<AdvertElement> adverts;

    factory Advert.fromJson(Map<String, dynamic> json) => Advert(
        totalItems: json["totalItems"],
        totalPages: json["totalPages"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        adverts: List<AdvertElement>.from(json["Adverts"].map((x) => AdvertElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "totalPages": totalPages,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "Adverts": List<dynamic>.from(adverts.map((x) => x.toJson())),
    };
}

class AdvertElement {
    AdvertElement({
        this.status,
        this.id,
        this.topic,
        this.description,
    });

    String status;
    String id;
    String topic;
    String description;

    factory AdvertElement.fromJson(Map<String, dynamic> json) => AdvertElement(
        status: json["status"],
        id: json["_id"],
        topic: json["topic"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "_id": id,
        "topic": topic,
        "description": description,
    };
}
