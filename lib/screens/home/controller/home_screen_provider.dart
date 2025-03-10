import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_bill/models/data_models/person.dart';
import 'package:uuid/uuid.dart';

part 'home_screen_provider.g.dart';

class HomeScreenTotalState {
  final double totalSpent;
  final double totalDept;

  HomeScreenTotalState({required this.totalSpent, required this.totalDept});
}

@riverpod
class HomeScreenTotalNotifier extends _$HomeScreenTotalNotifier {
  List<Person> allPerson = [];
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  HomeScreenTotalState build() {
    state = HomeScreenTotalState(totalSpent: 0.0, totalDept: 0.0);
    return state;
  }

  Future<void> fetchAllPerson() async {
    try {
      final databaseReference = FirebaseDatabase.instance.ref("persons");
      final snapshot = await databaseReference.get().timeout(const Duration(seconds: 30));

      allPerson.clear();

      if (snapshot.exists) {
        for (final data in snapshot.children) {
          final person = Person.fromMap(data.value as Map);
          print('person data ${person.toJson()}');
          allPerson.add(person);
        }
      } else {
        print('No data available.');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  // Update user's avatar
  Future<void> updateUserAvatar(String userId) async {
    try {
      // Pick image from gallery
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      final File imageFile = File(pickedFile.path);

      // Create a unique filename using UUID
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}';
      final storageRef = _storage.ref().child("avatars/$fileName");

      // Upload the file
      final uploadTask = storageRef.putFile(imageFile);

      // Wait for the upload to complete and get the download URL
      await uploadTask;
      final downloadUrl = await storageRef.getDownloadURL();

      // Update the user's avatar URL in the database
      final databaseReference = FirebaseDatabase.instance.ref("persons");
      await databaseReference.child(userId).update({'avtUrl': downloadUrl});

      // Refresh the person list to reflect the changes
      await fetchAllPerson();
    } catch (e) {
      print("Error updating user avatar: $e");
    }
  }

  Future<void> addNewPerson(Person newPerson) async {
    try {
      final databaseReference = FirebaseDatabase.instance.ref("persons");
      await databaseReference.child(newPerson.uid).set(newPerson.toJson());
      // Refresh the list
      await fetchAllPerson();
    } catch (e) {
      print("Error adding new person: $e");
    }
  }

  Future<void> updatePersonDetails(String userId, Map<String, dynamic> updates) async {
    try {
      final databaseReference = FirebaseDatabase.instance.ref("persons");
      await databaseReference.child(userId).update(updates);
      // Refresh the list
      await fetchAllPerson();
    } catch (e) {
      print("Error updating person details: $e");
    }
  }

  Future<void> deletePerson(String userId) async {
    try {
      final databaseReference = FirebaseDatabase.instance.ref("persons");
      await databaseReference.child(userId).remove();
      // Refresh the list
      await fetchAllPerson();
    } catch (e) {
      print("Error deleting person: $e");
    }
  }

  void addTotalSpent(double amount) {
    state = HomeScreenTotalState(totalSpent: state.totalSpent + amount, totalDept: state.totalDept);
  }

  void minusTotalSpent(double amount) {
    state = HomeScreenTotalState(totalSpent: state.totalSpent - amount, totalDept: state.totalDept);
  }

  void addTotalDept(double amount) {
    state = HomeScreenTotalState(totalSpent: state.totalSpent, totalDept: state.totalDept + amount);
  }

  void minusTotalDept(double amount) {
    state = HomeScreenTotalState(totalSpent: state.totalSpent, totalDept: state.totalDept - amount);
  }
}