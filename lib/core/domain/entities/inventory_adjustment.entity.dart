class InventoryAdjustment {
  String? adjustmentId;
  String? productId;
  String? userId;
  String? adjustmentType;
  int? quantity;
  String? reason;
  String? notes;
  String? timestamp;

  InventoryAdjustment(
      {this.adjustmentId,
      this.productId,
      this.userId,
      this.adjustmentType,
      this.quantity,
      this.reason,
      this.notes,
      this.timestamp});

  InventoryAdjustment.fromJson(Map<String, dynamic> json) {
    adjustmentId = json['adjustmentId'];
    productId = json['productId'];
    userId = json['userId'];
    adjustmentType = json['adjustmentType'];
    quantity = json['quantity'];
    reason = json['reason'];
    notes = json['notes'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adjustmentId'] = adjustmentId;
    data['productId'] = productId;
    data['userId'] = userId;
    data['adjustmentType'] = adjustmentType;
    data['quantity'] = quantity;
    data['reason'] = reason;
    data['notes'] = notes;
    data['timestamp'] = timestamp;
    return data;
  }
}
