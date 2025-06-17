import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/screens/home/UI/home_screen.dart';
import 'package:share_bill/gen/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:share_bill/models/data_models/person.dart';
import 'package:share_bill/models/data_models/group.dart';
import 'package:share_bill/models/data_models/bill.dart';
import 'package:share_bill/screens/person/controller/person_provider.dart';
import 'package:share_bill/screens/group/controller/group_provider.dart';
import 'package:share_bill/screens/bill/controller/bill_provider.dart';

// Mock providers for testing
class MockPersonNotifier extends PersonNotifier {
  @override
  List<Person> get allPerson => [
    Person(
      uid: 'person-001',
      name: 'Alice',
      avtUrl: '',
      groups: {'group-001': true},
    ),
    Person(
      uid: 'person-002',
      name: 'Bob',
      avtUrl: 'https://example.com/bob.jpg',
      groups: {'group-001': true},
    ),
  ];
}

class MockGroupNotifier extends GroupNotifier {
  @override
  List<Group> get allGroup => [
    Group(
      uid: 'group-001',
      name: 'Weekend Trip',
      members: {'person-001': true, 'person-002': true},
    ),
    Group(
      uid: 'group-002',
      name: 'Office Lunch',
      members: {'person-001': true},
    ),
  ];
}

class MockBillNotifier extends BillNotifier {
  @override
  List<Bill> get allBill => [
    Bill(
      uid: 'bill-001',
      groupId: 'group-001',
      personId: 'person-001',
      amount: 150000,
      description: 'Lunch',
      createdAt: DateTime.now().millisecondsSinceEpoch,
    ),
    Bill(
      uid: 'bill-002',
      groupId: 'group-001',
      personId: 'person-002',
      amount: 200000,
      description: 'Dinner',
      createdAt: DateTime.now().millisecondsSinceEpoch,
    ),
  ];

  @override
  List<Bill> getFirst5Bills() => allBill.take(5).toList();
}

void main() {
  group('HomeScreen Widget Tests', () {
    Widget createTestWidget({
      ProviderContainer? container,
    }) {
      return ProviderScope(
        parent: container,
        overrides: [
          personNotifierProvider.overrideWith(() => MockPersonNotifier()),
          groupNotifierProvider.overrideWith(() => MockGroupNotifier()),
          billNotifierProvider.overrideWith(() => MockBillNotifier()),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomeScreen(),
        ),
      );
    }

    testWidgets('should display loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Should show loading indicator initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display main UI elements after loading', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should find the main sections
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Add Person'), findsOneWidget);
      expect(find.text('Add Group'), findsOneWidget);
      expect(find.text('Add Expense'), findsOneWidget);
    });

    testWidgets('should display home add section with three buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for add person button
      expect(find.text('Add Person'), findsOneWidget);
      expect(find.byIcon(Icons.person_add), findsOneWidget);

      // Check for add group button
      expect(find.text('Add Group'), findsOneWidget);
      expect(find.byIcon(Icons.group_add), findsOneWidget);

      // Check for add expense button
      expect(find.text('Add Expense'), findsOneWidget);
      expect(find.byIcon(Icons.payment), findsOneWidget);
    });

    testWidgets('should display favorite persons section', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should find favorite persons section
      expect(find.text('Favorite Persons'), findsOneWidget);

      // Should display horizontal list of persons
      expect(find.byType(ListView), findsAtLeastNWidgets(1));
    });

    testWidgets('should display recent groups section', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should find recent groups section
      expect(find.text('Recent Groups'), findsOneWidget);

      // Should find group names from mock data
      expect(find.text('Weekend Trip'), findsOneWidget);
      expect(find.text('Office Lunch'), findsOneWidget);
    });

    testWidgets('should display expenses section', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should find expenses section
      expect(find.text('Expenses'), findsOneWidget);
    });

    testWidgets('should handle tap on add person button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap add person button
      final addPersonButton = find.ancestor(
        of: find.text('Add Person'),
        matching: find.byType(InkWell),
      );

      expect(addPersonButton, findsOneWidget);
      await tester.tap(addPersonButton);
      await tester.pumpAndSettle();

      // Should open add person dialog
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should handle tap on add group button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap add group button
      final addGroupButton = find.ancestor(
        of: find.text('Add Group'),
        matching: find.byType(InkWell),
      );

      expect(addGroupButton, findsOneWidget);
      await tester.tap(addGroupButton);
      await tester.pumpAndSettle();

      // Should open add group dialog
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should handle tap on add expense button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap add expense button
      final addExpenseButton = find.ancestor(
        of: find.text('Add Expense'),
        matching: find.byType(InkWell),
      );

      expect(addExpenseButton, findsOneWidget);
      await tester.tap(addExpenseButton);
      await tester.pump();

      // Should navigate to spent screen (in real app)
      // Here we just verify the tap doesn't cause errors
    });

    testWidgets('should display pull to refresh functionality', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find RefreshIndicator
      expect(find.byType(RefreshIndicator), findsOneWidget);

      // Perform pull to refresh gesture
      await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));
      await tester.pump();

      // Should show refresh indicator
      expect(find.byType(RefreshProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('should display header with user info', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should find management header
      expect(find.text('Home'), findsOneWidget);

      // Should find notification and user avatar icons
      expect(find.byIcon(Icons.notifications_none_sharp), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should handle favorite person tap', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find person in the favorite persons list
      final personTile = find.text('Alice');
      expect(personTile, findsOneWidget);

      await tester.tap(personTile);
      await tester.pump();

      // Should handle navigation (in real app would navigate to person detail)
    });

    testWidgets('should display correct home add section styling', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find containers with different background colors
      final containers = find.byType(Container);
      expect(containers, findsAtLeastNWidgets(3));

      // Verify that buttons have proper padding and margins
      final padding = find.byType(Padding);
      expect(padding, findsAtLeastNWidgets(1));
    });

    testWidgets('should handle empty data states gracefully', (WidgetTester tester) async {
      // Override with empty data
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            personNotifierProvider.overrideWith(() => PersonNotifier()),
            groupNotifierProvider.overrideWith(() => GroupNotifier()),
            billNotifierProvider.overrideWith(() => BillNotifier()),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should still display section headers
      expect(find.text('Favorite Persons'), findsOneWidget);
      expect(find.text('Recent Groups'), findsOneWidget);
      expect(find.text('Expenses'), findsOneWidget);

      // Should handle empty lists gracefully
      expect(find.byType(ListView), findsAtLeastNWidgets(1));
    });

    testWidgets('should display scrollable content', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find scrollable widget
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Perform scroll gesture
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -200));
      await tester.pump();

      // Should not cause errors
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should maintain proper widget hierarchy', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify scaffold structure
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(Column), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle horizontal scrolling in favorite persons', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find horizontal ListView in favorite persons section
      final horizontalList = find.byWidgetPredicate(
            (widget) => widget is ListView &&
            widget.scrollDirection == Axis.horizontal,
      );

      expect(horizontalList, findsOneWidget);

      // Perform horizontal scroll
      await tester.drag(horizontalList, const Offset(-100, 0));
      await tester.pump();

      // Should not cause errors
      expect(horizontalList, findsOneWidget);
    });

    testWidgets('should display proper spacing between sections', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find SizedBox widgets used for spacing
      final sizedBoxes = find.byType(SizedBox);
      expect(sizedBoxes, findsAtLeastNWidgets(1));
    });
  });
}