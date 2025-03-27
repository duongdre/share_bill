import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_bill/models/data_models/bill.dart';
import 'package:uuid/uuid.dart';

import '../../../models/data_models/group.dart';
import '../../../models/data_models/person.dart';
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

  Future<void> fetchAllBill() async {
    try {
      final databaseReference = FirebaseDatabase.instance.ref("bills");
      final snapshot = await databaseReference.get().timeout(const Duration(seconds: 30));

      allBill.clear();
      allBillMapping.clear();

      if (snapshot.exists) {
        for (final data in snapshot.children) {
          final bill = Bill.fromMap(data.value as Map);
          print('bill data ${bill.toString()}');
          allBill.add(bill);
        }
        allBillMapping = snapshot.value as Map<dynamic, dynamic>;
      } else {
        print('No data available.');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
    state = state + 1;
  }

  Bill? findBillWithPersonUid(String userId) {
    return Bill.fromMap(allBillMapping[userId] as Map);
  }

  Bill? findBillWithGroupUid(String userId) {
    return Bill.fromMap(allBillMapping[userId] as Map);
  }

  Future<void> addNewBill(Bill newBill) async {
    try {
      final databaseReference = FirebaseDatabase.instance.ref("bills");
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
      final databaseReference = FirebaseDatabase.instance.ref("bills");
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
      final databaseReference = FirebaseDatabase.instance.ref("bills");
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
      List<Bill> billsToDelete = allBill.where((bill) => bill.personId == personId).toList();

      // Step 3: Delete from Firebase
      final DatabaseReference database = FirebaseDatabase.instance.ref();

      for (Bill bill in billsToDelete) {
        // Assuming each bill has an id field
        database.child('bills/${bill.uid}').remove().then((_) {
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
      print("Error deleting person from all group: $e");
    }
  }

  Future<void> deleteAGroupFromAllBill(String groupId) async {
    try {
      List<Bill> billsToDelete = allBill.where((bill) => bill.groupId == groupId).toList();

      // Step 3: Delete from Firebase
      final DatabaseReference database = FirebaseDatabase.instance.ref();

      for (Bill bill in billsToDelete) {
        // Assuming each bill has an id field
        database.child('bills/${bill.uid}').remove().then((_) {
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
      print("Error deleting person from all group: $e");
    }
  }
}
