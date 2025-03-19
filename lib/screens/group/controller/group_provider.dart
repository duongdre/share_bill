import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../models/data_models/group.dart';

part 'group_provider.g.dart';

@riverpod
class GroupNotifier extends _$GroupNotifier {
  List<Group> allGroup = [];
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Group currentGroupDetail = Group(uid: "", name: "", members: {});

  @override
  int build() {
    state = 0;
    return state;
  }

  void clearNewGroupData() {
    currentGroupDetail = Group(uid: "", name: "", members: {});
  }

  Future<void> fetchAllGroup() async {
    try {
      final databaseReference = FirebaseDatabase.instance.ref("groups");
      final snapshot = await databaseReference.get().timeout(const Duration(seconds: 30));

      allGroup.clear();

      if (snapshot.exists) {
        for (final data in snapshot.children) {
          final group = Group.fromMap(data.value as Map);
          print('group data ${group.toJson()}');
          allGroup.add(group);
        }
      } else {
        print('No data available.');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
    state = state + 1;
  }

  // Update group's member
  Future<void> updateGroupMember(String groupId, Map<String, dynamic> updates) async {
    try {
      // Do not push the mapItem to firebase if the value is false
      // Format the updates-input data to remove all the false-value
      Map<String, dynamic> formatedUpdates = {};
      updates.forEach((k, v) {
        if (v) {
          formatedUpdates[k] = v;
        }
      });

      final databaseReference = FirebaseDatabase.instance.ref("groups");
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
      final databaseReference = FirebaseDatabase.instance.ref("groups");
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
      if (currentGroupDetail.uid.isEmpty) return;
      final databaseReference = FirebaseDatabase.instance.ref("groups");
      await databaseReference.child(newGroup.uid).set(newGroup.toJson());
      clearNewGroupData();
      // Refresh the list
      await fetchAllGroup();
      state = state + 1;
    } catch (e) {
      print("Error adding new group: $e");
    }
  }

  Future<void> updateGroupDetails(String groupId, Map<String, dynamic> updates) async {
    try {
      if (currentGroupDetail.uid.isEmpty) return;
      final databaseReference = FirebaseDatabase.instance.ref("groups");
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
      final databaseReference = FirebaseDatabase.instance.ref("groups");
      await databaseReference.child(groupId).remove();
      // Refresh the list
      await fetchAllGroup();
      state = state + 1;
    } catch (e) {
      print("Error deleting group: $e");
    }
  }

  Future<void> deleteAPersonFromAllGroup(String person) async {
    try {
      for (final group in allGroup) {
        group.members[person] = false;
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