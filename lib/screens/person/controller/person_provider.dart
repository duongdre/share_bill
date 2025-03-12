import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_bill/models/data_models/person.dart';
import 'package:uuid/uuid.dart';

part 'person_provider.g.dart';

@riverpod
class PersonNotifier extends _$PersonNotifier {
  List<Person> allPerson = [];
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // New person
  String newPersonId = "";
  String newPersonAvtUploaded = "";

  @override
  int build() {
    state = 0;
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
    state = state + 1;
  }

  void clearNewPersonData() {
    newPersonId = "";
    newPersonAvtUploaded = "";
  }

  Future<void> uploadUserAvatar() async {
    try {
      // Pick image from gallery
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        clearNewPersonData();
      }

      final File imageFile = File(pickedFile!.path);

      newPersonId = const Uuid().v4();

      // Create a unique filename using UUID
      final fileName = '${newPersonId}_${DateTime.now().millisecondsSinceEpoch}';
      final storageRef = _storage.ref().child("avatars/$fileName");

      // Upload the file
      final uploadTask = storageRef.putFile(imageFile);

      // Wait for the upload to complete and get the download URL
      await uploadTask;
      newPersonAvtUploaded = await storageRef.getDownloadURL();
      state = state + 1;
    } catch (e) {
      clearNewPersonData();
      print("Error uploading user avatar: $e");
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
      state = state + 1;
    } catch (e) {
      print("Error updating user avatar: $e");
    }
  }

  Future<void> addNewPerson(Person newPerson) async {
    try {
      if (newPersonId.isEmpty) return;
      final databaseReference = FirebaseDatabase.instance.ref("persons");
      await databaseReference.child(newPerson.uid).set(newPerson.toJson());
      clearNewPersonData();
      // Refresh the list
      await fetchAllPerson();
      state = state + 1;
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
      state = state + 1;
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
      state = state + 1;
    } catch (e) {
      print("Error deleting person: $e");
    }
  }
}