import 'package:eshop/core/domain/entities/cart.entity.dart';
import 'package:eshop/core/domain/entities/discount.entity.dart';

class TransactionModel {
  String? id;
  String? userId;
  String? customerId;
  String? transactionType;
  List<CartProduct>? items;
  String? subtotal;
  String? tax;
  String? totalAmount;
  String? paymentMethod;
  String? transactionDate;
  String? status;
  String? notes;
  List<Discount>? discounts;

  TransactionModel({
    this.id,
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
    this.discounts,
  });

  TransactionModel.fromJson(Map<String, dynamic> json, String did) {
    id = did;
    userId = json['userId'];
    customerId = json['customerId'];
    transactionType = json['transactionType'];
    if (json['items'] != null) {
      items = <CartProduct>[];
      json['items'].forEach((v) {
        items!.add(CartProduct.fromJson(v));
      });
    }
    subtotal = json['subtotal'];
    tax = json['tax'];
    totalAmount = json['totalAmount'];
    paymentMethod = json['paymentMethod'];
    transactionDate = json['transactionDate'];
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
    data['id'] = id;
    data['userId'] = userId;
    data['customerId'] = customerId;
    data['transactionType'] = transactionType;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['subtotal'] = subtotal;
    data['tax'] = tax;
    data['totalAmount'] = totalAmount;
    data['paymentMethod'] = paymentMethod;
    data['transactionDate'] = transactionDate;
    data['status'] = status;
    data['notes'] = notes;
    if (discounts != null) {
      data['discounts'] = discounts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
