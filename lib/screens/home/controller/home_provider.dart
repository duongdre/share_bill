import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_bill/models/data_models/person.dart';
import 'package:uuid/uuid.dart';

part 'home_provider.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  int build() {
    return 0; // default index
  }

  int getValue() {
    return state;
  }

  void setValue(int index) {
    state = index;
  }
}