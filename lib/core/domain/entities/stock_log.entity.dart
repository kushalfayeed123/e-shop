class StockLog {
  String? logId;
  String? productId;
  String? userId;
  String? changeType;
  int? remainingStock;
  String? timestamp;
  String? notes;

  StockLog(
      {this.logId,
      this.productId,
      this.userId,
      this.changeType,
      this.remainingStock,
      this.timestamp,
      this.notes});

  StockLog.fromJson(Map<String, dynamic> json) {
    logId = json['log_id'];
    productId = json['product_id'];
    userId = json['user_id'];
    changeType = json['change_type'];
    remainingStock = json['remaining_stock'];
    timestamp = json['timestamp'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['log_id'] = logId;
    data['product_id'] = productId;
    data['user_id'] = userId;
    data['change_type'] = changeType;
    data['remaining_stock'] = remainingStock;
    data['timestamp'] = timestamp;
    data['notes'] = notes;
    return data;
  }
}
