import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_bill/models/data_models/bill.dart';
import 'package:share_bill/models/data_models/group.dart';
import 'package:share_bill/models/data_models/person.dart';
import 'package:share_bill/screens/bill/controller/bill_provider.dart';

// Mock data for testing
class MockBillData {
  static List<Bill> getMockBills() {
    return [
      Bill(
        uid: 'bill-001',
        groupId: 'group-001',
        personId: 'person-001',
        amount: 150000,
        description: 'Lunch',
        createdAt: 1672531200000,
      ),
      Bill(
        uid: 'bill-002',
        groupId: 'group-001',
        personId: 'person-002',
        amount: 200000,
        description: 'Dinner',
        createdAt: 1672617600000,
      ),
      Bill(
        uid: 'bill-003',
        groupId: 'group-002',
        personId: 'person-001',
        amount: 100000,
        description: 'Coffee',
        createdAt: 1672704000000,
      ),
      Bill(
        uid: 'bill-004',
        groupId: 'group-001',
        personId: 'person-003',
        amount: 300000,
        description: 'Groceries',
        createdAt: 1672790400000,
      ),
      Bill(
        uid: 'bill-005',
        groupId: 'group-002',
        personId: 'person-002',
        amount: 75000,
        description: 'Snacks',
        createdAt: 1672876800000,
      ),
    ];
  }

  static Group getMockGroup1() {
    return Group(
      uid: 'group-001',
      name: 'Weekend Trip',
      members: {
        'person-001': true,
        'person-002': true,
        'person-003': true,
      },
    );
  }

  static Group getMockGroup2() {
    return Group(
      uid: 'group-002',
      name: 'Office Lunch',
      members: {
        'person-001': true,
        'person-002': true,
      },
    );
  }

  static Person getMockPerson1() {
    return Person(
      uid: 'person-001',
      name: 'Alice',
      avtUrl: '',
      groups: {'group-001': true, 'group-002': true},
    );
  }

  static Person getMockPerson2() {
    return Person(
      uid: 'person-002',
      name: 'Bob',
      avtUrl: '',
      groups: {'group-001': true, 'group-002': true},
    );
  }

  static Person getMockPerson3() {
    return Person(
      uid: 'person-003',
      name: 'Charlie',
      avtUrl: '',
      groups: {'group-001': true},
    );
  }
}

