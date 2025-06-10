import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_bill/models/data_models/bill.dart';
import 'package:uuid/uuid.dart';

import '../../../models/data_models/group.dart';
import '../../../models/data_models/person.dart';
import '../../../services/firebase_services/user_service.dart';
import '../../person/controller/person_provider.dart';

part 'bill_provider.g.dart';

@riverpod
class BillNotifier extends _$BillNotifier {
  List<Bill> allBill = [];
  Map<dynamic, dynamic> allBillMapping = {};

  Group currentSpentGroup = Group(uid: "", name: "", members: {});
  Person currentSpentPerson = Person(uid: "", name: "", avtUrl: "", groups: {});
  int currentAmount = 0;

  Map<Group, int> groupWithTotalPaidByPerson = {};

  @override
  int build() {
    state = 0;
    return state;
  }

  double getTotalPaidOfAGroup(Group group) {
    List<Bill> listBillOfGroup = allBill.where((bill) => bill.groupId == group.uid).toList();
    double totalPaidInGroup = 0;
    for (final bill in listBillOfGroup) {
      totalPaidInGroup += bill.amount;
    }
    return totalPaidInGroup;
  }

  double getGroupWithTotalPaidByPerson(String personId, Group group) {
    List<Bill> listBillOfGroup = allBill.where((bill) => bill.groupId == group.uid).toList();
    double totalPaidInGroup = 0;
    for (final bill in listBillOfGroup) {
      if (bill.personId == personId) {
        totalPaidInGroup += bill.amount;
      }
    }
    return totalPaidInGroup;
  }

  Map<String, double> getPersonWithPaidInGroup(Group group) {
    Map<String, double> personWithPaidInAGroup = {};
    final billsOfTheGroup = getAllBillOfGroup(group.uid);
    for (final bill in billsOfTheGroup) {
      if (personWithPaidInAGroup[bill.personId] == null) {
        personWithPaidInAGroup[bill.personId] = 0;
      }
      personWithPaidInAGroup[bill.personId] = personWithPaidInAGroup[bill.personId]! + bill.amount;
    }
    return personWithPaidInAGroup;
  }

  List<Bill> getAllBillOfGroup(String groupId) {
    List<Bill> allBillOfGroup = allBill.where((bill) => bill.groupId == groupId).toList();
    return allBillOfGroup;
  }

  List<Bill> getAllBillOfPerson(String personId) {
    List<Bill> allBillOfPerson = allBill.where((bill) => bill.personId == personId).toList();
    return allBillOfPerson;
  }

  void chooseGroup(Group group) {
    currentSpentGroup = group;
    state = state + 1;
  }

  void choosePerson(Person person) {
    currentSpentPerson = person;
    state = state + 1;
  }

  String getAllMemberNameOfChoseGroup() {
    var group = currentSpentGroup;
    var allMembersName = "";
    final persons = ref.read(personNotifierProvider.notifier);
    group.members.forEach((k, v) {
      final getName = persons.findPersonWithUid(k)?.name ?? "";
      if (v && getName.isNotEmpty) {
        allMembersName += "$getName, ";
      }
    });
    if (allMembersName.length > 2) {
      return allMembersName.substring(0, allMembersName.length - 2);
    } else {
      return "NaN";
    }
  }

  String getAllMemberNameOfAGroup(Group group) {
    var allMembersName = "";
    final persons = ref.read(personNotifierProvider.notifier);
    group.members.forEach((k, v) {
      final getName = persons.findPersonWithUid(k)?.name ?? "";
      if (v && getName.isNotEmpty) {
        allMembersName += "$getName, ";
      }
    });
    if (allMembersName.length > 2) {
      return allMembersName.substring(0, allMembersName.length - 2);
    } else {
      return "NaN";
    }
  }

  void removeCurrentSpent() {
    currentSpentGroup = Group(uid: "", name: "", members: {});
    currentSpentPerson = Person(uid: "", name: "", avtUrl: "", groups: {});
    currentAmount = 0;
  }

  void changeAmount(int newAmount) {
    currentAmount = newAmount;
    state = state + 1;
  }

  List<Bill> getFirst5Bills() {
    if (allBill.length >= 5) {
      return allBill.sublist(0, 4);
    } else {
      return allBill;
    }
  }

