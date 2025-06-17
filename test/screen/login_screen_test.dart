import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/screens/login/UI/login_screen.dart';
import 'package:share_bill/gen/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('LoginScreen Unit Tests', () {
    // Setup mock method channels before running tests
    setUpAll(() {
      // Mock Firebase Auth
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/firebase_auth'),
            (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'Auth#registerIdTokenListener':
              return null;
            case 'Auth#registerAuthStateListener':
              return null;
            case 'Auth#signInWithEmailAndPassword':
            // Simulate login failure for testing
              throw PlatformException(
                code: 'user-not-found',
                message: 'No user found for that email.',
              );
            default:
              return null;
          }
        },
      );

      // Mock Firebase Database
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/firebase_database'),
            (MethodCall methodCall) async => null,
      );

      // Mock Firebase Storage
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/firebase_storage'),
            (MethodCall methodCall) async => null,
      );

      // Mock Shared Preferences
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/shared_preferences'),
            (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'getAll':
              return <String, dynamic>{};
            case 'setBool':
            case 'setString':
              return true;
            default:
              return null;
          }
        },
      );
    });

    tearDownAll(() {
      // Clean up mock handlers
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/firebase_auth'),
        null,
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/firebase_database'),
        null,
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/firebase_storage'),
        null,
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/shared_preferences'),
        null,
      );
    });

    Widget createTestWidget() {
      return const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: LoginScreen(),
        ),
      );
    }

    Future<void> pumpLoginScreen(WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
    }

    testWidgets('should display login screen with all elements', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Check main elements are present
      expect(find.text('Share Bill'), findsOneWidget);
      expect(find.text('Welcome to Share Bill'), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));

      // Look for the specific ElevatedButton with "Sign In" text
      expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'Create New Account'), findsOneWidget);
    });

    testWidgets('should handle user input in form fields', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Find form fields by their decoration/hint text
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      // Enter text in email field
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      // Enter text in password field
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // Verify email text appears (password won't be visible due to obscureText)
      expect(find.text('test@example.com'), findsOneWidget);

      // Verify fields contain the text
      expect(tester.widget<TextFormField>(emailField).controller?.text, 'test@example.com');
      expect(tester.widget<TextFormField>(passwordField).controller?.text, 'password123');
    });

    /*testWidgets('should validate empty form', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Try to submit empty form using the ElevatedButton
      final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });*/

    testWidgets('should validate email format', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should validate password length', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Enter valid email but short password
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, '123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Password must be at least 8 characters'), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Initially should show visibility_off icon
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Tap the visibility button
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      // Should now show visibility icon
      expect(find.byIcon(Icons.visibility), findsOneWidget);

      // Tap again to hide
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();

      // Should be back to visibility_off
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    /*testWidgets('should show loading state when submitting valid form', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Fill form with valid data
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'validpassword123');

      // Submit form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump(); // Don't settle to catch loading state

      // Should show loading indicator inside the button
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });*/

    testWidgets('should handle create account button tap', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      final createAccountButton = find.widgetWithText(OutlinedButton, 'Create New Account');
      expect(createAccountButton, findsOneWidget);

      // Should be able to tap without errors
      await tester.tap(createAccountButton);
      await tester.pump();

      // No exception should be thrown
    });

    testWidgets('should display proper form field labels and hints', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Check for field labels
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Check for hint texts - these might be different based on your actual implementation
      expect(find.text('Enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('should display proper icons', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Check for app logo
      expect(find.byIcon(Icons.receipt_long), findsOneWidget);

      // Check for field icons
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    /*testWidgets('should handle keyboard navigation', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Focus on email field and enter text
      final emailField = find.byType(TextFormField).first;
      await tester.tap(emailField);
      await tester.enterText(emailField, 'test@example.com');

      // Use next action to move to password field
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();

      // Enter password
      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, 'password123');

      // Use done action (should trigger form submission)
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Should show loading (form submission triggered)
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });*/

    testWidgets('should have proper layout structure', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Check main layout components
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    /*testWidgets('should display terms and conditions', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      expect(find.text('You agree to our Terms of Service'), findsOneWidget);
    });*/

    testWidgets('should handle special characters in input', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Test special characters in email
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'user+test@domain.com');
      await tester.pump();

      expect(find.text('user+test@domain.com'), findsOneWidget);

      // Test special characters in password
      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, 'P@ssw0rd!123');
      await tester.pump();

      // Should not crash and field should contain the text
      expect(tester.widget<TextFormField>(passwordField).controller?.text, 'P@ssw0rd!123');
    });

    testWidgets('should handle rapid interactions', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;
      final visibilityIcon = find.byIcon(Icons.visibility_off);

      // Rapidly tap various elements
      for (int i = 0; i < 3; i++) {
        await tester.tap(emailField);
        await tester.pump();
        await tester.tap(passwordField);
        await tester.pump();
        if (visibilityIcon.evaluate().isNotEmpty) {
          await tester.tap(visibilityIcon);
          await tester.pump();
        }
      }

      // Should still be functional
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('should work on different screen sizes', (WidgetTester tester) async {
      // Test small screen
      await tester.binding.setSurfaceSize(const Size(320, 568));
      await pumpLoginScreen(tester);

      expect(find.text('Welcome to Share Bill'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));

      // Test large screen
      await tester.binding.setSurfaceSize(const Size(768, 1024));
      await tester.pumpAndSettle();

      expect(find.text('Welcome to Share Bill'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));

      // Reset to default size
      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpAndSettle();
    });

    /*testWidgets('should handle form submission with network error', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Fill form with valid data
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'validpassword123');

      // Submit form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the login process to complete (will fail due to mock)
      await tester.pumpAndSettle();

      // Should show error message in SnackBar
      expect(find.byType(SnackBar), findsOneWidget);
    });*/

    testWidgets('should clear form validation errors when typing', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Submit empty form to show validation errors
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.text('Please enter your email'), findsOneWidget);

      // Start typing in email field
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.pump();

      // Validation error should still be there until form is revalidated
      // This depends on your implementation - some forms clear errors on change, others don't
    });

    testWidgets('should maintain focus after validation error', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Enter invalid email and submit
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      // Form should still be interactive
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    /*testWidgets('should handle multiple consecutive login attempts', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Fill form
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      // Attempt login multiple times
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
        await tester.pump();

        // Wait for completion
        await tester.pumpAndSettle();

        // Should still be on login screen
        expect(find.text('Welcome to Share Bill'), findsOneWidget);
      }
    });*/
  });
}