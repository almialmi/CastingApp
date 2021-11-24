import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("try again", (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: TryAgain(
        
      
        
      )),
    );
    final button = find.byType(RaisedButton);
    expect(button, findsOneWidget);
    expect(find.byType(FlatButton), findsNothing);
  });
}
