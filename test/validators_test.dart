import 'package:appp/utils/validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("is valid email", () {
    test("empty string", () {
      //final validator = Validators();
      expect(Validators.isValidEmail(""), false);
    });

    test("invalid email", () {
      expect(Validators.isValidEmail("mekd"), false);
    });

    test("valid email", () {
      expect(Validators.isValidEmail("mekd@gmail.com"), true);
    });

    test("null String", () {
      expect(Validators.isValidEmail(null), false);
    });
  });

  group("is password valid", () {
    test("password empty", () {
      expect(Validators.isValidPassword(""), false);
    });

    test("weak password", () {
      expect(Validators.isValidPassword("1234as"), false);
    });
    test("strong passwrod", () {
      expect(Validators.isValidPassword("Cybma12345@!"), true);
    });

    test("null password string", () {
      expect(Validators.isValidPassword(null), false);
    });
  });
}
