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
    try {
      if (allGroupMapping.containsKey(groupId)) {
        return Group.fromMap(allGroupMapping[groupId] as Map<dynamic, dynamic>);
      }

      // Also search in the allGroup list as backup
      for (final group in allGroup) {
        if (group.uid == groupId) {
          return group;
        }
      }

      return null;
    } catch (e) {
      print('❌ Error finding group with uid $groupId: $e');
      return null;
    }
  }

  Group? findGroupWithName(String groupName) {
    try {
      if (allGroupMappingByName.containsKey(groupName)) {
        return Group.fromMap(allGroupMappingByName[groupName] as Map<dynamic, dynamic>);
      }

      // Also search in the allGroup list as backup
      for (final group in allGroup) {
        if (group.name == groupName) {
          return group;
        }
      }

      return null;
    } catch (e) {
      print('❌ Error finding group with name $groupName: $e');
      return null;
    }
  }

  void clearNewGroupData() {
    currentGroupDetail = Group(uid: "", name: "", members: {});
  }

  Future<List<Group>> fetchAllGroup() async {
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

      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        print('📊 Raw groups data: ${data.keys.length} items');

        data.forEach((key, value) {
          try {
            final group = Group.fromMap(value as Map<dynamic, dynamic>);
            print('✅ Successfully parsed group: ${group.name} (${group.uid})');
            allGroup.add(group);
            allGroupMapping[key] = value;
            allGroupMappingByName[group.name] = value;
          } catch (e) {
            print('❌ Error parsing group with key $key: $e');
            print('❌ Group data: $value');
          }
        });
      } else {
        print('📭 No groups data available.');
      }

      print('📊 Final groups count: ${allGroup.length}');

      // Force state update to trigger UI rebuild
      state = state + 1;

      // Return the data directly
      return List.from(allGroup);

    } catch (error) {
      print('❌ Error fetching groups data: $error');
      return [];
    }
  }

  Future<void> updateGroupMemberOffline(Map<String, bool> newGroupMember) async {
    currentGroupDetail.members = newGroupMember;
    state = state + 1;
  }

  // Update group's member
  Future<void> updateGroupMember(String groupId, Map<String, dynamic> updates) async {
    try {
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

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