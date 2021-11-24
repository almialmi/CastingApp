import 'dart:convert';

Verify verifyFromJson(String str) => Verify.fromJson(json.decode(str));

String verifyToJson(Verify data) => json.encode(data.toJson());

class Verify {
  Verify({
    this.message,
  });

  String message;

  factory Verify.fromJson(Map<String, dynamic> json) => Verify(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
