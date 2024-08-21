import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scentography/domain/fragrance.dart';

import '../../../data/providers.dart';

final searchProvider = FutureProvider.family<List<Fragrance>, String>((ref, query) async {
  final repo = ref.watch(fireStoreRepoProvider);
  return repo.searchFragrances(query);
});