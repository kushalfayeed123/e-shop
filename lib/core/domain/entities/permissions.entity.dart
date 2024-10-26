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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['can_create_orders'] = canCreateOrders;
    data['can_edit_inventory'] = canEditInventory;
    data['can_view_reports'] = canViewReports;
    data['can_process_returns'] = canProcessReturns;
    return data;
  }
}
