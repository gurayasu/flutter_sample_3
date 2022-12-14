import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoapp/photo.dart';
import 'package:photoapp/photo_repository.dart';

final userProvider = StreamProvider.autoDispose((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// ref.watch() を使うことで他Providerのデータを取得できる
final photoListProvider = StreamProvider.autoDispose((ref) {
  var data;
  final User? user = ref.watch(userProvider).data?.value;
  return user == null
      ? Stream.value(<Photo>[])
      : PhotoRepository(user).getPhotoList();
});

final photoListIndexProvider = StateProvider.autoDispose((ref) {
  return 0;
});

final photoViewInitialIndexProvider = ScopedProvider<int>(null);
