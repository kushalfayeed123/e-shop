import 'package:eshop/core/domain/abstractions/user.abstraction.dart';
import 'package:eshop/locator.dart';
import 'package:eshop/state/models/user.state.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
}
