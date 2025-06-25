// Updated Group Model Tests
import 'package:flutter_test/flutter_test.dart';
import 'package:share_bill/models/data_models/group.dart';
import 'package:share_bill/models/data_models/person.dart';

void main() {
  group('Fixed Group Model Tests', () {
    late Group testGroup;
    late Map<String, bool> testMembers;

    setUp(() {
      testMembers = {
        'person-001': true,
        'person-002': true,
        'person-003': false,
        'person-004': true,
      };

      testGroup = Group(
        uid: 'test-group-001',
        name: 'Weekend Trip',
        createdAt: 1672531200000,
        members: testMembers,
      );
    });

    test('should create Group with default createdAt when not provided', () {
      final beforeCreate = DateTime.now().millisecondsSinceEpoch;

      final group = Group(
        uid: 'test-group-002',
        name: 'Test Group',
        members: {'person-001': true},
      );

      final afterCreate = DateTime.now().millisecondsSinceEpoch;

      print('🔍 Group createdAt: ${group.createdAt}');

      expect(group.createdAt, isNotNull);
      expect(group.createdAt, greaterThan(0));
      expect(group.createdAt, greaterThanOrEqualTo(beforeCreate));
      expect(group.createdAt, lessThanOrEqualTo(afterCreate));
    });

    test('should use provided createdAt when given', () {
      const specificTime = 1672531200000;

      final group = Group(
        uid: 'test-group-003',
        name: 'Specific Time Group',
        createdAt: specificTime,
        members: {'person-001': true},
      );

      expect(group.createdAt, equals(specificTime));
    });

    test('should handle null createdAt explicitly', () {
      final group = Group(
        uid: 'test-group-004',
        name: 'Null Time Group',
        createdAt: null,
        members: {'person-001': true},
      );

      expect(group.createdAt, isNotNull);
      expect(group.createdAt, greaterThan(0));
    });

    test('copyWith should create new Group with updated fields', () {
      print('🔍 Original group:');
      print('  name: ${testGroup.name}');
      print('  createdAt: ${testGroup.createdAt}');
      print('  members count: ${testGroup.members.length}');

      final updatedMembers = {'person-005': true, 'person-006': true};
      final updatedGroup = testGroup.copyWith(
        name: 'Updated Weekend Trip',
        members: updatedMembers,
      );

      print('🔍 Updated group:');
      print('  name: ${updatedGroup.name}');
      print('  createdAt: ${updatedGroup.createdAt}');
      print('  members count: ${updatedGroup.members.length}');

      // Original group should remain unchanged
      expect(testGroup.name, equals('Weekend Trip'));
      expect(testGroup.members, equals(testMembers));

      // New group should have updated fields
      expect(updatedGroup.uid, equals('test-group-001'));
      expect(updatedGroup.name, equals('Updated Weekend Trip'));
      expect(updatedGroup.createdAt, equals(1672531200000));
      expect(updatedGroup.members, equals(updatedMembers));

      print('✅ Group copyWith test passed!');
    });

    test('copyWith should preserve original values when no updates provided', () {
      final copiedGroup = testGroup.copyWith();

      expect(copiedGroup.uid, equals(testGroup.uid));
      expect(copiedGroup.name, equals(testGroup.name));
      expect(copiedGroup.createdAt, equals(testGroup.createdAt));
      expect(copiedGroup.members, equals(testGroup.members));
    });

    // Test other Group methods
    test('countMember should count only active members', () {
      expect(testGroup.countMember(), equals(3)); // person-001, person-002, person-004
    });

    test('getMember should return correct member count string', () {
      expect(testGroup.getMember(), equals('3 members'));
    });
  });

  group('Fixed Person Model Tests', () {
    late Person testPerson;
    late Map<String, bool> testGroups;

    setUp(() {
      testGroups = {
        'group-001': true,
        'group-002': true,
        'group-003': false,
      };

      testPerson = Person(
        uid: 'test-person-001',
        name: 'John Doe',
        describe: 'A friendly person',
        avtUrl: 'https://example.com/avatar.jpg',
        groups: testGroups,
      );
    });

    test('copyWith should create new Person with updated fields', () {
      print('🔍 Original person:');
      print('  name: ${testPerson.name}');
      print('  describe: ${testPerson.describe}');
      print('  groups count: ${testPerson.groups.length}');

      final updatedGroups = {'group-006': true, 'group-007': false};
      final updatedPerson = testPerson.copyWith(
        name: 'John Updated',
        describe: 'Updated description',
        groups: updatedGroups,
      );

      print('🔍 Updated person:');
      print('  name: ${updatedPerson.name}');
      print('  describe: ${updatedPerson.describe}');
      print('  groups count: ${updatedPerson.groups.length}');

      // Original person should remain unchanged
      expect(testPerson.name, equals('John Doe'));
      expect(testPerson.describe, equals('A friendly person'));
      expect(testPerson.groups, equals(testGroups));

      // New person should have updated fields
      expect(updatedPerson.uid, equals('test-person-001'));
      expect(updatedPerson.name, equals('John Updated'));
      expect(updatedPerson.describe, equals('Updated description'));
      expect(updatedPerson.avtUrl, equals('https://example.com/avatar.jpg'));
      expect(updatedPerson.groups, equals(updatedGroups));

      print('✅ Person copyWith test passed!');
    });

    test('copyWith should preserve original values when no updates provided', () {
      final copiedPerson = testPerson.copyWith();

      expect(copiedPerson.uid, equals(testPerson.uid));
      expect(copiedPerson.name, equals(testPerson.name));
      expect(copiedPerson.describe, equals(testPerson.describe));
      expect(copiedPerson.avtUrl, equals(testPerson.avtUrl));
      expect(copiedPerson.groups, equals(testPerson.groups));
    });

    test('addGroup should add new group to person', () {
      final updatedPerson = testPerson.addGroup('group-new');

      // Original person should remain unchanged
      expect(testPerson.groups.containsKey('group-new'), isFalse);

      // New person should have the new group
      expect(updatedPerson.groups.containsKey('group-new'), isTrue);
      expect(updatedPerson.groups['group-new'], isTrue);
      expect(updatedPerson.groups.length, equals(testGroups.length + 1));
    });

    test('removeGroup should remove existing group from person', () {
      final updatedPerson = testPerson.removeGroup('group-001');

      // Original person should remain unchanged
      expect(testPerson.groups.containsKey('group-001'), isTrue);

      // New person should not have the removed group
      expect(updatedPerson.groups.containsKey('group-001'), isFalse);
      expect(updatedPerson.groups.length, equals(testGroups.length - 1));
    });

    // Test getter methods
    test('getPersonDescribe should return description when provided', () {
      expect(testPerson.getPersonDescribe(), equals('A friendly person'));
    });

    test('getPersonDescribe should return empty string when description is null', () {
      final personWithoutDesc = Person(
        uid: 'test-person-003',
        name: 'No Description Person',
        avtUrl: '',
        groups: {},
      );

      expect(personWithoutDesc.getPersonDescribe(), equals(''));
    });

    test('getPersonName should return name when provided', () {
      expect(testPerson.getPersonName(), equals('John Doe'));
    });
  });
}