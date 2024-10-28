import 'package:eshop/core/domain/entities/user.entity.dart';

abstract class IUserService {
  Future<void> createUser(UserModel payload);
  Future<void> updateUser(UserModel payload);
  Future<UserModel> getUser(String userId); // probably don't need this
  Future<List<UserModel>> getUsers();
  Future<void> deleteUser(String userId);
}
