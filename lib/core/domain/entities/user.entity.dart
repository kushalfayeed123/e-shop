import 'package:eshop/core/domain/entities/permissions.entity.dart';

class User {
  String? userId;
  String? name;
  String? email;
  String? phone;
  String? role;
  String? createdAt;
  String? updatedAt;
  String? status;
  Permissions? permissions;
  String? profilePictureUrl;
  String? lastLogin;

  User(
      {this.userId,
      this.name,
      this.email,
      this.phone,
      this.role,
      this.createdAt,
      this.updatedAt,
      this.status,
      this.permissions,
      this.profilePictureUrl,
      this.lastLogin});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    role = json['role'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    permissions = json['permissions'] != null
        ? Permissions.fromJson(json['permissions'])
        : null;
    profilePictureUrl = json['profile_picture_url'];
    lastLogin = json['last_login'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['role'] = role;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    if (permissions != null) {
      data['permissions'] = permissions!.toJson();
    }
    data['profile_picture_url'] = profilePictureUrl;
    data['last_login'] = lastLogin;
    return data;
  }
}
