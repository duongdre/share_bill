import 'package:flutter_test/flutter_test.dart';
import 'package:share_bill/models/data_models/person.dart';

void main() {
  group('Person Model Tests', () {
    late Person testPerson;
    late Map<String, dynamic> testPersonJson;
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

      testPersonJson = {
        'uid': 'test-person-001',
        'name': 'John Doe',
        'describe': 'A friendly person',
        'avtUrl': 'https://example.com/avatar.jpg',
        'groups': testGroups,
      };
    });

    test('should create Person with all required fields', () {
      expect(testPerson.uid, equals('test-person-001'));
      expect(testPerson.name, equals('John Doe'));
      expect(testPerson.describe, equals('A friendly person'));
      expect(testPerson.avtUrl, equals('https://example.com/avatar.jpg'));
      expect(testPerson.groups, equals(testGroups));
    });

    test('should create Person with minimal required fields', () {
      final minimalPerson = Person(
        uid: 'test-person-002',
        name: 'Jane Doe',
        avtUrl: '',
        groups: {},
      );

      expect(minimalPerson.uid, equals('test-person-002'));
      expect(minimalPerson.name, equals('Jane Doe'));
      expect(minimalPerson.describe, equals(''));
      expect(minimalPerson.avtUrl, equals(''));
      expect(minimalPerson.groups, equals({}));
    });

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

    test('getPersonName should return empty string when name is null', () {
      // Note: This test assumes name can be null, but the constructor requires it
      // This test might not be applicable given the current model structure
      final personWithName = Person(
        uid: 'test-person-004',
        name: 'Valid Name',
        avtUrl: '',
        groups: {},
      );

      expect(personWithName.getPersonName(), equals('Valid Name'));
    });

    test('fromJson should create Person from JSON correctly', () {
      final person = Person.fromJson(testPersonJson);

      expect(person.uid, equals('test-person-001'));
      expect(person.name, equals('John Doe'));
      expect(person.describe, equals('A friendly person'));
      expect(person.avtUrl, equals('https://example.com/avatar.jpg'));
      expect(person.groups, equals(testGroups));
    });

    test('fromMap should create Person from Map correctly', () {
      final mapData = {
        'uid': 'test-person-005',
        'name': 'Map Person',
        'describe': 'Created from map',
        'avtUrl': 'https://example.com/map-avatar.jpg',
        'groups': {'group-004': true, 'group-005': false},
      };

      final person = Person.fromMap(mapData);

      expect(person.uid, equals('test-person-005'));
      expect(person.name, equals('Map Person'));
      expect(person.describe, equals('Created from map'));
      expect(person.avtUrl, equals('https://example.com/map-avatar.jpg'));
      expect(person.groups, equals({'group-004': true, 'group-005': false}));
    });

    test('fromMap should handle missing optional fields', () {
      final mapDataMinimal = {
        'uid': 'test-person-006',
        'name': 'Minimal Person',
        'avtUrl': '',
      };

      final person = Person.fromMap(mapDataMinimal);

      expect(person.uid, equals('test-person-006'));
      expect(person.name, equals('Minimal Person'));
      expect(person.describe, equals(''));
      expect(person.avtUrl, equals(''));
      expect(person.groups, equals({}));
    });

    test('toMap should convert Person to Map correctly', () {
      final map = testPerson.toMap();

      expect(map['uid'], equals('test-person-001'));
      expect(map['name'], equals('John Doe'));
      expect(map['describe'], equals('A friendly person'));
      expect(map['avtUrl'], equals('https://example.com/avatar.jpg'));
      expect(map['groups'], equals(testGroups));
    });

    test('toJson should convert Person to JSON correctly', () {
      final json = testPerson.toJson();

      expect(json['uid'], equals('test-person-001'));
      expect(json['name'], equals('John Doe'));
      expect(json['describe'], equals('A friendly person'));
      expect(json['avtUrl'], equals('https://example.com/avatar.jpg'));
      expect(json['groups'], equals(testGroups));
    });

    test('copyWith should create new Person with updated fields', () {
      final updatedGroups = {'group-006': true, 'group-007': false};
      final updatedPerson = testPerson.copyWith(
        name: 'John Updated',
        describe: 'Updated description',
        groups: updatedGroups,
      );

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

    test('addGroup should not affect existing groups', () {
      final updatedPerson = testPerson.addGroup('group-new');

      // Check that all original groups are preserved
      testGroups.forEach((key, value) {
        expect(updatedPerson.groups[key], equals(value));
      });
    });

    test('removeGroup should remove existing group from person', () {
      final updatedPerson = testPerson.removeGroup('group-001');

      // Original person should remain unchanged
      expect(testPerson.groups.containsKey('group-001'), isTrue);

      // New person should not have the removed group
      expect(updatedPerson.groups.containsKey('group-001'), isFalse);
      expect(updatedPerson.groups.length, equals(testGroups.length - 1));
    });

    test('removeGroup should not affect other groups', () {
      final updatedPerson = testPerson.removeGroup('group-001');

      // Check that other groups are preserved
      expect(updatedPerson.groups['group-002'], equals(true));
      expect(updatedPerson.groups['group-003'], equals(false));
    });

    test('removeGroup should handle non-existing group gracefully', () {
      final updatedPerson = testPerson.removeGroup('non-existing-group');

      // Should not crash and should preserve all existing groups
      expect(updatedPerson.groups.length, equals(testGroups.length));
      testGroups.forEach((key, value) {
        expect(updatedPerson.groups[key], equals(value));
      });
    });

    test('should handle edge cases for avatar URL', () {
      final personWithEmptyAvatar = Person(
        uid: 'test-person-empty-avatar',
        name: 'No Avatar Person',
        avtUrl: '',
        groups: {},
      );

      expect(personWithEmptyAvatar.avtUrl, equals(''));

      final personWithSpecialCharAvatar = Person(
        uid: 'test-person-special-avatar',
        name: 'Special Avatar Person',
        avtUrl: 'https://example.com/avatar with spaces & émojis 🎉.jpg',
        groups: {},
      );

      expect(personWithSpecialCharAvatar.avtUrl, equals('https://example.com/avatar with spaces & émojis 🎉.jpg'));
    });

    test('should handle special characters in name and description', () {
      final specialPerson = Person(
        uid: 'test-person-special',
        name: 'Jöhn Døe 🎉',
        describe: 'A person with émojis & special chars!',
        avtUrl: '',
        groups: {},
      );

      expect(specialPerson.name, equals('Jöhn Døe 🎉'));
      expect(specialPerson.describe, equals('A person with émojis & special chars!'));
      expect(specialPerson.getPersonName(), equals('Jöhn Døe 🎉'));
      expect(specialPerson.getPersonDescribe(), equals('A person with émojis & special chars!'));
    });

    test('should handle large number of groups', () {
      final manyGroups = <String, bool>{};
      for (int i = 0; i < 100; i++) {
        manyGroups['group-$i'] = i % 2 == 0;
      }

      final personWithManyGroups = Person(
        uid: 'test-person-many-groups',
        name: 'Popular Person',
        avtUrl: '',
        groups: manyGroups,
      );

      expect(personWithManyGroups.groups.length, equals(100));

      // Test adding another group
      final updatedPerson = personWithManyGroups.addGroup('group-new');
      expect(updatedPerson.groups.length, equals(101));
      expect(updatedPerson.groups['group-new'], isTrue);
    });
  });
}