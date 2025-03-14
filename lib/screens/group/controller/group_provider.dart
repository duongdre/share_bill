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

  @override
  int build() {
    state = 0;
    return state;
  }

  Future<void> fetchAllGroup() async {
    try {
      final databaseReference = FirebaseDatabase.instance.ref("groups");
      final snapshot = await databaseReference.get().timeout(const Duration(seconds: 30));

      allGroup.clear();

      if (snapshot.exists) {
        for (final data in snapshot.children) {
          final group = Group.fromMap(data.value as Map);
          print('person data ${group.toJson()}');
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

  Future<void> addNewGroup(Group newGroup) async {
    try {
      final databaseReference = FirebaseDatabase.instance.ref("groups");
      await databaseReference.child(newGroup.uid).set(newGroup.toJson());
      // Refresh the list
      await fetchAllGroup();
      state = state + 1;
    } catch (e) {
      print("Error adding new person: $e");
    }
  }

  Future<void> updateGroupDetails(String groupId, Map<String, dynamic> updates) async {
    try {
      final databaseReference = FirebaseDatabase.instance.ref("groups");
      await databaseReference.child(groupId).update(updates);
      // Refresh the list
      await fetchAllGroup();
      state = state + 1;
    } catch (e) {
      print("Error updating person details: $e");
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
      print("Error deleting person: $e");
    }
  }
}