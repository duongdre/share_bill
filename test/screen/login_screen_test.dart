import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/screens/login/UI/login_screen.dart';
import 'package:share_bill/gen/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('LoginScreen Simple Behavior Tests', () {

    Widget createTestWidget() {
      return ProviderScope(
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const LoginScreen(),
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
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Create New Account'), findsOneWidget);
    });

    testWidgets('should handle user input in form fields', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Enter text in email field
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      // Enter text in password field
      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // Verify text appears
      expect(find.text('test@example.com'), findsOneWidget);
      // Note: Password text won't be visible due to obscureText
    });

    testWidgets('should validate empty form', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Try to submit empty form
      final signInButton = find.text('Sign In');
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('should validate email format', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should validate password length', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Enter valid email but short password
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, '123');
      await tester.tap(find.text('Sign In'));
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
      expect(find.byIcon(Icons.visibility_off), findsNothing);

      // Tap again to hide
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();

      // Should be back to visibility_off
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('should show loading state when submitting valid form', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Fill form with valid data
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'validpassword123');

      // Submit form
      await tester.tap(find.text('Sign In'));
      await tester.pump(); // Don't settle to catch loading state

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should handle create account button tap', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      final createAccountButton = find.text('Create New Account');
      expect(createAccountButton, findsOneWidget);

      // Should be able to tap without errors
      await tester.tap(createAccountButton);
      await tester.pump();
    });

    testWidgets('should display proper form field labels and hints', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Check for field labels
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Check for hint texts
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

    testWidgets('should handle keyboard navigation', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Focus on email field and enter text
      await tester.tap(find.byType(TextFormField).first);
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');

      // Use next action to move to password field
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();

      // Enter password
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      // Use done action (should trigger form submission)
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Should show loading (form submission triggered)
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should have proper layout structure', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Check main layout components
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should display terms and conditions', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      expect(find.text('You agree to our Terms of Service'), findsOneWidget);
    });

    testWidgets('should handle special characters in input', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Test special characters in email
      await tester.enterText(find.byType(TextFormField).first, 'user+test@domain.com');
      await tester.pump();

      expect(find.text('user+test@domain.com'), findsOneWidget);

      // Test special characters in password
      await tester.enterText(find.byType(TextFormField).last, 'P@ssw0rd!123');
      await tester.pump();

      // Should not crash
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('should handle rapid interactions', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      // Rapidly tap various elements
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byType(TextFormField).first);
        await tester.pump();
        await tester.tap(find.byType(TextFormField).last);
        await tester.pump();
        await tester.tap(find.byIcon(Icons.visibility_off));
        await tester.pump();
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

      // Reset
      await tester.binding.setSurfaceSize(const Size(800, 600));
    });
  });
}