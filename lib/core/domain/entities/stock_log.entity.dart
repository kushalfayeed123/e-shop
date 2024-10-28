class StockLog {
  String? id;
  String? productId;
  String? userId;
  String? changeType;
  int? remainingStock;
  String? timestamp;
  String? notes;

  StockLog(
      {this.id,
      this.productId,
      this.userId,
      this.changeType,
      this.remainingStock,
      this.timestamp,
      this.notes});

  StockLog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    userId = json['userId'];
    changeType = json['changeType'];
    remainingStock = json['remainingStock'];
    timestamp = json['timestamp'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['log_id'] = id;
    data['productId'] = productId;
    data['userId'] = userId;
    data['changeType'] = changeType;
    data['remainingStock'] = remainingStock;
    data['timestamp'] = timestamp;
    data['notes'] = notes;
    return data;
  }
}
