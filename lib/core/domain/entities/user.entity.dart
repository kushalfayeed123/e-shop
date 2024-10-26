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
        ? new Permissions.fromJson(json['permissions'])
        : null;
    profilePictureUrl = json['profile_picture_url'];
    lastLogin = json['last_login'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['role'] = this.role;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    if (this.permissions != null) {
      data['permissions'] = this.permissions!.toJson();
    }
    data['profile_picture_url'] = this.profilePictureUrl;
    data['last_login'] = this.lastLogin;
    return data;
  }
}

class Permissions {
  bool? canCreateOrders;
  bool? canEditInventory;
  bool? canViewReports;
  bool? canProcessReturns;

  Permissions(
      {this.canCreateOrders,
      this.canEditInventory,
      this.canViewReports,
      this.canProcessReturns});

  Permissions.fromJson(Map<String, dynamic> json) {
    canCreateOrders = json['can_create_orders'];
    canEditInventory = json['can_edit_inventory'];
    canViewReports = json['can_view_reports'];
    canProcessReturns = json['can_process_returns'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['can_create_orders'] = this.canCreateOrders;
    data['can_edit_inventory'] = this.canEditInventory;
    data['can_view_reports'] = this.canViewReports;
    data['can_process_returns'] = this.canProcessReturns;
    return data;
  }
}
