import 'package:appp/lib.dart';
import 'package:appp/user/screens/login/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("login form", (WidgetTester tester) async {
    await tester.pumpWidget(BlocProvider(
      create: (context) => LoginBloc(),
      child: MaterialApp(home: LoginForm()),
    ));
  });
}
