import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:forma/app/forma_app.dart';

void main() {
  testWidgets('launches into the auth entry screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: FormaApp()));

    expect(find.text('FORMA'), findsWidgets);
    expect(find.text('Start onboarding'), findsOneWidget);
  });
}
