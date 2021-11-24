import 'dart:convert';

Computation computationFromJson(String str) =>
    Computation.fromJson(json.decode(str));

String computationToJson(Computation data) => json.encode(data.toJson());

class Computation {
  Computation({
    this.totalItems,
    this.totalPages,
    this.pageNumber,
    this.pageSize,
    this.cOmputationPosts,
  });

  int totalItems;
  dynamic totalPages;
  dynamic pageNumber;
  int pageSize;
  List<COmputationPost> cOmputationPosts;

  factory Computation.fromJson(Map<String, dynamic> json) => Computation(
        totalItems: json["totalItems"],
        totalPages: json["totalPages"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        cOmputationPosts: List<COmputationPost>.from(
            json["COmputationPosts"].map((x) => COmputationPost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "totalPages": totalPages,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "COmputationPosts":
            List<dynamic>.from(cOmputationPosts.map((x) => x.toJson())),
      };
}

class COmputationPost {
  COmputationPost({
    this.like,
    this.disLike,
    this.jugePoints,
    this.sumOfJugePoints,
    this.id,
    this.user,
    this.eventForComputation,
    this.video,
    this.userid,
    this.eventid,
  });

  List<dynamic> like;
  List<dynamic> disLike;
  List<dynamic> jugePoints;
  int sumOfJugePoints;
  String eventid;
  String userid;
  String id;
  User user;
  EventForComputation eventForComputation;
  String video;

  factory COmputationPost.fromJson(Map<String, dynamic> json) =>
      COmputationPost(
        like: List<dynamic>.from(json["like"].map((x) => x)),
        disLike: List<dynamic>.from(json["disLike"].map((x) => x)),
        jugePoints: List<dynamic>.from(json["jugePoints"].map((x) => x)),
        sumOfJugePoints: json["sumOfJugePoints"],
        id: json["_id"],
        user: User.fromJson(json["user"]),
        eventForComputation:
            EventForComputation.fromJson(json["eventForComputation"]),
        video: json["video"],
        userid: User.fromJson(json["user"]).id,
        eventid: EventForComputation.fromJson(json["eventForComputation"]).id,
      );

  Map<String, dynamic> toJson() => {
        "like": List<dynamic>.from(like.map((x) => x)),
        "disLike": List<dynamic>.from(disLike.map((x) => x)),
        "jugePoints": List<dynamic>.from(jugePoints.map((x) => x)),
        "sumOfJugePoints": sumOfJugePoints,
        "_id": id,
        "user": user.toJson(),
        "eventForComputation": eventForComputation.toJson(),
        "video": video,
      };
}

class EventForComputation {
  EventForComputation({
    this.id,
    this.name,
    this.description,
  });

  String id;
  String name;
  String description;

  factory EventForComputation.fromJson(Map<String, dynamic> json) =>
      EventForComputation(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
      };
}

class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.mobile,
  });

  String id;
  String firstName;
  String lastName;
  String mobile;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        mobile: json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
      };
}
