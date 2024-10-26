class Discount {
  String? discountCode;
  int? amount;

  Discount({this.discountCode, this.amount});

  Discount.fromJson(Map<String, dynamic> json) {
    discountCode = json['discount_code'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['discount_code'] = discountCode;
    data['amount'] = amount;
    return data;
  }
}
