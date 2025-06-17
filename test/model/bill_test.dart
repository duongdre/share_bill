import 'package:flutter_test/flutter_test.dart';
import 'package:share_bill/models/data_models/bill.dart';

void main() {
  group('Bill Model Tests', () {
    late Bill testBill;
    late Map<String, dynamic> testBillJson;

    setUp(() {
      testBill = Bill(
        uid: 'test-bill-001',
        groupId: 'test-group-001',
        personId: 'test-person-001',
        amount: 150000,
        description: 'Lunch at restaurant',
        createdAt: 1672531200000, // 2023-01-01 00:00:00
      );

      testBillJson = {
        'uid': 'test-bill-001',
        'name': 'test-group-001', // Note: JSON uses 'name' for groupId
        'personId': 'test-person-001',
        'amount': 150000,
        'description': 'Lunch at restaurant',
        'createdAt': 1672531200000,
      };
    });

    test('should create Bill with all required fields', () {
      expect(testBill.uid, equals('test-bill-001'));
      expect(testBill.groupId, equals('test-group-001'));
      expect(testBill.personId, equals('test-person-001'));
      expect(testBill.amount, equals(150000));
      expect(testBill.description, equals('Lunch at restaurant'));
      expect(testBill.createdAt, equals(1672531200000));
    });

    test('should create Bill with default createdAt when not provided', () {
      final bill = Bill(
        uid: 'test-bill-002',
        groupId: 'test-group-002',
        personId: 'test-person-002',
        amount: 100000,
      );

      expect(bill.createdAt, isNotNull);
      expect(bill.createdAt, greaterThan(0));
    });

    test('getDescribe should return description when provided', () {
      expect(testBill.getDescribe(), equals('Lunch at restaurant'));
    });

    test('getDescribe should return default message when description is null', () {
      final billWithoutDesc = Bill(
        uid: 'test-bill-003',
        groupId: 'test-group-003',
        personId: 'test-person-003',
        amount: 50000,
      );

      expect(billWithoutDesc.getDescribe(), equals('Không ghi chú'));
    });

    test('getDescribe should return default message when description is empty', () {
      final billWithEmptyDesc = Bill(
        uid: 'test-bill-004',
        groupId: 'test-group-004',
        personId: 'test-person-004',
        amount: 50000,
        description: '',
      );

      expect(billWithEmptyDesc.getDescribe(), equals('Không ghi chú'));
    });

    test('fromJson should create Bill from JSON correctly', () {
      final bill = Bill.fromJson(testBillJson);

      expect(bill.uid, equals('test-bill-001'));
      expect(bill.groupId, equals('test-group-001'));
      expect(bill.personId, equals('test-person-001'));
      expect(bill.amount, equals(150000));
      expect(bill.description, equals('Lunch at restaurant'));
      expect(bill.createdAt, equals(1672531200000));
    });

    test('fromJson should handle missing createdAt', () {
      final jsonWithoutCreatedAt = Map<String, dynamic>.from(testBillJson);
      jsonWithoutCreatedAt.remove('createdAt');

      final bill = Bill.fromJson(jsonWithoutCreatedAt);

      expect(bill.createdAt, isNotNull);
      expect(bill.createdAt, greaterThan(0));
    });

    test('fromMap should create Bill from Map correctly', () {
      final mapData = {
        'uid': 'test-bill-005',
        'groupId': 'test-group-005',
        'personId': 'test-person-005',
        'amount': 200000,
        'description': 'Dinner',
        'createdAt': 1672617600000,
      };

      final bill = Bill.fromMap(mapData);

      expect(bill.uid, equals('test-bill-005'));
      expect(bill.groupId, equals('test-group-005'));
      expect(bill.personId, equals('test-person-005'));
      expect(bill.amount, equals(200000));
      expect(bill.description, equals('Dinner'));
      expect(bill.createdAt, equals(1672617600000));
    });

    test('toMap should convert Bill to Map correctly', () {
      final map = testBill.toMap();

      expect(map['uid'], equals('test-bill-001'));
      expect(map['groupId'], equals('test-group-001'));
      expect(map['personId'], equals('test-person-001'));
      expect(map['amount'], equals(150000));
      expect(map['description'], equals('Lunch at restaurant'));
      expect(map['createdAt'], equals(1672531200000));
    });

    test('toJson should convert Bill to JSON correctly', () {
      final json = testBill.toJson();

      expect(json['uid'], equals('test-bill-001'));
      expect(json['groupId'], equals('test-group-001'));
      expect(json['personId'], equals('test-person-001'));
      expect(json['amount'], equals(150000));
      expect(json['description'], equals('Lunch at restaurant'));
      expect(json['createdAt'], equals(1672531200000));
    });

    test('copyWith should create new Bill with updated fields', () {
      final updatedBill = testBill.copyWith(
        amount: 200000,
        description: 'Updated description',
      );

      // Original bill should remain unchanged
      expect(testBill.amount, equals(150000));
      expect(testBill.description, equals('Lunch at restaurant'));

      // New bill should have updated fields
      expect(updatedBill.uid, equals('test-bill-001'));
      expect(updatedBill.groupId, equals('test-group-001'));
      expect(updatedBill.personId, equals('test-person-001'));
      expect(updatedBill.amount, equals(200000));
      expect(updatedBill.description, equals('Updated description'));
    });

    test('toString should return formatted string representation', () {
      final stringRepresentation = testBill.toString();

      expect(stringRepresentation, contains('test-bill-001'));
      expect(stringRepresentation, contains('test-group-001'));
      expect(stringRepresentation, contains('test-person-001'));
      expect(stringRepresentation, contains('150000'));
      expect(stringRepresentation, contains('Lunch at restaurant'));
    });

    test('should handle edge cases for amount', () {
      final billWithZeroAmount = Bill(
        uid: 'test-bill-zero',
        groupId: 'test-group-zero',
        personId: 'test-person-zero',
        amount: 0,
      );

      expect(billWithZeroAmount.amount, equals(0));

      final billWithLargeAmount = Bill(
        uid: 'test-bill-large',
        groupId: 'test-group-large',
        personId: 'test-person-large',
        amount: 999999999,
      );

      expect(billWithLargeAmount.amount, equals(999999999));
    });
  });
}