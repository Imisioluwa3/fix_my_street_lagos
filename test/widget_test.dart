import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fix_my_street_lagos/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  setUpAll(() async {
    // Load a dummy .env file for tests
    dotenv.testLoad(fileInput: '''
      SUPABASE_URL=https://example.supabase.co
      SUPABASE_ANON_KEY=your-anon-key
    ''');
  });

  testWidgets('App shows AuthPage when not logged in', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(FixMyStreetApp());

    // Wait for the splash screen to finish
    // The splash screen waits for 3 seconds before navigating.
    await tester.pump(const Duration(seconds: 3));

    // After the delay, another frame is needed to process the navigation.
    await tester.pumpAndSettle();

    // Verify that AuthPage is now visible.
    expect(find.byType(AuthPage), findsOneWidget);

    // Verify that the Email and Phone tabs are present.
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Phone'), findsOneWidget);

    // Verify that the "Sign In" button is present in the Email tab.
    expect(find.text('Sign In'), findsOneWidget);
  });
}
