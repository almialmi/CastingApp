import 'package:appp/lib.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('from json', () {
    test("null data", () {
      final category = Category.fromJson(null);
      expect(category, null);
    });

    test("cat with all property", () {
      final cat = Category.fromJson(
          {"photo": "home/mekdes/logo.png", "_id": "1234532", "name": "model"});
      expect(cat.id, "1234532");
      expect(cat.photo, "home/mekdes/logo.png");
      expect(cat.name, "model");
    });

    test("missing name", () {
      final cat = Category.fromJson(
          {"photo": "home/mekdes/logo.png", "_id": "1234532"});
      expect(cat, null);
    });
  });

  group("to json", () {
    test("valid name", () {
      final cat = Category(id: "1234", name: "model", photo: "1233");
      expect(cat.toJson(), {
        '_id':"1234",
        'name':"model",
        'photo':"1233"
      });
    });
  });
}
