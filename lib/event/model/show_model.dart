import 'dart:convert';

Show showFromJson(String str) => Show.fromJson(json.decode(str));

String showToJson(Show data) => json.encode(data.toJson());

class Show {
    Show({
        this.message,
    });

    String message;

    factory Show.fromJson(Map<String, dynamic> json) => Show(
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
    };
}
