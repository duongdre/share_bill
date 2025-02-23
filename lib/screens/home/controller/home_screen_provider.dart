import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_screen_provider.g.dart';

// Generated notifier providers

class HomeScreenTotalState {
  final double totalSpent;
  final double totalDept;

  HomeScreenTotalState({required this.totalSpent, required this.totalDept});
}

// class HomeScreenMemberState {
//   final double totalSpent;
//   final double totalDept;
//
//   HomeScreenTotalState({required this.totalSpent, required this.totalDept});
// }

@riverpod
class HomeScreenTotalNotifier extends _$HomeScreenTotalNotifier {

  @override
  HomeScreenTotalState build() {
    state = HomeScreenTotalState(totalSpent: 0.0, totalDept: 0.0);
    return state;
  }

  void addTotalSpent(double amount) {
    state = HomeScreenTotalState(totalSpent: state.totalSpent + amount, totalDept: state.totalDept);
  }

  void minusTotalSpent(double amount) {
    state = HomeScreenTotalState(totalSpent: state.totalSpent - amount, totalDept: state.totalDept);
  }

  void addTotalDept(double amount) {
    state = HomeScreenTotalState(totalSpent: state.totalSpent + amount, totalDept: state.totalDept);
  }

  void minusTotalDept(double amount) {
    state = HomeScreenTotalState(totalSpent: state.totalSpent - amount, totalDept: state.totalDept);
  }
}

/*
onTap: () async {
print("=========== STARTTTTT ===========");

final databaseReference = FirebaseDatabase.instance.ref("users");

// final huongptm = Person.fromFulfill(
//   uid: const Uuid().v4(),
//   name: "HuongPTM",
//   yearOfBirth: 1997,
//   avtUrl: "",
//   groupId: [const Uuid().v4(), const Uuid().v4()],
// );
// await databaseReference.child(huongptm.uid).set(huongptm.toJsonWithoutUid());

// final snapshot = await databaseReference.get();
// if (snapshot.exists) {
//   print(snapshot.value);
// } else {
//   print('No data available.');
// }

///////////////////////////////////

FirebaseStorage _storage = FirebaseStorage.instance;

final _image = await ImagePicker().pickImage(source: ImageSource.gallery);

final storageRef = _storage.ref().child("images/");
final xab = storageRef.child("/user/${Uuid().v4()}");
final uploadTask = xab.putFile(File(_image!.path));
// Listen for state changes, errors, and completion of the upload.
uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
switch (taskSnapshot.state) {
case TaskState.running:
final progress = 100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
print("Upload is $progress% complete.");
break;
case TaskState.paused:
print("Upload is paused.");
break;
case TaskState.canceled:
print("Upload was canceled");
break;
case TaskState.error:
print("Upload was error");
break;
case TaskState.success:
print("Upload was success");
break;
}
});

final islandRef = _storage.ref("images").child("/user/fc0d1417-f36e-4659-b8e7-2e95113852fe");

Directory appDocDir = await getApplicationDocumentsDirectory();
File file = File('${appDocDir.path}/myPath/milktea.jpg');
print("AAA ${file.path}");
await file.create(recursive: true);

final downloadTask = islandRef.writeToFile(file);
downloadTask.snapshotEvents.listen((taskSnapshot) {
switch (taskSnapshot.state) {
case TaskState.running:
// TODO: Handle this case.
break;
case TaskState.paused:
// TODO: Handle this case.
break;
case TaskState.success:
// TODO: Handle this case.
break;
case TaskState.canceled:
// TODO: Handle this case.
break;
case TaskState.error:
// TODO: Handle this case.
break;
}
});

print("=========== ENDDDDDD ===========");
},*/
