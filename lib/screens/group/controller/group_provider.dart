import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../models/data_models/bill.dart';
import '../../../models/data_models/group.dart';
import '../../../services/firebase_services/user_service.dart';

part 'group_provider.g.dart';

@riverpod
class GroupNotifier extends _$GroupNotifier {
  List<Group> allGroup = [];
  Map<dynamic, dynamic> allGroupMapping = {};
  Map<dynamic, dynamic> allGroupMappingByName = {};
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Group currentGroupDetail = Group(uid: "", name: "", members: {});

  @override
  int build() {
    state = 0;
    return state;
  }

  List<Group> getAllGroupOfAPerson(String personId) {
    List<Group> allBillOfGroup = allGroup.where((group) => (group.members.keys.contains(personId)) && (group.members[personId] == true)).toList();
    return allBillOfGroup;
  }

  Group? findGroupWithUid(String groupId) {
    return Group.fromMap(allGroupMapping[groupId] as Map);
  }

  Group? findGroupWithName(String groupName) {
    return Group.fromMap(allGroupMappingByName[groupName]);
  }

  void clearNewGroupData() {
    currentGroupDetail = Group(uid: "", name: "", members: {});
  }

  Future<void> fetchAllGroup() async {
    try {
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

      print('USER ID: ${UserService.getCurrentUserId()}');
      final databaseReference = UserService.getUserCollectionRef('groups');
      final snapshot = await databaseReference.get().timeout(const Duration(seconds: 30));

      allGroup.clear();
      allGroupMapping.clear();
      allGroupMappingByName.clear();

      if (snapshot.exists) {
        for (final data in snapshot.children) {
          final group = Group.fromMap(data.value as Map);
          print('✅ Successfully parsed group: ${group.name} (${group.uid})');
          allGroup.add(group);
          allGroupMappingByName[group.name] = data.value as Map<dynamic, dynamic>;
        }
        allGroupMapping = snapshot.value as Map<dynamic, dynamic>;
      } else {
        print('📭 No groups data available.');
      }
    } catch (error) {
      print('📭 Error fetching data: $error');
    }
    print('📊 Final groups count: ${allGroup.length}');
    state = state + 1;
  }

  Future<void> updateGroupMemberOffline(Map<String, bool> newGroupMember) async {
    currentGroupDetail.members = newGroupMember;
    state = state + 1;
  }

  // Update group's member
  Future<void> updateGroupMember(String groupId, Map<String, dynamic> updates) async {
    if (!UserService.isUserLoggedIn()) {
      throw Exception('User not logged in');
    }

    try {
      // Do not push the mapItem to firebase if the value is false
      // Format the updates-input data to remove all the false-value
      Map<String, dynamic> formatedUpdates = {};
      updates.forEach((k, v) {
        if (v) {
          formatedUpdates[k] = v;
        }
      });

      final databaseReference = UserService.getUserCollectionRef('groups');
      // Because of only update true value. Needed to use set instead of update
      await databaseReference.child(groupId).child("members").set(formatedUpdates);
      // Refresh the list
      await fetchAllGroup();
      state = state + 1;
    } catch (e) {
      print("Error updating group member: $e");
    }
  }

  Future<void> updateGroupName(String groupId, String name) async {
    try {
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

      final databaseReference = UserService.getUserCollectionRef('groups');
      await databaseReference.child(groupId).update({"name": name});
      // Refresh the list
      await fetchAllGroup();
      state = state + 1;
    } catch (e) {
      print("Error updating group member: $e");
    }
  }
  
  Future<void> addNewGroup(Group newGroup) async {
    try {
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

      if (currentGroupDetail.uid.isEmpty) return;

      final databaseReference = UserService.getUserCollectionRef('groups');
      await databaseReference.child(newGroup.uid).set(newGroup.toJson());
      // Refresh the list
      await fetchAllGroup();
      state = state + 1;
    } catch (e) {
      print("Error adding new group: $e");
    }
  }

  Future<void> updateGroupDetails(String groupId, Map<String, dynamic> updates) async {
    try {
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

      if (currentGroupDetail.uid.isEmpty) return;


      final databaseReference = UserService.getUserCollectionRef('groups');
      await databaseReference.child(groupId).update(updates);
      // Refresh the list
      await fetchAllGroup();
      state = state + 1;
    } catch (e) {
      print("Error updating group details: $e");
    }
  }

  Future<void> deleteGroup(String groupId) async {
    try {
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

      final databaseReference = UserService.getUserCollectionRef('groups');
      await databaseReference.child(groupId).remove();
      // Refresh the list
      await fetchAllGroup();
      state = state + 1;
    } catch (e) {
      print("Error deleting group: $e");
    }
  }

  Future<void> deleteAPersonFromAllGroup(String personId) async {
    try {
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

      for (final group in allGroup) {
        group.members[personId] = false;
        updateGroupMember(group.uid, group.members);
      }
      // Refresh the list
      await fetchAllGroup();
      state = state + 1;
    } catch (e) {
      print("Error deleting person from all group: $e");
    }
  }
}