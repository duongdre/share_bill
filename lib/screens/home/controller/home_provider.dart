import 'package:riverpod_annotation/riverpod_annotation.dart';
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