void main() {
  group('BillNotifier Tests', () {
    late ProviderContainer container;
    late BillNotifier billNotifier;

    setUp(() {
      container = ProviderContainer();
      billNotifier = container.read(billNotifierProvider.notifier);

      // Setup mock data
      billNotifier.allBill = MockBillData.getMockBills();
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with default state', () {
      final freshContainer = ProviderContainer();
      final freshNotifier = freshContainer.read(billNotifierProvider.notifier);

      expect(freshNotifier.allBill, isEmpty);
      expect(freshNotifier.currentSpentGroup.uid, equals(''));
      expect(freshNotifier.currentSpentPerson.uid, equals(''));
      expect(freshNotifier.currentAmount, equals(0));

      freshContainer.dispose();
    });

    test('getTotalPaidOfAGroup should calculate correct total', () {
      final group1 = MockBillData.getMockGroup1();
      final total = billNotifier.getTotalPaidOfAGroup(group1);

      // Bills for group-001: 150000 + 200000 + 300000 = 650000
      expect(total, equals(650000.0));
    });

    test('getTotalPaidOfAGroup should return 0 for group with no bills', () {
      final emptyGroup = Group(
        uid: 'empty-group',
        name: 'Empty Group',
        members: {'person-001': true},
      );

      final total = billNotifier.getTotalPaidOfAGroup(emptyGroup);
      expect(total, equals(0.0));
    });

    test('getGroupWithTotalPaidByPerson should calculate correct total for specific person', () {
      final group1 = MockBillData.getMockGroup1();

      // person-001 in group-001: bill-001 (150000)
      final totalPerson1 = billNotifier.getGroupWithTotalPaidByPerson('person-001', group1);
      expect(totalPerson1, equals(150000.0));

      // person-002 in group-001: bill-002 (200000)
      final totalPerson2 = billNotifier.getGroupWithTotalPaidByPerson('person-002', group1);
      expect(totalPerson2, equals(200000.0));

      // person-003 in group-001: bill-004 (300000)
      final totalPerson3 = billNotifier.getGroupWithTotalPaidByPerson('person-003', group1);
      expect(totalPerson3, equals(300000.0));
    });

    test('getPersonWithPaidInGroup should return correct mapping', () {
      final group1 = MockBillData.getMockGroup1();
      final personPaidMap = billNotifier.getPersonWithPaidInGroup(group1);

      expect(personPaidMap['person-001'], equals(150000.0));
      expect(personPaidMap['person-002'], equals(200000.0));
      expect(personPaidMap['person-003'], equals(300000.0));
    });

    test('getAllBillOfGroup should return bills for specific group', () {
      final billsGroup1 = billNotifier.getAllBillOfGroup('group-001');
      expect(billsGroup1.length, equals(3));

      final billsGroup2 = billNotifier.getAllBillOfGroup('group-002');
      expect(billsGroup2.length, equals(2));

      final billsNonExistent = billNotifier.getAllBillOfGroup('non-existent');
      expect(billsNonExistent.length, equals(0));
    });

    test('getAllBillOfPerson should return bills for specific person', () {
      final billsPerson1 = billNotifier.getAllBillOfPerson('person-001');
      expect(billsPerson1.length, equals(2)); // bill-001, bill-003

      final billsPerson2 = billNotifier.getAllBillOfPerson('person-002');
      expect(billsPerson2.length, equals(2)); // bill-002, bill-005

      final billsPerson3 = billNotifier.getAllBillOfPerson('person-003');
      expect(billsPerson3.length, equals(1)); // bill-004
    });

    test('chooseGroup should update current spent group and increment state', () {
      final group = MockBillData.getMockGroup1();
      final initialState = container.read(billNotifierProvider);

      billNotifier.chooseGroup(group);

      expect(billNotifier.currentSpentGroup.uid, equals('group-001'));
      expect(billNotifier.currentSpentGroup.name, equals('Weekend Trip'));

      final newState = container.read(billNotifierProvider);
      expect(newState, equals(initialState + 1));
    });

    test('choosePerson should update current spent person and increment state', () {
      final person = MockBillData.getMockPerson1();
      final initialState = container.read(billNotifierProvider);

      billNotifier.choosePerson(person);

      expect(billNotifier.currentSpentPerson.uid, equals('person-001'));
      expect(billNotifier.currentSpentPerson.name, equals('Alice'));

      final newState = container.read(billNotifierProvider);
      expect(newState, equals(initialState + 1));
    });

    test('removeCurrentSpent should reset current spent data', () {
      // First set some data
      billNotifier.chooseGroup(MockBillData.getMockGroup1());
      billNotifier.choosePerson(MockBillData.getMockPerson1());
      billNotifier.changeAmount(100000);

      // Then remove it
      billNotifier.removeCurrentSpent();

      expect(billNotifier.currentSpentGroup.uid, equals(''));
      expect(billNotifier.currentSpentPerson.uid, equals(''));
      expect(billNotifier.currentAmount, equals(0));
    });

    test('changeAmount should update current amount and increment state', () {
      final initialState = container.read(billNotifierProvider);

      billNotifier.changeAmount(250000);

      expect(billNotifier.currentAmount, equals(250000));

      final newState = container.read(billNotifierProvider);
      expect(newState, equals(initialState + 1));
    });

    test('getFirst5Bills should return first 5 bills when more than 5 exist', () {
      // Add more bills to test the limit
      final moreBills = List.generate(10, (index) => Bill(
        uid: 'extra-bill-$index',
        groupId: 'group-extra',
        personId: 'person-extra',
        amount: 50000,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ));

      billNotifier.allBill.addAll(moreBills);

      final firstBills = billNotifier.getFirst5Bills();
      expect(firstBills.length, equals(5)); // Should return first 5, not 4 as in the code
    });

    test('getFirst5Bills should return all bills when less than 5 exist', () {
      // Use original mock data (5 bills)
      final firstBills = billNotifier.getFirst5Bills();
      expect(firstBills.length, equals(5)); // All 5 bills should be returned
    });

    test('should handle edge cases for calculations', () {
      // Test with bills that have zero amounts
      final zeroBill = Bill(
        uid: 'zero-bill',
        groupId: 'group-001',
        personId: 'person-001',
        amount: 0,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      billNotifier.allBill.add(zeroBill);

      final group1 = MockBillData.getMockGroup1();
      final total = billNotifier.getTotalPaidOfAGroup(group1);

      // Should still calculate correctly with zero amount
      expect(total, equals(650000.0)); // Original total unchanged
    });

    test('should handle empty group members correctly', () {
      final emptyMembersGroup = Group(
        uid: 'empty-members-group',
        name: 'Empty Members',
        members: {},
      );

      final personPaidMap = billNotifier.getPersonWithPaidInGroup(emptyMembersGroup);
      expect(personPaidMap, isEmpty);
    });

    test('should maintain data consistency across operations', () {
      final group = MockBillData.getMockGroup1();
      final person = MockBillData.getMockPerson1();

      // Perform multiple operations
      billNotifier.chooseGroup(group);
      billNotifier.choosePerson(person);
      billNotifier.changeAmount(150000);

      // Verify state consistency
      expect(billNotifier.currentSpentGroup.uid, equals('group-001'));
      expect(billNotifier.currentSpentPerson.uid, equals('person-001'));
      expect(billNotifier.currentAmount, equals(150000));

      // Verify original data unchanged
      final billsForGroup = billNotifier.getAllBillOfGroup('group-001');
      expect(billsForGroup.length, equals(3));
    });

    test('should handle large amounts correctly', () {
      final largeBill = Bill(
        uid: 'large-bill',
        groupId: 'group-001',
        personId: 'person-001',
        amount: 999999999,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      billNotifier.allBill.add(largeBill);

      final group1 = MockBillData.getMockGroup1();
      final total = billNotifier.getTotalPaidOfAGroup(group1);

      expect(total, equals(650000.0 + 999999999));
    });
  });
}