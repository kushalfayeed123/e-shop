import 'package:eshop/core/domain/entities/device.entity.dart';
import 'package:eshop/core/domain/entities/permissions.entity.dart';

class UserModel {
  String? id;
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
  Device? device;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.permissions,
    this.profilePictureUrl,
    this.lastLogin,
    this.device,
  });

  UserModel.fromJson(Map<String, dynamic> json, String uid) {
    id = uid;
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    role = json['role'];
    createdAt = json['createdAt'].toString();
    updatedAt = json['updatedAt'].toString();
    status = json['status'];
    permissions = json['permissions'] != null
        ? Permissions.fromJson(json['permissions'])
        : null;
    device = json['device'] != null ? Device.fromJson(json['device']) : null;
    profilePictureUrl = json['profilePictureUrl'];
    lastLogin = json['lastLogin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['role'] = role;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['status'] = status;
    if (permissions != null) {
      data['permissions'] = permissions!.toJson();
    }
    if (device != null) {
      data['device'] = device!.toJson();
    }
    data['profilePictureUrl'] = profilePictureUrl;
    data['lastLogin'] = lastLogin;
    return data;
  }
}
