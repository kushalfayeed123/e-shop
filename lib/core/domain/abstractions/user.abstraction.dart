import 'package:eshop/core/domain/entities/user.entity.dart';

abstract class IUserService {
  Future<void> createUser(User payload);
  Future<void> updateUser(User payload);
  Future<User> getUser(String userId); // probably don't need this
  Future<List<User>> getUsers();
  Future<void> deleteUser(String userId);
}
