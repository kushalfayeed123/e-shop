import 'package:eshop/core/domain/abstractions/user.abstraction.dart';
import 'package:eshop/core/domain/entities/device.entity.dart';
import 'package:eshop/core/domain/entities/user.entity.dart';
import 'package:eshop/locator.dart';
import 'package:eshop/state/models/user.state.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user.provider.g.dart';

@riverpod
class UserState extends _$UserState {
  final IUserService _userService = locator<IUserService>();

  @override
  AsyncValue<UserStateModel> build() {
    final defaultData = UserStateModel();
    return AsyncValue.data(defaultData);
  }

  setState(UserStateModel stateSlice) {
    state = const AsyncValue.loading();
    state = AsyncValue.data(stateSlice);
  }

  Future<void> getCurrentUser() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final user = await _userService.getUser(userId ?? '');
    final currentState = state.asData?.value;
    final newState =
        UserStateModel(currentUser: user, allUsers: currentState?.allUsers);
    setState(newState);
  }

  Future<void> getAllUsers() async {
    final users = await _userService.getUsers();
    final currentState = state.asData?.value;
    final newState =
        UserStateModel(currentUser: currentState?.currentUser, allUsers: users);
    setState(newState);
  }

  Future<void> fcmSetup() async {
    try {
      final messaging = FirebaseMessaging.instance;

      final settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: false,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        await getCurrentUser();
        String? token = await messaging.getToken();
        final currentState = state.asData?.value;

        final currentUser = currentState?.currentUser;
        final userPayload = UserModel(
          id: currentUser?.id ?? '',
          name: currentUser?.name ?? '',
          email: currentUser?.email ?? '',
          phone: currentUser?.phone ?? '',
          role: currentUser?.role ?? '',
          createdAt: currentUser?.createdAt ?? '',
          updatedAt: currentUser?.updatedAt ?? '',
          status: currentUser?.status ?? '',
          permissions: currentUser?.permissions,
          profilePictureUrl: currentUser?.profilePictureUrl ?? '',
          lastLogin: currentUser?.lastLogin ?? '',
          device: Device(token: token),
        );
        await updateUser(userPayload);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(UserModel payload) async {
    try {
      await _userService.updateUser(payload);
    } catch (e) {
      rethrow;
    }
  }
}
