import 'package:eshop/core/domain/abstractions/auth.abstraction.dart';
import 'package:eshop/locator.dart';
import 'package:eshop/state/models/auth.state.model.dart';
import 'package:eshop/state/providers/user/user.provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth.provider.g.dart';

@riverpod
class AuthState extends _$AuthState {
  final IAuthService _authService = locator<IAuthService>();

  @override
  AsyncValue<AuthStateModel> build() {
    final defaultData = AuthStateModel();
    return AsyncValue.data(defaultData);
  }

  setState(AuthStateModel stateSlice) {
    state = const AsyncValue.loading();
    state = AsyncValue.data(stateSlice);
  }

  Future<void> signIn(String email, String password) async {
    try {
      state = const AsyncLoading();
      final user =
          await _authService.signinWithEmailAndPassword(email, password);
      final res = AuthStateModel(
          isAuthenticated:
              (FirebaseAuth.instance.currentUser?.uid ?? '').isEmpty
                  ? false
                  : true,
          signedInUser: user.user?.uid ?? '');
      await ref.read(userStateProvider.notifier).getCurrentUser();
      await ref.read(userStateProvider.notifier).fcmSetup();
      state = AsyncValue.data(res);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      const AsyncLoading();
      await _authService.signout();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      state = const AsyncLoading();

      await _authService.forgotPassword(email);
      final res = AuthStateModel(
          isAuthenticated:
              (FirebaseAuth.instance.currentUser?.uid ?? '').isEmpty
                  ? false
                  : true,
          signedInUser: FirebaseAuth.instance.currentUser?.uid ?? '');
      state = AsyncValue.data(res);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      rethrow;
    }
  }
}
