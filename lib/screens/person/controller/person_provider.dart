import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_bill/models/data_models/person.dart';
import 'package:uuid/uuid.dart';
import '../../../services/firebase_services/user_service.dart';
part 'person_provider.g.dart';

@riverpod
class PersonNotifier extends _$PersonNotifier {
  List<Person> allPerson = [];
  Map<dynamic, dynamic> allPersonMapping = {};
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Person detail
  Person currentPersonDetail = Person(uid: "", name: "", avtUrl: "", groups: {});
  bool isLoadingImage = false;

  @override
  int build() {
    state = 0;
    return state;
  }

  Future<void> fetchAllPerson() async {
    try {
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

      final databaseReference = UserService.getUserCollectionRef('persons');
      final snapshot = await databaseReference.get().timeout(const Duration(seconds: 30));

      allPerson.clear();
      allPersonMapping.clear();

      if (snapshot.exists) {
        for (final data in snapshot.children) {
          final person = Person.fromMap(data.value as Map);
          print('✅ Successfully parsed person: ${person.name} (${person.uid})');
          allPerson.add(person);
        }
        allPersonMapping = snapshot.value as Map<dynamic, dynamic>;
      } else {
        print('📭 No persons data available.');
      }
    } catch (error) {
      print('📭 Error fetching data: $error');
    }
    print('📊 Final persons count: ${allPerson.length}');
    state = state + 1;
  }

  void clearNewPersonData() {
    currentPersonDetail = Person(uid: "", name: "", avtUrl: "", groups: {});
  }

  Person? findPersonWithUid(String userId) {
    return Person.fromMap(allPersonMapping[userId] as Map);
  }

  void loadingImageForPersonDetail(bool isLoading) {
    isLoadingImage = isLoading;
    state = state + 1;
  }

  Future<void> uploadAvatarForUserForNewOrExisted() async {
    try {
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

      // Pick image from gallery
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      loadingImageForPersonDetail(true);

      final File imageFile = File(pickedFile.path);

      if (currentPersonDetail.uid.isEmpty) {
        currentPersonDetail.uid = const Uuid().v4();
      }

      // Create a unique filename using UUID
      final userId = UserService.getCurrentUserId()!;
      // Create a unique filename using UUID and user ID
      final fileName = '${userId}_${currentPersonDetail.uid}_${DateTime.now().millisecondsSinceEpoch}';
      final storageRef = _storage.ref().child("avatars/$fileName");

      // Upload the file
      final uploadTask = storageRef.putFile(imageFile);

      // Wait for the upload to complete and get the download URL
      await uploadTask;
      currentPersonDetail.avtUrl = await storageRef.getDownloadURL();
      loadingImageForPersonDetail(false);
      state = state + 1;
    } catch (e) {
      clearNewPersonData();
      print("Error uploading user avatar: $e");
    }
  }

  // Update user's avatar
  Future<void> updateUserAvatar(String userId) async {
    try {
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

      // Pick image from gallery
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      loadingImageForPersonDetail(true);

      final File imageFile = File(pickedFile.path);

      final currentUserId = UserService.getCurrentUserId()!;
      // Create a unique filename using UUID
      final fileName = '${currentUserId}_${userId}_${DateTime.now().millisecondsSinceEpoch}';
      final storageRef = _storage.ref().child("avatars/$fileName");

      // Upload the file
      final uploadTask = storageRef.putFile(imageFile);

      // Wait for the upload to complete and get the download URL
      await uploadTask;
      final downloadUrl = await storageRef.getDownloadURL();

      // Update the user's avatar URL in the database
      final databaseReference = UserService.getUserCollectionRef('persons');
      await databaseReference.child(userId).update({'avtUrl': downloadUrl});

      // Refresh the person list to reflect the changes
      await fetchAllPerson();
      loadingImageForPersonDetail(true);
      state = state + 1;
    } catch (e) {
      print("Error updating user avatar: $e");
    }
  }

  Future<void> addNewPerson(Person newPerson) async {
    try {
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

      if (currentPersonDetail.uid.isEmpty) return;

      final databaseReference = UserService.getUserCollectionRef('persons');
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
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

      if (currentPersonDetail.uid.isEmpty) return;
      final databaseReference = UserService.getUserCollectionRef('persons');
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
      if (!UserService.isUserLoggedIn()) {
        throw Exception('User not logged in');
      }

      final databaseReference = UserService.getUserCollectionRef('persons');
      await databaseReference.child(userId).remove();
      // Refresh the list
      await fetchAllPerson();
      state = state + 1;
    } catch (e) {
      print("Error deleting person: $e");
    }
  }
}