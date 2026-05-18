import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sura_app/features/auth/data/services/auth_services.dart';

enum AuthFormType { login, register }

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthSuccess extends AuthState {
  final bool isLogin;
  AuthSuccess({required this.isLogin});
}

class AuthFailed extends AuthState {
  final String error;
  AuthFailed(this.error);
}

class AuthLoading extends AuthState {}

class AuthController extends StateNotifier<AuthState> {
  final AuthServices authServices;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthFormType formType = AuthFormType.login;

  AuthController({required this.authServices}) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    state = AuthLoading();
    try {
      final user = await authServices.loginWithEmailAndPassword(email, password);

      if (user != null) {
        state = AuthSuccess(isLogin: true);
      } else {
        state = AuthFailed('Hatalı kimlik bilgileri!');
      }
    } catch (e) {
      state = AuthFailed(e.toString());
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    state = AuthLoading();
    try {
      final user = await authServices.signUpWithEmailAndPassword(email, password);

      if (user != null) {
        final uid = user.uid;

        await _firestore.collection('users').doc(uid).set({
          'uid': uid,
          'name': name,
          'email': email,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
        });

        state = AuthSuccess(isLogin: false);
      } else {
        state = AuthFailed('Hatalı kimlik bilgileri!');
      }
    } catch (e) {
      state = AuthFailed(e.toString());
    }
  }

  void authStatus() {
    final user = authServices.currentUser;
    if (user != null) {
      state = AuthSuccess(isLogin: true);
    } else {
      state = AuthInitial();
    }
  }

  Future<void> logout() async {
    state = AuthLoading();
    try {
      await authServices.logout();
      state = AuthInitial();
    } catch (e) {
      state = AuthFailed(e.toString());
    }
  }

  void toggleFormType() {
    formType = formType == AuthFormType.login
        ? AuthFormType.register
        : AuthFormType.login;
    // We emit initial state when toggling form to reset any errors
    state = AuthInitial();
  }
}

final authServicesProvider = Provider<AuthServices>((ref) {
  return AuthServicesImpl();
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final authServices = ref.watch(authServicesProvider);
  return AuthController(authServices: authServices);
});
