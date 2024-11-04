class Discount {
  String? discountCode;
  String? amount;

  Discount({this.discountCode, this.amount});

  Discount.fromJson(Map<String, dynamic> json) {
    discountCode = json['discountCode'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['discountCode'] = discountCode;
    data['amount'] = amount;
    return data;
  }
}
