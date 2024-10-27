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
    adjustmentId = json['adjustment_id'];
    productId = json['product_id'];
    userId = json['user_id'];
    adjustmentType = json['adjustment_type'];
    quantity = json['quantity'];
    reason = json['reason'];
    notes = json['notes'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adjustment_id'] = adjustmentId;
    data['product_id'] = productId;
    data['user_id'] = userId;
    data['adjustment_type'] = adjustmentType;
    data['quantity'] = quantity;
    data['reason'] = reason;
    data['notes'] = notes;
    data['timestamp'] = timestamp;
    return data;
  }
}
