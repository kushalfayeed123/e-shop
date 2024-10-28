import 'package:eshop/core/domain/entities/user.entity.dart';

class UserStateModel {
  UserModel? currentUser;
  List<UserModel>? allUsers;

  UserStateModel({this.currentUser, this.allUsers});
}
