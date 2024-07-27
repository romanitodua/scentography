

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scentography/data/repositories/firestore.dart';

final fireStoreRepoProvider = Provider<FireStoreRepo>((ref) {
  return FireStoreRepo();
});