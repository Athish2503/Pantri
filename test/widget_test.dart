import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pantri/main.dart';

void main() {
  testWidgets('App initializes smoke test', (WidgetTester tester) async {
    // Build our app wrapped in ProviderScope to support Riverpod dependencies
    await tester.pumpWidget(const ProviderScope(child: PantriApp()));

    // Verify root container or title rendering
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
