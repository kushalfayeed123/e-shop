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
    canCreateOrders = json['canCreateOrders'];
    canEditInventory = json['canEditInventory'];
    canViewReports = json['canViewReports'];
    canProcessReturns = json['canProcessReturns'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['canCreateOrders'] = canCreateOrders;
    data['canEditInventory'] = canEditInventory;
    data['canViewReports'] = canViewReports;
    data['canProcessReturns'] = canProcessReturns;
    return data;
  }
}
