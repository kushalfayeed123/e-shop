import 'package:eshop/core/domain/entities/discount.entity.dart';
import 'package:eshop/core/domain/entities/product.entity.dart';

class Transaction {
  String? transactionId;
  String? userId;
  String? customerId;
  String? transactionType;
  List<Product>? items;
  int? subtotal;
  double? tax;
  double? totalAmount;
  String? paymentMethod;
  String? transactionDate;
  String? status;
  String? notes;
  List<Discount>? discounts;

  Transaction(
      {this.transactionId,
      this.userId,
      this.customerId,
      this.transactionType,
      this.items,
      this.subtotal,
      this.tax,
      this.totalAmount,
      this.paymentMethod,
      this.transactionDate,
      this.status,
      this.notes,
      this.discounts});

  Transaction.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    userId = json['user_id'];
    customerId = json['customer_id'];
    transactionType = json['transaction_type'];
    if (json['items'] != null) {
      items = <Product>[];
      json['items'].forEach((v) {
        items!.add(Product.fromJson(v));
      });
    }
    subtotal = json['subtotal'];
    tax = json['tax'];
    totalAmount = json['total_amount'];
    paymentMethod = json['payment_method'];
    transactionDate = json['transaction_date'];
    status = json['status'];
    notes = json['notes'];
    if (json['discounts'] != null) {
      discounts = <Discount>[];
      json['discounts'].forEach((v) {
        discounts!.add(Discount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transaction_id'] = transactionId;
    data['user_id'] = userId;
    data['customer_id'] = customerId;
    data['transaction_type'] = transactionType;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['subtotal'] = subtotal;
    data['tax'] = tax;
    data['total_amount'] = totalAmount;
    data['payment_method'] = paymentMethod;
    data['transaction_date'] = transactionDate;
    data['status'] = status;
    data['notes'] = notes;
    if (discounts != null) {
      data['discounts'] = discounts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
