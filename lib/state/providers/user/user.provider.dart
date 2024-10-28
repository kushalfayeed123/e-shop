import 'package:eshop/state/models/user.state.model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user.provider.g.dart';

@riverpod
class UserState extends _$UserState {
  @override
  AsyncValue<UserStateModel> build() {
    final defaultData = UserStateModel();
    return AsyncValue.data(defaultData);
  }

  setState(UserStateModel stateSlice) {
    state = const AsyncValue.loading();
    state = AsyncValue.data(stateSlice);
  }
}
