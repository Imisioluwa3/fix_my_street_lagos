import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fix_my_street_lagos/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  setUpAll(() async {
    // Ensure Flutter binding is initialized
    TestWidgetsFlutterBinding.ensureInitialized();
    
    // Load a dummy .env file for tests
    dotenv.testLoad(fileInput: '''
      SUPABASE_URL=https://example.supabase.co
      SUPABASE_ANON_KEY=your-anon-key
    ''');
    
    // Initialize Supabase for testing
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    );
  });

  testWidgets('App shows AuthPage when not logged in', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(FixMyStreetApp());

    // Wait for the splash screen to finish
    await tester.pump(const Duration(seconds: 3));

    // Give more time for the StreamBuilder in AuthWrapper to process
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Debug: Print what widgets are actually present
    print('Looking for AuthPage...');
    final finder = find.byType(AuthPage);
    print('Found ${finder.evaluate().length} AuthPage widgets');

    // Verify that AuthPage is now visible.
    expect(find.byType(AuthPage), findsOneWidget);

    // Verify that the Email and Phone tabs are present.
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Phone'), findsOneWidget);

    // Verify that the "Sign In" button is present in the Email tab.
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('App navigation works correctly', (WidgetTester tester) async {
    await tester.pumpWidget(FixMyStreetApp());
    
    // Wait for splash screen
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Verify we're on AuthPage
    expect(find.byType(AuthPage), findsOneWidget);
    
    // Test tab switching
    await tester.tap(find.text('Phone'));
    await tester.pumpAndSettle();
    
    // Should now see phone-related elements
    expect(find.text('Send OTP'), findsOneWidget);
  });
}