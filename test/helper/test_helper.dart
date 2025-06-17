import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/models/data_models/bill.dart';
import 'package:share_bill/models/data_models/group.dart';
import 'package:share_bill/models/data_models/person.dart';
import 'package:share_bill/gen/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Test helper utilities for Share Bill app testing
class TestHelpers {

  /// Creates a test widget wrapped with necessary providers and localizations
  static Widget createTestApp({
    required Widget child,
    List<Override>? overrides,
  }) {
    return ProviderScope(
      overrides: overrides ?? [],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );
  }

  /// Creates a test widget with scaffold
  static Widget createTestWidget({
    required Widget child,
    List<Override>? overrides,
  }) {
    return createTestApp(
      overrides: overrides,
      child: Scaffold(body: child),
    );
  }

  /// Pump widget and wait for all animations and async operations
  static Future<void> pumpAndSettleWidget(
      WidgetTester tester,
      Widget widget, {
        Duration? duration,
      }) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle(duration ?? const Duration(seconds: 1));
  }

  /// Find widget by text with optional ancestor matching
  static Finder findTextWithAncestor(String text, Type ancestorType) {
    return find.descendant(
      of: find.byType(ancestorType),
      matching: find.text(text),
    );
  }

  /// Enter text in a specific TextFormField by index
  static Future<void> enterTextInField(
      WidgetTester tester,
      int fieldIndex,
      String text,
      ) async {
    final field = find.byType(TextFormField).at(fieldIndex);
    await tester.enterText(field, text);
    await tester.pump();
  }

  /// Tap button by text and pump
  static Future<void> tapButtonByText(
      WidgetTester tester,
      String buttonText,
      ) async {
    await tester.tap(find.text(buttonText));
    await tester.pump();
  }

  /// Tap button by type and pump
  static Future<void> tapButtonByType<T>(
      WidgetTester tester,
      ) async {
    await tester.tap(find.byType(T));
    await tester.pump();
  }

  /// Verify that a specific error message is displayed
  static void expectErrorMessage(String message) {
    expect(find.text(message), findsOneWidget);
  }

  /// Verify that loading indicator is displayed
  static void expectLoadingIndicator() {
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  }

  /// Verify that loading indicator is not displayed
  static void expectNoLoadingIndicator() {
    expect(find.byType(CircularProgressIndicator), findsNothing);
  }

  /// Verify navigation occurred by checking for specific screen content
  static void expectScreenNavigation(String screenTitle) {
    expect(find.text(screenTitle), findsOneWidget);
  }

  /// Wait for a specific duration and pump
  static Future<void> waitAndPump(
      WidgetTester tester, {
        Duration duration = const Duration(milliseconds: 100),
      }) async {
    await Future.delayed(duration);
    await tester.pump();
  }

  /// Scroll widget by offset
  static Future<void> scrollWidget(
      WidgetTester tester,
      Finder finder,
      Offset offset,
      ) async {
    await tester.drag(finder, offset);
    await tester.pump();
  }

  /// Verify that a specific number of widgets of a type exist
  static void expectWidgetCount<T>(int count) {
    expect(find.byType(T), findsNWidgets(count));
  }

  /// Verify that at least a specific number of widgets exist
  static void expectAtLeastWidgets<T>(int count) {
    expect(find.byType(T), findsAtLeastNWidgets(count));
  }

  /// Perform form validation by submitting empty form
  static Future<void> triggerFormValidation(
      WidgetTester tester,
      String submitButtonText,
      ) async {
    await tapButtonByText(tester, submitButtonText);
    await tester.pumpAndSettle();
  }

  /// Fill login form with test credentials
  static Future<void> fillLoginForm(
      WidgetTester tester, {
        String email = 'test@example.com',
        String password = 'testpassword123',
      }) async {
    await enterTextInField(tester, 0, email);
    await enterTextInField(tester, 1, password);
  }

  /// Fill create account form with test data
  static Future<void> fillCreateAccountForm(
      WidgetTester tester, {
        String name = 'Test User',
        String email = 'test@example.com',
        String password = 'testpassword123',
        String confirmPassword = 'testpassword123',
      }) async {
    await enterTextInField(tester, 0, name);
    await enterTextInField(tester, 1, email);
    await enterTextInField(tester, 2, password);
    await enterTextInField(tester, 3, confirmPassword);
  }

  /// Simulate network delay
  static Future<void> simulateNetworkDelay({
    Duration delay = const Duration(seconds: 2),
  }) async {
    await Future.delayed(delay);
  }

  /// Create mock providers container
  static ProviderContainer createMockContainer({
    List<Override>? overrides,
  }) {
    return ProviderContainer(overrides: overrides ?? []);
  }

  /// Dispose provider container safely
  static void disposeMockContainer(ProviderContainer container) {
    container.dispose();
  }
}

/// Mock data factory for testing
class MockDataFactory {

  /// Create mock person
  static Person createMockPerson({
    String uid = 'test-person-001',
    String name = 'John Doe',
    String? describe = 'Test person',
    String avtUrl = '',
    Map<String, bool>? groups,
  }) {
    return Person(
      uid: uid,
      name: name,
      describe: describe,
      avtUrl: avtUrl,
      groups: groups ?? {'group-001': true},
    );
  }

