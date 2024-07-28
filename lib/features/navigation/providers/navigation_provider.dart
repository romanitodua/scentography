import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scentography/app.dart';


part 'navigation_provider.g.dart';

@riverpod
class Navigation extends _$Navigation {
  Navigation() : super();

  @override
  int build() {
    return 0;
  }

  void setIndex(int index) async {
    state = index;
  }
}
