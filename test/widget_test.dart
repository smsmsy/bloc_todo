// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bloc_todo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  tearDown(() {
    SharedPreferencesAsyncPlatform.instance = null;
  });

  testWidgets('Theme toggles via ThemeBloc', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    SharedPreferences.setMockInitialValues({});
    final prefs = SharedPreferencesAsync();
    await tester.pumpWidget(
      MyApp(
        prefs: prefs,
        initialThemeMode: ThemeMode.light,
      ),
    );
    await tester.pump();

    expect(find.text('TODO アプリ'), findsOneWidget);
    var materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.light);

    // Toggle theme.
    await tester.tap(find.byIcon(Icons.brightness_6));
    await tester.pumpAndSettle();

    materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.dark);
  });
}
