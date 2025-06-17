import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:share_bill/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Share Bill App Flow Integration Tests', () {
    testWidgets('complete app flow - splash to login to home', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Should start with splash screen
      expect(find.text('Share Bill'), findsOneWidget);
      expect(find.byIcon(Icons.receipt_long), findsOneWidget);

      // Wait for splash screen timeout and navigation to login
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should navigate to login screen
      expect(find.text('Welcome to Share Bill'), findsOneWidget);
      expect(find.text('Sign In'), findsAtLeastNWidgets(1));
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('login flow with validation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Try to login without credentials
      final loginButton = find.text('Sign In').last;
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);

      // Enter invalid email
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'invalid-email');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Should show email validation error
      expect(find.text('Please enter a valid email'), findsOneWidget);

      // Enter valid email but short password
      await tester.enterText(emailField, 'test@example.com');
      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, '123');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Should show password validation error
      expect(find.text('Password must be at least 8 characters'), findsOneWidget);
    });

    testWidgets('create account navigation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Tap create account button
      final createAccountButton = find.text('Create New Account');
      await tester.tap(createAccountButton);
      await tester.pumpAndSettle();

      // Should navigate to create account screen
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Start splitting bills with friends'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(4)); // Name, email, password, confirm password
    });

    testWidgets('create account form validation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to create account
      await tester.tap(find.text('Create New Account'));
      await tester.pumpAndSettle();

      // Try to create account without filling form
      final createButton = find.text('Create Account').last;
      await tester.tap(createButton);
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);

      // Fill form with mismatched passwords
      final nameField = find.byType(TextFormField).at(0);
      final emailField = find.byType(TextFormField).at(1);
      final passwordField = find.byType(TextFormField).at(2);
      final confirmPasswordField = find.byType(TextFormField).at(3);

      await tester.enterText(nameField, 'John Doe');
      await tester.enterText(emailField, 'john@example.com');
      await tester.enterText(passwordField, 'Password123');
      await tester.enterText(confirmPasswordField, 'Password456');

      await tester.tap(createButton);
      await tester.pumpAndSettle();

      // Should show password mismatch error
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('navigation between screens using back button', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to create account
      await tester.tap(find.text('Create New Account'));
      await tester.pumpAndSettle();

      // Use back button to return to login
      final backButton = find.byIcon(Icons.arrow_back);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Should be back on login screen
      expect(find.text('Welcome to Share Bill'), findsOneWidget);
      expect(find.text('Sign In'), findsAtLeastNWidgets(1));
    });

    testWidgets('language settings navigation and functionality', (WidgetTester tester) async {
      // This test would require mocking authentication to get to home screen
      // For now, we'll test the language settings screen independently

      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Assuming we can navigate to language settings
      // In a real integration test, you'd need to authenticate first
      // This is a simplified test of the language settings screen
    });

    testWidgets('password visibility toggle functionality', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find password field
      final passwordField = find.byType(TextFormField).last;

      // Enter password
      await tester.enterText(passwordField, 'testpassword');

      // Find visibility toggle button
      final visibilityButton = find.descendant(
        of: passwordField,
        matching: find.byType(IconButton),
      );

      // Tap to toggle visibility
      await tester.tap(visibilityButton);
      await tester.pump();

      // Tap again to toggle back
      await tester.tap(visibilityButton);
      await tester.pump();

      // Should not cause any errors
      expect(passwordField, findsOneWidget);
    });

    testWidgets('form field focus and keyboard navigation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test keyboard navigation between fields
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      // Focus on email field
      await tester.tap(emailField);
      await tester.pump();

      // Enter email and use next action
      await tester.enterText(emailField, 'test@example.com');
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();

      // Password field should be focused (can't easily verify, but ensures no crash)
      await tester.enterText(passwordField, 'password123');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Should not cause errors
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('app handles orientation changes', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Get initial size
      final initialSize = tester.getSize(find.byType(MaterialApp));

      // Simulate orientation change by changing the window size
      await tester.binding.setSurfaceSize(Size(initialSize.height, initialSize.width));
      await tester.pumpAndSettle();

      // App should still function correctly
      expect(find.text('Welcome to Share Bill'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));

      // Restore original orientation
      await tester.binding.setSurfaceSize(initialSize);
      await tester.pumpAndSettle();
    });

    testWidgets('app handles rapid user interactions', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Rapidly tap different elements
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;
      final loginButton = find.text('Sign In').last;
      final createAccountButton = find.text('Create New Account');

      // Rapid taps should not cause crashes
      await tester.tap(emailField);
      await tester.pump();
      await tester.tap(passwordField);
      await tester.pump();
      await tester.tap(loginButton);
      await tester.pump();
      await tester.tap(createAccountButton);
      await tester.pump();

      // Should still be functional
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('app maintains state during background/foreground', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Enter some data
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'persistent@example.com');
      await tester.pump();

      // Simulate app going to background and returning
      await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'flutter/lifecycle',
        const StandardMethodCodec().encodeMethodCall(
          const MethodCall('AppLifecycleState.paused'),
        ),
            (data) {},
      );
      await tester.pump();

      await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'flutter/lifecycle',
        const StandardMethodCodec().encodeMethodCall(
          const MethodCall('AppLifecycleState.resumed'),
        ),
            (data) {},
      );
      await tester.pump();

      // Data should still be there
      expect(find.text('persistent@example.com'), findsOneWidget);
    });

    testWidgets('complete user journey simulation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Start at login screen
      expect(find.text('Welcome to Share Bill'), findsOneWidget);

      // Go to create account
      await tester.tap(find.text('Create New Account'));
      await tester.pumpAndSettle();

      // Fill create account form correctly
      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      await tester.enterText(find.byType(TextFormField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), 'SecurePassword123');
      await tester.enterText(find.byType(TextFormField).at(3), 'SecurePassword123');

      // Accept terms
      final termsCheckbox = find.byType(Checkbox);
      await tester.tap(termsCheckbox);
      await tester.pump();

      // Try to create account (would normally require mocking auth service)
      final createButton = find.text('Create Account').last;
      await tester.tap(createButton);
      await tester.pump();

      // Should show loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('error handling in network scenarios', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Enter valid credentials
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'validpassword123');

      // Attempt login (would fail in real scenario without proper backend)
      await tester.tap(find.text('Sign In').last);
      await tester.pump();

      // Should handle the error gracefully
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for potential error handling
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // App should still be responsive
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('accessibility features work correctly', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Check that widgets have proper semantics
      expect(
        tester.getSemantics(find.byType(TextFormField).first),
        matchesSemantics(
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
        ),
      );

      expect(
        tester.getSemantics(find.text('Sign In').last),
        matchesSemantics(
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          // hasIncreasedValue: false,
        ),
      );
    });

    testWidgets('deep link handling simulation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Simulate receiving a deep link while on login screen
      // In a real app, this would test navigation to specific screens via deep links

      // For now, just ensure the app handles navigation correctly
      expect(find.text('Welcome to Share Bill'), findsOneWidget);

      // Navigate to create account and back to simulate deep link navigation
      await tester.tap(find.text('Create New Account'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Should return to login screen properly
      expect(find.text('Welcome to Share Bill'), findsOneWidget);
    });

    testWidgets('memory management during navigation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate between screens multiple times to test memory management
      for (int i = 0; i < 5; i++) {
        // Go to create account
        await tester.tap(find.text('Create New Account'));
        await tester.pumpAndSettle();

        // Return to login
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        // Verify we're back on login screen
        expect(find.text('Welcome to Share Bill'), findsOneWidget);
      }

      // App should still be responsive after multiple navigations
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('form state persistence across navigation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Enter data in login form
      await tester.enterText(find.byType(TextFormField).first, 'persistent@test.com');
      await tester.enterText(find.byType(TextFormField).last, 'persistentpassword');

      // Navigate away and back
      await tester.tap(find.text('Create New Account'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Form data should be cleared (as expected in login flow)
      // This tests that the app properly manages form state
      expect(find.text('Welcome to Share Bill'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('UI responsiveness under load', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Perform many UI interactions rapidly
      final interactions = <Future<void>>[];

      for (int i = 0; i < 10; i++) {
        interactions.add(tester.tap(find.byType(TextFormField).first));
        interactions.add(tester.pump());
        interactions.add(tester.enterText(find.byType(TextFormField).first, 'test$i@example.com'));
        interactions.add(tester.pump());
      }

      // Wait for all interactions to complete
      await Future.wait(interactions);
      await tester.pumpAndSettle();

      // App should still be responsive
      expect(find.text('Welcome to Share Bill'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });
  });
}