  Future<List<Bill>> fetchAllBill() async {
    try {
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

      print('USER ID: ${UserService.getCurrentUserId()}');
      final databaseReference = UserService.getUserCollectionRef('bills');
      final snapshot = await databaseReference.get().timeout(const Duration(seconds: 30));

      allBill.clear();
      allBillMapping.clear();

      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        print('📊 Raw bills data: ${data.keys.length} items');

        data.forEach((key, value) {
          try {
            final bill = Bill.fromMap(value as Map<dynamic, dynamic>);
            print('✅ Successfully parsed bill: ${bill.uid} - Amount: ${bill.amount}');
            allBill.add(bill);
            allBillMapping[key] = value;
          } catch (e) {
            print('❌ Error parsing bill with key $key: $e');
            print('❌ Bill data: $value');
          }
        });
      } else {
        print('📭 No bills data available.');
      }

      print('📊 Final bills count: ${allBill.length}');

      // Force state update to trigger UI rebuild
      state = state + 1;

      // Return the data directly
      return List.from(allBill);

    } catch (error) {
      print('❌ Error fetching bills data: $error');
      return [];
    }
  }

  Bill? findBillWithPersonUid(String userId) {
    try {
      if (allBillMapping.containsKey(userId)) {
        return Bill.fromMap(allBillMapping[userId] as Map<dynamic, dynamic>);
      }
      return null;
    } catch (e) {
      print('❌ Error finding bill with person uid $userId: $e');
      return null;
    }
  }

  Bill? findBillWithGroupUid(String userId) {
    try {
      if (allBillMapping.containsKey(userId)) {
        return Bill.fromMap(allBillMapping[userId] as Map<dynamic, dynamic>);
      }
      return null;
    } catch (e) {
      print('❌ Error finding bill with group uid $userId: $e');
      return null;
    }
  }

  Future<void> addNewBill(Bill newBill) async {
    try {
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

      final databaseReference = UserService.getUserCollectionRef('bills');
      await databaseReference.child(newBill.uid).set(newBill.toJson());
      // Refresh the list
      await fetchAllBill();
      state = state + 1;
    } catch (e) {
      print("Error adding new bill: $e");
    }
  }

  Future<void> updateBillDetails(String billId, Map<String, dynamic> updates) async {
    try {
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

      final databaseReference = UserService.getUserCollectionRef('bills');
      await databaseReference.child(billId).update(updates);
      // Refresh the list
      await fetchAllBill();
      state = state + 1;
    } catch (e) {
      print("Error updating bill details: $e");
    }
  }

  Future<void> deleteBill(String billID) async {
    try {
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

      final databaseReference = UserService.getUserCollectionRef('bills');
      await databaseReference.child(billID).remove();
      // Refresh the list
      await fetchAllBill();
      state = state + 1;
    } catch (e) {
      print("Error deleting bill: $e");
    }
  }

  Future<void> deleteAPersonFromAllBill(String personId) async {
    try {
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

      List<Bill> billsToDelete = allBill.where((bill) => bill.personId == personId).toList();

      // Delete from Firebase
      final DatabaseReference database = UserService.getUserCollectionRef('bills');

      for (Bill bill in billsToDelete) {
        database.child(bill.uid).remove().then((_) {
          print('Bill ${bill.uid} deleted successfully');
        }).catchError((error) {
          print('Failed to delete bill: $error');
          // Handle error (possibly re-add to local list)
        });
      }

      // Refresh the list
      await fetchAllBill();
      state = state + 1;
    } catch (e) {
      print("Error deleting person from all bills: $e");
    }
  }

  Future<void> deleteAGroupFromAllBill(String groupId) async {
    try {
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

      List<Bill> billsToDelete = allBill.where((bill) => bill.groupId == groupId).toList();

      // Delete from Firebase
      final DatabaseReference database = UserService.getUserCollectionRef('bills');

      for (Bill bill in billsToDelete) {
        database.child(bill.uid).remove().then((_) {
          print('Bill ${bill.uid} deleted successfully');
        }).catchError((error) {
          print('Failed to delete bill: $error');
          // Handle error (possibly re-add to local list)
        });
      }

      // Refresh the list
      await fetchAllBill();
      state = state + 1;
    } catch (e) {
      print("Error deleting group from all bills: $e");
    }
  }
}