  /// Create mock group
  static Group createMockGroup({
    String uid = 'test-group-001',
    String name = 'Test Group',
    num? createdAt,
    Map<String, bool>? members,
  }) {
    return Group(
      uid: uid,
      name: name,
      createdAt: createdAt ?? DateTime.now().millisecondsSinceEpoch,
      members: members ?? {'person-001': true, 'person-002': true},
    );
  }

  /// Create mock bill
  static Bill createMockBill({
    String uid = 'test-bill-001',
    String groupId = 'test-group-001',
    String personId = 'test-person-001',
    int amount = 100000,
    String? description = 'Test expense',
    int? createdAt,
  }) {
    return Bill(
      uid: uid,
      groupId: groupId,
      personId: personId,
      amount: amount,
      description: description,
      createdAt: createdAt ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Create list of mock persons
  static List<Person> createMockPersons(int count) {
    return List.generate(count, (index) => createMockPerson(
      uid: 'person-${index.toString().padLeft(3, '0')}',
      name: 'Person $index',
      describe: 'Test person $index',
    ));
  }

  /// Create list of mock groups
  static List<Group> createMockGroups(int count) {
    return List.generate(count, (index) => createMockGroup(
      uid: 'group-${index.toString().padLeft(3, '0')}',
      name: 'Group $index',
    ));
  }

  /// Create list of mock bills
  static List<Bill> createMockBills(int count) {
    return List.generate(count, (index) => createMockBill(
      uid: 'bill-${index.toString().padLeft(3, '0')}',
      amount: (index + 1) * 50000,
      description: 'Expense $index',
    ));
  }

  /// Create complex mock data scenario
  static Map<String, dynamic> createComplexMockScenario() {
    final persons = createMockPersons(5);
    final groups = createMockGroups(3);
    final bills = createMockBills(10);

    // Set up relationships
    for (int i = 0; i < groups.length; i++) {
      final group = groups[i];
      // Assign persons to groups
      for (int j = 0; j < persons.length; j++) {
        if (j % (i + 1) == 0) {
          group.members[persons[j].uid] = true;
          persons[j].groups[group.uid] = true;
        }
      }
    }

    // Assign bills to groups and persons
    for (int i = 0; i < bills.length; i++) {
      final bill = bills[i];
      bill.groupId = groups[i % groups.length].uid;
      bill.personId = persons[i % persons.length].uid;
    }

    return {
      'persons': persons,
      'groups': groups,
      'bills': bills,
    };
  }
}

/// Custom matchers for testing
class CustomMatchers {

  /// Matcher for checking if a widget has specific text color
  static Matcher hasTextColor(Color color) {
    return _HasTextColor(color);
  }

  /// Matcher for checking if a widget has specific background color
  static Matcher hasBackgroundColor(Color color) {
    return _HasBackgroundColor(color);
  }

  /// Matcher for checking if a widget is enabled
  static Matcher isEnabled() {
    return _IsEnabled();
  }

  /// Matcher for checking if a widget is disabled
  static Matcher isDisabled() {
    return _IsDisabled();
  }
}

class _HasTextColor extends Matcher {
  final Color expectedColor;

  _HasTextColor(this.expectedColor);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is Text) {
      return item.style?.color == expectedColor;
    }
    return false;
  }

  @override
  Description describe(Description description) {
    return description.add('has text color $expectedColor');
  }
}

class _HasBackgroundColor extends Matcher {
  final Color expectedColor;

  _HasBackgroundColor(this.expectedColor);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is Container && item.decoration is BoxDecoration) {
      final decoration = item.decoration as BoxDecoration;
      return decoration.color == expectedColor;
    }
    return false;
  }

  @override
  Description describe(Description description) {
    return description.add('has background color $expectedColor');
  }
}

class _IsEnabled extends Matcher {
  @override
  bool matches(dynamic item, Map matchState) {
    if (item is ElevatedButton) {
      return item.onPressed != null;
    }
    if (item is TextButton) {
      return item.onPressed != null;
    }
    if (item is OutlinedButton) {
      return item.onPressed != null;
    }
    return false;
  }

  @override
  Description describe(Description description) {
    return description.add('is enabled');
  }
}

class _IsDisabled extends Matcher {
  @override
  bool matches(dynamic item, Map matchState) {
    if (item is ElevatedButton) {
      return item.onPressed == null;
    }
    if (item is TextButton) {
      return item.onPressed == null;
    }
    if (item is OutlinedButton) {
      return item.onPressed == null;
    }
    return false;
  }

  @override
  Description describe(Description description) {
    return description.add('is disabled');
  }
}

/// Test configuration constants
class TestConfig {
  static const Duration defaultTimeout = Duration(seconds: 5);
  static const Duration networkTimeout = Duration(seconds: 10);
  static const Duration animationTimeout = Duration(milliseconds: 500);

  static const String testEmail = 'test@example.com';
  static const String testPassword = 'testpassword123';
  static const String testName = 'Test User';

  static const int defaultMockDataCount = 5;
  static const double defaultTestAmount = 100000;
}