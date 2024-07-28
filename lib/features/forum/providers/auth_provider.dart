import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../bindings/auth.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthUser extends _$AuthUser {
  late AuthRepo authRepo;

  @override
  User? build() {
    authRepo = AuthRepo();
    // Initialize with current user if already signed in
    state = authRepo.getCurrentUser();
    return state;
  }

  Future<void> signIn() async {
    await authRepo.signInWithGoogle();
    state = authRepo.getCurrentUser();
  }

  Future<void> signOut() async {
    await authRepo.signOut();
    state = null;// Notify state change
    print("AuthUser state after signOut: $state");
  }
}
