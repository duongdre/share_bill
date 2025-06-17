import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/models/data_models/person.dart';
import 'package:share_bill/utilities/utils/avatar_person.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  group('AvatarPerson Widget Tests', () {
    late Person testPerson;
    late Person testPersonWithAvatar;
    late Person testPersonWithoutAvatar;

    setUp(() {
      testPerson = Person(
        uid: 'test-person-001',
        name: 'John Doe',
        describe: 'Test person',
        avtUrl: 'https://example.com/avatar.jpg',
        groups: {},
      );

      testPersonWithAvatar = Person(
        uid: 'test-person-002',
        name: 'Jane Doe',
        avtUrl: 'https://example.com/jane-avatar.jpg',
        groups: {},
      );

      testPersonWithoutAvatar = Person(
        uid: 'test-person-003',
        name: 'No Avatar Person',
        avtUrl: '',
        groups: {},
      );
    });

    Widget createTestWidget({
      Person? person,
      double size = 50.0,
      bool isEditable = false,
    }) {
      return ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: AvatarPerson(
              person: person,
              size: size,
              isEditable: isEditable,
            ),
          ),
        ),
      );
    }

    testWidgets('should display placeholder when person is null', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(person: null));

      // Should find a CircleAvatar (placeholder)
      expect(find.byType(CircleAvatar), findsOneWidget);

      // Should find person icon
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should display placeholder when person has no avatar', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(person: testPersonWithoutAvatar));

      // Should find a CircleAvatar (placeholder)
      expect(find.byType(CircleAvatar), findsOneWidget);

      // Should find person icon
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should display CachedNetworkImage when person has avatar', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(person: testPersonWithAvatar));

      // Should find CachedNetworkImage
      expect(find.byType(CachedNetworkImage), findsOneWidget);

      // Should find ClipRRect for rounded image
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('should respect size parameter', (WidgetTester tester) async {
      const double testSize = 100.0;
      await tester.pumpWidget(createTestWidget(
        person: testPersonWithoutAvatar,
        size: testSize,
      ));

      final circleAvatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(circleAvatar.radius, equals(testSize / 2));
    });

    testWidgets('should display edit button when isEditable is true', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        person: testPersonWithoutAvatar,
        isEditable: true,
      ));

      // Should find Stack widget (for layering edit button)
      expect(find.byType(Stack), findsOneWidget);

      // Should find edit icon
      expect(find.byIcon(Icons.edit), findsOneWidget);

      // Should find GestureDetector for edit functionality
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('should not display edit button when isEditable is false', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        person: testPersonWithoutAvatar,
        isEditable: false,
      ));

      // Should not find edit icon
      expect(find.byIcon(Icons.edit), findsNothing);

      // Should not find GestureDetector for edit functionality
      expect(find.byType(GestureDetector), findsNothing);
    });

    testWidgets('should handle tap on edit button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        person: testPersonWithAvatar,
        isEditable: true,
      ));

      // Find and tap the edit button
      final editButton = find.byType(GestureDetector);
      expect(editButton, findsOneWidget);

      await tester.tap(editButton);
      await tester.pump();

      // The tap should not cause any errors
      // Note: In a real test, you might want to verify that the image picker is called
      // but that would require mocking the image picker functionality
    });

    testWidgets('should display correct icon size in placeholder', (WidgetTester tester) async {
      const double testSize = 60.0;
      await tester.pumpWidget(createTestWidget(
        person: testPersonWithoutAvatar,
        size: testSize,
      ));

      final icon = tester.widget<Icon>(find.byIcon(Icons.person));
      expect(icon.size, equals(testSize / 1.5)); // As per the code logic
    });

    testWidgets('should have proper container structure with avatar image', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(person: testPersonWithAvatar));

      // Should find Stack for proper layering
      expect(find.byType(Stack), findsOneWidget);

      // Should find Container widgets for styling
      expect(find.byType(Container), findsAtLeastNWidgets(1));

      // Should find SizedBox for proper sizing
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('should display correct edit button size based on avatar size', (WidgetTester tester) async {
      const double testSize = 80.0;
      await tester.pumpWidget(createTestWidget(
        person: testPersonWithAvatar,
        size: testSize,
        isEditable: true,
      ));

      final editIcon = tester.widget<Icon>(find.byIcon(Icons.edit));
      expect(editIcon.size, equals(testSize / 4)); // As per the code logic
    });

    testWidgets('should handle different avatar URL formats', (WidgetTester tester) async {
      final personWithSpecialUrl = Person(
        uid: 'test-person-special',
        name: 'Special URL Person',
        avtUrl: 'https://example.com/avatar with spaces.jpg',
        groups: {},
      );

      await tester.pumpWidget(createTestWidget(person: personWithSpecialUrl));

      // Should still display CachedNetworkImage
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('should handle edge case with very small size', (WidgetTester tester) async {
      const double verySmallSize = 10.0;
      await tester.pumpWidget(createTestWidget(
        person: testPersonWithoutAvatar,
        size: verySmallSize,
      ));

      final circleAvatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(circleAvatar.radius, equals(verySmallSize / 2));

      final icon = tester.widget<Icon>(find.byIcon(Icons.person));
      expect(icon.size, equals(verySmallSize / 1.5));
    });

    testWidgets('should handle edge case with very large size', (WidgetTester tester) async {
      const double veryLargeSize = 200.0;
      await tester.pumpWidget(createTestWidget(
        person: testPersonWithoutAvatar,
        size: veryLargeSize,
      ));

      final circleAvatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(circleAvatar.radius, equals(veryLargeSize / 2));

      final icon = tester.widget<Icon>(find.byIcon(Icons.person));
      expect(icon.size, equals(veryLargeSize / 1.5));
    });

    testWidgets('should maintain aspect ratio with different sizes', (WidgetTester tester) async {
      const List<double> testSizes = [20.0, 50.0, 100.0, 150.0];

      for (final size in testSizes) {
        await tester.pumpWidget(createTestWidget(
          person: testPersonWithoutAvatar,
          size: size,
        ));

        final circleAvatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
        expect(circleAvatar.radius, equals(size / 2));

        final icon = tester.widget<Icon>(find.byIcon(Icons.person));
        expect(icon.size, equals(size / 1.5));
      }
    });

    testWidgets('should have correct styling for edit button container', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        person: testPersonWithAvatar,
        isEditable: true,
      ));

      // Find the container that wraps the edit icon
      final containers = find.byType(Container);
      expect(containers, findsAtLeastNWidgets(1));

      // The edit button should be positioned at bottom right
      final positioned = find.byType(Positioned);
      expect(positioned, findsOneWidget);
    });
  });
}