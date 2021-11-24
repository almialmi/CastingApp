
import 'dart:convert';

import 'comp_model.dart';

Winners winnersFromJson(String str) => Winners.fromJson(json.decode(str));

String winnersToJson(Winners data) => json.encode(data.toJson());

class Winners {
  Winners({
    this.computationPosts,
  });

  List<ComputationPost> computationPosts;

  factory Winners.fromJson(Map<String, dynamic> json) => Winners(
        computationPosts: List<ComputationPost>.from(
            json["ComputationPosts"].map((x) => ComputationPost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ComputationPosts":
            List<dynamic>.from(computationPosts.map((x) => x.toJson())),
      };
}

class ComputationPost {
  ComputationPost({
    this.like,
    this.disLike,
    this.jugePoints,
    this.sumOfJugePoints,
    this.id,
    this.user,
    this.eventForComputation,
    this.video,
  });

  List<dynamic> like;
  List<dynamic> disLike;
  List<int> jugePoints;
  int sumOfJugePoints;
  String id;
  User user;
  EventForComputation eventForComputation;
  String video;

  factory ComputationPost.fromJson(Map<String, dynamic> json) =>
      ComputationPost(
        like: List<dynamic>.from(json["like"].map((x) => x)),
        disLike: List<dynamic>.from(json["disLike"].map((x) => x)),
        jugePoints: List<int>.from(json["jugePoints"].map((x) => x)),
        sumOfJugePoints: json["sumOfJugePoints"],
        id: json["_id"],
        user: User.fromJson(json["user"]),
        eventForComputation:
            EventForComputation.fromJson(json["eventForComputation"]),
        video: json["video"],
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

